## A simple amplifier LV2 plugin

import std/math
import nymph

const PluginUri = "urn:nymph:examples:amp"

type
    SampleBuffer = UncheckedArray[cfloat]

    PluginPort {.pure.} = enum
        Input, Output, Gain

    AmpPlugin = object
        input: ptr SampleBuffer
        output: ptr SampleBuffer
        gain: ptr cfloat


template db2coeff(db: cfloat): cfloat =
    pow(10.0, db / 20.0)


proc instantiate(descriptor: ptr Lv2Descriptor; sampleRate: cdouble;
                 bundlePath: cstring; features: ptr ptr Lv2Feature):
                 Lv2Handle {.cdecl.} =
    return createShared(AmpPlugin)


proc connectPort(instance: Lv2Handle; port: cuint;
                 dataLocation: pointer) {.cdecl.} =
    let amp = cast[ptr AmpPlugin](instance)
    case cast[PluginPort](port)
    of PluginPort.Input:
        amp.input = cast[ptr SampleBuffer](dataLocation)
    of PluginPort.Output:
        amp.output = cast[ptr SampleBuffer](dataLocation)
    of PluginPort.Gain:
        amp.gain = cast[ptr cfloat](dataLocation)


proc activate(instance: Lv2Handle) {.cdecl.} =
    discard


proc run(instance: Lv2Handle; nSamples: cuint) {.cdecl.} =
    let amp = cast[ptr AmpPlugin](instance)
    for pos in 0 ..< nSamples:
        amp.output[pos] = amp.input[pos] * db2coeff(amp.gain[])


proc deactivate(instance: Lv2Handle) {.cdecl.} =
    discard


proc cleanup(instance: Lv2Handle) {.cdecl.} =
    freeShared(cast[ptr AmpPlugin](instance))


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

