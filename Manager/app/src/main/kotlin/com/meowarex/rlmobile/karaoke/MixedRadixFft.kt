package com.meowarex.rlmobile.karaoke

import kotlin.math.PI
import kotlin.math.cos
import kotlin.math.sin
import kotlin.math.sqrt

/**
 * Iterative Stockham mixed-radix complex FFT supporting factors 2, 3, 4, 5
 * for all UVR MDX-NET sizes (2048, 5120, 6144, 7680).
 */
class MixedRadixFft(val length: Int) {
    private val radices: IntArray
    private val pValues: IntArray
    private val fwdTwCos: Array<FloatArray>
    private val fwdTwSin: Array<FloatArray>
    private val invTwCos: Array<FloatArray>
    private val invTwSin: Array<FloatArray>

    private val bufARe: FloatArray
    private val bufAIm: FloatArray
    private val bufBRe: FloatArray
    private val bufBIm: FloatArray

    init {
        require(length >= 2) { "FFT length must be >= 2" }

        val rads = ArrayList<Int>()
        var rem = length
        while (rem % 4 == 0) { rads.add(4); rem /= 4 }
        while (rem % 2 == 0) { rads.add(2); rem /= 2 }
        while (rem % 3 == 0) { rads.add(3); rem /= 3 }
        while (rem % 5 == 0) { rads.add(5); rem /= 5 }
        require(rem == 1) { "Unsupported FFT size $length: only products of 2, 3, 5 are supported." }

        radices = rads.toIntArray()
        pValues = IntArray(radices.size)
        fwdTwCos = Array(radices.size) { FloatArray(0) }
        fwdTwSin = Array(radices.size) { FloatArray(0) }
        invTwCos = Array(radices.size) { FloatArray(0) }
        invTwSin = Array(radices.size) { FloatArray(0) }

        var p = 1
        for (stage in radices.indices) {
            val r = radices[stage]
            pValues[stage] = p
            val span = r * p
            val tableLen = p * r
            val fCos = FloatArray(tableLen)
            val fSin = FloatArray(tableLen)
            val iCos = FloatArray(tableLen)
            val iSin = FloatArray(tableLen)

            for (k in 0 until p) {
                for (m in 0 until r) {
                    val angle = -2.0 * PI * k * m / span
                    val c = cos(angle).toFloat()
                    val s = sin(angle).toFloat()
                    val idx = k * r + m
                    fCos[idx] = c
                    fSin[idx] = s
                    iCos[idx] = c
                    iSin[idx] = -s
                }
            }

            fwdTwCos[stage] = fCos
            fwdTwSin[stage] = fSin
            invTwCos[stage] = iCos
            invTwSin[stage] = iSin
            p *= r
        }

        bufARe = FloatArray(length)
        bufAIm = FloatArray(length)
        bufBRe = FloatArray(length)
        bufBIm = FloatArray(length)
    }

    fun forward(realInput: FloatArray, realOutput: FloatArray, imagOutput: FloatArray) {
        System.arraycopy(realInput, 0, bufARe, 0, length)
        bufAIm.fill(0f)
        val (finalRe, finalIm) = executeStages(inverse = false)
        System.arraycopy(finalRe, 0, realOutput, 0, length)
        System.arraycopy(finalIm, 0, imagOutput, 0, length)
    }

    fun inverse(realInput: FloatArray, imagInput: FloatArray, realOutput: FloatArray) {
        System.arraycopy(realInput, 0, bufARe, 0, length)
        System.arraycopy(imagInput, 0, bufAIm, 0, length)
        val (finalRe, _) = executeStages(inverse = true)
        val invN = 1f / length.toFloat()
        for (i in 0 until length) {
            realOutput[i] = finalRe[i] * invN
        }
    }

    private fun executeStages(inverse: Boolean): Pair<FloatArray, FloatArray> {
        var srcRe = bufARe
        var srcIm = bufAIm
        var dstRe = bufBRe
        var dstIm = bufBIm

        val sign = if (inverse) 1f else -1f
        val twCosArr = if (inverse) invTwCos else fwdTwCos
        val twSinArr = if (inverse) invTwSin else fwdTwSin

        for (stage in radices.indices) {
            val r = radices[stage]
            val p = pValues[stage]
            val qPrime = length / (r * p)
            val twCos = twCosArr[stage]
            val twSin = twSinArr[stage]

            when (r) {
                2 -> stageRadix2(srcRe, srcIm, dstRe, dstIm, p, qPrime, twCos, twSin)
                4 -> stageRadix4(srcRe, srcIm, dstRe, dstIm, p, qPrime, sign, twCos, twSin)
                3 -> stageRadix3(srcRe, srcIm, dstRe, dstIm, p, qPrime, sign, twCos, twSin)
                else -> stageRadix5(srcRe, srcIm, dstRe, dstIm, p, qPrime, sign, twCos, twSin)
            }

            val tmpRe = srcRe; srcRe = dstRe; dstRe = tmpRe
            val tmpIm = srcIm; srcIm = dstIm; dstIm = tmpIm
        }

        return srcRe to srcIm
    }

