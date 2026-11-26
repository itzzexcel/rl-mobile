package com.meowarex.rlmobile.karaoke

import android.content.Context
import android.os.Build
import android.util.Log
import ai.onnxruntime.OnnxTensor
import ai.onnxruntime.OrtEnvironment
import ai.onnxruntime.OrtSession
import org.json.JSONArray
import org.json.JSONObject
import java.io.Closeable
import java.io.File
import java.nio.ByteBuffer
import java.nio.ByteOrder
import java.nio.FloatBuffer
import kotlin.math.PI
import kotlin.math.abs
import kotlin.math.cos
import kotlin.math.max
import kotlin.math.min
import kotlin.math.roundToInt
import kotlin.math.sin
import kotlin.math.sqrt
import kotlin.random.Random

/**
 * Qualcomm QNN (Hexagon HTP NPU -> QNN GPU -> NNAPI -> CPU) MDX-NET stem separator.
 * Shares the exact STFT/iSTFT and zero-per-chunk buffer design of PC karaoke-engine.
 */
class QnnStemSeparator : Closeable {
    companion object {
        private const val TAG = "KaraokeQNN"
        private const val INV_32768 = 1f / 32768f

        internal fun detectHtpArch(socModel: String): String? {
            val s = socModel.trim().uppercase()
            return when {
                s.startsWith("SM8850") || s.startsWith("SM8845") || s.startsWith("QCS8850") -> "81"
                s.startsWith("SM8750") || s.startsWith("QCS8750") -> "79"
                s.startsWith("SM8650") || s.startsWith("SM8635") || s.startsWith("QCS8650") -> "75"
                s.startsWith("SM8550") || s.startsWith("SM8735") || s.startsWith("SM8535") ||
                    s.startsWith("SM7675") || s.startsWith("QCS8550") -> "73"
                s.startsWith("SM8450") || s.startsWith("SM8475") -> "69"
                s.startsWith("SM8350") -> "68"
                else -> null
            }
        }
    }

    private val lock = Any()
    private var env: OrtEnvironment? = null
    private var session: OrtSession? = null
    private var activeSpec: MdxModelSpec? = null

    @Volatile
    var activeProvider: String = "Idle"
        private set

    @Volatile
    var lastLoadError: String? = null
        private set

    @Volatile
    var loadedMode: String = ""
        private set

    @Volatile
    var lastStftMs: Double = 0.0
        private set

    @Volatile
    var lastOrtMs: Double = 0.0
        private set

    @Volatile
    var lastIstftMs: Double = 0.0
        private set

    private var fft: MixedRadixFft? = null
    private var window = FloatArray(0)
    private var padL = FloatArray(0)
    private var padR = FloatArray(0)
    private var winFrame = FloatArray(0)
    private var fftRe = FloatArray(0)
    private var fftIm = FloatArray(0)
    private var ifftRe = FloatArray(0)
    private var ifftIm = FloatArray(0)
    private var ifftTime = FloatArray(0)
    private var olaOutL = FloatArray(0)
    private var olaOutR = FloatArray(0)
    private var olaInvNorm = FloatArray(0)

    private var inputFloatBuffer: FloatBuffer? = null
    private var inputScratch = FloatArray(0)
    private var outputScratch = FloatArray(0)
    private var zeroBiasScratch = FloatArray(0)
    private var inputName = "input"
    private var outputName = "output"

    val isLoaded: Boolean
        get() = synchronized(lock) { session != null }

    fun getExactChunkFrames(): Int = synchronized(lock) {
        val spec = activeSpec ?: ModelCatalog.KARAOKE_SPEC
        (spec.dimT - 1) * spec.hopLength
    }

