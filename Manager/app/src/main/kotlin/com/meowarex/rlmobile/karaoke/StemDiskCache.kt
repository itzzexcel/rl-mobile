package com.meowarex.rlmobile.karaoke

import android.content.Context
import android.util.Log
import java.io.File
import java.io.FileInputStream
import java.io.FileOutputStream
import java.nio.ByteBuffer
import java.nio.ByteOrder
import java.util.UUID

/**
 * Persistent binary KRK1 PCM16 disk cache (matching desktop karaoke-engine KRK1 format).
 */
class StemDiskCache(private val cacheDir: File) {
    companion object {
        private const val TAG = "KaraokeCache"
        private const val MAGIC = 0x314B524B // "KRK1"
        private const val VERSION = 1
        private const val SAMPLE_RATE = 44100
        private const val CHANNELS = 2
        private const val HEADER_BYTES = 32

        fun fromContext(context: Context): StemDiskCache {
            val base = context.getExternalFilesDir(null) ?: context.filesDir
            return StemDiskCache(File(base, "karaoke_cache"))
        }
    }

    private val quotaLock = Any()
    private var maxBytes: Long = 1024L * 1024 * 1024
    private var entryCount: Int = 0
    private var totalBytes: Long = 0

    init {
        synchronized(quotaLock) {
            if (!cacheDir.exists()) cacheDir.mkdirs()
            cacheDir.listFiles { _, name -> name.endsWith(".tmp") }?.forEach { it.delete() }
            refreshStatsLocked()
        }
    }

    fun getStats(): Pair<Int, Double> = synchronized(quotaLock) {
        entryCount to (kotlin.math.round((totalBytes / (1024.0 * 1024.0)) * 10.0) / 10.0)
    }

    fun tryLoadInstrumental(trackId: String, mode: String, modelHash8: String): ShortArray? {
        val file = getInstrumentalFile(trackId, mode, modelHash8)
        return tryLoadInternal(file, "$trackId|${ModelCatalog.normalizeMode(mode)}|$modelHash8")
    }

    fun saveInstrumental(trackId: String, mode: String, modelHash8: String, pcm16: ShortArray) {
        if (pcm16.size < 4 || (pcm16.size and 1) != 0) return
        val dest = getInstrumentalFile(trackId, mode, modelHash8)
        val tag = "$trackId|${ModelCatalog.normalizeMode(mode)}|$modelHash8"
        val tmp = File(cacheDir, "${dest.name}.${UUID.randomUUID()}.tmp")

        try {
            if (!cacheDir.exists()) cacheDir.mkdirs()
            val totalFrames = pcm16.size / 2
            val tagHash = fnv1a64(tag)

            val header = ByteBuffer.allocate(HEADER_BYTES).order(ByteOrder.LITTLE_ENDIAN).apply {
                putInt(MAGIC)
                putInt(VERSION)
                putInt(SAMPLE_RATE)
                putInt(CHANNELS)
                putInt(totalFrames)
                putInt(0)
                putLong(tagHash)
            }.array()

            val payload = ByteBuffer.allocate(pcm16.size * 2).order(ByteOrder.LITTLE_ENDIAN)
            payload.asShortBuffer().put(pcm16)

            FileOutputStream(tmp).use { fos ->
                fos.write(header)
                fos.write(payload.array())
                fos.flush()
            }

            if (dest.exists()) dest.delete()
            if (!tmp.renameTo(dest)) tmp.delete()
            dest.setLastModified(System.currentTimeMillis())

            synchronized(quotaLock) {
                enforceQuotaLocked(dest.absolutePath)
            }
        } catch (t: Throwable) {
            Log.w(TAG, "Cache save failed: ${t.message}")
            if (tmp.exists()) tmp.delete()
        }
    }

    fun clearAll() {
        synchronized(quotaLock) {
            cacheDir.listFiles()?.forEach { f ->
                if (f.name.endsWith(".krk") || f.name.endsWith(".tmp")) f.delete()
            }
            refreshStatsLocked()
        }
    }

