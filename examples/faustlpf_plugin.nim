## A FAUST standard library 2-pole lowpass filter LV2 plugin

import nymph
import faustlpf

const
    PluginUri = "urn:nymph:examples:faustlpf"

type
    PluginPort {.pure.} = enum
        Input, Output, Frequency

    FaustLPFPlugin = object
        input: ptr SampleBuffer
        output: ptr SampleBuffer
        freq: ptr cfloat
        flt: ptr faustlpf


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
    plug.flt.set_cutoff(plug.freq[])
    computefaustlpf(plug.flt, nSamples.cint, addr plug.input, addr plug.output)


proc cleanup(instance: Lv2Handle) {.cdecl.} =
    let plug = cast[ptr FaustLPFPlugin](instance)
    deletefaustlpf(plug.flt)
    freeShared(plug)


proc NimMain() {.cdecl, importc.}


let descriptor = Lv2Descriptor(
    uri: cstring(PluginUri),
    instantiate: instantiate,
    connectPort: connectPort,
    activate: activate,
    run: run,
    deactivate: nil,
    cleanup: cleanup,
    extensionData: nil,
)

proc lv2Descriptor(index: cuint): ptr Lv2Descriptor {.
                   cdecl, exportc, dynlib, extern: "lv2_descriptor".} =
    if index == 0:
        NimMain()
        return addr(descriptor)

    return nil
