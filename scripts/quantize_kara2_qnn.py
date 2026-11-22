"""Quantize UVR_MDXNET_KARA_2.onnx and UVR-MDX-NET-Inst_HQ_3.onnx to QNN QDQ A16W8 for Hexagon HTP NPU."""

from __future__ import annotations

import argparse
import shutil
import sys
from dataclasses import dataclass
from pathlib import Path

import numpy as np
import onnx
import onnxruntime as ort
from onnxruntime.quantization import (
    CalibrationDataReader,
    CalibrationMethod,
    QuantType,
    quantize,
)
from onnxruntime.quantization.execution_providers.qnn import (
    get_qnn_qdq_config,
    qnn_preprocess_model,
)

OUT_DIR = Path(r"C:\Users\excel\Projects\rl-mobile\local_model_weights")
SR = 44100


@dataclass(frozen=True)
class ModelQuantSpec:
    name: str
    src: Path
    out_prefix: Path
    n_fft: int
    hop: int
    dim_f: int
    dim_t: int


MODELS = [
    ModelQuantSpec(
        name="karaoke",
        src=Path(r"C:\Users\excel\AppData\Local\karaoke-engine\models\UVR_MDXNET_KARA_2.onnx"),
        out_prefix=OUT_DIR / "UVR_MDXNET_KARA_2_qnn",
        n_fft=5120,
        hop=1024,
        dim_f=2048,
        dim_t=256,
    ),
    ModelQuantSpec(
        name="instrumental",
        src=Path(r"C:\Users\excel\AppData\Local\karaoke-engine\models\UVR-MDX-NET-Inst_HQ_3.onnx"),
        out_prefix=OUT_DIR / "UVR-MDX-NET-Inst_HQ_3_qnn",
        n_fft=6144,
        hop=1024,
        dim_f=3072,
        dim_t=256,
    ),
]


def _stft_tensor(mix_l: np.ndarray, mix_r: np.ndarray, spec: ModelQuantSpec) -> np.ndarray:
    half = spec.n_fft // 2
    pad_l = np.pad(mix_l, (half, half), mode="reflect")
    pad_r = np.pad(mix_r, (half, half), mode="reflect")
    window = np.hanning(spec.n_fft + 1)[:-1].astype(np.float32)

    out = np.zeros((1, 4, spec.dim_f, spec.dim_t), dtype=np.float32)
    for frame in range(spec.dim_t):
        off = frame * spec.hop
        spec_l = np.fft.rfft(pad_l[off : off + spec.n_fft] * window)[: spec.dim_f]
        spec_r = np.fft.rfft(pad_r[off : off + spec.n_fft] * window)[: spec.dim_f]
        out[0, 0, :, frame] = spec_l.real.astype(np.float32)
        out[0, 1, :, frame] = spec_l.imag.astype(np.float32)
        out[0, 2, :, frame] = spec_r.real.astype(np.float32)
        out[0, 3, :, frame] = spec_r.imag.astype(np.float32)
    return out


