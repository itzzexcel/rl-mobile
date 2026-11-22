package androidx.media3.common.audio;

import java.nio.ByteBuffer;

public abstract class BaseAudioProcessor implements AudioProcessor {
    protected AudioFormat inputAudioFormat = AudioFormat.NOT_SET;
    protected AudioFormat outputAudioFormat = AudioFormat.NOT_SET;

    @Override
    public final AudioFormat configure(AudioFormat inputAudioFormat) throws UnhandledAudioFormatException {
        return AudioFormat.NOT_SET;
    }

    @Override
    public boolean isActive() {
        return false;
    }

    @Override
    public final void queueEndOfStream() {
    }

    @Override
    public ByteBuffer getOutput() {
        return EMPTY_BUFFER;
    }

    @Override
    public boolean isEnded() {
        return false;
    }

    @Override
    public final void flush() {
    }

    @Override
    public final void reset() {
    }

    public AudioFormat onConfigure(AudioFormat inputAudioFormat) throws UnhandledAudioFormatException {
        return AudioFormat.NOT_SET;
    }

    public void onQueueEndOfStream() {
    }

    public void onFlush() {
    }

    public void onReset() {
    }

    public final ByteBuffer replaceOutputBuffer(int count) {
        return EMPTY_BUFFER;
    }
}
