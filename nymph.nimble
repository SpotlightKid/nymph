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


proc showArgs() =
    ## Show task environment (for debugging when writing nimble tasks)
    echo "Command: ", getCommand()
    echo "ProjectName: ", projectName()
    echo "ProjectDir: ", projectDir()
    echo "ProjectPath: ", projectPath()
    echo "Task args: ", commandLineParams

    for i in 0..paramCount():
        echo &"Arg {i}: ", paramStr(i)


task build_ex, "Build given example plugin":
    #showArgs()
    let (_, args) = parseArgs()

    if args.len == 0:
        echo "Usage: nimble build_ex <example name>"
        return

    let example = args[^1]
    let source = thisDir() / "examples" / example & ".nim"
    let bundle = thisDir() / "examples" / example & ".lv2"
    let dll = bundle / toDll(example)

    if fileExists(source):
        switch("app", "lib")
        switch("noMain", "on")
        switch("mm", "arc")
        switch("out", dll)

        when not defined(release) and not defined(debug):
            echo &"Compiling plugin {example} in release mode."
            switch("define", "release")
            switch("opt", "speed")

        setCommand("compile", source)
    else:
        echo &"Example '{example}' not found."


task lv2lint, "Run lv2lint check on given example plugin":
    let (_, args) = parseArgs()

    if args.len == 0:
        echo "Usage: nimble lv2lint <example name>"
        return

    let example = args[^1]
    let uri = examples.getOrDefault(example)

    if uri == "":
        echo &"Plugin URI for example '{example}' not set."
        return

    let examplesDir = thisDir() & "/examples"
    let bundle = examplesDir & "/" & example & ".lv2"
    let dll = bundle & "/" & toDll(example)

    if fileExists(dll):
        exec(&"lv2lint -s NimMain -I {bundle} \"{uri}\"")
    else:
        echo &"Example '{example}' shared library not found. Use task 'build_ex' to build it."


task lv2bm, "Run lv2bm benchmark on given example plugin":
    let (_, args) = parseArgs()

    if args.len == 0:
        echo "Usage: nimble lv2bm <example name>"
        return

    let example = args[^1]
    let uri = examples.getOrDefault(example)

    if uri == "":
        echo &"Plugin URI for example '{example}' not set."
        return

    let examplesDir = thisDir() / "examples"
    let bundle = examplesDir / example & ".lv2"
    let dll = bundle / toDll(example)

    if fileExists(dll):
        let lv2_path = getEnv("LV2_PATH")
        let tempLv2Dir = thisDir() / ".lv2"
        let bundleLink = tempLv2Dir / example & ".lv2"

        mkDir(tempLv2Dir)
        rmFile(bundleLink)
        exec(&"ln -s \"{bundle}\" \"{bundleLink}\"")

        if lv2_path == "":
            putEnv("LV2_PATH", tempLv2Dir)
        else:
            putEnv("LV2_PATH", tempLv2Dir & ":" & lv2_path)

        exec(&"lv2bm --full-test -i white \"{uri}\"")
    else:
        echo &"Example '{example}' shared library not found. Use task 'build_ex' to build it."