    private fun tryLoadInternal(file: File, expectedTag: String): ShortArray? {
        if (!file.exists() || file.length() < HEADER_BYTES) return null
        return try {
            val headerBytes = ByteArray(HEADER_BYTES)
            FileInputStream(file).use { fis ->
                if (readExact(fis, headerBytes) < HEADER_BYTES) {
                    file.delete()
                    return null
                }
                val hb = ByteBuffer.wrap(headerBytes).order(ByteOrder.LITTLE_ENDIAN)
                val magic = hb.int
                val ver = hb.int
                val sr = hb.int
                val ch = hb.int
                val totalFrames = hb.int
                hb.int
                val tagHash = hb.long

                val expectedPayloadBytes = totalFrames.toLong() * ch * 2L
                if (magic != MAGIC ||
                    ver != VERSION ||
                    sr != SAMPLE_RATE ||
                    ch != CHANNELS ||
                    totalFrames <= 0 ||
                    totalFrames > 100_000_000 ||
                    tagHash != fnv1a64(expectedTag) ||
                    file.length() != HEADER_BYTES + expectedPayloadBytes
                ) {
                    file.delete()
                    return null
                }

                val payloadBytes = ByteArray(expectedPayloadBytes.toInt())
                if (readExact(fis, payloadBytes) < payloadBytes.size) {
                    file.delete()
                    return null
                }
                val pcm16 = ShortArray(totalFrames * ch)
                ByteBuffer.wrap(payloadBytes).order(ByteOrder.LITTLE_ENDIAN).asShortBuffer().get(pcm16)
                file.setLastModified(System.currentTimeMillis())
                pcm16
            }
        } catch (t: Throwable) {
            Log.w(TAG, "Cache load failed: ${t.message}")
            file.delete()
            null
        }
    }

    private fun readExact(fis: FileInputStream, dst: ByteArray): Int {
        var off = 0
        while (off < dst.size) {
            val n = fis.read(dst, off, dst.size - off)
            if (n <= 0) break
            off += n
        }
        return off
    }

    private fun enforceQuotaLocked(protectedPath: String?) {
        val files = cacheDir.listFiles { _, name -> name.endsWith(".krk") }
            ?.sortedBy { it.lastModified() } ?: emptyList()
        var total = files.sumOf { it.length() }
        if (total > maxBytes) {
            val target = (maxBytes * 0.85).toLong()
            for (f in files) {
                if (total <= target) break
                if (f.absolutePath == protectedPath) continue
                val len = f.length()
                if (f.delete()) total -= len
            }
        }
        refreshStatsLocked()
    }

    private fun refreshStatsLocked() {
        val files = cacheDir.listFiles { _, name -> name.endsWith(".krk") } ?: emptyArray()
        entryCount = files.size
        totalBytes = files.sumOf { it.length() }
    }

    private fun getInstrumentalFile(trackId: String, mode: String, modelHash8: String): File {
        val normMode = ModelCatalog.normalizeMode(mode)
        val safeHash = sanitizeKey(modelHash8.ifBlank { "none" })
        return File(cacheDir, "inst_${sanitizeKey(trackId)}_${normMode}_${safeHash}.krk")
    }

    private fun sanitizeKey(raw: String): String {
        if (raw.isEmpty()) return "unknown"
        val sb = StringBuilder(48)
        var clean = true
        for (c in raw) {
            if (c.isLetterOrDigit() || c == '-' || c == '_') {
                if (sb.length < 40) sb.append(c)
            } else {
                clean = false
            }
        }
        if (sb.isEmpty() || !clean || raw.length > 40) {
            val shortHash = fnv1a64(raw).toInt()
            val hex = String.format("%08x", shortHash)
            return if (sb.isEmpty()) "t_$hex" else "${sb}_$hex"
        }
        return sb.toString()
    }

    private fun fnv1a64(text: String): Long {
        var hash = -3750763034362895579L // 14695981039346656037UL signed equivalent
        val prime = 1099511628211L
        for (ch in text) {
            hash = (hash xor (ch.code and 0xFF).toLong()) * prime
            hash = (hash xor ((ch.code ushr 8) and 0xFF).toLong()) * prime
        }
        return hash
    }
}
