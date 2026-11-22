package com.meowarex.rlmobile.karaoke

import android.content.Context
import android.os.Build
import android.util.Log
import org.json.JSONObject
import java.io.BufferedInputStream
import java.io.ByteArrayOutputStream
import java.io.InputStream
import java.io.OutputStream
import java.net.InetAddress
import java.net.ServerSocket
import java.net.Socket
import java.net.URLDecoder
import java.nio.ByteBuffer
import java.nio.ByteOrder
import java.util.concurrent.Executors
import kotlin.math.roundToLong

/**
 * Local loopback HTTP server on 127.0.0.1:5445 exposing QNN MDX-NET vocal separation endpoints.
 */
object KaraokeLocalServer {
    private const val TAG = "KaraokeServer"
    const val PORT = 5445

    private val clientPool = Executors.newCachedThreadPool()
    private val dlPool = Executors.newSingleThreadExecutor()

    @Volatile
    private var isRunning = false
    private var serverSocket: ServerSocket? = null
    private lateinit var appContext: Context
    private var separator: QnnStemSeparator? = null
    private var cache: StemDiskCache? = null

    @Volatile
    private var currentMode = "karaoke"

    @Volatile
    var karaokeEnabled: Boolean = false
        private set

    @Volatile
    var vocalGain: Float = 0.0f
        private set

    @Volatile
    private var state = "idle"

    @Volatile
    private var downloadProgress = -1f

    @Volatile
    private var lastChunkMs = 0.0

    @Volatile
    private var lastError: String? = null

    fun start(context: Context) {
        synchronized(this) {
            if (isRunning) return
            appContext = context.applicationContext
            isRunning = true
        }

        Thread({
            try {
                synchronized(this) {
                    if (separator == null) separator = QnnStemSeparator()
                    if (cache == null) cache = StemDiskCache.fromContext(appContext)
                }
                val ss = ServerSocket(PORT, 32, InetAddress.getByName("127.0.0.1"))
                serverSocket = ss
                Log.i(TAG, "Karaoke QNN server listening @ http://127.0.0.1:$PORT (SoC=${Build.SOC_MODEL})")

                while (isRunning && !ss.isClosed) {
                    val sock = ss.accept()
                    clientPool.execute { handleClient(sock) }
                }
            } catch (t: Throwable) {
                if (isRunning) {
                    Log.e(TAG, "Server loop error: ${t.message}", t)
                }
            } finally {
                synchronized(this) {
                    if (serverSocket?.isClosed != false) {
                        serverSocket = null
                        isRunning = false
                    }
                }
            }
        }, "KaraokeLocalServer-Main").start()
    }

    @Synchronized
    fun stop() {
        isRunning = false
        try { serverSocket?.close() } catch (_: Throwable) {}
        serverSocket = null
        unloadSession()
    }

    @Synchronized
    fun unloadSession() {
        try { separator?.close() } catch (_: Throwable) {}
        separator = null
        state = "idle"
        System.gc()
    }

    fun getActiveMode(): String = currentMode

    fun getActiveProvider(): String = separator?.activeProvider ?: "Idle"

    fun setKaraokeEnabled(context: Context, enabled: Boolean) {
        karaokeEnabled = enabled
        if (enabled) {
            KaraokeForegroundService.start(context)
            KaraokeForegroundService.updateNotification(context)
        } else {
            unloadSession()
            KaraokeForegroundService.stop(context)
        }
    }

    fun setActiveMode(context: Context, mode: String) {
        currentMode = ModelCatalog.normalizeMode(mode)
        KaraokeForegroundService.updateNotification(context)
    }

    fun setVocalGain(gain: Float) {
        vocalGain = gain.coerceIn(0f, 1f)
    }

    fun getCacheStats(context: Context): Pair<Int, Double> {
        val c = cache ?: StemDiskCache.fromContext(context).also { cache = it }
        return c.getStats()
    }

    fun clearStemCache(context: Context) {
        val c = cache ?: StemDiskCache.fromContext(context).also { cache = it }
        c.clearAll()
    }

    fun unloadModelIfLoaded(mode: String) {
        separator?.unloadIfMode(mode)
    }

    fun runLocalSelfTest(context: Context): String {
        val appCtx = context.applicationContext
        val sep = separator ?: QnnStemSeparator().also { separator = it }
        return sep.runSelfTest(appCtx)
    }

