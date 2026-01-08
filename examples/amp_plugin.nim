## A simple amplifier LV2 plugin

import std/[math, strformat]
import nymph/[core, log, urid, util]

const PluginUri = "urn:nymph:examples:amp"

type
    SampleBuffer = UncheckedArray[cfloat]

    PluginPort {.pure.} = enum
        Input, Output, Gain

    AmpPlugin = object
        input: ptr SampleBuffer
        output: ptr SampleBuffer
        map: ptr UridMap
        log: Logger
        gain: ptr cfloat


template db2coeff(db: cfloat): cfloat =
    pow(10.0, db / 20.0)


proc instantiate(descriptor: ptr Lv2Descriptor; sampleRate: cdouble;
                 bundlePath: cstring; features: ptr UncheckedArray[ptr Lv2Feature]):
                 Lv2Handle {.cdecl.} =
    try:
        let plug: ptr AmpPlugin = createShared(AmpPlugin)

        plug.map = cast[ptr UridMap](lv2FeaturesData(features, lv2UridMap))

        if plug.map.isNil:
            freeShared(plug)
            return cast[Lv2Handle](nil)

        let logPtr = cast[ptr Log](lv2FeaturesData(features, lv2LogLog))

        if not plug.log.setup(logPtr, plug.map):
            plug.log.warning("LV2 Log feature not available.")

        plug.log.note("nymph amp LV2 plugin instance created.")
        return cast[Lv2Handle](plug)
    except OutOfMemDefect:
        return cast[Lv2Handle](nil)


proc connectPort(instance: Lv2Handle; port: cuint;
                 dataLocation: pointer) {.cdecl.} =
    let plug = cast[ptr AmpPlugin](instance)
    case cast[PluginPort](port)
    of PluginPort.Input:
        plug.input = cast[ptr SampleBuffer](dataLocation)
    of PluginPort.Output:
        plug.output = cast[ptr SampleBuffer](dataLocation)
    of PluginPort.Gain:
        plug.gain = cast[ptr cfloat](dataLocation)


proc activate(instance: Lv2Handle) {.cdecl.} =
    let plug = cast[ptr AmpPlugin](instance)
    plug.log.note("nymph amp plugin activated.")


proc run(instance: Lv2Handle; nSamples: cuint) {.cdecl.} =
    let plug = cast[ptr AmpPlugin](instance)
    for pos in 0 ..< nSamples:
        plug.output[pos] = plug.input[pos] * db2coeff(plug.gain[])


proc deactivate(instance: Lv2Handle) {.cdecl.} =
    let plug = cast[ptr AmpPlugin](instance)
    plug.log.note("nymph amp plugin deactivated.")


proc cleanup(instance: Lv2Handle) {.cdecl.} =
    let plug = cast[ptr AmpPlugin](instance)
    plug.log.note("De-allocating nymph amp plugin instance.")
    freeShared(cast[ptr AmpPlugin](instance))


proc extensionData(uri: cstring): pointer {.cdecl.} =
    return nil


proc NimMain() {.cdecl, importc.}


let descriptor = Lv2Descriptor(
    uri: cstring(PluginUri),
    instantiate: instantiate,
    connectPort: connectPort,
    activate: activate,
    run: run,
    deactivate: deactivate,
    cleanup: cleanup,
    extensionData: extensionData,
)

proc lv2Descriptor(index: cuint): ptr Lv2Descriptor {.
                   cdecl, exportc, dynlib, extern: "lv2_descriptor".} =

    echo fmt"nymph am plugin descriptor #{index} requested"

    if index == 0:
        NimMain()
        return addr(descriptor)

    return nil
