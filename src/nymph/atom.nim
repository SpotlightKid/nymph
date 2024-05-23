## Copyright 2008-2016 David Robillard <d@drobilla.net>
## SPDX-License-Identifier: ISC
##
## A generic value container and several data types.
##
## See <http://lv2plug.in/ns/ext/atom> for details.
##

import ptrmath
import urid

const
    lv2AtomBaseUri ="http://lv2plug.in/ns/ext/atom"
    lv2AtomPrefix = lv2AtomBaseUri & "#"

    lv2AtomAtom = lv2AtomPrefix & "Atom"
    lv2AtomAtomport = lv2AtomPrefix & "AtomPort"
    lv2AtomBlank = lv2AtomPrefix & "Blank"
    lv2AtomBool = lv2AtomPrefix & "Bool"
    lv2AtomChunk = lv2AtomPrefix & "Chunk"
    lv2AtomDouble = lv2AtomPrefix & "Double"
    lv2AtomEvent = lv2AtomPrefix & "Event"
    lv2AtomFloat = lv2AtomPrefix & "Float"
    lv2AtomInt = lv2AtomPrefix & "Int"
    lv2AtomLiteral = lv2AtomPrefix & "Literal"
    lv2AtomLong = lv2AtomPrefix & "Long"
    lv2AtomNumber = lv2AtomPrefix & "Number"
    lv2AtomObject = lv2AtomPrefix & "Object"
    lv2AtomPath = lv2AtomPrefix & "Path"
    lv2AtomProperty = lv2AtomPrefix & "Property"
    lv2AtomResource = lv2AtomPrefix & "Resource"
    lv2AtomSequence = lv2AtomPrefix & "Sequence"
    lv2AtomSound = lv2AtomPrefix & "Sound"
    lv2AtomString = lv2AtomPrefix & "String"
    lv2AtomTuple = lv2AtomPrefix & "Tuple"
    lv2AtomUri = lv2AtomPrefix & "URI"
    lv2AtomUrid = lv2AtomPrefix & "URID"
    lv2AtomVector = lv2AtomPrefix & "Vector"
    lv2AtomAtomtransfer = lv2AtomPrefix & "atomTransfer"
    lv2AtomBeattime = lv2AtomPrefix & "beatTime"
    lv2AtomBuffer= lv2AtomPrefix & "bufferType"
    lv2AtomChild= lv2AtomPrefix & "childType"
    lv2AtomEventtransfer = lv2AtomPrefix & "eventTransfer"
    lv2AtomFrametime = lv2AtomPrefix & "frameTime"
    lv2AtomSupports = lv2AtomPrefix & "supports"
    lv2AtomTimeunit = lv2AtomPrefix & "timeUnit"

##
## Return a pointer to the contents of an Atom.  The "contents" of an atom
## is the data past the complete type-specific header.
## @param type The type of the atom, for example AtomString.
## @param atom A variable-sized atom.
##
template atomContents*(`type`, atom: untyped): pointer =
    cast[ptr uint8](atom) + sizeof(`type`)

##
## Return a pointer to the body of an Atom.  The "body" of an atom is the
## data just past the Atom head (i.e. the same offset for all types).
##
template atomBody*(atom: untyped): pointer =
    atomContents(Atom, atom)