    private fun handleClient(socket: Socket) {
        try {
            socket.soTimeout = 30_000
            val input = BufferedInputStream(socket.getInputStream())
            val reqLine = readLineAscii(input) ?: return
            val parts = reqLine.split(" ")
            if (parts.size < 2) return

            val method = parts[0]
            val target = parts[1].split("?", limit = 2)
            val path = target[0]
            val params = parseQueryParams(if (target.size > 1) target[1] else "")

            var contentLength = 0
            while (true) {
                val h = readLineAscii(input) ?: break
                if (h.isEmpty()) break
                val lower = h.lowercase()
                if (lower.startsWith("content-length:")) {
                    contentLength = lower.substringAfter("content-length:").trim().toIntOrNull() ?: 0
                }
            }

            val body = if (contentLength in 1..(16 * 1024 * 1024)) {
                readExactBytes(input, contentLength)
            } else {
                ByteArray(0)
            }

            val out = socket.getOutputStream()
            when {
                path == "/health" -> {
                    sendJson(out, 200, buildStatusJson())
                }

                method == "GET" && path == "/karaoke/config" -> {
                    val spec = ModelCatalog.getSpec(currentMode)
                    val chunkFrames = (spec.dimT - 1) * spec.hopLength
                    val line = "${if (karaokeEnabled) 1 else 0}|$currentMode|$vocalGain|$chunkFrames"
                    sendBytes(out, 200, "text/plain; charset=utf-8", line.toByteArray(Charsets.UTF_8))
                }

                method == "POST" && path == "/karaoke/toggle" -> {
                    if (params.containsKey("mode")) {
                        currentMode = ModelCatalog.normalizeMode(params["mode"])
                    }
                    params["vocalGain"]?.toFloatOrNull()?.let {
                        vocalGain = it.coerceIn(0f, 1f)
                    }
                    val nextEnabled = params["enabled"]?.let {
                        it == "1" || it.equals("true", ignoreCase = true)
                    } ?: !karaokeEnabled
                    karaokeEnabled = nextEnabled
                    sendJson(out, 200, buildStatusJson())
                    setKaraokeEnabled(appContext, nextEnabled)
                }

                method == "POST" && path == "/karaoke/download" -> {
                    val mode = ModelCatalog.normalizeMode(params["mode"] ?: currentMode)
                    currentMode = mode
                    triggerDownload(mode)
                    sendJson(out, 200, buildStatusJson())
                }

                method == "POST" && path == "/karaoke/self-test" -> {
                    val sep = separator ?: QnnStemSeparator().also { separator = it }
                    val reportJson = sep.runSelfTest(appContext)
                    sendJson(out, 200, reportJson)
                }

                method == "DELETE" && path == "/karaoke/model" -> {
                    val mode = ModelCatalog.normalizeMode(params["mode"] ?: currentMode)
                    unloadModelIfLoaded(mode)
                    ModelCatalog.deleteModel(appContext, mode)
                    sendJson(out, 200, buildStatusJson())
                }

                method == "POST" && path == "/karaoke/separate-pcm" -> {
                    handleSeparatePcm(out, params, body)
                }

                else -> {
                    sendBytes(out, 404, "application/json", """{"error":"not_found"}""".toByteArray())
                }
            }
        } catch (t: Throwable) {
            Log.w(TAG, "Client handler error: ${t.message}")
        } finally {
            try { socket.close() } catch (_: Throwable) {}
        }
    }

    private fun handleSeparatePcm(out: OutputStream, params: Map<String, String>, body: ByteArray) {
        if (body.size < 4 || (body.size and 3) != 0) {
            sendJson(out, 400, """{"error":"Expected stereo 16-bit PCM byte stream (size % 4 == 0)"}""")
            return
        }

        val mode = ModelCatalog.normalizeMode(params["mode"] ?: currentMode)
        currentMode = mode
        val sep = separator ?: QnnStemSeparator().also { separator = it }

        if (!ModelCatalog.isModelInstalled(appContext, mode)) {
            sendJson(out, 409, """{"error":"Model not installed for mode '$mode'"}""")
            return
        }

        if (!sep.ensureLoaded(appContext, mode)) {
            lastError = "Failed initializing QNN session for $mode"
            sendJson(out, 500, """{"error":"${lastError}"}""")
            return
        }

        val trackId = params["trackId"]?.takeIf { it.isNotBlank() }
        val spec = ModelCatalog.getSpec(mode)
        if (trackId != null) {
            val cached = cache?.tryLoadInstrumental(trackId, mode, spec.hash8)
            if (cached != null && cached.size == body.size / 2) {
                val cachedBytes = shortsToBytesLe(cached)
                sendBytes(out, 200, "application/octet-stream", cachedBytes)
                return
            }
        }

        val pcmIn = ShortArray(body.size / 2)
        ByteBuffer.wrap(body).order(ByteOrder.LITTLE_ENDIAN).asShortBuffer().get(pcmIn)

        val frames = pcmIn.size / 2
        val maxFrames = sep.getExactChunkFrames()
        if (frames > maxFrames) {
            sendJson(out, 400, """{"error":"Chunk exceeds max frames ($maxFrames)"}""")
            return
        }

        val pcmOut = ShortArray(pcmIn.size)
        val t0 = System.nanoTime()
        state = "ai_active"
        val ok = sep.separateChunk(pcmIn, frames, pcmOut)
        val elapsedMs = (System.nanoTime() - t0) / 1_000_000.0
        lastChunkMs = (elapsedMs * 10.0).roundToLong() / 10.0

        if (!ok) {
            lastError = "QNN separation failed"
            sendJson(out, 500, """{"error":"QNN separation failed"}""")
            return
        }

        lastError = null
        if (trackId != null) {
            cache?.saveInstrumental(trackId, mode, spec.hash8, pcmOut)
        }
        sendBytes(out, 200, "application/octet-stream", shortsToBytesLe(pcmOut))
    }

