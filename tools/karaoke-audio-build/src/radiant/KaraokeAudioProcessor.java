package radiant;

import android.util.Log;

import androidx.media3.common.audio.AudioProcessor;
import androidx.media3.common.audio.BaseAudioProcessor;

import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.util.LinkedList;

/**
 * Unobfuscated Media3 BaseAudioProcessor hook for TIDAL ExoPlayer.
 * Maintains a passive 5.92s STFT context ring buffer and processes short 557 ms
 * sliding-window hops over Android Binder + SharedMemory to Hexagon HTP NPU,
 * preserving exact 1:1 input-to-output frame conservation across ON/OFF toggles.
 */
public final class KaraokeAudioProcessor extends BaseAudioProcessor {
    private static final String TAG = "RLKaraokeAudio";

    private static final int ENCODING_PCM_16BIT = 2;
    private static final int ENCODING_PCM_FLOAT = 4;
    private static final int ENCODING_PCM_24BIT_MEDIA3 = 21;
    private static final int ENCODING_PCM_24BIT_LEGACY = 536870912;
    private static final int ENCODING_PCM_32BIT_MEDIA3 = 22;
    private static final int ENCODING_PCM_32BIT_LEGACY = 805306368;

    private static final int WINDOW_FRAMES = 261120;
    private static final int WINDOW_BYTES = WINDOW_FRAMES * 4;
    private static final int HOP_FRAMES = 24576;
    private static final int HOP_BYTES = HOP_FRAMES * 4;
    private static final int LOOKAHEAD_FRAMES = 2048;
    private static final int XFADE_FRAMES = 512;
    private static final int XFADE_BYTES = XFADE_FRAMES * 4;
    private static final int DISPATCH_SLICE_FRAMES = HOP_FRAMES + XFADE_FRAMES;
    private static final int DISPATCH_SLICE_BYTES = DISPATCH_SLICE_FRAMES * 4;
    private static final int DISPATCH_OUT_START = WINDOW_FRAMES - LOOKAHEAD_FRAMES - DISPATCH_SLICE_FRAMES;
    private static final int TOGGLE_XFADE_FRAMES = 1323;
    private static final int MAX_BUFFERED_HOPS = 3;
    private static final long WAIT_READY_TIMEOUT_MS = 1800L;

    private static final class PendingChunk {
        final int generation;
        final String mode;
        final byte[] windowDryBytes;
        final byte[] dryHopBytes;

        PendingChunk(int generation, String mode, byte[] windowDryBytes, byte[] dryHopBytes) {
            this.generation = generation;
            this.mode = mode;
            this.windowDryBytes = windowDryBytes;
            this.dryHopBytes = dryHopBytes;
        }
    }

    private static final class ReadyChunk {
        final int generation;
        final byte[] dryBytes;
        final byte[] instBytes;

        ReadyChunk(int generation, byte[] dryBytes, byte[] instBytes) {
            this.generation = generation;
            this.dryBytes = dryBytes;
            this.instBytes = instBytes;
        }
    }

    private final Object queueLock = new Object();
    private final LinkedList<PendingChunk> pendingQueue = new LinkedList<PendingChunk>();
    private final LinkedList<ReadyChunk> readyQueue = new LinkedList<ReadyChunk>();
    private volatile int generation = 0;

    private boolean workerStarted = false;
    private boolean workerBusy = false;
    private byte[] workerPrevTail = new byte[XFADE_BYTES];
    private int workerPrevTailGen = -1;

    private byte[] dryHistory = null;
    private long totalFramesIn = 0L;
    private long totalFramesOut = 0L;
    private long nextDispatchStartFrame = 0L;

    private byte[] scratchPcm16 = new byte[16384];
    private byte[] mixSliceScratch = new byte[32768];
    private byte[] drainScratch = null;

    private boolean primed = false;
    private boolean wasEnabled = false;
    private int fadeInFramesDone = TOGGLE_XFADE_FRAMES;
    private ReadyChunk activeOut = null;
    private int activeOutOffset = 0;

