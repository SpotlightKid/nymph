# nymph

A [Nim] library for writing audio and MIDI plugins conforming to the [LV2]
standard


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
can be built and tested with similar commands. Just change the example name to
the basename of the plugin's LV2 bundle dir.

Currently, there are just a few other example plugins:

* [`miditranspose`](./examples/miditranspose_plugin.nim): shows how to handle
  receiving and sending MIDI events.
* [`multimodefilter`](./examples/multimodefilter_plugin.nim): shows a
  multimode state-variable filter implementation ported from C++ to Nim.
* [`tiltfilter`](./examples/titltfilter_plugin.nim): shows a multimode tilt
  equalizer filter implementation ported from Rust to Nim.
* [`faustlpf`](./examples/faustlpf_plugin.nim): shows how to integrate DSP C
  code generated from a [FAUST] source file in Nim (in this example the FAUST
  code implements a simple non-resonant low-pass filter from the FAUST
  standard library).


## How To

**Note:** I'll use `mydsp` as the base name for the new plugin in the
examples below. Substitute your own plugin basename wherever you see it used
below.

1. Install this library:

      nimble install https://github.com/SpotlightKid/nymph.git

1. Make a directory named `mydsp.lv2` and copy `examples/amp.lv2/manifest.ttl`
    into it. Also copy `examples/amp.lv2/amp.ttl` to `mydsp.lv2/mydsp.ttl`.

1. Copy `examples/amp_plugin.nim` into your project as `mydsp_plugin.nim`.

1. Edit `mydsp.lv2/manifest.ttl`:
   * Change the plugin URI.
   * Change the plugin's shared library name defined via `lv2:binary` to
     `libmydsp.so`.
   * Change file name referenced via `rdfs:seeAlso` to `mydsp.ttl`.

1. Edit `mydsp.lv2/mydsp.ttl`:
   * Change the plugin URI.
   * Define audio, control and atom ports as needed.

1. Edit `mydsp_plugin.nim`:
   * Change the `PluginUri` constant at the top.
   * Change the `PluginPort` enum and list the ports in the order defined in
     `mydsp.ttl`.
   * Rename and update the definition of the `AmpPlugin` object type and
     define its members with the appropriate data types for the plugin ports
     they will be connected to. Update the type name in the `instantiate`,
     `deactivate`, `connectPorts` and `run` procs.
   * Update and extend the `case` statement in `connectPort` to connect ports
     to your plugin object instance members.
   * Implement your DSP code in the `run` proc.

1. Compile the plugin shared library object with:

        nim c --app:lib --noMain:on --mm:arc \
            --out:mydsp.lv2/libmydsp.so mydsp_plugin.nim

    See the definition of the `build_ex` task in the
    [nymph.nimble](./nymph.nimble#L67) file on how to create a nimble task
    to simplify compilation.


## Dependencies

Required:

* [Nim] >= 2.0

Optional:

* [lv2bm] - For benchmarking and stress-testing plugins
* [lv2lint] - For checking conformity of plugin bundles


## See Also

* [lv2-nim](https://gitlab.com/lpirl/lv2-nim) - Older third-party Nim bindings
  for the LV2 audio plugin specification. Last update in 2021.
* [offbeat](https://github.com/NimAudio/offbeat) - A [CLAP] based plugin
  framework in Nim


[CLAP]: https://cleveraudio.org/
[FAUST]: https://faust.grame.fr/
[LV2]: https://lv2plug.in/
[lv2bm]: https://github.com/moddevices/lv2bm
[lv2lint]: https://git.open-music-kontrollers.ch/~hp/lv2lint
[Nim]: https://nim-lang.org/