def make_stft_tensor(rng: np.random.Generator, variant: int, spec: ModelQuantSpec) -> np.ndarray:
    """Synthesize diverse MDX-NET STFT tensors spanning quiet (0.08) to -6 LUFS 0 dBFS (1.00) mastered tracks."""
    chunk_samples = (spec.dim_t - 1) * spec.hop
    t = np.arange(chunk_samples, dtype=np.float32) / SR
    dur = float(chunk_samples) / SR
    amp_schedule = [0.08, 0.30, 0.65, 0.90, 1.00]
    mix_l = np.zeros(chunk_samples, dtype=np.float32)
    mix_r = np.zeros(chunk_samples, dtype=np.float32)

    if 16 <= variant <= 17:
        # Sustained 808 bass & dense synth-chord tones at 0 dBFS (peaks ~500-1200 in STFT bins)
        bass_roots = [49.0, 55.0, 65.41, 82.41]
        f0 = bass_roots[(variant - 16) % len(bass_roots)]
        amp = 0.95 if (variant % 2 == 0) else 1.00
        freqs = [f0, f0 * 2.0, f0 * 3.0, 220.0, 329.63, 440.0, 880.0]
        weights = [0.45, 0.30, 0.18, 0.25, 0.20, 0.18, 0.12]
        for freq, w in zip(freqs, weights):
            ph_l = rng.uniform(0, 2 * np.pi)
            ph_r = ph_l + rng.uniform(-0.25, 0.25)
            mix_l += w * np.sin(2 * np.pi * freq * t + ph_l)
            mix_r += w * np.sin(2 * np.pi * freq * t + ph_r)
    elif 18 <= variant <= 19:
        # Heavily limited/mastered dense full-band pop/EDM tracks at amp=0.98..1.00 (bass + mids + 3-14 kHz hi-hats)
        amp = 0.98 if variant == 18 else 1.00
        for freq, w in [(55.0, 0.45), (110.0, 0.35), (220.0, 0.35), (440.0, 0.32), (880.0, 0.28), (1760.0, 0.24), (3520.0, 0.18), (7040.0, 0.14), (11000.0, 0.10)]:
            ph_l = rng.uniform(0, 2 * np.pi)
            ph_r = ph_l + rng.uniform(-0.35, 0.35)
            mix_l += w * np.sin(2 * np.pi * freq * t + ph_l)
            mix_r += w * np.sin(2 * np.pi * freq * t + ph_r)
        ph_v = np.cumsum(2 * np.pi * (240.0 + 4.0 * np.sin(2 * np.pi * 5.2 * t)) / SR)
        vocal = (0.40 * np.sin(ph_v) + 0.30 * np.sin(2 * ph_v) + 0.20 * np.sin(3 * ph_v)).astype(np.float32)
        mix_l += vocal
        mix_r += vocal * 0.95
        for beat_idx in range(0, chunk_samples, SR // 4):
            decay = np.exp(-np.arange(min(2048, chunk_samples - beat_idx), dtype=np.float32) / 300.0)
            burst = rng.normal(0.0, 0.45, size=decay.shape).astype(np.float32) * decay
            mix_l[beat_idx : beat_idx + len(burst)] += burst
            mix_r[beat_idx : beat_idx + len(burst)] += burst * 0.90
        mix_l = np.tanh(2.8 * mix_l).astype(np.float32)
        mix_r = np.tanh(2.8 * mix_r).astype(np.float32)
    elif 20 <= variant <= 21:
        # Loud mid/high multi-octave chord + vocal-formant + limited synth mixes (110 Hz..10 kHz)
        amp = 0.98 if variant == 20 else 1.00
        for freq, w in [(65.4, 0.35), (130.8, 0.35), (220.0, 0.35), (440.0, 0.35), (880.0, 0.35), (1760.0, 0.30), (3100.0, 0.22), (6200.0, 0.16), (9600.0, 0.12)]:
            ph_l = rng.uniform(0, 2 * np.pi)
            ph_r = ph_l + 0.3
            mix_l += w * np.sin(2 * np.pi * freq * t + ph_l)
            mix_r += w * np.sin(2 * np.pi * freq * t + ph_r)
        ph_f = np.cumsum(2 * np.pi * (330.0 + 3.5 * np.sin(2 * np.pi * 4.8 * t)) / SR)
        mix_l += (0.35 * np.sin(ph_f) + 0.25 * np.sin(3 * ph_f)).astype(np.float32)
        mix_r += (0.35 * np.sin(ph_f) + 0.25 * np.sin(3 * ph_f)).astype(np.float32) * 0.94
        mix_l = np.tanh(2.2 * mix_l).astype(np.float32)
        mix_r = np.tanh(2.2 * mix_r).astype(np.float32)
    elif 22 <= variant <= 23:
        # Broadband full-scale logarithmic frequency sweeps (40 Hz -> 16 kHz) + noise bursts
        amp = 0.95 if variant == 22 else 1.00
        f_start, f_end = 40.0, 16000.0
        k_log = np.log(f_end / f_start)
        phase_sw = 2.0 * np.pi * f_start * dur / k_log * (np.exp(k_log * t / dur) - 1.0)
        sweep_l = 0.70 * np.sin(phase_sw).astype(np.float32)
        sweep_r = 0.70 * np.sin(phase_sw + 0.35).astype(np.float32)
        white = rng.normal(0.0, 0.25, size=chunk_samples).astype(np.float32)
        # Simple 1-pole pink-ish emphasis mixed with white bursts
        pink = np.convolve(white, np.ones(8, dtype=np.float32) / 8.0, mode="same").astype(np.float32)
        mix_l = np.tanh(1.8 * (sweep_l + pink + 0.35 * white)).astype(np.float32)
        mix_r = np.tanh(1.8 * (sweep_r + pink * 0.9 + 0.35 * white)).astype(np.float32)
    else:
        amp = amp_schedule[variant % len(amp_schedule)]
        roots = [55.0, 73.42, 82.41, 98.0, 110.0, 130.81]
        f0 = roots[variant % len(roots)]
        for mult, gain in [(1.0, 0.35), (1.5, 0.25), (2.0, 0.25), (3.0, 0.15), (4.0, 0.10), (6.0, 0.08)]:
            ph_l = rng.uniform(0, 2 * np.pi)
            ph_r = ph_l + rng.uniform(-0.4, 0.4)
            mix_l += gain * np.sin(2 * np.pi * f0 * mult * t + ph_l)
            mix_r += gain * np.sin(2 * np.pi * f0 * mult * t + ph_r)

        if variant % 4 != 3:
            v0 = 180.0 + 35.0 * (variant % 6)
            vibrato = 4.0 * np.sin(2 * np.pi * 5.5 * t)
            phase = np.cumsum(2 * np.pi * (v0 + vibrato) / SR)
            vocal = (
                0.35 * np.sin(phase)
                + 0.28 * np.sin(2 * phase)
                + 0.18 * np.sin(3 * phase)
                + 0.10 * np.sin(5 * phase)
            ).astype(np.float32)
            env = 0.5 + 0.5 * np.sin(2 * np.pi * (0.4 + 0.1 * variant) * t)
            vocal *= env.astype(np.float32)
            mix_l += vocal
            mix_r += vocal * 0.96

        noise = rng.normal(0.0, 0.05, size=chunk_samples).astype(np.float32)
        for beat_idx in range(0, chunk_samples, SR // 2):
            decay = np.exp(-np.arange(min(4096, chunk_samples - beat_idx), dtype=np.float32) / 600.0)
            burst = rng.normal(0.0, 0.30, size=decay.shape).astype(np.float32) * decay
            mix_l[beat_idx : beat_idx + len(burst)] += burst
            mix_r[beat_idx : beat_idx + len(burst)] += burst * 0.92
        mix_l += noise
        mix_r += noise

    peak = float(max(np.max(np.abs(mix_l)), np.max(np.abs(mix_r)), 1e-6))
    scale = amp / peak
    mix_l = np.clip(mix_l * scale, -0.999, 0.999)
    mix_r = np.clip(mix_r * scale, -0.999, 0.999)
    return _stft_tensor(mix_l, mix_r, spec)


def make_eval_tensor(amp: float, spec: ModelQuantSpec) -> np.ndarray:
    rng = np.random.default_rng(7)
    chunk_samples = (spec.dim_t - 1) * spec.hop
    t = np.arange(chunk_samples, dtype=np.float32) / SR
    mix_l = np.zeros(chunk_samples, dtype=np.float32)
    mix_r = np.zeros(chunk_samples, dtype=np.float32)
    for f0 in (65.4, 130.8, 220.0, 440.0, 880.0, 1760.0):
        ph = rng.uniform(0, 2 * np.pi)
        mix_l += 0.25 * np.sin(2 * np.pi * f0 * t + ph)
        mix_r += 0.25 * np.sin(2 * np.pi * f0 * t + ph + 0.3)
    mix_l = np.clip(mix_l, -1.0, 1.0) * amp
    mix_r = np.clip(mix_r, -1.0, 1.0) * amp
    return _stft_tensor(mix_l, mix_r, spec)


class StftCalibrationReader(CalibrationDataReader):
    def __init__(self, samples: list[np.ndarray], input_name: str = "input") -> None:
        self._samples = samples
        self._input_name = input_name
        self._idx = 0

    def get_next(self) -> dict[str, np.ndarray] | None:
        if self._idx >= len(self._samples):
            return None
        item = {self._input_name: self._samples[self._idx]}
        self._idx += 1
        return item

    def rewind(self) -> None:
        self._idx = 0


def eval_multi_level(ref_path: Path, qdq_path: Path, spec: ModelQuantSpec) -> bool:
    sess_ref = ort.InferenceSession(str(ref_path), providers=["CPUExecutionProvider"])
    sess_qdq = ort.InferenceSession(str(qdq_path), providers=["CPUExecutionProvider"])
    ok = True
    for amp, min_snr in [(0.10, 15.0), (0.30, 18.0), (0.75, 18.0), (0.98, 18.0)]:
        x = make_eval_tensor(amp, spec)
        ref = sess_ref.run(None, {"input": x})[0].reshape(-1).astype(np.float64)
        qdq = sess_qdq.run(None, {"input": x})[0].reshape(-1).astype(np.float64)
        diff = ref - qdq
        sig_pow = float(np.mean(ref ** 2))
        err_pow = float(np.mean(diff ** 2)) + 1e-12
        snr_db = 10.0 * np.log10(sig_pow / err_pow)
        cos_sim = float(np.dot(ref, qdq) / ((np.linalg.norm(ref) * np.linalg.norm(qdq)) + 1e-12))
        in_max = float(np.max(np.abs(x)))
        ref_max = float(np.max(np.abs(ref)))
        qdq_max = float(np.max(np.abs(qdq)))
        print(
            f"[{spec.name}] amp={amp:.2f} | in_max={in_max:.1f} | ref_max={ref_max:.1f} "
            f"qdq_max={qdq_max:.1f} | SNR={snr_db:.2f} dB | cos={cos_sim:.6f}"
        )
        if snr_db < min_snr or (amp >= 0.75 and cos_sim < 0.992):
            ok = False
    return ok


def quantize_one(spec: ModelQuantSpec, mode: str = "a16w16", force: bool = False) -> bool:
    out_path = Path(f"{spec.out_prefix}_{mode}.onnx")
    if not force and out_path.exists() and out_path.stat().st_size > 1_000_000:
        print(f"[{spec.name}] Already exists ({out_path.stat().st_size / (1024 * 1024):.2f} MB), skipping.")
        return True
    if not spec.src.exists():
        print(f"ERROR: Source model missing: {spec.src}", file=sys.stderr)
        return False

    preproc = OUT_DIR / f"{spec.src.stem}_qnn_preproc.onnx"
    if force or not preproc.exists():
        print(f"[{spec.name}] Preprocessing {spec.src.name} (static=[1,4,{spec.dim_f},{spec.dim_t}])")
        modified = qnn_preprocess_model(
            str(spec.src),
            str(preproc),
            dynamic_input_shapes=[("input", f"1,4,{spec.dim_f},{spec.dim_t}")],
        )
        print(f"[{spec.name}] qnn_preprocess_model modified={modified}")
        if not preproc.exists():
            shutil.copy2(spec.src, preproc)

    pm = onnx.load(str(preproc), load_external_data=False)
    for inp in pm.graph.input:
        print(f"[{spec.name}] Preprocessed input:", inp.name, [d.dim_param or d.dim_value for d in inp.type.tensor_type.shape.dim])

    rng = np.random.default_rng(12345 + spec.dim_f)
    cal_samples = [make_stft_tensor(rng, i, spec) for i in range(24)]
    cal_peak = max(float(np.max(np.abs(s))) for s in cal_samples)
    print(f"[{spec.name}] Generated 24 calibration samples (max |STFT|={cal_peak:.1f})")
    reader = StftCalibrationReader(cal_samples)

    if mode == "a16w16":
        print(f"[{spec.name}] Running QNN QDQ A16W16 (QUInt16 act, QInt16 wt, MinMax)...")
        qcfg = get_qnn_qdq_config(
            str(preproc),
            reader,
            calibrate_method=CalibrationMethod.MinMax,
            activation_type=QuantType.QUInt16,
            weight_type=QuantType.QInt16,
        )
    elif mode == "a16w8_perch":
        print(f"[{spec.name}] Running QNN QDQ A16W8 per-channel (QUInt16 act, QInt8 wt, per_channel=True)...")
        qcfg = get_qnn_qdq_config(
            str(preproc),
            reader,
            calibrate_method=CalibrationMethod.MinMax,
            activation_type=QuantType.QUInt16,
            weight_type=QuantType.QInt8,
            per_channel=True,
        )
    else:
        print(f"[{spec.name}] Running QNN QDQ A16W8 (QUInt16 act, QUInt8 wt, MinMax)...")
        qcfg = get_qnn_qdq_config(
            str(preproc),
            reader,
            calibrate_method=CalibrationMethod.MinMax,
            activation_type=QuantType.QUInt16,
            weight_type=QuantType.QUInt8,
        )

    quantize(str(preproc), str(out_path), qcfg)
    size_mb = out_path.stat().st_size / (1024 * 1024)
    print(f"[{spec.name}] {mode} built -> {out_path.name}: {size_mb:.2f} MB")
    return eval_multi_level(spec.src, out_path, spec)


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--mode", choices=["a16w16", "a16w8_perch", "a16w8"], default="a16w16")
    parser.add_argument("--force", action="store_true", help="Regenerate quantized models even if already present")
    args = parser.parse_args()
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    results = [quantize_one(m, mode=args.mode, force=args.force) for m in MODELS]
    return 0 if all(results) else 1


if __name__ == "__main__":
    raise SystemExit(main())
