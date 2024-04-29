## Dynamic Smoothing Using Self Modulating Filter
## Andrew Simper, Cytomic, 2014, andy@cytomic.com
## public release: 6th Dec 2016
## https://cytomic.com/files/dsp/DynamicSmoothing.pdf

type
    DynParamSmooth* = object
        baseFreq: float
        sensitivity: float
        wc: float
        low1: float
        low2: float
        inz: float


proc reset*(self: var DynParamSmooth) =
    self.low1 = 0.0
    self.low2 = 0.0
    self.inz = 0.0


proc setSampleRate*(self: var DynParamSmooth, sampleRate: float) =
    self.wc = self.baseFreq / sampleRate
    self.reset()


proc process*(self: var DynParamSmooth, sample: float): float =
    let low1z = self.low1
    let low2z = self.low2
    let bandz = low1z - low2z
    let wd = self.wc + self.sensitivity * abs(bandz)
    let g = min(wd * (5.9948827 + wd * (-11.969296 + wd * 15.959062)), 1.0)
    self.low1 = low1z + g * (0.5 * (sample + self.inz) - low1z)
    self.low2 = low2z + g * (0.5 * (self.low1 + low1z) - low2z)
    self.inz = sample
    return self.low2


proc initDynParamSmooth*(
    baseFreq: float = 2.0,
    sensitivity: float = 2.0,
    sampleRate: float = 48_000.0
): DynParamSmooth =
    result.baseFreq = baseFreq
    result.sensitivity = sensitivity
    result.wc = result.baseFreq / sampleRate
    result.reset()

