## A simple MIDI transpose LV2 plugin

import std/math
#import std/strformat
#import std/strutils
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


proc instantiate(descriptor: ptr Lv2Descriptor; sampleRate: cdouble;
                 bundlePath: cstring; features: ptr UncheckedArray[ptr Lv2Feature]):
                 Lv2Handle {.cdecl.} =
    let amp: ptr MidiTransposePlugin = createShared(MidiTransposePlugin)
    amp.map = cast[ptr UridMap](lv2FeaturesData(features, lv2UridMap))

    if amp.map == nil:
        return nil

    amp.midi_urid = amp.map[].map(amp.map[].handle, lv2MidiMidiEvent)

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
    let outCapacity = amp.output.atom.size
    atomSequenceClear(amp.output)
    amp.output.atom.type = amp.input.atom.type

    if amp.input.atom.size > 8:
        #echo &"Event sequence size: {amp.input.atom.size}"

        for ev in items(amp.input):
            if Urid(ev.body.`type`) == amp.midi_urid:
                var msg = cast[ptr UncheckedArray[uint8]](atomContents(AtomEvent, ev))
                #echo &"0x{toHex(msg[0], 2)} 0x{toHex(msg[1], 2)} 0x{toHex(msg[2], 2)}"

                case midiGetMessageType(msg[]):
                of midiMsgNoteOff, midiMsgNoteOn, midiMsgNotePressure:
                    let noteOffset = clamp(floor(amp.transposition[] + 0.5), -12, 12).uint8
                    msg[1] = clamp(msg[1] + noteOffset, 0, 127).uint8
                else:
                    discard

                discard atomSequenceAppendEvent(amp.output, outCapacity, ev)


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
