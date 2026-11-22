package com.meowarex.rlmobile.karaoke

import android.app.Service
import android.content.Intent
import android.os.Binder
import android.os.IBinder
import android.os.Parcel
import android.os.SharedMemory
import android.system.OsConstants
import android.util.Log
import java.nio.ByteOrder

/**
 * Bound Binder + SharedMemory relay service for patched TIDAL.
 * Avoids Android 17 loopback socket restrictions (ACCESS_LOCAL_NETWORK) and
 * keeps QNN Hexagon HTP session strictly on-demand (unloads immediately on unbind/OFF).
 */
class KaraokeRelayService : Service() {
    companion object {
        private const val TAG = "KaraokeRelay"
        private const val DESCRIPTOR = "radiant.karaoke.IRelay"
        private const val TX_GET_STATUS = Binder.FIRST_CALL_TRANSACTION + 0 // 1
        private const val TX_SEPARATE_PCM = Binder.FIRST_CALL_TRANSACTION + 1 // 2
        private const val TX_UNLOAD = Binder.FIRST_CALL_TRANSACTION + 2 // 3
        private const val TX_SEPARATE_HOP = Binder.FIRST_CALL_TRANSACTION + 3 // 4
    }

    private val sepLock = Any()
    private val separator = QnnStemSeparator()
    private var inShorts = ShortArray(0)
    private var outShorts = ShortArray(0)

    @Volatile
    private var lastChunkMs = 0.0

    private val binder = object : Binder() {
        override fun onTransact(code: Int, data: Parcel, reply: Parcel?, flags: Int): Boolean {
            when (code) {
                INTERFACE_TRANSACTION -> {
                    reply?.writeString(DESCRIPTOR)
                    return true
                }

                TX_GET_STATUS -> {
                    data.enforceInterface(DESCRIPTOR)
                    val requestedMode = ModelCatalog.normalizeMode(data.readString())
                    val chunkFrames = run {
                        val s = ModelCatalog.getSpec(requestedMode)
                        (s.dimT - 1) * s.hopLength
                    }
                    reply?.apply {
                        writeNoException()
                        writeInt(if (ModelCatalog.isModelInstalled(applicationContext, "karaoke")) 1 else 0)
                        writeInt(if (ModelCatalog.isModelInstalled(applicationContext, "instrumental")) 1 else 0)
                        writeString(separator.activeProvider)
                        writeDouble(lastChunkMs)
                        writeInt(chunkFrames)
                    }
                    return true
                }

                TX_SEPARATE_PCM -> {
                    data.enforceInterface(DESCRIPTOR)
                    val mode = ModelCatalog.normalizeMode(data.readString())
                    val byteCount = data.readInt()
                    val shm = SharedMemory.CREATOR.createFromParcel(data)
                    handleSeparatePcm(mode, byteCount, 0, -1, shm, reply)
                    return true
                }

                TX_SEPARATE_HOP -> {
                    data.enforceInterface(DESCRIPTOR)
                    val mode = ModelCatalog.normalizeMode(data.readString())
                    val windowBytes = data.readInt()
                    val outStartFrame = data.readInt()
                    val outFrames = data.readInt()
                    val shm = SharedMemory.CREATOR.createFromParcel(data)
                    handleSeparatePcm(mode, windowBytes, outStartFrame, outFrames, shm, reply)
                    return true
                }

                TX_UNLOAD -> {
                    data.enforceInterface(DESCRIPTOR)
                    unloadAll()
                    reply?.writeNoException()
                    return true
                }
            }
            return super.onTransact(code, data, reply, flags)
        }
    }

    private fun handleSeparatePcm(
        mode: String,
        byteCount: Int,
        outStartFrame: Int,
        requestedOutFrames: Int,
        shm: SharedMemory,
        reply: Parcel?
    ) {
        var mapped: java.nio.ByteBuffer? = null
        try {
            if (byteCount < 4 || (byteCount and 3) != 0 || byteCount > shm.size) {
                reply?.apply {
                    writeNoException()
                    writeInt(0)
                    writeString("Invalid PCM byteCount=$byteCount")
                }
                return
            }

            mapped = shm.map(OsConstants.PROT_READ or OsConstants.PROT_WRITE, 0, byteCount)
            synchronized(sepLock) {
                if (!ModelCatalog.isModelInstalled(applicationContext, mode)) {
                    reply?.apply {
                        writeNoException()
                        writeInt(0)
                        writeString("Model not installed ($mode)")
                    }
                    return
                }

                if (!separator.ensureLoaded(applicationContext, mode)) {
                    reply?.apply {
                        writeNoException()
                        writeInt(0)
                        writeString("Failed loading QNN-HTP session ($mode)")
                    }
                    return
                }

                val sampleCount = byteCount / 2
                val frames = sampleCount / 2
                if (frames > separator.getExactChunkFrames()) {
                    reply?.apply {
                        writeNoException()
                        writeInt(0)
                        writeString("Chunk exceeds max frames ($frames)")
                    }
                    return
                }

                val outFrames = if (requestedOutFrames > 0) requestedOutFrames.coerceAtMost(frames) else frames
                val safeOutStart = outStartFrame.coerceIn(0, (frames - outFrames).coerceAtLeast(0))
                val outSamples = outFrames * 2

                if (inShorts.size < sampleCount) inShorts = ShortArray(sampleCount)
                if (outShorts.size < outSamples) outShorts = ShortArray(outSamples)

                mapped.order(ByteOrder.LITTLE_ENDIAN)
                mapped.position(0)
                val sbIn = mapped.asShortBuffer()
                sbIn.get(inShorts, 0, sampleCount)

                val t0 = System.nanoTime()
                val ok = separator.separateWindow(inShorts, frames, safeOutStart, outFrames, outShorts)
                val elapsedMs = (System.nanoTime() - t0) / 1_000_000.0
                lastChunkMs = elapsedMs

                if (!ok) {
                    reply?.apply {
                        writeNoException()
                        writeInt(0)
                        writeString("QNN separation failed")
                    }
                    return
                }

                val tagOp = if (requestedOutFrames > 0) "TX_SEPARATE_HOP" else "TX_SEPARATE_PCM"
                Log.i(TAG, "$tagOp mode=$mode win=$frames hop=$outFrames ms=${"%.1f".format(elapsedMs)} prov=${separator.activeProvider}")

                mapped.position(0)
                val sbOut = mapped.asShortBuffer()
                sbOut.put(outShorts, 0, outSamples)

                reply?.apply {
                    writeNoException()
                    writeInt(1)
                    writeString(separator.activeProvider)
                    writeDouble(elapsedMs)
                }
            }
        } catch (t: Throwable) {
            Log.e(TAG, "TX_SEPARATE_PCM error: ${t.message}", t)
            reply?.apply {
                writeNoException()
                writeInt(0)
                writeString(t.message ?: "Binder separation error")
            }
        } finally {
            if (mapped != null) {
                try { SharedMemory.unmap(mapped) } catch (_: Throwable) {}
            }
            try { shm.close() } catch (_: Throwable) {}
        }
    }

    private fun unloadAll() {
        synchronized(sepLock) {
            separator.close()
            inShorts = ShortArray(0)
            outShorts = ShortArray(0)
        }
        System.gc()
        Log.i(TAG, "Unloaded Karaoke HTP NPU session and freed buffers")
    }

    override fun onBind(intent: Intent?): IBinder = binder

    override fun onUnbind(intent: Intent?): Boolean {
        unloadAll()
        return false
    }

    override fun onDestroy() {
        unloadAll()
        super.onDestroy()
    }
}
