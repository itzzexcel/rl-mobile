package com.meowarex.rlmobile.karaoke

import android.content.Context
import android.os.Environment
import android.util.Log
import java.io.File
import java.io.FileOutputStream
import java.net.HttpURLConnection
import java.net.URL

data class MdxModelSpec(
    val mode: String,
    val fileName: String,
    val legacyFileName: String,
    val downloadUrl: String,
    val dimF: Int,
    val dimT: Int,
    val nFft: Int,
    val hopLength: Int,
    val compensate: Float,
    val primaryStem: String,
    val hash8: String
)

object ModelCatalog {
    private const val TAG = "KaraokeModels"
    private const val MIN_MODEL_BYTES = 1_000_000L
    const val MAX_QUANTIZED_MODEL_BYTES = 42_000_000L

    val KARAOKE_SPEC = MdxModelSpec(
        mode = "karaoke",
        fileName = "UVR_MDXNET_KARA_2_qnn_a16w16.onnx",
        legacyFileName = "UVR_MDXNET_KARA_2.onnx",
        downloadUrl = "https://github.com/itzzexcel/rl-mobile/releases/download/karaoke-models-a16w16/UVR_MDXNET_KARA_2_qnn_a16w16.onnx",
        dimF = 2048,
        dimT = 256,
        nFft = 5120,
        hopLength = 1024,
        compensate = 1.065f,
        primaryStem = "Instrumental",
        hash8 = "1d64a6d2"
    )

    val INSTRUMENTAL_SPEC = MdxModelSpec(
        mode = "instrumental",
        fileName = "UVR-MDX-NET-Inst_HQ_3_qnn_a16w16.onnx",
        legacyFileName = "UVR-MDX-NET-Inst_HQ_3.onnx",
        downloadUrl = "https://github.com/itzzexcel/rl-mobile/releases/download/karaoke-models-a16w16/UVR-MDX-NET-Inst_HQ_3_qnn_a16w16.onnx",
        dimF = 3072,
        dimT = 256,
        nFft = 6144,
        hopLength = 1024,
        compensate = 1.022f,
        primaryStem = "Instrumental",
        hash8 = "55657dd7"
    )

    fun normalizeMode(mode: String?): String =
        if (mode.equals("instrumental", ignoreCase = true)) "instrumental" else "karaoke"

    fun getSpec(mode: String?): MdxModelSpec =
        if (normalizeMode(mode) == "instrumental") INSTRUMENTAL_SPEC else KARAOKE_SPEC

    fun getAppModelsDir(context: Context): File =
        File(context.getExternalFilesDir(null) ?: context.filesDir, "models")

    fun isQuantizedModelFile(file: File): Boolean =
        file.exists() && file.length() in (MIN_MODEL_BYTES + 1)..MAX_QUANTIZED_MODEL_BYTES

    fun hasLegacyFp32Model(context: Context, mode: String?): Boolean {
        val spec = getSpec(mode)
        val sdcardDir = File(Environment.getExternalStorageDirectory(), "RadiantLyrics/models")
        val appDir = getAppModelsDir(context)
        return listOf(
            File(sdcardDir, spec.fileName),
            File(appDir, spec.fileName),
            File(sdcardDir, spec.legacyFileName),
            File(appDir, spec.legacyFileName)
        ).any { it.exists() && it.length() > MAX_QUANTIZED_MODEL_BYTES }
    }

    fun resolveModelFile(context: Context, mode: String?): File {
        val spec = getSpec(mode)
        val sdcardDir = File(Environment.getExternalStorageDirectory(), "RadiantLyrics/models")
        val appDir = getAppModelsDir(context)
        val candidates = listOf(
            File(sdcardDir, spec.fileName),
            File(appDir, spec.fileName),
            File(sdcardDir, spec.legacyFileName),
            File(appDir, spec.legacyFileName)
        )
        candidates.firstOrNull { isQuantizedModelFile(it) }?.let { return it }
        return File(appDir, spec.fileName)
    }

