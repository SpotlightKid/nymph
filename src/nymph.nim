const LV2_CORE_URI* = "http://lv2plug.in/ns/lv2core"


type Lv2Handle* = pointer


type Lv2Feature* = object
    uri*: cstring
    data*: pointer


type Lv2Descriptor* = object
    uri*: cstring

    instantiate*: proc(descriptor: ptr Lv2Descriptor, sampleRate: cdouble, bundlePath: cstring,
                       features: ptr ptr Lv2Feature): Lv2Handle {.cdecl.}

    connectPort*: proc(instance: Lv2Handle, port: cuint, dataLocation: pointer) {.cdecl.}

    activate*: proc(instance: Lv2Handle) {.cdecl.}

    run*: proc(instance: Lv2Handle, sampleCount: cuint) {.cdecl.}

    deactivate*: proc(instance: Lv2Handle) {.cdecl.}

    cleanup*: proc(instance: Lv2Handle) {.cdecl.}

    extensionData*: proc(uri: cstring): pointer {.cdecl.}


type lv2Descriptor* = proc(index: cuint): ptr Lv2Descriptor {.cdecl.}

