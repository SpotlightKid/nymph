## Copyright 2012-2016 David Robillard <d@drobilla.net>
## SPDX-License-Identifier: ISC
##
## Definitions of standard MIDI messages.
##
## See <http://lv2plug.in/ns/ext/midi> for details.
##

const
    lv2MidiBaseUri = "http://lv2plug.in/ns/ext/midi"
    lv2MidiPrefix = lv2MidiBaseUri & "#" 

    lv2MidiActiveSense* = lv2MidiPrefix & "ActiveSense" 
    lv2MidiAftertouch* = lv2MidiPrefix & "Aftertouch" 
    lv2MidiBender* = lv2MidiPrefix & "Bender" 
    lv2MidiChannelPressure* = lv2MidiPrefix & "ChannelPressure" 
    lv2MidiChunk* = lv2MidiPrefix & "Chunk" 
    lv2MidiClock* = lv2MidiPrefix & "Clock" 
    lv2MidiContinue* = lv2MidiPrefix & "Continue" 
    lv2MidiController* = lv2MidiPrefix & "Controller" 
    lv2MidiMidiEvent* = lv2MidiPrefix & "MidiEvent" 
    lv2MidiNoteOff* = lv2MidiPrefix & "NoteOff" 
    lv2MidiNoteOn* = lv2MidiPrefix & "NoteOn" 
    lv2MidiProgramChange* = lv2MidiPrefix & "ProgramChange" 
    lv2MidiQuarterFrame* = lv2MidiPrefix & "QuarterFrame" 
    lv2MidiReset* = lv2MidiPrefix & "Reset" 
    lv2MidiSongPosition* = lv2MidiPrefix & "SongPosition" 
    lv2MidiSongSelect* = lv2MidiPrefix & "SongSelect" 
    lv2MidiStart* = lv2MidiPrefix & "Start" 
    lv2MidiStop* = lv2MidiPrefix & "Stop" 
    lv2MidiSystemCommon* = lv2MidiPrefix & "SystemCommon" 
    lv2MidiSystemExclusive* = lv2MidiPrefix & "SystemExclusive" 
    lv2MidiSystemMessage* = lv2MidiPrefix & "SystemMessage" 
    lv2MidiSystemRealtime* = lv2MidiPrefix & "SystemRealtime" 
    lv2MidiTick* = lv2MidiPrefix & "Tick" 
    lv2MidiTuneRequest* = lv2MidiPrefix & "TuneRequest" 
    lv2MidiVoiceMessage* = lv2MidiPrefix & "VoiceMessage" 
    lv2MidiPropBenderValue* = lv2MidiPrefix & "benderValue" 
    lv2MidiPropBinding* = lv2MidiPrefix & "binding" 
    lv2MidiPropByteNumber* = lv2MidiPrefix & "byteNumber" 
    lv2MidiPropChannel* = lv2MidiPrefix & "channel" 
    lv2MidiPropChunk* = lv2MidiPrefix & "chunk" 
    lv2MidiPropControllerNumber* = lv2MidiPrefix & "controllerNumber" 
    lv2MidiPropControllerValue* = lv2MidiPrefix & "controllerValue" 
    lv2MidiPropNoteNumber* = lv2MidiPrefix & "noteNumber" 
    lv2MidiPropPressure* = lv2MidiPrefix & "pressure" 
    lv2MidiPropProgramNumber* = lv2MidiPrefix & "programNumber" 
    lv2MidiPropProperty* = lv2MidiPrefix & "property" 
    lv2MidiPropSongNumber* = lv2MidiPrefix & "songNumber" 
    lv2MidiPropSongPosition* = lv2MidiPrefix & "songPosition" 
    lv2MidiPropStatus* = lv2MidiPrefix & "status" 
    lv2MidiPropStatusMask* = lv2MidiPrefix & "statusMask" 
    lv2MidiPropVelocity* = lv2MidiPrefix & "velocity" 