    fun ensureLoaded(context: Context, mode: String): Boolean {
        val normalized = ModelCatalog.normalizeMode(mode)
        synchronized(lock) {
            if (session != null && loadedMode == normalized) {
                lastLoadError = null
                return true
            }
            lastLoadError = null
            val modelFile = ModelCatalog.resolveModelFile(context, normalized)
            if (!modelFile.exists() || modelFile.length() <= 1_000_000L) {
                val msg = if (ModelCatalog.hasLegacyFp32Model(context, normalized)) {
                    "Outdated FP32 model — re-download QNN A16W16 in Manager"
                } else {
                    "Model not installed ($normalized)"
                }
                lastLoadError = msg
                Log.w(TAG, "$msg: ${modelFile.absolutePath}")
                return false
            }
            if (!ModelCatalog.isQuantizedModelFile(modelFile)) {
                val msg = "Unquantized FP32 model (${modelFile.length() / (1024 * 1024)} MB) is unsupported on-device — re-download QNN A16W16 in Manager"
                lastLoadError = msg
                Log.w(TAG, "$msg: ${modelFile.absolutePath}")
                return false
            }

            val spec = ModelCatalog.getSpec(normalized)
            val ortEnv = env ?: OrtEnvironment.getEnvironment("KaraokeQNN").also { env = it }
            val created = createSessionWithProviderFallback(context, ortEnv, modelFile, spec)
                ?: return false

            closeSessionLocked()
            session = created.first
            activeProvider = created.second
            activeSpec = spec
            loadedMode = normalized

            inputName = session!!.inputNames.firstOrNull() ?: "input"
            outputName = session!!.outputNames.firstOrNull() ?: "output"

            allocateWorkspaceLocked(spec)
            calibrateZeroBiasLocked(ortEnv, created.first, spec, isLegacyA16W8 = modelFile.length() < 20_000_000L)
            Log.i(TAG, "Loaded MDX-NET '${spec.mode}' (${modelFile.length() / (1024 * 1024)} MB) on $activeProvider (SoC=${Build.SOC_MODEL}, shape=[1,4,${spec.dimF},${spec.dimT}], n_fft=${spec.nFft})")
            return true
        }
    }

    private fun createSessionWithProviderFallback(
        context: Context,
        ortEnv: OrtEnvironment,
        modelFile: File,
        spec: MdxModelSpec
    ): Pair<OrtSession, String>? {
        val nativeDir = context.applicationInfo.nativeLibraryDir
        val dspLibPath = "$nativeDir;/vendor/dsp/cdsp;/vendor/lib/rfsa/adsp;/vendor/lib64/rfsa/adsp;/system/vendor/lib/rfsa/adsp;/system/lib/rfsa/adsp;/dsp"
        for (envVar in listOf("ADSP_LIBRARY_PATH", "CDSP_LIBRARY_PATH")) {
            try {
                android.system.Os.setenv(envVar, dspLibPath, true)
            } catch (t: Throwable) {
                Log.w(TAG, "Failed setting $envVar: ${t.message}")
            }
        }

        var lastErr: String? = null

        fun tryCreateQnnSession(
            label: String,
            path: String,
            qnnOpts: Map<String, String>,
            strict: Boolean,
            ctxOutFile: File? = null
        ): Pair<OrtSession, String>? {
            return try {
                OrtSession.SessionOptions().use { opts ->
                    opts.setOptimizationLevel(OrtSession.SessionOptions.OptLevel.ALL_OPT)
                    opts.setSymbolicDimensionValue("batch_size", 1L)
                    if (strict) {
                        opts.addConfigEntry("session.disable_cpu_ep_fallback", "1")
                    }
                    if (ctxOutFile != null) {
                        if (ctxOutFile.exists()) ctxOutFile.delete()
                        opts.addConfigEntry("ep.context_enable", "1")
                        opts.addConfigEntry("ep.context_embed_mode", "1")
                        opts.addConfigEntry("ep.context_file_path", ctxOutFile.absolutePath)
                    }
                    opts.addQnn(qnnOpts)
                    val s = ortEnv.createSession(path, opts)
                    s to label
                }
            } catch (t: Throwable) {
                lastErr = t.message ?: t.javaClass.simpleName
                Log.w(TAG, "$label init failed ($qnnOpts): $lastErr")
                if (ctxOutFile != null && ctxOutFile.exists() && ctxOutFile.length() < 100_000L) {
                    ctxOutFile.delete()
                }
                null
            }
        }

        val qdqHtpAutoOpts = mapOf(
            "backend_type" to "htp",
            "htp_performance_mode" to "sustained_high_performance",
            "htp_graph_finalization_optimization_mode" to "1",
            "vtcm_mb" to "8"
        )
        val detectedArch = detectHtpArch(Build.SOC_MODEL)
        val qdqHtpExplicitOpts = buildMap {
            put("backend_path", File(nativeDir, "libQnnHtp.so").absolutePath)
            if (detectedArch != null) {
                put("htp_arch", detectedArch)
            }
            put("htp_performance_mode", "sustained_high_performance")
            put("htp_graph_finalization_optimization_mode", "1")
            put("vtcm_mb", "8")
        }

        val ctxDir = File(context.cacheDir, "qnn_ctx").apply { mkdirs() }
        val socSafe = Build.SOC_MODEL.uppercase().replace(Regex("[^A-Z0-9_-]"), "").ifBlank { "SOC" }
        val ctxOnnx = File(ctxDir, "${spec.mode}_qdq_${socSafe}_o1_${modelFile.length()}_${spec.hash8}.onnx")
        if (ctxOnnx.exists() && ctxOnnx.length() > 100_000L) {
            tryCreateQnnSession("QNN-HTP", ctxOnnx.absolutePath, qdqHtpAutoOpts, strict = true)?.let {
                Log.i(TAG, "Loaded QNN-HTP cached context binary: ${ctxOnnx.name}")
                return it
            }
            ctxOnnx.delete()
        }

        tryCreateQnnSession("QNN-HTP", modelFile.absolutePath, qdqHtpAutoOpts, strict = true, ctxOutFile = ctxOnnx)?.let {
            return it
        }
        tryCreateQnnSession("QNN-HTP", modelFile.absolutePath, qdqHtpExplicitOpts, strict = true, ctxOutFile = ctxOnnx)?.let {
            return it
        }

        lastLoadError = "QNN-HTP init failed on ${Build.SOC_MODEL.ifBlank { Build.BOARD }}: ${lastErr ?: "unknown"}"
        Log.e(TAG, lastLoadError!!)
        return null
    }

