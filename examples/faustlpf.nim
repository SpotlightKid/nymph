{.compile: "faustlpf.c".}

type
    faustlpf* = object
    SampleBuffer* = UncheckedArray[cfloat]


proc newfaustlpf*(): ptr faustlpf {.importc.}
proc deletefaustlpf*(dsp: ptr faustlpf) {.importc.}
proc initfaustlpf*(dsp: ptr faustlpf, sample_rate: cint) {.importc.}
proc instanceClearfaustlpf*(dsp: ptr faustlpf) {.importc.}
proc computefaustlpf*(dsp: ptr faustlpf, count: cint, inputs, outputs: ptr ptr SampleBuffer) {.importc.}

proc parameter_group*(index: cuint): cint {.importc}
proc parameter_is_boolean*(index: cuint): bool {.importc}
proc parameter_is_enum*(index: cuint): bool {.importc}
proc parameter_is_integer*(index: cuint): bool {.importc}
proc parameter_is_logarithmic*(index: cuint): bool {.importc}
proc parameter_is_trigger*(index: cuint): bool {.importc}
proc parameter_label*(index: cuint): cstring {.importc}
proc parameter_short_label*(index: cuint): cstring {.importc}
proc parameter_style*(index: cuint): cstring {.importc}
proc parameter_symbol*(index: cuint): cstring {.importc}
proc parameter_unit*(index: cuint): cstring {.importc}

proc get_parameter*(dsp: ptr faustlpf, index: cuint): cfloat {.importc}
proc set_parameter*(dsp: ptr faustlpf, index: cuint, value: cfloat) {.importc}


proc get_cutoff*(dsp: ptr faustlpf): cfloat {.importc}


proc set_cutoff*(dsp: ptr faustlpf, value: cfloat) {.importc}
