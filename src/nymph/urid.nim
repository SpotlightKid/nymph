## Copyright 2008-2016 David Robillard <d@drobilla.net>
## Copyright 2011 Gabriel M. Beddingfield <gabrbedd@gmail.com>
## SPDX-License-Identifier: ISC
##
## Features for mapping URIs to and from integers.
##
## See <http://lv2plug.in/ns/ext/urid> for details.
##

const
    lv2UridBaseUri* = "http://lv2plug.in/ns/ext/urid"
    lv2UridPrefix* = lv2UridBaseUri & "#"

    lv2UridMap* = lv2UridPrefix & "map"
    lv2UridUnmap* = lv2UridPrefix & "unmap"

##
## Opaque pointer to host data for UridMap.
##
type UridMapHandle* = pointer

##
## Opaque pointer to host data for uridUnmap.
##
type UridUnmapHandle* = pointer

##
## URI mapped to an integer.
##
type Urid* = distinct uint32

##
## URID Map Feature (lv2UridMap)
##
type UridMap* {.bycopy.} = object
    ##
    ## Opaque pointer to host data.
    ##
    ## This MUST be passed to map_uri() whenever it is called.
    ## Otherwise, it must not be interpreted in any way.
    ##
    handle*: UridMapHandle
    ##
    ## Get the numeric ID of a URI.
    ##
    ## If the ID does not already exist, it will be created.
    ##
    ## This function is referentially transparent; any number of calls with the
    ## same arguments is guaranteed to return the same value over the life of a
    ## plugin instance.  Note, however, that several URIs MAY resolve to the
    ## same ID if the host considers those URIs equivalent.
    ##
    ## This function is not necessarily very fast or RT-safe: plugins SHOULD
    ## cache any IDs they might need in performance critical situations.
    ##
    ## The return value 0 is reserved and indicates that an ID for that URI
    ## could not be created for whatever reason.  However, hosts SHOULD NOT
    ## return 0 from this function in non-exceptional circumstances (i.e. the
    ## URI map SHOULD be dynamic).
    ##
    ## @param handle Must be the callback_data member of this struct.
    ## @param uri The URI to be mapped to an integer ID.
    ##
    map*: proc (handle: UridMapHandle; uri: cstring): Urid

##
## URI Unmap Feature (lv2UridUnmap)
##
type UridUnmap* {.bycopy.} = object
    ##
    ## Opaque pointer to host data.
    ##
    ## This MUST be passed to unmap() whenever it is called.
    ## Otherwise, it must not be interpreted in any way.
    ##
    handle*: UridUnmapHandle
    ##
    ## Get the URI for a previously mapped numeric ID.
    ##
    ## Returns NULL if `urid` is not yet mapped.  Otherwise, the corresponding
    ## URI is returned in a canonical form.  This MAY not be the exact same
    ## string that was originally passed to LV2_URID_Map::map(), but it MUST be
    ## an identical URI according to the URI syntax specification (RFC3986).  A
    ## non-NULL return for a given `urid` will always be the same for the life
    ## of the plugin.  Plugins that intend to perform string comparison on
    ## unmapped URIs SHOULD first canonicalise URI strings with a call to
    ## map_uri() followed by a call to unmap_uri().
    ##
    ## @param handle Must be the callback_data member of this struct.
    ## @param urid The ID to be mapped back to the URI string.
    ##
    unmap*: proc (handle: UridUnmapHandle; urid: Urid): cstring

proc `==`* (x: Urid, y: Urid): bool {.borrow.}
