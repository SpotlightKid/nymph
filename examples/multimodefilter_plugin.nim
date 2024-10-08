## A simple multi-mode audio filter LV2 plugin

import nymph

import paramsmooth
import svf

const PluginUri = "urn:nymph:examples:multimodefilter"

type
    SampleBuffer = UncheckedArray[cfloat]

    PluginPort {.pure.} = enum
        Input, Output, Cutoff, Q, Mode

    SVFPlugin = object
        input: ptr SampleBuffer
        output: ptr SampleBuffer
        cutoff: ptr cfloat
        q: ptr cfloat
        mode: ptr cfloat
        svf: SVFilter
        smoothCutoff: ParamSmooth


proc instantiate(descriptor: ptr Lv2Descriptor; sampleRate: cdouble;
                 bundlePath: cstring; features: ptr UncheckedArray[ptr Lv2Feature]):
                 Lv2Handle {.cdecl.} =
    try:
        let plug = createShared(SVFPlugin)
        plug.svf = initSVFilter(fmLowPass, sampleRate)
        plug.smoothCutoff = initParamSmooth(20.0, sampleRate)
        return cast[Lv2Handle](plug)
    except OutOfMemDefect:
        return nil


proc connectPort(instance: Lv2Handle; port: cuint;
                 dataLocation: pointer) {.cdecl.} =
    let plug = cast[ptr SVFPlugin](instance)
    case cast[PluginPort](port)
    of PluginPort.Input:
        plug.input = cast[ptr SampleBuffer](dataLocation)
    of PluginPort.Output:
        plug.output = cast[ptr SampleBuffer](dataLocation)
    of PluginPort.Cutoff:
        plug.cutoff = cast[ptr cfloat](dataLocation)
    of PluginPort.Q:
        plug.q = cast[ptr cfloat](dataLocation)
    of PluginPort.Mode:
        plug.mode = cast[ptr cfloat](dataLocation)


proc activate(instance: Lv2Handle) {.cdecl.} =
    let plug = cast[ptr SVFPlugin](instance)
    plug.svf.reset()
    plug.svf.setMode(fmLowPass)
    plug.svf.setCutoff(7_000.0)
    plug.svf.setQ(0.8)
    plug.svf.calcCoef()


proc run(instance: Lv2Handle; nSamples: cuint) {.cdecl.} =
    let plug = cast[ptr SVFPlugin](instance)
    let cutoff = plug.cutoff[].clamp(16.0, 7_000.0)
    plug.svf.setMode(plug.mode[].int.clamp(0, 3).FilterMode)
    plug.svf.setQ(plug.q[].clamp(0.8, 10.0))

    for pos in 0 ..< nSamples:
        plug.svf.setCutoff(plug.smoothCutoff.process(cutoff))
        plug.svf.calcCoef()
        plug.output[pos] = plug.svf.process(plug.input[pos])


proc deactivate(instance: Lv2Handle) {.cdecl.} =
    discard


proc cleanup(instance: Lv2Handle) {.cdecl.} =
    freeShared(cast[ptr SVFPlugin](instance))


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