    public KaraokeAudioProcessor() {
        // Zero background threads while Karaoke is OFF.
    }

    private synchronized void ensureWorkerStarted() {
        if (workerStarted) {
            return;
        }
        workerStarted = true;
        Thread worker = new Thread(new Runnable() {
            @Override
            public void run() {
                while (true) {
                    PendingChunk task;
                    synchronized (queueLock) {
                        while (pendingQueue.isEmpty()) {
                            try {
                                queueLock.wait();
                            } catch (InterruptedException e) {
                                return;
                            }
                        }
                        task = pendingQueue.pollFirst();
                        workerBusy = (task != null);
                        queueLock.notifyAll();
                    }
                    if (task == null || task.generation != generation) {
                        synchronized (queueLock) {
                            workerBusy = false;
                            queueLock.notifyAll();
                        }
                        continue;
                    }
                    byte[] wetSlice = KaraokeBridge.separateHop(
                            task.mode, task.windowDryBytes, DISPATCH_OUT_START, DISPATCH_SLICE_FRAMES);

                    byte[] instHop;
                    if (wetSlice != null && wetSlice.length >= DISPATCH_SLICE_BYTES) {
                        instHop = new byte[HOP_BYTES];
                        System.arraycopy(wetSlice, 0, instHop, 0, HOP_BYTES);
                        if (workerPrevTailGen == task.generation) {
                            crossfadeInPlace(workerPrevTail, instHop, XFADE_FRAMES);
                        }
                        System.arraycopy(wetSlice, HOP_BYTES, workerPrevTail, 0, XFADE_BYTES);
                        workerPrevTailGen = task.generation;
                    } else {
                        instHop = task.dryHopBytes;
                        workerPrevTailGen = -1;
                    }

                    synchronized (queueLock) {
                        workerBusy = false;
                        if (task.generation == generation && KaraokeBridge.isEnabled()) {
                            readyQueue.addLast(new ReadyChunk(task.generation, task.dryHopBytes, instHop));
                        }
                        queueLock.notifyAll();
                    }
                }
            }
        }, "Karaoke-HTP-Worker");
        worker.setDaemon(true);
        worker.start();
    }

    private static void crossfadeInPlace(byte[] prevTail, byte[] nextHead, int frames) {
        for (int i = 0; i < frames; i++) {
            float alpha = (i + 0.5f) / (float) frames;
            float inv = 1f - alpha;
            int idx = i * 4;
            blendStereoSample(prevTail, idx, nextHead, idx, inv, alpha, nextHead, idx);
        }
    }

    private static void blendStereoSample(
            byte[] srcA, int offA,
            byte[] srcB, int offB,
            float weightA, float weightB,
            byte[] dst, int dstOff) {
        int lA = (srcA[offA] & 0xFF) | (srcA[offA + 1] << 8);
        int lB = (srcB[offB] & 0xFF) | (srcB[offB + 1] << 8);
        int rA = (srcA[offA + 2] & 0xFF) | (srcA[offA + 3] << 8);
        int rB = (srcB[offB + 2] & 0xFF) | (srcB[offB + 3] << 8);
        int l = Math.round(lA * weightA + lB * weightB);
        int r = Math.round(rA * weightA + rB * weightB);
        if (l < -32768) l = -32768; else if (l > 32767) l = 32767;
        if (r < -32768) r = -32768; else if (r > 32767) r = 32767;
        dst[dstOff] = (byte) (l & 0xFF);
        dst[dstOff + 1] = (byte) ((l >> 8) & 0xFF);
        dst[dstOff + 2] = (byte) (r & 0xFF);
        dst[dstOff + 3] = (byte) ((r >> 8) & 0xFF);
    }

