## State Variable Filter after Hal Chamberlin, Musical Applications of Microprocessors
##
## Only stable up to fc ~= fs / 6.5 !
## Sensible range for q ~= 0.8 .. 10.0

import std/math

type
    FilterMode* = enum
        fmLowPass, fmHighPass, fmBandPass, fmBandReject

    SVFilter* = object
        mode: FilterMode
        cutoff, q, lowPass, hiPass, bandPass, bandReject, a, b, maxCutoff: float
        sampleRate: float64
        needsUpdate: bool


proc reset*(self: var SVFilter) =
    self.lowPass = 0.0
    self.hiPass = 0.0
    self.bandPass = 0.0
    self.bandReject = 0.0


proc initSVFilter*(mode: FilterMode = fmLowPass, sampleRate: float64 = 48_000.0): SVFilter =
    result.mode = mode
    result.sampleRate = sampleRate
    result.reset()
    result.a = 0.0
    result.b = 0.0
    result.maxCutoff = sampleRate / 6.0
    result.needsUpdate = true


proc calcCoef*(self: var SVFilter) =
    if self.needsUpdate:
        self.a = 2.0 * sin(PI * self.cutoff / self.sampleRate)

        if self.q > 0.0:
            self.b = 1.0 / self.q
        else:
            self.b = 0.0

        self.needsUpdate = false


proc setCutoff*(self: var SVFilter, cutoff: float) =
    let fc = min(self.maxCutoff, cutoff)

    if fc != self.cutoff:
        self.cutoff = fc
        self.needsUpdate = true


proc setQ*(self: var SVFilter, q: float) =
    if q != self.q:
        self.q = q
        self.needsUpdate = true


proc setMode*(self: var SVFilter, mode: FilterMode) =
    self.mode = mode


proc setSampleRate*(self: var SVFilter, sampleRate: float) =
    if sampleRate != self.sampleRate:
        self.sampleRate = sampleRate
        self.needsUpdate = true
        self.reset()
        self.calcCoef()


proc process*(self: var SVFilter, sample: float): float =
    self.lowPass += self.a * self.bandPass
    self.hiPass = sample - (self.lowPass + (self.b * self.bandPass))
    self.bandPass += self.a * self.hiPass
    self.bandReject = self.hiPass + self.lowPass

    case self.mode:
        of fmLowPass:
            return self.lowPass
        of fmHighPass:
            return self.hiPass
        of fmBandPass:
            return self.bandPass
        of fmBandReject:
            return self.bandReject