    private fun stageRadix2(
        sRe: FloatArray, sIm: FloatArray, dRe: FloatArray, dIm: FloatArray,
        p: Int, qPrime: Int, twCos: FloatArray, twSin: FloatArray
    ) {
        val stride = 2 * qPrime
        for (k in 0 until p) {
            val sBase = k * stride
            val dBase0 = k * qPrime
            val dBase1 = (k + p) * qPrime
            val c1 = twCos[k * 2 + 1]
            val sn1 = twSin[k * 2 + 1]

            for (j1 in 0 until qPrime) {
                val i0 = sBase + j1
                val i1 = i0 + qPrime
                val x0r = sRe[i0]; val x0i = sIm[i0]
                val a1r = sRe[i1]; val a1i = sIm[i1]
                val x1r = a1r * c1 - a1i * sn1
                val x1i = a1r * sn1 + a1i * c1

                dRe[dBase0 + j1] = x0r + x1r
                dIm[dBase0 + j1] = x0i + x1i
                dRe[dBase1 + j1] = x0r - x1r
                dIm[dBase1 + j1] = x0i - x1i
            }
        }
    }

    private fun stageRadix4(
        sRe: FloatArray, sIm: FloatArray, dRe: FloatArray, dIm: FloatArray,
        p: Int, qPrime: Int, sign: Float, twCos: FloatArray, twSin: FloatArray
    ) {
        val stride = 4 * qPrime
        for (k in 0 until p) {
            val sBase = k * stride
            val twBase = k * 4
            val c1 = twCos[twBase + 1]; val sn1 = twSin[twBase + 1]
            val c2 = twCos[twBase + 2]; val sn2 = twSin[twBase + 2]
            val c3 = twCos[twBase + 3]; val sn3 = twSin[twBase + 3]

            val d0 = k * qPrime
            val d1 = (k + p) * qPrime
            val d2 = (k + 2 * p) * qPrime
            val d3 = (k + 3 * p) * qPrime

            for (j1 in 0 until qPrime) {
                val idx0 = sBase + j1
                val idx1 = idx0 + qPrime
                val idx2 = idx1 + qPrime
                val idx3 = idx2 + qPrime

                val u0r = sRe[idx0]; val u0i = sIm[idx0]
                val a1r = sRe[idx1]; val a1i = sIm[idx1]
                val u1r = a1r * c1 - a1i * sn1
                val u1i = a1r * sn1 + a1i * c1

                val a2r = sRe[idx2]; val a2i = sIm[idx2]
                val u2r = a2r * c2 - a2i * sn2
                val u2i = a2r * sn2 + a2i * c2

                val a3r = sRe[idx3]; val a3i = sIm[idx3]
                val u3r = a3r * c3 - a3i * sn3
                val u3i = a3r * sn3 + a3i * c3

                val t0r = u0r + u2r; val t0i = u0i + u2i
                val t1r = u0r - u2r; val t1i = u0i - u2i
                val t2r = u1r + u3r; val t2i = u1i + u3i
                val diff13r = u1r - u3r
                val diff13i = u1i - u3i
                val rotR = -diff13i * sign
                val rotI = diff13r * sign

                dRe[d0 + j1] = t0r + t2r
                dIm[d0 + j1] = t0i + t2i
                dRe[d1 + j1] = t1r + rotR
                dIm[d1 + j1] = t1i + rotI
                dRe[d2 + j1] = t0r - t2r
                dIm[d2 + j1] = t0i - t2i
                dRe[d3 + j1] = t1r - rotR
                dIm[d3 + j1] = t1i - rotI
            }
        }
    }

    private fun stageRadix3(
        sRe: FloatArray, sIm: FloatArray, dRe: FloatArray, dIm: FloatArray,
        p: Int, qPrime: Int, sign: Float, twCos: FloatArray, twSin: FloatArray
    ) {
        val stride = 3 * qPrime
        val sin120s = sign * SIN_120
        for (k in 0 until p) {
            val sBase = k * stride
            val twBase = k * 3
            val c1 = twCos[twBase + 1]; val sn1 = twSin[twBase + 1]
            val c2 = twCos[twBase + 2]; val sn2 = twSin[twBase + 2]

            val d0 = k * qPrime
            val d1 = (k + p) * qPrime
            val d2 = (k + 2 * p) * qPrime

            for (j1 in 0 until qPrime) {
                val idx0 = sBase + j1
                val idx1 = idx0 + qPrime
                val idx2 = idx1 + qPrime

                val u0r = sRe[idx0]; val u0i = sIm[idx0]
                val a1r = sRe[idx1]; val a1i = sIm[idx1]
                val u1r = a1r * c1 - a1i * sn1
                val u1i = a1r * sn1 + a1i * c1

                val a2r = sRe[idx2]; val a2i = sIm[idx2]
                val u2r = a2r * c2 - a2i * sn2
                val u2i = a2r * sn2 + a2i * c2

                val t1r = u1r + u2r; val t1i = u1i + u2i
                val t2r = u0r - 0.5f * t1r; val t2i = u0i - 0.5f * t1i
                val t3r = sin120s * (u1r - u2r); val t3i = sin120s * (u1i - u2i)

                dRe[d0 + j1] = u0r + t1r
                dIm[d0 + j1] = u0i + t1i
                dRe[d1 + j1] = t2r - t3i
                dIm[d1 + j1] = t2i + t3r
                dRe[d2 + j1] = t2r + t3i
                dIm[d2 + j1] = t2i - t3r
            }
        }
    }

