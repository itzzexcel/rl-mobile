package androidx.media3.common.audio;

import java.nio.ByteBuffer;
import java.nio.ByteOrder;

public interface AudioProcessor {
    ByteBuffer EMPTY_BUFFER = ByteBuffer.allocateDirect(0).order(ByteOrder.nativeOrder());

    final class AudioFormat {
        public static final AudioFormat NOT_SET = new AudioFormat(-1, -1, -1);

        public final int sampleRate;
        public final int channelCount;
        public final int encoding;
        public final int bytesPerFrame;

        public AudioFormat(int sampleRate, int channelCount, int encoding) {
            this.sampleRate = sampleRate;
            this.channelCount = channelCount;
            this.encoding = encoding;
            this.bytesPerFrame = -1;
        }
    }

    final class UnhandledAudioFormatException extends Exception {
        public UnhandledAudioFormatException(AudioFormat inputAudioFormat) {
            super("Unhandled input format");
        }
    }

    AudioFormat configure(AudioFormat inputAudioFormat) throws UnhandledAudioFormatException;

    boolean isActive();

    void queueInput(ByteBuffer inputBuffer);

    void queueEndOfStream();

    ByteBuffer getOutput();

    boolean isEnded();

    void flush();

    void reset();
}