type
    ## The header of an atom:Atom.
    Atom* {.bycopy.} = object
        size*: uint32  ## Size in bytes, not including type and size.
        `type`*: Urid  ## Type of this atom (mapped URI).

    ## An atom:Int or atom:Bool.  May be cast to Atom.
    AtomInt* {.bycopy.} = object
        atom*: Atom  ## Atom header.
        body*: int32  ## Integer value.

    ## An atom:Long.  May be cast to Atom.
    AtomLong* {.bycopy.} = object
        atom*: Atom  ## Atom header.
        body*: int64  ## Integer value.

    ## An atom:Float.  May be cast to Atom.
    AtomFloat* {.bycopy.} = object
        atom*: Atom  ## Atom header.
        body*: cfloat  ## Floating point value.

    ## An atom:Double.  May be cast to Atom.
    AtomDouble* {.bycopy.} = object
        atom*: Atom  ## Atom header.
        body*: cdouble  ## Floating point value.

    ## An atom:Bool.  May be cast to Atom.
    AtomBool* = distinct AtomInt

    ## An atom:URID.  May be cast to Atom.
    AtomUrid* {.bycopy.} = object
        atom*: Atom  ## Atom header.
        body*: Urid  ## Urid.

    ## An atom:String.  May be cast to Atom.
    AtomString* {.bycopy.} = object
        atom*: Atom  ## Atom header.
        ## Contents (a null-terminated UTF-8 string) follow here.

    ## The body of an atom:Literal.
    AtomLiteralBody* {.bycopy.} = object
        datatype*: Urid  ## Datatype Urid.
        lang*: Urid  ## Language Urid.
        ## Contents (a null-terminated UTF-8 string) follow here.

    ## An atom:Literal.  May be cast to Atom.
    AtomLiteral* {.bycopy.} = object
        atom*: Atom  ## Atom header.
        body*: AtomLiteralBody  ## Body.

    ## An atom:Tuple.  May be cast to Atom.
    AtomTuple* {.bycopy.} = object
        atom*: Atom  ## Atom header.
        ## Contents (a series of complete atoms) follow here.

    ## The body of an atom:Vector.
    AtomVectorBody* {.bycopy.} = object
        childSize*: uint32  ## The size of each element in the vector.
        childType*: uint32  ## The of each element in the vector.
        ## Contents (a series of packed atom bodies) follow here.

    ## An atom:Vector.  May be cast to Atom.
    AtomVector* {.bycopy.} = object
        atom*: Atom  ## Atom header.
        body*: AtomVectorBody  ## Body.

    ## The body of an atom:Property (typically in an atom:Object).
    AtomPropertyBody* {.bycopy.} = object
        key*: Urid  ## Key (predicate) (mapped URI).
        context*: Urid  ## Context URID (may be, and generally is, 0).
        value*: Atom  ## Value atom header.
        ## Value atom body follows here.

    ## An atom:Property.  May be cast to Atom.
    AtomProperty* {.bycopy.} = object
        atom*: Atom  ## Atom header.
        body*: AtomPropertyBody  ## Body.

    ## The body of an atom:Object. May be cast to Atom.
    AtomObjectBody* {.bycopy.} = object
        id*: Urid  ## Urid, or 0 for blank.
        otype*: Urid  ## Urid (same as rdf:type, for fast dispatch).
        ## Contents (a series of property bodies) follow here.

    ## An atom:Object.  May be cast to Atom.
    AtomObject* {.bycopy.} = object
        atom*: Atom  ## Atom header.
        body*: AtomObjectBody  ## Body.

    ## The header of an atom:Event.  Note this is NOT an Atom.
    AtomEventTime* {.bycopy, union.} = object
        frames*: int64  ## Time in audio frames.
        beats*: cdouble  ## Time in beats.

    AtomEvent* {.bycopy.} = object
        time*: AtomEventTime  ## Time stamp.  Which is valid is determined by context.
        body*: Atom  ## Event body atom header.
        ## Body atom contents follow here.

    ##
    ## The body of an AtomSequence (a sequence of events).
    ##
    ## The unit field is either a Urid that describes an appropriate time stamp
    ## type, or may be 0 where a default stamp type is known.  For
    ## lv2Descriptor.run(), the default stamp type is audio frames.
    ##
    ## The contents of a sequence is a series of AtomEvent, each aligned
    ## to 64-bits, for example:
    ## 
    ## ```
    ## | Event 1 (size 6)                              | Event 2
    ## |       |       |       |       |       |       |       |       |
    ## | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | |
    ## |FRAMES         |SIZE   |TYPE   |DATADATADATAPAD|FRAMES         |...
    ## ```
    ##
    AtomSequenceBody* {.bycopy.} = object
        unit*: Urid  ## Urid of unit of event time stamps.
        pad*: uint32  ## Currently unused.
        ## Contents (a series of events) follow here.

    ## An atom:Sequence.
    AtomSequence* {.bycopy.} = object
        atom*: Atom  ## Atom header.
        body*: AtomSequenceBody  ## Body.
