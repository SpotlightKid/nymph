##
## Tilt Filter
##
## Nim translation of this Rust implementation:
##
## https://github.com/ardura/Actuate/blob/main/src/fx/ArduraFilter.rs
##
## Inspired by https://www.musicdsp.org/en/latest/Filters/267-simple-tilt-equalizer.html
## Lowpass, Bandpass, Highpass based off tilt filter code

import math

const
    slopeNeg = -60.0
    amp = 6.0 / ln(2.0)
    denorm = pow(10.0, -30.0)
    minFreq = 20.0
    maxFreq = 20_000.0

type
    FilterMode* = enum
        fmLowPass, fmBandPass, fmHighPass

    TiltFilter* = object
        # Filter parameters
        sampleRate: float64
        centerFreq: float
        steepness: float
        mode: FilterMode
        # Filter tracking / internal
        needsUpdate: bool
        sampleRateX3: float64
        lowGain: float
        highGain: float
        a: float
        b: float
        lpOut: float
        # Band pass separate vars
        bandALow: float
        bandBLow: float
        bandOutLow: float
        bandAHigh: float
        bandBHigh: float
        bandOutHigh: float


# Super useful function to scale an sample 0-1 into other ranges
proc scaleRange(sample, minOutput, maxOutput: float): float =
    result = clamp(sample * (maxOutput - minOutput) + minOutput, minOutput, maxOutput)


proc initTiltFilter*(centerFreq, steepness: float, mode: FilterMode = fmLowPass, sampleRate: float64 = 48_000.0): TiltFilter =
    let sampleRateX3 = 3.0 * sampleRate

    case mode:
        # These are the gains for the slopes when math happens later
        of fmLowPass:
            result.lowGain = exp(0.0 / amp) - 1.0
            result.highGain = exp(slopeNeg / amp) - 1.0
        of fmBandPass:
            result.lowGain = exp(0.0 / amp) - 1.0
            result.highGain = exp(slopeNeg / amp) - 1.0
        of fmHighPass:
            result.lowGain = exp(slopeNeg / amp) - 1.0
            result.highGain = exp(0.0 / amp) - 1.0

    let omega = 2.0 * PI * centerFreq
    let n = 1.0 / (scaleRange(steepness, 0.98, 1.2) * (sampleRateX3 + omega))
    result.a = 2.0 * omega * n
    result.bandALow = result.a
    result.bandAHigh = result.a
    result.b = (sampleRateX3 - omega) * n
    result.bandBLow = result.b
    result.bandBHigh = result.b
    result.lpOut = 0.0
    result.bandOutLow = 0.0
    result.bandOutHigh = 0.0
    result.centerFreq = centerFreq
    result.sampleRateX3 = sampleRateX3
    result.steepness = steepness
    result.sampleRate = sampleRate
    result.mode = mode
    result.needsUpdate = true


proc setMode*(self: var TiltFilter, mode: FilterMode) =
    if mode != self.mode:
        self.mode = mode
        self.needsUpdate = true


proc setCenterFreq*(self: var TiltFilter, value: float) =
    let freq = value.clamp(minFreq, maxFreq)

    if freq != self.centerFreq:
        self.centerFreq = freq
        self.needsUpdate = true


proc setSteepness*(self: var TiltFilter, value: float) =
    let steepness = value.clamp(0.0, 1.0)

    if steepness != self.steepness:
        self.steepness = steepness
        self.needsUpdate = true


proc setSampleRate*(self: var TiltFilter, sampleRate: float) =
    if sampleRate != self.sampleRate:
        self.sampleRate = sampleRate
        self.sampleRateX3 = self.sampleRate * 3.0
        self.needsUpdate = true


proc reset*(self: var TiltFilter) =
    discard


proc update*(self: var TiltFilter) =
    if self.needsUpdate:
        case self.mode:
            of fmLowPass:
                let omega = 2.0 * PI * self.centerFreq
                let n = 1.0 / (scaleRange(self.steepness, 0.98, 1.2) * (self.sample_rate_x3 + omega))
                self.b = (self.sampleRateX3 - omega) * n
                self.lowGain = exp(0.0 / amp) - 1.0
                self.highGain = exp(slopeNeg / amp) - 1.0
            of fmBandPass:
                let width = self.steepness * self.steepness * 500.0

                let lowOmega = 2.0 * PI * (self.centerFreq - width).clamp(20.0, 16_000.0)
                let lowN = 1.0 / (scaleRange(self.steepness, 0.98, 1.2) * (self.sampleRateX3 + lowOmega))
                self.bandALow = 2.0 * lowOmega * lowN
                self.bandBLow = (self.sampleRateX3 - lowOmega) * lowN

                let highOmega = 2.0 * PI * (self.centerFreq + width).clamp(20.0, 16_000.0);
                let highN = 1.0 / (scaleRange(self.steepness, 0.98, 1.2) * (self.sampleRateX3 + highOmega))
                self.bandAHigh = 2.0 * highOmega * highN
                self.bandBHigh = (self.sampleRateX3 - highOmega) * highN

                self.lowGain = exp(0.0 / amp) - 1.0
                self.highGain = exp(slopeNeg / amp) - 1.0
            of fmHighPass:
                let omega = 2.0 * PI * self.centerFreq
                let n = 1.0 / (scaleRange(self.steepness, 0.98, 1.2) * (self.sampleRateX3 + omega))
                self.a = 2.0 * omega * n
                self.b = (self.sampleRateX3 - omega) * n
                self.lowGain = exp(slopeNeg / amp) - 1.0
                self.highGain = exp(0.0 / amp) - 1.0

        self.needsUpdate = false


##
## Process the input sample using the tilt filter
##
proc process*(self: var TiltFilter, sample: float): float =
    if self.mode == fmBandPass:
        self.bandOutLow = self.bandALow * sample + self.bandBLow * self.bandOutLow
        let temp = sample + self.highGain * self.bandOutLow + self.lowGain * (sample - self.bandOutLow)
        self.bandOutHigh = self.bandAHigh * temp + self.bandBHigh * self.bandOutHigh
        result = temp + self.lowGain * self.bandOutHigh + self.highGain * (temp - self.bandOutHigh) + denorm
    else:
        self.lpOut = self.a * sample + self.b * self.lpOut;
        result = sample + self.lowGain * self.lpOut + self.highGain * (sample - self.lpOut) + denorm