    @Override
    public AudioFormat onConfigure(AudioFormat inputAudioFormat) throws UnhandledAudioFormatException {
        if (inputAudioFormat == null || inputAudioFormat.channelCount != 2) {
            return AudioFormat.NOT_SET;
        }
        if (!isSupportedEncoding(inputAudioFormat.encoding)) {
            return AudioFormat.NOT_SET;
        }
        Log.i(TAG, "onConfigure sr=" + inputAudioFormat.sampleRate
                + " ch=" + inputAudioFormat.channelCount
                + " enc=" + inputAudioFormat.encoding);
        return new AudioFormat(inputAudioFormat.sampleRate, 2, ENCODING_PCM_16BIT);
    }

    private static boolean isSupportedEncoding(int enc) {
        return enc == ENCODING_PCM_16BIT
                || enc == ENCODING_PCM_FLOAT
                || enc == ENCODING_PCM_24BIT_MEDIA3
                || enc == ENCODING_PCM_24BIT_LEGACY
                || enc == ENCODING_PCM_32BIT_MEDIA3
                || enc == ENCODING_PCM_32BIT_LEGACY;
    }

    @Override
    public void queueInput(ByteBuffer inputBuffer) {
        int remaining = inputBuffer.remaining();
        int pcm16Bytes = remaining > 0 ? convertInputToPcm16(inputBuffer) : 0;
        boolean enabled = KaraokeBridge.isEnabled();

        if (!enabled) {
            if (wasEnabled) {
                wasEnabled = false;
                drainWetToDryOnDisable(pcm16Bytes);
                return;
            }
            if (pcm16Bytes > 0) {
                appendToHistory(scratchPcm16, 0, pcm16Bytes);
                totalFramesIn += (pcm16Bytes / 4);
                totalFramesOut = totalFramesIn;
                ByteBuffer out = replaceOutputBuffer(pcm16Bytes);
                out.put(scratchPcm16, 0, pcm16Bytes);
                out.flip();
            }
            return;
        }

        ensureWorkerStarted();
        if (!wasEnabled) {
            wasEnabled = true;
            clearQueuesLocked();
            nextDispatchStartFrame = totalFramesOut;
            fadeInFramesDone = 0;
        }

        if (pcm16Bytes > 0) {
            int offsetBytes = 0;
            while (offsetBytes < pcm16Bytes) {
                long neededEnd = nextDispatchStartFrame + DISPATCH_SLICE_FRAMES + LOOKAHEAD_FRAMES;
                long framesUntil = neededEnd - totalFramesIn;
                int takeBytes;
                if (framesUntil <= 0L) {
                    takeBytes = 0;
                } else {
                    long maxBytes = framesUntil * 4L;
                    takeBytes = (int) Math.min(maxBytes, (long) (pcm16Bytes - offsetBytes));
                }
                if (takeBytes > 0) {
                    appendToHistory(scratchPcm16, offsetBytes, takeBytes);
                    totalFramesIn += (takeBytes / 4);
                    offsetBytes += takeBytes;
                }
                if (totalFramesIn >= neededEnd) {
                    byte[] windowBytes = new byte[WINDOW_BYTES];
                    readHistoryWindow(totalFramesIn - WINDOW_FRAMES, WINDOW_FRAMES, windowBytes, 0);
                    byte[] dryHop = new byte[HOP_BYTES];
                    System.arraycopy(windowBytes, DISPATCH_OUT_START * 4, dryHop, 0, HOP_BYTES);
                    enqueueHopWithBackpressure(new PendingChunk(generation, KaraokeBridge.getMode(), windowBytes, dryHop));
                    nextDispatchStartFrame += HOP_FRAMES;
                }
            }
        }

        if (!primed) {
            int myGen = generation;
            synchronized (queueLock) {
                if (readyQueue.isEmpty() && (workerBusy || !pendingQueue.isEmpty()) && generation == myGen) {
                    long deadline = System.currentTimeMillis() + WAIT_READY_TIMEOUT_MS;
                    while (readyQueue.isEmpty() && generation == myGen && KaraokeBridge.isEnabled()) {
                        long left = deadline - System.currentTimeMillis();
                        if (left <= 0L) {
                            break;
                        }
                        try {
                            queueLock.wait(Math.min(20L, left));
                        } catch (InterruptedException ignored) {
                            break;
                        }
                    }
                }
                if (!readyQueue.isEmpty()) {
                    primed = true;
                }
            }
            if (!primed) {
                return;
            }
        }

        if (pcm16Bytes > 0) {
            emitWetExactly(pcm16Bytes);
        }
    }