    private fun allocateWorkspaceLocked(spec: MdxModelSpec) {
        val nSamples = (spec.dimT - 1) * spec.hopLength
        val paddedLen = nSamples + spec.nFft
        val tensorLen = 4 * spec.dimF * spec.dimT

        fft = MixedRadixFft(spec.nFft)
        window = MixedRadixFft.createPeriodicHannWindow(spec.nFft)
        padL = FloatArray(paddedLen)
        padR = FloatArray(paddedLen)
        winFrame = FloatArray(spec.nFft)
        fftRe = FloatArray(spec.nFft)
        fftIm = FloatArray(spec.nFft)
        ifftRe = FloatArray(spec.nFft)
        ifftIm = FloatArray(spec.nFft)
        ifftTime = FloatArray(spec.nFft)
        olaOutL = FloatArray(paddedLen)
        olaOutR = FloatArray(paddedLen)
        olaInvNorm = FloatArray(paddedLen)

        val normAccum = FloatArray(paddedLen)
        for (t in 0 until spec.dimT) {
            val off = t * spec.hopLength
            for (n in 0 until spec.nFft) {
                val w = window[n]
                normAccum[off + n] += w * w
            }
        }
        for (i in 0 until paddedLen) {
            olaInvNorm[i] = 1f / max(1e-7f, normAccum[i])
        }

        inputScratch = FloatArray(tensorLen)
        outputScratch = FloatArray(tensorLen)
        inputFloatBuffer = ByteBuffer.allocateDirect(tensorLen * 4)
            .order(ByteOrder.nativeOrder())
            .asFloatBuffer()
    }

