package com.meowarex.rlmobile.karaoke

import org.junit.Assert.assertArrayEquals
import org.junit.Assert.assertTrue
import org.junit.Test
import java.io.File
import kotlin.io.path.createTempDirectory
import kotlin.math.abs
import kotlin.math.max
import kotlin.random.Random

class MixedRadixFftTest {
    @Test
    fun roundTripAccuracyAcrossMdxSizes() {
        val rng = Random(42)
        for (n in intArrayOf(2048, 5120, 6144, 7680)) {
            val fft = MixedRadixFft(n)
            val input = FloatArray(n) { rng.nextFloat() * 2f - 1f }
            val re = FloatArray(n)
            val im = FloatArray(n)
            val recon = FloatArray(n)

            fft.forward(input, re, im)
            fft.inverse(re, im, recon)

            var maxErr = 0f
            for (i in 0 until n) {
                maxErr = max(maxErr, abs(input[i] - recon[i]))
            }
            assertTrue("FFT N=$n error too large: $maxErr", maxErr <= 1e-4f)
        }
    }

    @Test
    fun stemDiskCacheRoundTrip() {
        val dir = createTempDirectory("krk_cache_unit_").toFile()
        try {
            val cache = StemDiskCache(dir)
            val sample = ShortArray(4096) { i -> ((i * 73) % 30000 - 15000).toShort() }
            cache.saveInstrumental("track_99", "karaoke", "1d64a6d2", sample)
            val loaded = cache.tryLoadInstrumental("track_99", "karaoke", "1d64a6d2")
            assertArrayEquals(sample, loaded)
        } finally {
            dir.deleteRecursively()
        }
    }
}