    private void drainWetToDryOnDisable(int newPcm16Bytes) {
        ReadyChunk curActive = activeOut;
        int curOff = activeOutOffset;
        clearQueuesLocked();

        if (newPcm16Bytes > 0) {
            appendToHistory(scratchPcm16, 0, newPcm16Bytes);
            totalFramesIn += (newPcm16Bytes / 4);
        }

        long backlogFrames = totalFramesIn - totalFramesOut;
        if (backlogFrames <= 0L) {
            totalFramesOut = totalFramesIn;
            return;
        }

        int totalOutBytes = (int) (backlogFrames * 4L);
        if (drainScratch == null || drainScratch.length < totalOutBytes) {
            drainScratch = new byte[totalOutBytes];
        }
        readHistoryWindow(totalFramesOut, (int) backlogFrames, drainScratch, 0);

        if (curActive != null && curOff < curActive.dryBytes.length) {
            int availWetFrames = Math.min(TOGGLE_XFADE_FRAMES,
                    Math.min((curActive.dryBytes.length - curOff) / 4, (int) backlogFrames));
            float vocalGain = KaraokeBridge.getVocalGain();
            for (int i = 0; i < availWetFrames; i++) {
                float wetWeight = 1f - ((i + 0.5f) / (float) availWetFrames);
                int idx = i * 4;
                int cIdx = curOff + idx;
                int wetL = wetSampleAt(curActive.dryBytes, curActive.instBytes, cIdx, vocalGain);
                int wetR = wetSampleAt(curActive.dryBytes, curActive.instBytes, cIdx + 2, vocalGain);
                int dryL = (drainScratch[idx] & 0xFF) | (drainScratch[idx + 1] << 8);
                int dryR = (drainScratch[idx + 2] & 0xFF) | (drainScratch[idx + 3] << 8);
                int l = Math.round(wetL * wetWeight + dryL * (1f - wetWeight));
                int r = Math.round(wetR * wetWeight + dryR * (1f - wetWeight));
                if (l < -32768) l = -32768; else if (l > 32767) l = 32767;
                if (r < -32768) r = -32768; else if (r > 32767) r = 32767;
                drainScratch[idx] = (byte) (l & 0xFF);
                drainScratch[idx + 1] = (byte) ((l >> 8) & 0xFF);
                drainScratch[idx + 2] = (byte) (r & 0xFF);
                drainScratch[idx + 3] = (byte) ((r >> 8) & 0xFF);
            }
        }

        totalFramesOut = totalFramesIn;
        ByteBuffer out = replaceOutputBuffer(totalOutBytes);
        out.put(drainScratch, 0, totalOutBytes);
        out.flip();
    }

    private void enqueueHopWithBackpressure(PendingChunk task) {
        int myGen = generation;
        synchronized (queueLock) {
            while ((pendingQueue.size() + readyQueue.size() + (workerBusy ? 1 : 0)) >= MAX_BUFFERED_HOPS
                    && generation == myGen
                    && KaraokeBridge.isEnabled()) {
                try {
                    queueLock.wait(20L);
                } catch (InterruptedException ignored) {
                    break;
                }
            }
            if (generation == myGen && KaraokeBridge.isEnabled()) {
                pendingQueue.addLast(task);
                queueLock.notifyAll();
            }
        }
    }