    private fun calibrateZeroBiasLocked(
        ortEnv: OrtEnvironment,
        sess: OrtSession,
        spec: MdxModelSpec,
        isLegacyA16W8: Boolean
    ) {
        val tensorLen = 4 * spec.dimF * spec.dimT
        val directBuf = inputFloatBuffer ?: return
        val scratch = FloatArray(tensorLen)
        try {
            inputScratch.fill(0f)
            directBuf.clear()
            directBuf.put(inputScratch)
            directBuf.rewind()
            val shape = longArrayOf(1L, 4L, spec.dimF.toLong(), spec.dimT.toLong())
            OnnxTensor.createTensor(ortEnv, directBuf, shape).use { inputTensor ->
                sess.run(mapOf(inputName to inputTensor)).use { result ->
                    val outVal = result.iterator().next().value as OnnxTensor
                    val outFb = outVal.floatBuffer
                    outFb.rewind()
                    outFb.get(scratch, 0, scratch.size)
                }
            }
            var maxBias = 0f
            for (v in scratch) {
                val av = abs(v)
                if (av > maxBias) maxBias = av
            }
            zeroBiasScratch = if (isLegacyA16W8 && maxBias > 0.25f) scratch else FloatArray(0)
            Log.i(TAG, "Calibrated QNN-HTP zero-bias for '${spec.mode}' (max=${"%.4f".format(maxBias)}, subtract=${zeroBiasScratch.isNotEmpty()})")
        } catch (t: Throwable) {
            zeroBiasScratch = FloatArray(0)
            Log.w(TAG, "Zero-bias calibration failed for '${spec.mode}': ${t.message}")
        }
    }

    fun separateChunk(
        stereoPcm16In: ShortArray,
        validFrames: Int,
        instPcm16Out: ShortArray
    ): Boolean = separateWindow(stereoPcm16In, validFrames, 0, validFrames, instPcm16Out)