    private fun triggerDownload(mode: String) {
        if (downloadProgress >= 0f) return
        downloadProgress = 0f
        lastError = null
        dlPool.execute {
            try {
                ModelCatalog.downloadModel(appContext, mode) { p -> downloadProgress = p }
                downloadProgress = -1f
            } catch (t: Throwable) {
                downloadProgress = -1f
                lastError = t.message
                Log.e(TAG, "Model download failed ($mode): ${t.message}", t)
            }
        }
    }

    private fun buildStatusJson(): String {
        val (entries, cacheMb) = cache?.getStats() ?: (0 to 0.0)
        return JSONObject().apply {
            put("enabled", karaokeEnabled)
            put("vocalGain", vocalGain.toDouble())
            put("state", state)
            put("provider", separator?.activeProvider ?: "Idle")
            put("mode", currentMode)
            put("socModel", Build.SOC_MODEL)
            put("cacheEntries", entries)
            put("cacheMb", cacheMb)
            put("karaokeModelInstalled", ModelCatalog.isModelInstalled(appContext, "karaoke"))
            put("instrumentalModelInstalled", ModelCatalog.isModelInstalled(appContext, "instrumental"))
            put("downloadProgress", downloadProgress.toDouble())
            put("lastChunkMs", lastChunkMs)
            put("error", lastError ?: JSONObject.NULL)
        }.toString()
    }

    private fun shortsToBytesLe(src: ShortArray): ByteArray {
        val bb = ByteBuffer.allocate(src.size * 2).order(ByteOrder.LITTLE_ENDIAN)
        bb.asShortBuffer().put(src)
        return bb.array()
    }

    private fun readLineAscii(input: InputStream): String? {
        val baos = ByteArrayOutputStream(128)
        while (true) {
            val b = input.read()
            if (b == -1) {
                return if (baos.size() == 0) null else baos.toString("UTF-8")
            }
            if (b == '\n'.code) break
            if (b != '\r'.code) baos.write(b)
        }
        return baos.toString("UTF-8")
    }

    private fun readExactBytes(input: InputStream, count: Int): ByteArray {
        val buf = ByteArray(count)
        var off = 0
        while (off < count) {
            val n = input.read(buf, off, count - off)
            if (n <= 0) break
            off += n
        }
        return if (off == count) buf else buf.copyOf(off)
    }

    private fun parseQueryParams(query: String): Map<String, String> {
        val map = LinkedHashMap<String, String>()
        if (query.isEmpty()) return map
        for (pair in query.split("&")) {
            val idx = pair.indexOf('=')
            if (idx > 0) {
                val k = URLDecoder.decode(pair.substring(0, idx), "UTF-8")
                val v = URLDecoder.decode(pair.substring(idx + 1), "UTF-8")
                map[k] = v
            }
        }
        return map
    }

    private fun sendJson(out: OutputStream, code: Int, json: String) {
        sendBytes(out, code, "application/json; charset=utf-8", json.toByteArray(Charsets.UTF_8))
    }

    private fun sendBytes(out: OutputStream, code: Int, contentType: String, body: ByteArray) {
        val statusText = when (code) {
            200 -> "OK"
            400 -> "Bad Request"
            404 -> "Not Found"
            409 -> "Conflict"
            else -> "Internal Server Error"
        }
        val header = "HTTP/1.1 $code $statusText\r\n" +
            "Content-Type: $contentType\r\n" +
            "Content-Length: ${body.size}\r\n" +
            "Access-Control-Allow-Origin: *\r\n" +
            "Connection: close\r\n\r\n"
        out.write(header.toByteArray(Charsets.UTF_8))
        out.write(body)
        out.flush()
    }
}