    private ReadyChunk awaitNextReadyChunk(long timeoutMs) {
        int myGen = generation;
        long deadline = System.currentTimeMillis() + timeoutMs;
        synchronized (queueLock) {
            while (generation == myGen) {
                while (!readyQueue.isEmpty()) {
                    ReadyChunk candidate = readyQueue.pollFirst();
                    if (candidate != null && candidate.generation == myGen) {
                        queueLock.notifyAll();
                        return candidate;
                    }
                }
                if (!KaraokeBridge.isEnabled()) {
                    return null;
                }
                long left = deadline - System.currentTimeMillis();
                if (left <= 0L) {
                    return null;
                }
                try {
                    queueLock.wait(Math.min(20L, left));
                } catch (InterruptedException ignored) {
                    return null;
                }
            }
            return null;
        }
    }

    private void emitWetExactly(int targetBytes) {
        ByteBuffer out = replaceOutputBuffer(targetBytes);
        float vocalGain = KaraokeBridge.getVocalGain();
        int written = 0;

        while (written < targetBytes) {
            ReadyChunk chunk = activeOut;
            if (chunk == null || chunk.generation != generation || activeOutOffset >= chunk.dryBytes.length) {
                chunk = awaitNextReadyChunk(WAIT_READY_TIMEOUT_MS);
                activeOut = chunk;
                activeOutOffset = 0;
            }
            if (chunk == null) {
                int fallbackBytes = targetBytes - written;
                ensureMixScratchCapacity(fallbackBytes);
                readHistoryWindow(totalFramesOut, fallbackBytes / 4, mixSliceScratch, 0);
                out.put(mixSliceScratch, 0, fallbackBytes);
                totalFramesOut += (fallbackBytes / 4);
                written += fallbackBytes;
                break;
            }

            int avail = chunk.dryBytes.length - activeOutOffset;
            int take = Math.min(avail, targetBytes - written);
            appendBlendedSlice(out, chunk.dryBytes, chunk.instBytes, activeOutOffset, take, vocalGain);
            activeOutOffset += take;
            totalFramesOut += (take / 4);
            written += take;

            if (activeOutOffset >= chunk.dryBytes.length) {
                activeOut = null;
                activeOutOffset = 0;
            }
        }

        out.flip();
    }

    private static int wetSampleAt(byte[] dry, byte[] inst, int byteOff, float vocalGain) {
        int d = (dry[byteOff] & 0xFF) | (dry[byteOff + 1] << 8);
        if (inst == null || inst.length != dry.length || vocalGain >= 0.999f) {
            return d;
        }
        int ins = (inst[byteOff] & 0xFF) | (inst[byteOff + 1] << 8);
        if (vocalGain <= 0.001f) {
            return ins;
        }
        return Math.round(ins + (d - ins) * vocalGain);
    }

    private void appendBlendedSlice(ByteBuffer out, byte[] dry, byte[] inst, int off, int len, float vocalGain) {
        if (fadeInFramesDone >= TOGGLE_XFADE_FRAMES) {
            if (inst == null || inst.length != dry.length || vocalGain >= 0.999f) {
                out.put(dry, off, len);
                return;
            }
            if (vocalGain <= 0.001f) {
                out.put(inst, off, len);
                return;
            }
        }
        ensureMixScratchCapacity(len);
        int frames = len / 4;
        for (int f = 0; f < frames; f++) {
            int i = f * 4;
            int idx = off + i;
            float effVocalGain = vocalGain;
            if (fadeInFramesDone < TOGGLE_XFADE_FRAMES) {
                float ramp = (fadeInFramesDone + 0.5f) / (float) TOGGLE_XFADE_FRAMES;
                fadeInFramesDone++;
                effVocalGain = 1f - ramp * (1f - vocalGain);
            }
            int l = wetSampleAt(dry, inst, idx, effVocalGain);
            int r = wetSampleAt(dry, inst, idx + 2, effVocalGain);
            if (l < -32768) l = -32768; else if (l > 32767) l = 32767;
            if (r < -32768) r = -32768; else if (r > 32767) r = 32767;
            mixSliceScratch[i] = (byte) (l & 0xFF);
            mixSliceScratch[i + 1] = (byte) ((l >> 8) & 0xFF);
            mixSliceScratch[i + 2] = (byte) (r & 0xFF);
            mixSliceScratch[i + 3] = (byte) ((r >> 8) & 0xFF);
        }
        out.put(mixSliceScratch, 0, len);
    }