    fun separateWindow(
        stereoPcm16In: ShortArray,
        validFrames: Int,
        outStartFrame: Int,
        outFrames: Int,
        instPcm16Out: ShortArray
    ): Boolean = synchronized(lock) {
        val sess = session ?: return@synchronized false
        val spec = activeSpec ?: return@synchronized false
        val ortEnv = env ?: return@synchronized false
        val localFft = fft ?: return@synchronized false
        val directBuf = inputFloatBuffer ?: return@synchronized false

        val nSamples = (spec.dimT - 1) * spec.hopLength
        val halfFft = spec.nFft / 2
        val paddedLen = nSamples + spec.nFft
        val framesToCopy = min(validFrames, min(nSamples, stereoPcm16In.size / 2))
        if (framesToCopy <= 0) return@synchronized false

        val safeOutStart = outStartFrame.coerceIn(0, framesToCopy - 1)
        val safeOutFrames = min(outFrames, framesToCopy - safeOutStart)
        if (safeOutFrames <= 0 || instPcm16Out.size < safeOutFrames * 2) return@synchronized false

        var peakAbs = 0
        val sampleCount = framesToCopy * 2
        for (i in 0 until sampleCount) {
            val a = abs(stereoPcm16In[i].toInt())
            if (a > peakAbs) peakAbs = a
        }
        if (peakAbs <= 8) {
            instPcm16Out.fill(0, 0, safeOutFrames * 2)
            return@synchronized true
        }

        padL.fill(0f, 0, paddedLen)
        padR.fill(0f, 0, paddedLen)
        for (i in 0 until framesToCopy) {
            padL[halfFft + i] = stereoPcm16In[i * 2] * INV_32768
            padR[halfFft + i] = stereoPcm16In[i * 2 + 1] * INV_32768
        }

        // Reflect padding matching C# / UVR STFT
        if (framesToCopy > 1) {
            for (i in 0 until halfFft) {
                val mirrorL = min(framesToCopy - 1, halfFft - i)
                padL[i] = padL[halfFft + mirrorL]
                padR[i] = padR[halfFft + mirrorL]

                val tailIdx = halfFft + nSamples + i
                val mirrorR = max(0, nSamples - 2 - i)
                padL[tailIdx] = padL[halfFft + mirrorR]
                padR[tailIdx] = padR[halfFft + mirrorR]
            }
        }

        val dimF = spec.dimF
        val dimT = spec.dimT
        val ftStride = dimF * dimT
        val ch0 = 0
        val ch1 = ftStride
        val ch2 = 2 * ftStride
        val ch3 = 3 * ftStride

        val tStft0 = System.nanoTime()
        for (t in 0 until dimT) {
            val off = t * spec.hopLength

            for (n in 0 until spec.nFft) winFrame[n] = padL[off + n] * window[n]
            localFft.forward(winFrame, fftRe, fftIm)
            for (f in 0 until dimF) {
                val cell = f * dimT + t
                inputScratch[ch0 + cell] = fftRe[f]
                inputScratch[ch1 + cell] = fftIm[f]
            }

            for (n in 0 until spec.nFft) winFrame[n] = padR[off + n] * window[n]
            localFft.forward(winFrame, fftRe, fftIm)
            for (f in 0 until dimF) {
                val cell = f * dimT + t
                inputScratch[ch2 + cell] = fftRe[f]
                inputScratch[ch3 + cell] = fftIm[f]
            }
        }

        directBuf.clear()
        directBuf.put(inputScratch)
        directBuf.rewind()
        val tOrt0 = System.nanoTime()
        lastStftMs = (tOrt0 - tStft0) / 1_000_000.0

        val shape = longArrayOf(1L, 4L, dimF.toLong(), dimT.toLong())
        OnnxTensor.createTensor(ortEnv, directBuf, shape).use { inputTensor ->
            sess.run(mapOf(inputName to inputTensor)).use { result ->
                val outVal = result.iterator().next().value as OnnxTensor
                val outFb = outVal.floatBuffer
                outFb.rewind()
                outFb.get(outputScratch, 0, outputScratch.size)
            }
        }
        if (zeroBiasScratch.size == outputScratch.size) {
            for (i in outputScratch.indices) {
                outputScratch[i] -= zeroBiasScratch[i]
            }
        }

        val tIstft0 = System.nanoTime()
        lastOrtMs = (tIstft0 - tOrt0) / 1_000_000.0

        val pStart = halfFft + safeOutStart
        val pEnd = pStart + safeOutFrames
        var tStart = max(0, (pStart - spec.nFft) / spec.hopLength)
        while (tStart < dimT && tStart * spec.hopLength + spec.nFft <= pStart) {
            tStart++
        }
        val tEnd = min(dimT - 1, (pEnd - 1) / spec.hopLength)

        olaOutL.fill(0f, 0, paddedLen)
        olaOutR.fill(0f, 0, paddedLen)
        for (t in tStart..tEnd) {
            val off = t * spec.hopLength

            ifftRe.fill(0f)
            ifftIm.fill(0f)
            for (f in 0 until dimF) {
                val cell = f * dimT + t
                val re = outputScratch[ch0 + cell]
                val im = outputScratch[ch1 + cell]
                ifftRe[f] = re
                ifftIm[f] = im
                if (f in 1 until halfFft) {
                    val mir = spec.nFft - f
                    ifftRe[mir] = re
                    ifftIm[mir] = -im
                }
            }
            localFft.inverse(ifftRe, ifftIm, ifftTime)
            for (n in 0 until spec.nFft) {
                olaOutL[off + n] += ifftTime[n] * window[n]
            }

            ifftRe.fill(0f)
            ifftIm.fill(0f)
            for (f in 0 until dimF) {
                val cell = f * dimT + t
                val re = outputScratch[ch2 + cell]
                val im = outputScratch[ch3 + cell]
                ifftRe[f] = re
                ifftIm[f] = im
                if (f in 1 until halfFft) {
                    val mir = spec.nFft - f
                    ifftRe[mir] = re
                    ifftIm[mir] = -im
                }
            }
            localFft.inverse(ifftRe, ifftIm, ifftTime)
            for (n in 0 until spec.nFft) {
                olaOutR[off + n] += ifftTime[n] * window[n]
            }
        }
        lastIstftMs = (System.nanoTime() - tIstft0) / 1_000_000.0

        val comp = spec.compensate
        val primaryIsVocals = spec.primaryStem.equals("Vocals", ignoreCase = true)
        for (i in 0 until safeOutFrames) {
            val inIdx = safeOutStart + i
            val pIdx = halfFft + inIdx
            val scale = olaInvNorm[pIdx] * comp
            val stemL = olaOutL[pIdx] * scale
            val stemR = olaOutR[pIdx] * scale

            val outL = if (primaryIsVocals) (stereoPcm16In[inIdx * 2] * INV_32768 - stemL) else stemL
            val outR = if (primaryIsVocals) (stereoPcm16In[inIdx * 2 + 1] * INV_32768 - stemR) else stemR

            instPcm16Out[i * 2] = (outL * 32767f).roundToInt().coerceIn(-32768, 32767).toShort()
            instPcm16Out[i * 2 + 1] = (outR * 32767f).roundToInt().coerceIn(-32768, 32767).toShort()
        }

        return@synchronized true
    }

