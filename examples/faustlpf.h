//------------------------------------------------------------------------------
// This file was generated using the Faust compiler (https://faust.grame.fr),
// and the Faust post-processor (https://github.com/SpotlightKid/faustdoctor).
//
// Source: faustlpf.dsp
// Name: FaustLPF
// Author: Christopher Arndt
// Copyright: Christopher Arndt, 2024
// License: MIT
// Version: 0.1.0
// FAUST version: 2.76.0
// FAUST compilation options: -a /home/chris/tmp/tmpkjrmmie8.c -lang c -rui -ct 1 -fm def -cn faustlpf -es 1 -mcd 16 -mdd 1024 -mdy 33 -single -ftz 0 -vec -lv 0 -vs 32
//------------------------------------------------------------------------------

#ifndef  __faustlpf_H__
#define  __faustlpf_H__

#ifndef FAUSTFLOAT
#define FAUSTFLOAT float
#endif

#ifndef FAUSTCLASS
#define FAUSTCLASS faustlpf
#endif

#if defined(_WIN32)
#define RESTRICT __restrict
#else
#define RESTRICT __restrict__
#endif

#include <stdbool.h>
#include <stdint.h>
#include "faust/gui/CInterface.h"

typedef struct {
    int fSampleRate;
    float fConst0;
    float fConst1;
    float fConst2;
    FAUSTFLOAT fHslider0;
    float fRec1_perm[4];
    float fConst3;
    float fRec0_perm[4];
} faustlpf;

faustlpf* newfaustlpf();
void deletefaustlpf(faustlpf* dsp);
void metadatafaustlpf(MetaGlue* m);
int getSampleRatefaustlpf(faustlpf* RESTRICT dsp);
int getNumInputsfaustlpf(faustlpf* RESTRICT dsp);
int getNumOutputsfaustlpf(faustlpf* RESTRICT dsp);
void classInitfaustlpf(int sample_rate);
void instanceResetUserInterfacefaustlpf(faustlpf* dsp);
void instanceClearfaustlpf(faustlpf* dsp);
void instanceConstantsfaustlpf(faustlpf* dsp, int sample_rate);
void instanceInitfaustlpf(faustlpf* dsp, int sample_rate);
void initfaustlpf(faustlpf* dsp, int sample_rate);
void buildUserInterfacefaustlpf(faustlpf* dsp, UIGlue* ui_interface);
void computefaustlpf(faustlpf* dsp, int count, FAUSTFLOAT** RESTRICT inputs, FAUSTFLOAT** RESTRICT outputs);

typedef struct {
    FAUSTFLOAT init;
    FAUSTFLOAT min;
    FAUSTFLOAT max;
} ParameterRange;

int parameter_group(unsigned index) {
    switch (index) {
    default:
        return -1;
    }
}

const char *parameter_label(unsigned index) {
    switch (index) {
    case 0:
        return "Cutoff";
    default:
        return 0;
    }
}

const char *parameter_short_label(unsigned index) {
    switch (index) {
    case 0:
        return "Cutoff";
    default:
        return 0;
    }
}

const char *parameter_style(unsigned index) {
    switch (index) {
    case 0: {
        return "knob";
    }
    default:
        return "";
    }
}

const char *parameter_symbol(unsigned index) {
    switch (index) {
    case 0:
        return "cutoff";
    default:
        return "";
    }
}

const char *parameter_unit(unsigned index) {
    switch (index) {
    case 0:
        return "Hz";
    default:
        return 0;
    }
}

const ParameterRange *parameter_range(unsigned index) {
    switch (index) {
    case 0: {
        static const ParameterRange range = { 15000.0, 16.0, 15000.0 };
        return &range;
    }
    default:
        return 0;
    }
}

bool parameter_is_trigger(unsigned index) {
    switch (index) {
    default:
        return false;
    }
}

bool parameter_is_boolean(unsigned index) {
    switch (index) {
    default:
        return false;
    }
}

bool parameter_is_enum(unsigned index) {
    switch (index) {
    default:
        return false;
    }
}

bool parameter_is_integer(unsigned index) {
    switch (index) {
    default:
        return false;
    }
}

bool parameter_is_logarithmic(unsigned index) {
    switch (index) {
    case 0:
        return true;
    default:
        return false;
    }
}

FAUSTFLOAT get_parameter(faustlpf* dsp, unsigned index) {
    switch (index) {
    case 0:
        return dsp->fHslider0;
    default:
        (void)dsp;
        return 0.0;
    }
}

void set_parameter(faustlpf* dsp, unsigned index, FAUSTFLOAT value) {
    switch (index) {
    case 0:
        dsp->fHslider0 = value;
        break;
    default:
        (void)dsp;
        (void)value;
        break;
    }
}

FAUSTFLOAT get_cutoff(faustlpf* dsp) {
    return dsp->fHslider0;
}

void set_cutoff(faustlpf* dsp, FAUSTFLOAT value) {
    dsp->fHslider0 = value;
}


#endif  /* __faustlpf_H__ */