    @Override
    public void onQueueEndOfStream() {
        long remFrames = totalFramesIn - totalFramesOut;
        if (remFrames <= 0L) {
            return;
        }
        int remBytes = (int) (remFrames * 4L);
        if (drainScratch == null || drainScratch.length < remBytes) {
            drainScratch = new byte[remBytes];
        }
        readHistoryWindow(totalFramesOut, (int) remFrames, drainScratch, 0);
        totalFramesOut = totalFramesIn;
        ByteBuffer out = replaceOutputBuffer(remBytes);
        out.put(drainScratch, 0, remBytes);
        out.flip();
    }

    @Override
    public void onFlush() {
        clearQueuesLocked();
        totalFramesIn = 0L;
        totalFramesOut = 0L;
        nextDispatchStartFrame = 0L;
        fadeInFramesDone = TOGGLE_XFADE_FRAMES;
    }

    @Override
    public void onReset() {
        onFlush();
        wasEnabled = false;
        dryHistory = null;
        drainScratch = null;
    }

    private void clearQueuesLocked() {
        primed = false;
        activeOut = null;
        activeOutOffset = 0;
        synchronized (queueLock) {
            generation++;
            pendingQueue.clear();
            readyQueue.clear();
            queueLock.notifyAll();
        }
    }

    private void appendToHistory(byte[] src, int off, int lenBytes) {
        if (lenBytes <= 0) return;
        if (dryHistory == null) {
            dryHistory = new byte[WINDOW_BYTES];
        }
        int srcPos = off;
        int left = lenBytes;
        if (left >= WINDOW_BYTES) {
            srcPos += (left - WINDOW_BYTES);
            left = WINDOW_BYTES;
        }
        long startByteGlobal = (totalFramesIn * 4L) + (srcPos - off);
        int ringPos = (int) (startByteGlobal % WINDOW_BYTES);
        int first = Math.min(left, WINDOW_BYTES - ringPos);
        System.arraycopy(src, srcPos, dryHistory, ringPos, first);
        if (first < left) {
            System.arraycopy(src, srcPos + first, dryHistory, 0, left - first);
        }
    }

    private void readHistoryWindow(long startFrame, int numFrames, byte[] dst, int dstOff) {
        int bytesNeeded = numFrames * 4;
        if (dryHistory == null || numFrames <= 0) {
            for (int i = 0; i < bytesNeeded; i++) dst[dstOff + i] = 0;
            return;
        }
        long oldestValidFrame = Math.max(0L, totalFramesIn - WINDOW_FRAMES);
        int written = 0;
        if (startFrame < oldestValidFrame) {
            int padFrames = (int) Math.min(numFrames, oldestValidFrame - startFrame);
            int padBytes = padFrames * 4;
            for (int i = 0; i < padBytes; i++) dst[dstOff + i] = 0;
            written += padBytes;
            startFrame += padFrames;
            numFrames -= padFrames;
        }
        if (numFrames <= 0) return;

        int ringBytes = numFrames * 4;
        int ringPos = (int) ((startFrame * 4L) % WINDOW_BYTES);
        int first = Math.min(ringBytes, WINDOW_BYTES - ringPos);
        System.arraycopy(dryHistory, ringPos, dst, dstOff + written, first);
        if (first < ringBytes) {
            System.arraycopy(dryHistory, 0, dst, dstOff + written + first, ringBytes - first);
        }
    }

