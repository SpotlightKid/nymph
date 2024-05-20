## A simple MIDI event processor LV2 plugin

import std/[math, strformat, strutils]
import nymph/[atom, core, midi, util, urid]
import nymph/atom/util

const PluginUri = "urn:nymph:examples:miditranspose"

type
    PluginPort {.pure.} = enum
        Input, Output, Transposition

    MidiTransposePlugin = object
        input: ptr AtomSequence
        output: ptr AtomSequence
        transposition: ptr cfloat
        map: ptr UridMap
        midi_urid: Urid


proc printFeatures(features: ptr UncheckedArray[ptr Lv2Feature]) =
    if features != nil:
        var i = 0
        while true:
            let feature = features[i]
            if feature == nil:
                break
            echo &"URI: {feature[].uri}"
            echo &"Data: {cast[int](feature[].data)}"
            inc i


proc instantiate(descriptor: ptr Lv2Descriptor; sampleRate: cdouble;
                 bundlePath: cstring; features: ptr UncheckedArray[ptr Lv2Feature]):
                 Lv2Handle {.cdecl.} =
    printFeatures(features)
    let amp: ptr MidiTransposePlugin = createShared(MidiTransposePlugin)
    amp.map = cast[ptr UridMap](lv2FeaturesData(features, lv2UridMap))
    assert amp.map != nil
    amp.midi_urid = amp.map[].map(amp.map[].handle, lv2MidiMidiEvent)
    echo &"{lv2MidiMidiEvent} = {amp.midi_urid.int}"
    return cast[Lv2Handle](amp)


proc connectPort(instance: Lv2Handle; port: cuint;
                 dataLocation: pointer) {.cdecl.} =
    let amp = cast[ptr MidiTransposePlugin](instance)
    case cast[PluginPort](port)
    of PluginPort.Input:
        amp.input = cast[ptr AtomSequence](dataLocation)
    of PluginPort.Output:
        amp.output = cast[ptr AtomSequence](dataLocation)
    of PluginPort.Transposition:
        amp.transposition = cast[ptr cfloat](dataLocation)

proc activate(instance: Lv2Handle) {.cdecl.} =
    discard


proc run(instance: Lv2Handle; nSamples: cuint) {.cdecl.} =
    let amp = cast[ptr MidiTransposePlugin](instance)
    if amp.input.atom.size > 8:
        for ev in items(amp.input):
            if Urid(ev.body.`type`) == amp.midi_urid:
                # TODO
                var msg = cast[ptr UncheckedArray[uint8]](ev.body.addr + 1)
                echo &"0x{toHex(msg[0], 2)} 0x{toHex(msg[1], 2)} 0x{toHex(msg[2], 2)}"


proc deactivate(instance: Lv2Handle) {.cdecl.} =
    discard


proc cleanup(instance: Lv2Handle) {.cdecl.} =
    freeShared(cast[ptr MidiTransposePlugin](instance))


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
