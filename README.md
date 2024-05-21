# nymph

A [Nim] library for writing audio and MIDI plugins conforming to the [LV2] standard


## Examples

Build the `amp.lv2` example plugin:

    nimble build_ex amp

Check the `amp.lv2` plugin bundle with `lv2lint`:

    nimble lv2lint amp

Run the `lv2bm` benchmark with the `amp.lv2` plugin:

    nimble lv2bm amp

Install the `amp.lv2` example plugin:

    cp -a examples/amp.lv2 ~/.lv2

Other example plugins can be found in the [examples](./examples) directory and
can be built and tested with similar commands, just changing the example name
to the basename of the plugin's LV2 bundle dir.

Currently, there are only two other example plugins, `multimode_filter` and
`miditranspose`, but more will be added in due time.


## How To

* Install this library:

        nimble install https://git.0x20.eu/chris/nymph

* Copy `examples/amp.lv2` and `examples/amp.nim` into your project and rename
  them as you like (also rename `amp.lv2/amp.ttl`). I'll use `myplugin` as the
  base name in the examples below.

* Edit `myplugin.lv2/manifest.ttl`:
    * Change the plugin URI.
    * Change the plugin's shared library name defined via `lv2:binary` to
      `libmyplugin.so`.
    * Change file name referenced via `rdfs:seeAlso` to `myplugin.ttl`.

* Edit `myplugin.lv2/myplugin.ttl`:
    * Change the plugin URI.
    * Define audio, control and atom ports as needed.

* Edit `myplugin.nim`:
    * Change the `PluginUri` constant at the top.
    * Change the `PluginPort` enum and list the ports in the order defined in
      `myplugin.ttl`.
    * Rename and update the definition of the `AmpPlugin` object type and
      define its members with the appropriate data type for the plugin port
      they will be connected to. Update the type name in the `instantiate`,
      `deactivate`, `connectPorts` and `run` procs.
    * Update and extend the `case` statement in `connectPort` to connect ports
      to your plugin object instance members.
    * Implement your DSP code in the `run` proc.

* Compile the plugin shared library object with:

        nim c --app:lib --noMain:on --mm:arc \
            --out:myplugin.lv2/libmyplugin.so myplugin.nim

    See the definition of the `build_ex` task in the
    [nymph.nimble](./nymph.nimble#L43) file on how to create a nimble task
    to simplify compilation.


## Dependencies

Required:

* [Nim] >= 2.0

Optional:

* [lv2bm] - For benchmarking and stress-testing plugins
* [lv2lint] - For checking conformity of plugin bundles


[LV2]: https://lv2plug.in/
[lv2bm]: https://github.com/moddevices/lv2bm
[lv2lint]: https://git.open-music-kontrollers.ch/~hp/lv2lint
[Nim]: https://nim-lang.org/