    private int convertInputToPcm16(ByteBuffer inputBuffer) {
        int remaining = inputBuffer.remaining();
        int enc = inputAudioFormat.encoding;
        if (enc == ENCODING_PCM_16BIT) {
            int copyBytes = remaining & ~3;
            ensureScratchCapacity(copyBytes);
            inputBuffer.get(scratchPcm16, 0, copyBytes);
            return copyBytes;
        }

        if (enc == ENCODING_PCM_24BIT_MEDIA3 || enc == ENCODING_PCM_24BIT_LEGACY) {
            int frames = remaining / 6;
            int outBytes = frames * 4;
            ensureScratchCapacity(outBytes);
            int pos = inputBuffer.position();
            int outIdx = 0;
            if (inputBuffer.order() == ByteOrder.LITTLE_ENDIAN) {
                for (int f = 0; f < frames; f++) {
                    int base = pos + f * 6;
                    scratchPcm16[outIdx++] = inputBuffer.get(base + 1);
                    scratchPcm16[outIdx++] = inputBuffer.get(base + 2);
                    scratchPcm16[outIdx++] = inputBuffer.get(base + 4);
                    scratchPcm16[outIdx++] = inputBuffer.get(base + 5);
                }
            } else {
                for (int f = 0; f < frames; f++) {
                    int base = pos + f * 6;
                    scratchPcm16[outIdx++] = inputBuffer.get(base + 1);
                    scratchPcm16[outIdx++] = inputBuffer.get(base);
                    scratchPcm16[outIdx++] = inputBuffer.get(base + 4);
                    scratchPcm16[outIdx++] = inputBuffer.get(base + 3);
                }
            }
            inputBuffer.position(pos + frames * 6);
            return outBytes;
        }

        if (enc == ENCODING_PCM_32BIT_MEDIA3 || enc == ENCODING_PCM_32BIT_LEGACY) {
            int frames = remaining / 8;
            int outBytes = frames * 4;
            ensureScratchCapacity(outBytes);
            int pos = inputBuffer.position();
            int outIdx = 0;
            if (inputBuffer.order() == ByteOrder.LITTLE_ENDIAN) {
                for (int f = 0; f < frames; f++) {
                    int base = pos + f * 8;
                    scratchPcm16[outIdx++] = inputBuffer.get(base + 2);
                    scratchPcm16[outIdx++] = inputBuffer.get(base + 3);
                    scratchPcm16[outIdx++] = inputBuffer.get(base + 6);
                    scratchPcm16[outIdx++] = inputBuffer.get(base + 7);
                }
            } else {
                for (int f = 0; f < frames; f++) {
                    int base = pos + f * 8;
                    scratchPcm16[outIdx++] = inputBuffer.get(base + 1);
                    scratchPcm16[outIdx++] = inputBuffer.get(base);
                    scratchPcm16[outIdx++] = inputBuffer.get(base + 5);
                    scratchPcm16[outIdx++] = inputBuffer.get(base + 4);
                }
            }
            inputBuffer.position(pos + frames * 8);
            return outBytes;
        }

        if (enc == ENCODING_PCM_FLOAT) {
            int frames = remaining / 8;
            int outBytes = frames * 4;
            ensureScratchCapacity(outBytes);
            int outIdx = 0;
            for (int f = 0; f < frames; f++) {
                float fl = inputBuffer.getFloat();
                float fr = inputBuffer.getFloat();
                int sl = Math.round(fl * 32767f);
                int sr = Math.round(fr * 32767f);
                if (sl < -32768) sl = -32768; else if (sl > 32767) sl = 32767;
                if (sr < -32768) sr = -32768; else if (sr > 32767) sr = 32767;
                scratchPcm16[outIdx++] = (byte) (sl & 0xFF);
                scratchPcm16[outIdx++] = (byte) ((sl >> 8) & 0xFF);
                scratchPcm16[outIdx++] = (byte) (sr & 0xFF);
                scratchPcm16[outIdx++] = (byte) ((sr >> 8) & 0xFF);
            }
            return outBytes;
        }

        inputBuffer.position(inputBuffer.limit());
        return 0;
    }

    private void ensureScratchCapacity(int needed) {
        if (scratchPcm16.length < needed) {
            scratchPcm16 = new byte[needed];
        }
    }

    private void ensureMixScratchCapacity(int needed) {
        if (mixSliceScratch.length < needed) {
            mixSliceScratch = new byte[needed];
        }
    }
}