    fun isModelInstalled(context: Context, mode: String?): Boolean =
        isQuantizedModelFile(resolveModelFile(context, mode))

    fun getModelSizeMb(context: Context, mode: String?): Double {
        val f = resolveModelFile(context, mode)
        if (!isQuantizedModelFile(f)) return 0.0
        return kotlin.math.round((f.length() / (1024.0 * 1024.0)) * 10.0) / 10.0
    }

    fun deleteModel(context: Context, mode: String?): Boolean {
        val spec = getSpec(mode)
        var deleted = false
        val appDir = getAppModelsDir(context)
        val sdcardDir = File(Environment.getExternalStorageDirectory(), "RadiantLyrics/models")
        val candidates = listOf(
            resolveModelFile(context, mode),
            File(appDir, spec.fileName),
            File(appDir, "${spec.fileName}.part"),
            File(appDir, spec.legacyFileName),
            File(appDir, "${spec.legacyFileName}.part"),
            File(sdcardDir, spec.fileName),
            File(sdcardDir, spec.legacyFileName)
        )
        for (file in candidates) {
            if (file.exists() && file.delete()) {
                deleted = true
            }
        }
        val ctxDir = File(context.cacheDir, "qnn_ctx")
        ctxDir.listFiles()?.forEach { f ->
            if (f.name.startsWith("${spec.mode}_")) f.delete()
        }
        return deleted
    }

    fun downloadModel(
        context: Context,
        mode: String?,
        onProgress: (Float) -> Unit
    ): File {
        val spec = getSpec(mode)
        val dir = getAppModelsDir(context)
        if (!dir.exists()) dir.mkdirs()

        val dest = File(dir, spec.fileName)
        if (isQuantizedModelFile(dest)) {
            onProgress(1f)
            return dest
        }

        val part = File(dir, "${spec.fileName}.part")
        Log.i(TAG, "Downloading ${spec.fileName} from ${spec.downloadUrl}")
        onProgress(0f)

        val conn = (URL(spec.downloadUrl).openConnection() as HttpURLConnection).apply {
            instanceFollowRedirects = true
            connectTimeout = 20_000
            readTimeout = 60_000
        }

        try {
            val code = conn.responseCode
            if (code !in 200..299) {
                throw IllegalStateException("HTTP $code downloading ${spec.fileName}")
            }
            val totalBytes = conn.contentLengthLong
            conn.inputStream.use { input ->
                FileOutputStream(part).use { out ->
                    val buf = ByteArray(65536)
                    var readTotal = 0L
                    var lastReportMs = 0L
                    while (true) {
                        val n = input.read(buf)
                        if (n <= 0) break
                        out.write(buf, 0, n)
                        readTotal += n
                        if (totalBytes > 0) {
                            val now = System.currentTimeMillis()
                            if (now - lastReportMs >= 150) {
                                lastReportMs = now
                                onProgress((readTotal.toFloat() / totalBytes.toFloat()).coerceIn(0f, 0.99f))
                            }
                        }
                    }
                    out.flush()
                }
            }
            if (dest.exists()) dest.delete()
            if (!part.renameTo(dest)) {
                throw IllegalStateException("Failed renaming ${part.name} to ${dest.name}")
            }
            File(dir, spec.legacyFileName).takeIf { it.exists() }?.delete()
            File(context.cacheDir, "qnn_ctx").listFiles()?.forEach { f ->
                if (f.name.startsWith("${spec.mode}_")) f.delete()
            }
            onProgress(1f)
            Log.i(TAG, "Model downloaded cleanly: ${dest.absolutePath} (${dest.length() / (1024 * 1024)} MB)")
            return dest
        } catch (t: Throwable) {
            if (part.exists()) part.delete()
            throw t
        } finally {
            conn.disconnect()
        }
    }
}
