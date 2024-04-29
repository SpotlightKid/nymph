## One-pole LPF for smooth parameter changes
##
## https://www.musicdsp.org/en/latest/Filters/257-1-pole-lpf-for-smooth-parameter-changes.html

import math

const TwoPi = PI * 2

type
    ParamSmooth* = object
        a, b, t, z: float
        fs: float64


proc reset*(self: var ParamSmooth) =
    self.z = 0.0


proc setSampleRate*(self: var ParamSmooth, sampleRate: float64) =
    if sampleRate != self.fs:
        self.fs = sampleRate
        self.a = exp(-TwoPi / (self.t * 0.001 * sampleRate))
        self.b = 1.0 - self.a
        self.z = 0.0


proc process*(self: var ParamSmooth, sample: float): float =
    self.z = (sample * self.b) + (self.z * self.a)
    return self.z


proc initParamSmooth*(smoothingTimeMs: float = 20.0, sampleRate: float64 = 48_000.0): ParamSmooth =
    result.t = smoothingTimeMs
    result.setSampleRate(sampleRate)