    fun runSelfTest(context: Context): String {
        val report = JSONObject()
        val fftResults = JSONArray()
        var allPassed = true

        val rng = Random(42)
        for (n in intArrayOf(2048, 5120, 6144, 7680)) {
            val testFft = MixedRadixFft(n)
            val x = FloatArray(n) { (rng.nextFloat() * 2f - 1f) }
            val re = FloatArray(n)
            val im = FloatArray(n)
            val recon = FloatArray(n)
            testFft.forward(x, re, im)
            testFft.inverse(re, im, recon)
            var maxErr = 0f
            for (i in 0 until n) maxErr = max(maxErr, abs(x[i] - recon[i]))
            if (maxErr > 1e-4f) allPassed = false
            fftResults.put(JSONObject().apply {
                put("n", n)
                put("maxErr", maxErr.toDouble())
                put("ok", maxErr <= 1e-4f)
            })
        }
        report.put("fft", fftResults)

        val onnxResults = JSONArray()
        try {
            for (mode in arrayOf("karaoke", "instrumental")) {
                val entry = JSONObject().put("mode", mode)
                if (!ModelCatalog.isModelInstalled(context, mode)) {
                    entry.put("installed", false)
                    onnxResults.put(entry)
                    continue
                }
                val loaded = ensureLoaded(context, mode)
                entry.put("installed", true)
                entry.put("loaded", loaded)
                entry.put("provider", activeProvider)
                if (loaded) {
                    val frames = getExactChunkFrames()
                    val zeroIn = ShortArray(frames * 2)
                    val zeroOut = ShortArray(frames * 2)
                    separateChunk(zeroIn, frames, zeroOut)
                    var zeroPeak = 0
                    for (s in zeroOut) {
                        val a = abs(s.toInt())
                        if (a > zeroPeak) zeroPeak = a
                    }

                    // Pure 2043-cycle (439.923Hz) stereo asymmetric tone: orthogonal to 1024-sample folding over 200 hops
                    val foldHops = 200
                    val foldPeriod = 1024
                    val freqHz = 2043.0 * 44100.0 / (foldHops * foldPeriod)
                    val pcmIn = ShortArray(frames * 2)
                    for (i in 0 until frames) {
                        val v = sin(2.0 * PI * freqHz * i / 44100.0)
                        pcmIn[i * 2] = (v * 9830.0).roundToInt().coerceIn(-32768, 32767).toShort()
                        pcmIn[i * 2 + 1] = (v * 3276.0).roundToInt().coerceIn(-32768, 32767).toShort()
                    }
                    val pcmOut = ShortArray(frames * 2)
                    // Warmup + timed full-chunk run + timed 24576-frame hop slice
                    separateChunk(pcmIn, frames, pcmOut)
                    val t0 = System.nanoTime()
                    val ok = separateChunk(pcmIn, frames, pcmOut)
                    val ms = (System.nanoTime() - t0) / 1_000_000.0

                    val hopOut = ShortArray(24576 * 2)
                    val th0 = System.nanoTime()
                    separateWindow(pcmIn, frames, frames - 2048 - 24576, 24576, hopOut)
                    val hopMs = (System.nanoTime() - th0) / 1_000_000.0

                    var sumSq = 0.0
                    for (s in pcmOut) {
                        val f = s * INV_32768
                        sumSq += f * f
                    }
                    val rms = sqrt(sumSq / pcmOut.size.coerceAtLeast(1))

                    val folded = DoubleArray(foldPeriod)
                    val foldStart = 10240
                    for (h in 0 until foldHops) {
                        val base = foldStart + h * foldPeriod
                        for (n in 0 until foldPeriod) {
                            folded[n] += pcmOut[(base + n) * 2].toDouble()
                        }
                    }
                    var foldMean = 0.0
                    for (n in 0 until foldPeriod) {
                        folded[n] /= foldHops
                        foldMean += folded[n]
                    }
                    foldMean /= foldPeriod
                    var buzzHarmMaxPcm = 0.0
                    for (k in 1..8) {
                        var re = 0.0
                        var im = 0.0
                        val w = 2.0 * PI * k / foldPeriod
                        for (n in 0 until foldPeriod) {
                            val v = folded[n] - foldMean
                            re += v * cos(w * n)
                            im -= v * sin(w * n)
                        }
                        val amp = sqrt(re * re + im * im) / (foldPeriod / 2.0)
                        if (amp > buzzHarmMaxPcm) buzzHarmMaxPcm = amp
                    }

                    Log.i(TAG, "SelfTest '$mode': prov=$activeProvider fullMs=${"%.1f".format(ms)} hopMs=${"%.1f".format(hopMs)} stft=${"%.1f".format(lastStftMs)} ort=${"%.1f".format(lastOrtMs)} istft=${"%.1f".format(lastIstftMs)} zeroPeak=$zeroPeak buzz43Hz=${"%.2f".format(buzzHarmMaxPcm)} PCM")
                    entry.put("chunkMs", ms)
                    entry.put("hopMs", hopMs)
                    entry.put("stftMs", lastStftMs)
                    entry.put("ortMs", lastOrtMs)
                    entry.put("istftMs", lastIstftMs)
                    entry.put("rms", rms)
                    entry.put("zeroPeak", zeroPeak)
                    entry.put("buzzFoldedPeakPcm", buzzHarmMaxPcm)
                    entry.put("ok", ok && rms > 1e-5 && zeroPeak == 0 && buzzHarmMaxPcm < 5.0)
                    if (!ok || rms <= 1e-5 || zeroPeak != 0 || buzzHarmMaxPcm >= 5.0) allPassed = false
                } else {
                    entry.put("error", lastLoadError ?: "QNN-HTP init failed")
                    allPassed = false
                }
                onnxResults.put(entry)
            }
        } finally {
            // Release ~1.2GB QNN-GPU/ORT session & float buffers right after benchmark unless live mode is ON
            if (!KaraokeLocalServer.karaokeEnabled) {
                close()
                System.gc()
            }
        }
        report.put("onnx", onnxResults)
        report.put("passed", allPassed)
        report.put("socModel", Build.SOC_MODEL)
        return report.toString()
    }

