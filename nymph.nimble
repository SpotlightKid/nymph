import std/os except commandLineParams
import std/strformat

# Package definition

version       = "0.1.0"
author        = "Christopher Arndt"
description   = "A Nim library for writing audio and MIDI plugins conforming to the LV2 standard"
license       = "MIT"
srcDir        = "src"

# Dependencies

requires "nim >= 2.0"

# Custom tasks

type Example = tuple
    name: string
    uri: string
    source: string
    bundle: string
    dll: string


const examples = to_table({
    "amp": "urn:nymph:examples:amp"
})


proc parseArgs(): tuple[options: seq[string], args: seq[string]] =
    ## Parse task specific command line arguments into option switches and positional arguments
    for arg in commandLineParams:
        if arg[0] == '-':    # -d:foo or --define:foo
            result.options.add(arg)
        else:
            result.args.add(arg)


proc getExample(task_name: string): Example =
    let (_, args) = parseArgs()

    if args.len == 0:
        quit(&"Usage: nimble {task_name} <example name>")

    result.name = changeFileExt(args[^1], "")

    let examplesDir = thisDir() / "examples"
    result.source = examplesDir / changeFileExt(result.name, "nim")

    if not fileExists(result.source):
        quit(&"Example '{result.name}' not found.")

    result.uri = examples.getOrDefault(result.name)

    if result.uri == "":
        quit(&"Plugin URI for example '{result.name}' not set.")

    result.bundle = examplesDir / changeFileExt(result.name, "lv2")
    result.dll = result.bundle / toDll(result.name)


task build_ex, "Build given example plugin":
    let ex = getExample("build_ex")

    switch("app", "lib")
    switch("noMain", "on")
    switch("mm", "arc")
    switch("out", ex.dll)

    when not defined(release) and not defined(debug):
        echo &"Compiling plugin {ex.name} in release mode."
        switch("define", "release")
        switch("opt", "speed")
        switch("define", "lto")
        switch("define", "strip")

    setCommand("compile", ex.source)


task lv2lint, "Run lv2lint check on given example plugin":
    let ex = getExample("lv2lint")

    if fileExists(ex.dll):
        exec(&"lv2lint -s NimMain -I \"{ex.bundle}\" \"{ex.uri}\"")
    else:
        echo &"Example '{ex.name}' shared library not found. Use task 'build_ex' to build it."


task lv2bm, "Run lv2bm benchmark on given example plugin":
    let ex = getExample("lv2bm")

    if ex.uri == "":
        echo &"Plugin URI for example '{ex.name}' not set."
        return

    if fileExists(ex.dll):
        let lv2_path = getEnv("LV2_PATH")
        let tempLv2Dir = thisDir() / ".lv2"
        let bundleLink = tempLv2Dir / changeFileExt(ex.name, "lv2")

        mkDir(tempLv2Dir)
        rmFile(bundleLink)
        exec(&"ln -s \"{ex.bundle}\" \"{bundleLink}\"")

        if lv2_path == "":
            putEnv("LV2_PATH", tempLv2Dir)
        else:
            putEnv("LV2_PATH", tempLv2Dir & ":" & lv2_path)

        exec(&"lv2bm --full-test -i white \"{ex.uri}\"")
    else:
        echo &"Example '{ex.name}' shared library not found. Use task 'build_ex' to build it."

