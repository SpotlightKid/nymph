## Copyright 2008-2015 David Robillard <d@drobilla.net>
## SPDX-License-Identifier: ISC
##
## Helper functions for the LV2 Atom extension.
##
## Utilities for working with atoms.
##

import ../atom
import ../ptrmath
import ../urid

##
## Pad a size to 64 bits.
##
proc atomPadSize*(size: uint32): uint32 {.inline.} =
    let mask: uint32 = 7
    return (size + mask) and not mask

##
## Return the total size of `atom`, including the header.
##
proc atomTotalSize*(atom: ptr Atom): uint32 {.inline.} =
    return cast[uint32](sizeof(atom)) + atom.size

##
## Return true iff `atom` is null.
##
proc atomIsNull*(atom: ptr Atom): bool {.inline.} =
    return atom.isNil or (atom.`type` == Urid(0) and atom.size == 0)

##
## Return true iff `a` is equal to `b`.
##
proc atomEquals*(a: ptr Atom; b: ptr Atom): bool {.inline.} =
    return (a == b) or
        ((a.`type` == b.`type`) and (a.size == b.size) and
        cmpMem(a + 1, b + 1, a.size) == 0)

##
## Sequence Iterator
##
## Get an iterator pointing to the first event in a Sequence body.
##
template atomSequenceBegin*(body: ptr AtomSequenceBody): ptr AtomEvent =
    cast[ptr AtomEvent](body + 1)

##
## Get an iterator pointing to the end of a Sequence body.
##
template atomSequenceEnd*(body: ptr AtomSequenceBody; size: Natural): ptr AtomEvent =
    cast[ptr AtomEvent](cast[ptr uint8](body) + atomPadSize(size.uint32))

##
## Return true iff `i` has reached the end of `body`.
##
template atomSequenceIsEnd*(body: ptr AtomSequenceBody; size: Natural; i: ptr AtomEvent): bool =
    cast[ptr uint8](i) >= (cast[ptr uint8](body) + size.uint)

##
## Return an iterator to the element following `i`.
##
template atomSequenceNext*(i: ptr AtomEvent): ptr AtomEvent =
    cast[ptr AtomEvent](cast[ptr uint8](i) + sizeof(AtomEvent) + atomPadSize(i.body.size))

##
## An iterator for looping over all events in an AtomSequence.
## @param seq  Pointer to the sequence to iterate over
##
iterator items*(seq: ptr AtomSequence): ptr AtomEvent {.inline.} =
    var event = atomSequenceBegin(seq.body.addr)
    while not atomSequenceIsEnd(seq.body.addr, seq.atom.size, event):
        yield event
        event = atomSequenceNext(event)

## 
## An iterator for looping over all events in an AtomSequenceBody.
## @param body  Pointer to the sequence body to iterate over
## @param size  Size in bytes of the sequence body (including the 8 bytes of AtomSequenceBody)
## 
iterator items*(body: ptr AtomSequenceBody, size: Natural): ptr AtomEvent {.inline.} =
    var event = atomSequenceBegin(body)
    while not atomSequenceIsEnd(body, size, event):
        yield event
        event = atomSequenceNext(event)

##
## Sequence Utilities
##

##
## Test if AtomSequence is empty, i.e the body has no events
##
template atomSequenceIsEmpty*(seq: ptr AtomSequence): bool =
    seq.atom.size == sizeof(AtomSequenceBody).uint32

##
## Clear all events from `sequence`.
##
## This simply resets the size field, the other fields are left untouched.
##
template atomSequenceClear*(seq: ptr AtomSequence) =
    seq.atom.size = sizeof(AtomSequenceBody).uint32

##
## Append an event at the end of `sequence`.
##
## @param seq Sequence to append to.
## @param capacity Total capacity of the sequence atom
## (as set by the host for sequence output ports).
## @param event Event to write.
##
## @return A pointer to the newly written event in `seq`,
## or nil on failure (insufficient space).
##
proc atomSequenceAppendEvent*(seq: ptr AtomSequence; capacity: uint32;
                              event: ptr AtomEvent): ptr AtomEvent {.inline.} =
    let totalSize = sizeof(AtomEvent).uint32 + event.body.size
    
    if capacity - seq.atom.size < totalSize:
        return nil
    
    var e = atomSequenceEnd(seq.body.addr, seq.atom.size)
    copyMem(e, event, totalSize)
    seq.atom.size += atomPadSize(totalSize)
    return e

##
## Tuple Iterator
##
## Get an iterator pointing to the first element in `tup`.
##
template atomTupleBegin*(tup: ptr AtomTuple): ptr Atom =
    cast[ptr Atom](atomContents(Atom, tup))

##
## Return true iff `i` has reached the end of `body`.
##
template atomTupleIsEnd*(body: pointer; size: Natural; i: ptr Atom): bool =
    cast[ptr uint8](i) >= (cast[ptr uint8](body) + size.uint)

##
## Return an iterator to the element following `i`.
##
template atomTupleNext*(i: ptr Atom): ptr Atom =
    cast[ptr Atom](cast[ptr uint8](i) + sizeof(Atom) + atomPadSize(i.size))

##
## An iterator for looping over all elements of an AtomTuple.
## @param tuple Pointer to the tuple to iterate over
##
iterator items*(tup: ptr AtomTuple): ptr Atom {.inline.} =
    var atom = atomTupleBegin(tup)
    while not atomTupleIsEnd(atomBody(tup), tup.atom.size, atom):
        yield atom
        atom = atomTupleNext(atom)

##
## An iterator for looping over all elements of a headerless tuple.
## @param tuple Pointer to the first Atom of the tuple to iterate over
## @param size  Size in bytes of the tuple body
##
iterator items*(tup: ptr Atom, size: Natural): ptr Atom {.inline.} =
    var atom = tup
    while not atomTupleIsEnd(tup, size, atom):
        yield atom
        atom = atomTupleNext(atom)

##
## Object Iterator
##
## Return a pointer to the first property in `body`.
##
template atomObjectBegin*(body: ptr AtomObjectBody): ptr AtomPropertyBody =
    cast[ptr AtomPropertyBody](body + 1)

##
## Return true iff `i` has reached the end of `obj`.
##
template atomObjectIsEnd*(body: ptr AtomObjectBody; size: Natural; i: ptr AtomPropertyBody): bool =
    cast[ptr uint8](i) >= (cast[ptr uint8](body) + size.uint)

##
## Return an iterator to the property following `i`.
##
template atomObjectNext*(i: ptr AtomPropertyBody): ptr AtomPropertyBody =
    let value = cast[ptr Atom](cast[ptr uint8](i) + 2 * sizeof(uint32))
    return cast[ptr AtomPropertyBody](cast[ptr uint8](i) + atomPadSize(sizeof(AtomPropertyBody).uint32 + value.size))

## TODO: 
##
## A iterator for looping over all properties of an Object.
## @param obj The object to iterate over
##

## TODO: 
##
## Like LV2_ATOM_OBJECT_FOREACH but for a headerless object body.
##
