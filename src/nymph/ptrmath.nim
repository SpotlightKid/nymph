##
## Increment pointer `p` by `offset` that jumps memory in increments of
## the size of `T`.
##
proc `+`*[T](p: ptr T, offset: SomeInteger): ptr T =
    return cast[ptr T](cast[int](p) +% (offset.int * sizeof(T)))
