## A tilt EQ / filter LV2 plugin

import nymph

import paramsmooth
import tiltfilter

const
    PluginUri = "urn:nymph:examples:tiltfilter"
    minFreq = 20.0
    maxFreq = 20_000.0

type
    SampleBuffer = UncheckedArray[cfloat]

    PluginPort {.pure.} = enum
        Input, Output, Frequency, Steepness, Mode

    TiltFilterPlugin = object
        input: ptr SampleBuffer
        output: ptr SampleBuffer
        freq: ptr cfloat
        steepness: ptr cfloat
        mode: ptr cfloat
        flt: TiltFilter
        smoothFreq: ParamSmooth


proc instantiate(descriptor: ptr Lv2Descriptor; sampleRate: cdouble;
                 bundlePath: cstring; features: ptr UncheckedArray[ptr Lv2Feature]):
                 Lv2Handle {.cdecl.} =
    try:
        let plug = createShared(TiltFilterPlugin)
        plug.flt = initTiltFilter(10_000.0, 1.0, fmLowPass, sampleRate)
        plug.smoothFreq = initParamSmooth(20.0, sampleRate)
        return cast[Lv2Handle](plug)
    except OutOfMemDefect:
        return nil


proc connectPort(instance: Lv2Handle; port: cuint;
                 dataLocation: pointer) {.cdecl.} =
    let plug = cast[ptr TiltFilterPlugin](instance)
    case cast[PluginPort](port)
    of PluginPort.Input:
        plug.input = cast[ptr SampleBuffer](dataLocation)
    of PluginPort.Output:
        plug.output = cast[ptr SampleBuffer](dataLocation)
    of PluginPort.Frequency:
        plug.freq = cast[ptr cfloat](dataLocation)
    of PluginPort.Steepness:
        plug.steepness = cast[ptr cfloat](dataLocation)
    of PluginPort.Mode:
        plug.mode = cast[ptr cfloat](dataLocation)


proc activate(instance: Lv2Handle) {.cdecl.} =
    let plug = cast[ptr TiltFilterPlugin](instance)
    plug.flt.reset()


proc run(instance: Lv2Handle; nSamples: cuint) {.cdecl.} =
    let plug = cast[ptr TiltFilterPlugin](instance)
    let freq = plug.freq[].clamp(minFreq, maxFreq)

    plug.flt.setMode(plug.mode[].clamp(0.0, 2.0).FilterMode)
    plug.flt.setSteepness(plug.steepness[])

    for pos in 0 ..< nSamples:
        plug.flt.setCenterFreq(plug.smoothFreq.process(freq))
        plug.flt.update()
        plug.output[pos] = plug.flt.process(plug.input[pos])


proc deactivate(instance: Lv2Handle) {.cdecl.} =
    discard


proc cleanup(instance: Lv2Handle) {.cdecl.} =
    freeShared(cast[ptr TiltFilterPlugin](instance))


proc extensionData(uri: cstring): pointer {.cdecl.} =
    return nil


proc NimMain() {.cdecl, importc.}


proc lv2Descriptor(index: cuint): ptr Lv2Descriptor {.
                   cdecl, exportc, dynlib, extern: "lv2_descriptor".} =
    NimMain()

    if index == 0:
        result = createShared(Lv2Descriptor)
        result.uri = cstring(PluginUri)
        result.instantiate = instantiate
        result.connectPort = connectPort
        result.activate = activate
        result.run = run
        result.deactivate = deactivate
        result.cleanup = cleanup
        result.extensionData = extensionData

