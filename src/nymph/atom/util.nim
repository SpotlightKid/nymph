## Copyright 2008-2015 David Robillard <d@drobilla.net>
## SPDX-License-Identifier: ISC
##
## Helper functions for the LV2 Atom extension.
##
## Note these functions are all static inline, do not take their address.
##
## This header is non-normative, it is provided for convenience.
##
## Utilities for working with atoms.
##

from system/ansi_c import c_memcmp, c_memcpy
import ../atom


##
## Increment pointer `p` by `offset` that jumps memory in increments of
## the size of `T`.
##
proc `+`*[T](p: ptr T, offset: SomeInteger): ptr T =
    return cast[ptr T](cast[int](p) +% (offset.int * sizeof(T)))

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
    return atom == nil or (atom.`type` == 0 and atom.size == 0)

##
## Return true iff `a` is equal to `b`.
##
proc atomEquals*(a: ptr Atom; b: ptr Atom): bool {.inline.} =
    return (a == b) or
        ((a.`type` == b.`type`) and (a.size == b.size) and
        c_memcmp(a + 1, b + 1, a.size) == 0)

##
## Sequence Iterator
##
## Get an iterator pointing to the first event in a Sequence body.
##
proc atomSequenceBegin*(body: ptr AtomSequenceBody): ptr AtomEvent {.inline.} =
    return cast[ptr AtomEvent](body + 1)


##
## Get an iterator pointing to the end of a Sequence body.
##
proc atomSequenceEnd*(body: ptr AtomSequenceBody; size: uint32): ptr AtomEvent {.inline.} =
    return cast[ptr AtomEvent](cast[ptr uint8](body) + atomPadSize(size))

##
## Return true iff `i` has reached the end of `body`.
##
proc atomSequenceIsEnd*(body: ptr AtomSequenceBody; size: Natural; i: ptr AtomEvent): bool {.inline.} =
    return cast[ptr uint8](i) >= (cast[ptr uint8](body) + size.uint)

##
## Return an iterator to the element following `i`.
##
proc atomSequenceNext*(i: ptr AtomEvent): ptr AtomEvent {.inline.} =
    return cast[ptr AtomEvent](i + sizeof(AtomEvent) + atomPadSize(i.body.size))

##
## An iterator for looping over all events in a Sequence.
## @param seq  The sequence to iterate over
##
iterator items*(seq: ptr AtomSequence): ptr AtomEvent {.inline.} =
    var event = atomSequenceBegin(seq.body.addr)
    while not atomSequenceIsEnd(seq.body.addr, seq.atom.size, event):
        yield event
        event = atomSequenceNext(event)

## TODO: Like LV2_ATOM_SEQUENCE_FOREACH but for a headerless sequence body.

##
## Sequence Utilities
##
## Clear all events from `sequence`.
##
## This simply resets the size field, the other fields are left untouched.
##
proc atomSequenceClear*(seq: ptr AtomSequence) {.inline.} =
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
## or NULL on failure (insufficient space).
##
proc atomSequenceAppendEvent*(seq: ptr AtomSequence; capacity: uint32;
                              event: ptr AtomEvent): ptr AtomEvent {.inline.} =
    let totalSize = sizeof(AtomEvent).uint32 + event.body.size
    
    if capacity - seq.atom.size < totalSize:
        return nil
    
    var e = atomSequenceEnd(seq.body.addr, seq.atom.size)
    c_memcpy(e, event, totalSize)
    seq.atom.size += atomPadSize(totalSize)
    return e

##
## Tuple Iterator
##
## Get an iterator pointing to the first element in `tup`.
##
proc atomTupleBegin*(tup: ptr AtomTuple): ptr Atom {.inline.} =
    return cast[ptr Atom](atomContents(Atom, tup))

##
## Return true iff `i` has reached the end of `body`.
##
proc atomTupleIsEnd*(body: pointer; size: Natural; i: ptr Atom): bool {.inline.} =
    return cast[ptr uint8](i) >= (cast[ptr uint8](body) + size.int)

##
## Return an iterator to the element following `i`.
##
proc atomTupleNext*(i: ptr Atom): ptr Atom {.inline.} =
    return cast[ptr Atom](cast[ptr uint8](i) + sizeof(Atom) + atomPadSize(i.size))


## TODO:
##
## A iterator for looping over all properties of a Tuple.
## @param tuple The tuple to iterate over

## TODO: 
## Like LV2_ATOM_TUPLE_FOREACH but for a headerless tuple body.

##
## Object Iterator
##
## Return a pointer to the first property in `body`.
##
proc atomObjectBegin*(body: ptr AtomObjectBody): ptr AtomPropertyBody {.inline.} =
    return cast[ptr AtomPropertyBody](body + 1)

##
## Return true iff `i` has reached the end of `obj`.
##
proc atomObjectIsEnd*(body: ptr AtomObjectBody; size: Natural; i: ptr AtomPropertyBody): bool {.inline.} =
    return cast[ptr uint8](i) >= (cast[ptr uint8](body) + size.int)

##
## Return an iterator to the property following `i`.
##
proc atomObjectNext*(i: ptr AtomPropertyBody): ptr AtomPropertyBody {.inline.} =
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