    private fun stageRadix5(
        sRe: FloatArray, sIm: FloatArray, dRe: FloatArray, dIm: FloatArray,
        p: Int, qPrime: Int, sign: Float, twCos: FloatArray, twSin: FloatArray
    ) {
        val stride = 5 * qPrime
        val s72 = sign * SIN_72
        val s144 = sign * SIN_144

        for (k in 0 until p) {
            val sBase = k * stride
            val twBase = k * 5
            val c1 = twCos[twBase + 1]; val sn1 = twSin[twBase + 1]
            val c2 = twCos[twBase + 2]; val sn2 = twSin[twBase + 2]
            val c3 = twCos[twBase + 3]; val sn3 = twSin[twBase + 3]
            val c4 = twCos[twBase + 4]; val sn4 = twSin[twBase + 4]

            val d0 = k * qPrime
            val d1 = (k + p) * qPrime
            val d2 = (k + 2 * p) * qPrime
            val d3 = (k + 3 * p) * qPrime
            val d4 = (k + 4 * p) * qPrime

            for (j1 in 0 until qPrime) {
                val idx0 = sBase + j1
                val idx1 = idx0 + qPrime
                val idx2 = idx1 + qPrime
                val idx3 = idx2 + qPrime
                val idx4 = idx3 + qPrime

                val u0r = sRe[idx0]; val u0i = sIm[idx0]
                val a1r = sRe[idx1]; val a1i = sIm[idx1]
                val u1r = a1r * c1 - a1i * sn1
                val u1i = a1r * sn1 + a1i * c1

                val a2r = sRe[idx2]; val a2i = sIm[idx2]
                val u2r = a2r * c2 - a2i * sn2
                val u2i = a2r * sn2 + a2i * c2

                val a3r = sRe[idx3]; val a3i = sIm[idx3]
                val u3r = a3r * c3 - a3i * sn3
                val u3i = a3r * sn3 + a3i * c3

                val a4r = sRe[idx4]; val a4i = sIm[idx4]
                val u4r = a4r * c4 - a4i * sn4
                val u4i = a4r * sn4 + a4i * c4

                val s14r = u1r + u4r; val s14i = u1i + u4i
                val d14r = u1r - u4r; val d14i = u1i - u4i
                val s23r = u2r + u3r; val s23i = u2i + u3i
                val d23r = u2r - u3r; val d23i = u2i - u3i

                dRe[d0 + j1] = u0r + s14r + s23r
                dIm[d0 + j1] = u0i + s14i + s23i

                val m1r = u0r + COS_72 * s14r + COS_144 * s23r
                val m1i = u0i + COS_72 * s14i + COS_144 * s23i
                val n1r = s72 * d14r + s144 * d23r
                val n1i = s72 * d14i + s144 * d23i

                dRe[d1 + j1] = m1r - n1i
                dIm[d1 + j1] = m1i + n1r
                dRe[d4 + j1] = m1r + n1i
                dIm[d4 + j1] = m1i - n1r

                val m2r = u0r + COS_144 * s14r + COS_72 * s23r
                val m2i = u0i + COS_144 * s14i + COS_72 * s23i
                val n2r = s144 * d14r - s72 * d23r
                val n2i = s144 * d14i - s72 * d23i

                dRe[d2 + j1] = m2r - n2i
                dIm[d2 + j1] = m2i + n2r
                dRe[d3 + j1] = m2r + n2i
                dIm[d3 + j1] = m2i - n2r
            }
        }
    }

    companion object {
        private val SIN_120 = (sqrt(3.0) * 0.5).toFloat()
        private val COS_72 = cos(2.0 * PI / 5.0).toFloat()
        private val SIN_72 = sin(2.0 * PI / 5.0).toFloat()
        private val COS_144 = cos(4.0 * PI / 5.0).toFloat()
        private val SIN_144 = sin(4.0 * PI / 5.0).toFloat()

        fun createPeriodicHannWindow(length: Int): FloatArray {
            val win = FloatArray(length)
            val scale = (2.0 * PI / length).toFloat()
            for (n in 0 until length) {
                win[n] = 0.5f * (1f - cos((scale * n).toDouble()).toFloat())
            }
            return win
        }
    }
}