    private fun closeSessionLocked() {
        try { session?.close() } catch (_: Throwable) {}
        session = null
        fft = null
        window = FloatArray(0)
        padL = FloatArray(0)
        padR = FloatArray(0)
        winFrame = FloatArray(0)
        fftRe = FloatArray(0)
        fftIm = FloatArray(0)
        ifftRe = FloatArray(0)
        ifftIm = FloatArray(0)
        ifftTime = FloatArray(0)
        olaOutL = FloatArray(0)
        olaOutR = FloatArray(0)
        olaInvNorm = FloatArray(0)
        inputScratch = FloatArray(0)
        outputScratch = FloatArray(0)
        zeroBiasScratch = FloatArray(0)
        inputFloatBuffer = null
    }

    fun unloadIfMode(mode: String) {
        val normalized = ModelCatalog.normalizeMode(mode)
        synchronized(lock) {
            if (loadedMode == normalized && session != null) {
                closeSessionLocked()
                activeSpec = null
                loadedMode = ""
                activeProvider = "Idle"
                Log.i(TAG, "Unloaded QNN session for deleted mode '$normalized'.")
            }
        }
    }

    override fun close() {
        synchronized(lock) {
            closeSessionLocked()
            try { env?.close() } catch (_: Throwable) {}
            env = null
            activeSpec = null
            loadedMode = ""
            activeProvider = "Idle"
        }
    }
}
