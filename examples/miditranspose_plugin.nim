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

    MidiEvent = object
        size: uint32
        frames: int64
        data: ptr UncheckedArray[byte]


proc instantiate(descriptor: ptr Lv2Descriptor; sampleRate: cdouble;
                 bundlePath: cstring; features: ptr UncheckedArray[ptr Lv2Feature]):
                 Lv2Handle {.cdecl.} =
    let plug: ptr MidiTransposePlugin = createShared(MidiTransposePlugin)
    plug.map = cast[ptr UridMap](lv2FeaturesData(features, lv2UridMap))

    if plug.map.isNil:
        freeShared(plug)
        return nil

    plug.midi_urid = plug.map.map(plug.map.handle, lv2MidiMidiEvent)

    return cast[Lv2Handle](plug)


proc connectPort(instance: Lv2Handle; port: cuint;
                 dataLocation: pointer) {.cdecl.} =
    let plug = cast[ptr MidiTransposePlugin](instance)
    case cast[PluginPort](port)
    of PluginPort.Input:
        plug.input = cast[ptr AtomSequence](dataLocation)
    of PluginPort.Output:
        plug.output = cast[ptr AtomSequence](dataLocation)
    of PluginPort.Transposition:
        plug.transposition = cast[ptr cfloat](dataLocation)


proc activate(instance: Lv2Handle) {.cdecl.} =
    discard


proc run(instance: Lv2Handle; nSamples: cuint) {.cdecl.} =
    let plug = cast[ptr MidiTransposePlugin](instance)
    let outCapacity = plug.output.atom.size
    atomSequenceClear(plug.output)
    plug.output.atom.type = plug.input.atom.type

    if not atomSequenceIsEmpty(plug.input):
        #echo &"Event sequence size: {plug.input.atom.size}"
        let noteOffset = clamp(floor(plug.transposition[] + 0.5), -12, 12).uint8

        for ev in plug.input:
            if ev.body.`type` == plug.midi_urid:
                var msg = cast[ptr UncheckedArray[uint8]](atomContents(AtomEvent, ev))
                #echo &"0x{toHex(msg[0], 2)} 0x{toHex(msg[1], 2)} 0x{toHex(msg[2], 2)}"

                case midiGetMessageType(msg[]):
                of midiMsgNoteOff, midiMsgNoteOn, midiMsgNotePressure:
                    msg[1] = clamp(msg[1] + noteOffset, 0, 127).uint8
                else:
                    discard

                discard atomSequenceAppendEvent(plug.output, outCapacity, ev)


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
