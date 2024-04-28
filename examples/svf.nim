## State Variable Filter after Hal Chamberlin, Musical Applications of Microprocessors
##
## Only stable up to fc ~= fs / 6.5 !
## Sensible range for q ~= 0.8 .. 10.0

import std/math

type
    FilterMode* = enum
        fmLowPass, fmHighPass, fmBandPass, fmBandReject

    FilterSV* = object
        mode: FilterMode
        cutoff: float
        q: float
        lowPass: float
        hiPass: float
        bandPass: float
        bandReject: float
        a: float
        b: float
        maxCutoff: float
        sampleRate: float64
        needs_update: bool


proc reset*(self: var FilterSV) =
    self.lowPass = 0.0
    self.hiPass = 0.0
    self.bandPass = 0.0
    self.bandReject = 0.0


proc initFilterSV*(mode: FilterMode = fmLowPass, sampleRate: float64 = 48_000.0): FilterSV =
    result.mode = mode
    result.sampleRate = sampleRate
    result.reset()
    result.a = 0.0
    result.b = 0.0
    result.maxCutoff = sampleRate / 6.0
    result.needs_update = true


proc calcCoef*(self: var FilterSV) =
    if self.needs_update:
        self.a = 2.0 * sin(PI * self.cutoff / self.sampleRate)

        if self.q > 0.0:
            self.b = 1.0 / self.q
        else:
            self.b = 0.0

        self.needs_update = false


proc setCutoff*(self: var FilterSV, cutoff: float) =
    let fc = min(self.maxCutoff, cutoff)

    if fc != self.cutoff:
        self.cutoff = fc
        self.needs_update = true


proc setQ*(self: var FilterSV, q: float) =
    if q != self.q:
        self.q = q
        self.needs_update = true


proc setMode*(self: var FilterSV, mode: FilterMode) =
    self.mode = mode


proc setSampleRate*(self: var FilterSV, sampleRate: float) =
    if sampleRate != self.sampleRate:
        self.sampleRate = sampleRate
        self.needs_update = true
        self.reset()
        self.calcCoef()


proc process*(self: var FilterSV, sample: float): float =
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