##
## MIDI Message Type
##
## This includes both voice messages (which have a channel) and system messages
## (which do not), as well as a sentinel value for invalid messages. To get
## the type of a message suitable for use in a switch statement, use
## midiGetMessageType() on the status byte.
##
type
    MidiMessageType* = enum
        midiMsgInvalid = 0,  # Invalid Message
        midiMsgNoteOff = 0x80,  # Note Off
        midiMsgNoteOn = 0x90,  # Note On
        midiMsgNotePressure = 0xA0,  # Note Pressure
        midiMsgController = 0xB0,  # Controller
        midiMsgPgmChange = 0xC0,  # Program Change
        midiMsgChannelPressure = 0xD0,  # Channel Pressure
        midiMsgBender = 0xE0,  # Pitch Bender
        midiMsgSystemExclusive = 0xF0,  # System Exclusive Begin
        midiMsgMtcQuarter = 0xF1,  # MTC Quarter Frame
        midiMsgSongPos = 0xF2,  # Song Position
        midiMsgSongSelect = 0xF3,  # Song Select
        midiMsgTuneRequest = 0xF6,  # Tune Request
        midiMsgClock = 0xF8,  # Clock
        midiMsgStart = 0xFA,  # Start
        midiMsgContinue = 0xFB,  # Continue
        midiMsgStop = 0xFC,  # Stop
        midiMsgActiveSense = 0xFE,  # Active Sensing
        midiMsgReset = 0xFF  # Reset

