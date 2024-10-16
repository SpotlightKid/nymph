declare name "FaustLPF";
declare author "Christopher Arndt";
declare copyright "Christopher Arndt, 2024";
declare license "MIT"; 
declare version "0.1.0";

import("stdfaust.lib");

cutoff = hslider("[1] Cutoff [symbol:cutoff] [unit:Hz] [scale:log] [style:knob] [tooltip:Low-pass filter cutoff frequency]",
    15000, 16, 15000, 0.1) : si.smoo;

process = fi.lowpass(2, cutoff);
