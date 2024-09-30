## A FAUST standard library 2-pole lowpass filter LV2 plugin

import nymph

{.emit: """#include "lpf.h"""".}

const
    PluginUri = "urn:nymph:examples:faustlpf"

type
    faustlpf {.importc, header: "lpf.h".} = object
        # struct field representing the value of the FAUST UI element,
        # which controls the filter cutoff frequency
        fHslider0: cfloat

    PluginPort {.pure.} = enum
        Input, Output, Frequency

    SampleBuffer = UncheckedArray[cfloat]

    FaustLPFPlugin = object
        input: ptr SampleBuffer
        output: ptr SampleBuffer
        freq: ptr cfloat
        flt: ptr faustlpf


# wrap only those functions from the C code, which we actually need
proc newfaustlpf(): ptr faustlpf {.importc.}
proc deletefaustlpf(dsp: ptr faustlpf) {.importc.}
proc initfaustlpf(dsp: ptr faustlpf, sample_rate: cint) {.importc.}
proc instanceClearfaustlpf(dsp: ptr faustlpf) {.importc.}
proc computefaustlpf(dsp: ptr faustlpf, count: cint, inputs, outputs: ptr ptr SampleBuffer) {.importc.}

proc NimMain() {.cdecl, importc.}


proc instantiate(descriptor: ptr Lv2Descriptor; sampleRate: cdouble;
                 bundlePath: cstring; features: ptr UncheckedArray[ptr Lv2Feature]):
                 Lv2Handle {.cdecl.} =
    try:
        let plug = cast[ptr FaustLPFPlugin](createShared(FaustLPFPlugin))
        plug.flt = newfaustlpf()
        initfaustlpf(plug.flt, sampleRate.cint)
        return cast[Lv2Handle](plug)
    except OutOfMemDefect:
        return nil


proc connectPort(instance: Lv2Handle; port: cuint;
                 dataLocation: pointer) {.cdecl.} =
    let plug = cast[ptr FaustLPFPlugin](instance)
    case cast[PluginPort](port)
    of PluginPort.Input:
        plug.input = cast[ptr SampleBuffer](dataLocation)
    of PluginPort.Output:
        plug.output = cast[ptr SampleBuffer](dataLocation)
    of PluginPort.Frequency:
        plug.freq = cast[ptr cfloat](dataLocation)


proc activate(instance: Lv2Handle) {.cdecl.} =
    let plug = cast[ptr FaustLPFPlugin](instance)
    instanceClearfaustlpf(plug.flt)


proc run(instance: Lv2Handle; nSamples: cuint) {.cdecl.} =
    let plug = cast[ptr FaustLPFPlugin](instance)
    plug.flt.fHslider0 = plug.freq[]
    computefaustlpf(plug.flt, nSamples.cint, addr plug.input, addr plug.output)


proc deactivate(instance: Lv2Handle) {.cdecl.} =
    discard


proc cleanup(instance: Lv2Handle) {.cdecl.} =
    let plug = cast[ptr FaustLPFPlugin](instance)
    deletefaustlpf(plug.flt)
    freeShared(plug)


proc extensionData(uri: cstring): pointer {.cdecl.} =
    return nil


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