##
## Standard MIDI Controller Numbers
##
type
    MidiController* = enum
        midiCtlMsbBank = 0x00,  ##  Bank Selection
        midiCtlMsbModwheel = 0x01,  # Modulation
        midiCtlMsbBreath = 0x02,  # Breath
        midiCtlMsbFoot = 0x04,  # Foot
        midiCtlMsbPortamentoTime = 0x05,  # Portamento Time
        midiCtlMsbDataEntry = 0x06,  # Data Entry
        midiCtlMsbMainVolume = 0x07,  # Main Volume
        midiCtlMsbBalance = 0x08,  # Balance
        midiCtlMsbPan = 0x0A,  # Panpot
        midiCtlMsbExpression = 0x0B,  # Expression
        midiCtlMsbEffect1 = 0x0C,  # Effect1
        midiCtlMsbEffect2 = 0x0D,  # Effect2
        midiCtlMsbGeneralPurpose1 = 0x10,  # General Purpose 1
        midiCtlMsbGeneralPurpose2 = 0x11,  # General Purpose 2
        midiCtlMsbGeneralPurpose3 = 0x12,  # General Purpose 3
        midiCtlMsbGeneralPurpose4 = 0x13,  # General Purpose 4
        midiCtlLsbBank = 0x20,  # Bank Selection
        midiCtlLsbModwheel = 0x21,  # Modulation
        midiCtlLsbBreath = 0x22,  # Breath
        midiCtlLsbFoot = 0x24,  # Foot
        midiCtlLsbPortamentoTime = 0x25,  # Portamento Time
        midiCtlLsbDataEntry = 0x26,  # Data Entry
        midiCtlLsbMainVolume = 0x27,  # Main Volume
        midiCtlLsbBalance = 0x28,  # Balance
        midiCtlLsbPan = 0x2A,  # Panpot
        midiCtlLsbExpression = 0x2B,  # Expression
        midiCtlLsbEffect1 = 0x2C,  # Effect1
        midiCtlLsbEffect2 = 0x2D,  # Effect2
        midiCtlLsbGeneralPurpose1 = 0x30,  # General Purpose 1
        midiCtlLsbGeneralPurpose2 = 0x31,  # General Purpose 2
        midiCtlLsbGeneralPurpose3 = 0x32,  # General Purpose 3
        midiCtlLsbGeneralPurpose4 = 0x33,  # General Purpose 4
        midiCtlSustain = 0x40,  # Sustain Pedal
        midiCtlPortamento = 0x41,  # Portamento
        midiCtlSostenuto = 0x42,  # Sostenuto
        midiCtlSoftPedal = 0x43,  # Soft Pedal
        midiCtlLegatoFootswitch = 0x44,  # Legato Foot Switch
        midiCtlHold2 = 0x45,  # Hold2
        midiCtlSc1SoundVariation = 0x46,  # SC1 Sound Variation
        midiCtlSc2Timbre = 0x47,  # SC2 Timbre
        midiCtlSc3ReleaseTime = 0x48,  # SC3 Release Time
        midiCtlSc4AttackTime = 0x49,  # SC4 Attack Time
        midiCtlSc5Brightness = 0x4A,  # SC5 Brightness
        midiCtlSc6 = 0x4B,  # SC6
        midiCtlSc7 = 0x4C,  # SC7
        midiCtlSc8 = 0x4D,  # SC8
        midiCtlSc9 = 0x4E,  # SC9
        midiCtlSc10 = 0x4F,  # SC10
        midiCtlGeneralPurpose5 = 0x50,  # General Purpose 5
        midiCtlGeneralPurpose6 = 0x51,  # General Purpose 6
        midiCtlGeneralPurpose7 = 0x52,  # General Purpose 7
        midiCtlGeneralPurpose8 = 0x53,  # General Purpose 8
        midiCtlPortamentoControl = 0x54,  # Portamento Control
        midiCtlE1ReverbDepth = 0x5B,  # E1 Reverb Depth
        midiCtlE2TremoloDepth = 0x5C,  # E2 Tremolo Depth
        midiCtlE3ChorusDepth = 0x5D,  # E3 Chorus Depth
        midiCtlE4DetuneDepth = 0x5E,  # E4 Detune Depth
        midiCtlE5PhaserDepth = 0x5F,  # E5 Phaser Depth
        midiCtlDataIncrement = 0x60,  # Data Increment
        midiCtlDataDecrement = 0x61,  # Data Decrement
        midiCtlNrpnLsb = 0x62,  # Non-registered Parameter Number
        midiCtlNrpnMsb = 0x63,  # Non-registered Parameter Number
        midiCtlRpnLsb = 0x64,  # Registered Parameter Number
        midiCtlRpnMsb = 0x65,  # Registered Parameter Number
        midiCtlAllSoundsOff = 0x78,  # All Sounds Off
        midiCtlResetControllers = 0x79,  # Reset Controllers
        midiCtlLocalControlSwitch = 0x7A,  # Local Control Switch
        midiCtlAllNotesOff = 0x7B,  # All Notes Off
        midiCtlOmniOff = 0x7C,  # Omni Off
        midiCtlOmniOn = 0x7D,  # Omni On
        midiCtlMono1 = 0x7E,  # Mono1
        midiCtlMono2 = 0x7F  # Mono2

##
## Return true iff `msg` is a MIDI voice message (which has a channel).
##
proc midiIsVoiceMessage*(msg: UncheckedArray[uint8]): bool {.inline.} =
    return msg[0] >= 0x80 and msg[0] < 0xF0

##
## Return true iff `msg` is a MIDI system message (which has no channel).
##
proc midiIsSystemMessage*(msg: UncheckedArray[uint8]): bool {.inline.} =
    case msg[0]
    of 0xF4, 0xF5, 0xF7, 0xF9, 0xFD:
        return false
    else:
        return (msg[0] and 0xF0) == 0xF0

##
## Return the type of a MIDI message.
## 
## @param msg Pointer to the start (status byte) of a MIDI message.
##
proc midiGetMessageType*(msg: UncheckedArray[uint8]): MidiMessageType {.inline.} =
    if midiIsVoiceMessage(msg):
        return cast[MidiMessageType](msg[0] and 0xF0)
    if midiIsSystemMessage(msg):
        return cast[MidiMessageType](msg[0])
    return midiMsgInvalid
