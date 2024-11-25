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
// FAUST compilation options: -a /home/chris/tmp/tmpnf8hapuk.c -lang c -rui -ct 1 -fm def -cn faustlpf -es 1 -mcd 16 -mdd 1024 -mdy 33 -single -ftz 0 -vec -lv 0 -vs 32
//------------------------------------------------------------------------------

#include "faustlpf.h"

//------------------------------------------------------------------------------
// Begin the Faust code section

#if defined(__GNUC__)
#   pragma GCC diagnostic push
#   pragma GCC diagnostic ignored "-Wunused-parameter"
#endif

// START INTRINSICS
// END INTRINSICS
// START CLASS CODE
#ifndef FAUSTFLOAT
#define FAUSTFLOAT float
#endif 


#ifdef __cplusplus
extern "C" {
#endif

#if defined(_WIN32)
#define RESTRICT __restrict
#else
#define RESTRICT __restrict__
#endif

#include "faust/dsp/fastmath.cpp"
#include <math.h>
#include <stdint.h>
#include <stdlib.h>

static float faustlpf_faustpower2_f(float value) {
    return value * value;
}

#ifndef FAUSTCLASS 
#define FAUSTCLASS faustlpf
#endif

#ifdef __APPLE__ 
#define exp10f __exp10f
#define exp10 __exp10
#endif



faustlpf* newfaustlpf() { 
    faustlpf* dsp = (faustlpf*)calloc(1, sizeof(faustlpf));
    return dsp;
}

void deletefaustlpf(faustlpf* dsp) { 
    free(dsp);
}

void metadatafaustlpf(MetaGlue* m) { 
    m->declare(m->metaInterface, "author", "Christopher Arndt");
    m->declare(m->metaInterface, "compile_options", "-a /home/chris/tmp/tmpnf8hapuk.c -lang c -rui -ct 1 -fm def -cn faustlpf -es 1 -mcd 16 -mdd 1024 -mdy 33 -single -ftz 0 -vec -lv 0 -vs 32");
    m->declare(m->metaInterface, "copyright", "Christopher Arndt, 2024");
    m->declare(m->metaInterface, "filename", "faustlpf.dsp");
    m->declare(m->metaInterface, "filters.lib/fir:author", "Julius O. Smith III");
    m->declare(m->metaInterface, "filters.lib/fir:copyright", "Copyright (C) 2003-2019 by Julius O. Smith III <jos@ccrma.stanford.edu>");
    m->declare(m->metaInterface, "filters.lib/fir:license", "MIT-style STK-4.3 license");
    m->declare(m->metaInterface, "filters.lib/iir:author", "Julius O. Smith III");
    m->declare(m->metaInterface, "filters.lib/iir:copyright", "Copyright (C) 2003-2019 by Julius O. Smith III <jos@ccrma.stanford.edu>");
    m->declare(m->metaInterface, "filters.lib/iir:license", "MIT-style STK-4.3 license");
    m->declare(m->metaInterface, "filters.lib/lowpass0_highpass1", "Copyright (C) 2003-2019 by Julius O. Smith III <jos@ccrma.stanford.edu>");
    m->declare(m->metaInterface, "filters.lib/lowpass0_highpass1:author", "Julius O. Smith III");
    m->declare(m->metaInterface, "filters.lib/lowpass:author", "Julius O. Smith III");
    m->declare(m->metaInterface, "filters.lib/lowpass:copyright", "Copyright (C) 2003-2019 by Julius O. Smith III <jos@ccrma.stanford.edu>");
    m->declare(m->metaInterface, "filters.lib/lowpass:license", "MIT-style STK-4.3 license");
    m->declare(m->metaInterface, "filters.lib/name", "Faust Filters Library");
    m->declare(m->metaInterface, "filters.lib/tf2:author", "Julius O. Smith III");
    m->declare(m->metaInterface, "filters.lib/tf2:copyright", "Copyright (C) 2003-2019 by Julius O. Smith III <jos@ccrma.stanford.edu>");
    m->declare(m->metaInterface, "filters.lib/tf2:license", "MIT-style STK-4.3 license");
    m->declare(m->metaInterface, "filters.lib/tf2s:author", "Julius O. Smith III");
    m->declare(m->metaInterface, "filters.lib/tf2s:copyright", "Copyright (C) 2003-2019 by Julius O. Smith III <jos@ccrma.stanford.edu>");
    m->declare(m->metaInterface, "filters.lib/tf2s:license", "MIT-style STK-4.3 license");
    m->declare(m->metaInterface, "filters.lib/version", "1.3.0");
    m->declare(m->metaInterface, "license", "MIT");
    m->declare(m->metaInterface, "maths.lib/author", "GRAME");
    m->declare(m->metaInterface, "maths.lib/copyright", "GRAME");
    m->declare(m->metaInterface, "maths.lib/license", "LGPL with exception");
    m->declare(m->metaInterface, "maths.lib/name", "Faust Math Library");
    m->declare(m->metaInterface, "maths.lib/version", "2.8.0");
    m->declare(m->metaInterface, "name", "FaustLPF");
    m->declare(m->metaInterface, "platform.lib/name", "Generic Platform Library");
    m->declare(m->metaInterface, "platform.lib/version", "1.3.0");
    m->declare(m->metaInterface, "signals.lib/name", "Faust Signal Routing Library");
    m->declare(m->metaInterface, "signals.lib/version", "1.6.0");
    m->declare(m->metaInterface, "version", "0.1.0");
}

int getSampleRatefaustlpf(faustlpf* RESTRICT dsp) {
    return dsp->fSampleRate;
}

int getNumInputsfaustlpf(faustlpf* RESTRICT dsp) {
    return 1;
}
int getNumOutputsfaustlpf(faustlpf* RESTRICT dsp) {
    return 1;
}

void classInitfaustlpf(int sample_rate) {
}

void instanceResetUserInterfacefaustlpf(faustlpf* dsp) {
    dsp->fHslider0 = (FAUSTFLOAT)(1.5e+04f);
}

void instanceClearfaustlpf(faustlpf* dsp) {
    /* C99 loop */
    {
        int l0;
        for (l0 = 0; l0 < 4; l0 = l0 + 1) {
            dsp->fRec1_perm[l0] = 0.0f;
        }
    }
    /* C99 loop */
    {
        int l1;
        for (l1 = 0; l1 < 4; l1 = l1 + 1) {
            dsp->fRec0_perm[l1] = 0.0f;
        }
    }
}

void instanceConstantsfaustlpf(faustlpf* dsp, int sample_rate) {
    dsp->fSampleRate = sample_rate;
    dsp->fConst0 = fminf(1.92e+05f, fmaxf(1.0f, (float)(dsp->fSampleRate)));
    dsp->fConst1 = 44.1f / dsp->fConst0;
    dsp->fConst2 = 1.0f - dsp->fConst1;
    dsp->fConst3 = 3.1415927f / dsp->fConst0;
}
    
void instanceInitfaustlpf(faustlpf* dsp, int sample_rate) {
    instanceConstantsfaustlpf(dsp, sample_rate);
    instanceResetUserInterfacefaustlpf(dsp);
    instanceClearfaustlpf(dsp);
}

void initfaustlpf(faustlpf* dsp, int sample_rate) {
    classInitfaustlpf(sample_rate);
    instanceInitfaustlpf(dsp, sample_rate);
}

void buildUserInterfacefaustlpf(faustlpf* dsp, UIGlue* ui_interface) {
    ui_interface->openVerticalBox(ui_interface->uiInterface, "FaustLPF");
    ui_interface->declare(ui_interface->uiInterface, &dsp->fHslider0, "1", "");
    ui_interface->declare(ui_interface->uiInterface, &dsp->fHslider0, "scale", "log");
    ui_interface->declare(ui_interface->uiInterface, &dsp->fHslider0, "style", "knob");
    ui_interface->declare(ui_interface->uiInterface, &dsp->fHslider0, "symbol", "cutoff");
    ui_interface->declare(ui_interface->uiInterface, &dsp->fHslider0, "tooltip", "Low-pass filter cutoff frequency");
    ui_interface->declare(ui_interface->uiInterface, &dsp->fHslider0, "unit", "Hz");
    ui_interface->addHorizontalSlider(ui_interface->uiInterface, "Cutoff", &dsp->fHslider0, (FAUSTFLOAT)1.5e+04f, (FAUSTFLOAT)16.0f, (FAUSTFLOAT)1.5e+04f, (FAUSTFLOAT)0.1f);
    ui_interface->closeBox(ui_interface->uiInterface);
}

void computefaustlpf(faustlpf* dsp, int count, FAUSTFLOAT** RESTRICT inputs, FAUSTFLOAT** RESTRICT outputs) {
    FAUSTFLOAT* input0_ptr = inputs[0];
    FAUSTFLOAT* output0_ptr = outputs[0];
    float fSlow0 = dsp->fConst1 * fmaxf(16.0f, fminf(1.5e+04f, (float)(dsp->fHslider0)));
    float fRec1_tmp[36];
    float* fRec1 = &fRec1_tmp[4];
    float fZec0[32];
    float fZec1[32];
    float fZec2[32];
    float fRec0_tmp[36];
    float* fRec0 = &fRec0_tmp[4];
    int vindex = 0;
    /* Main loop */
    for (vindex = 0; vindex <= (count - 32); vindex = vindex + 32) {
        FAUSTFLOAT* input0 = &input0_ptr[vindex];
        FAUSTFLOAT* output0 = &output0_ptr[vindex];
        int vsize = 32;
        /* Recursive loop 0 */
        /* Pre code */
        /* C99 loop */
        {
            int j0;
            for (j0 = 0; j0 < 4; j0 = j0 + 1) {
                fRec1_tmp[j0] = dsp->fRec1_perm[j0];
            }
        }
        /* Compute code */
        /* C99 loop */
        {
            int i;
            for (i = 0; i < vsize; i = i + 1) {
                fRec1[i] = fSlow0 + dsp->fConst2 * fRec1[i - 1];
            }
        }
        /* Post code */
        /* C99 loop */
        {
            int j1;
            for (j1 = 0; j1 < 4; j1 = j1 + 1) {
                dsp->fRec1_perm[j1] = fRec1_tmp[vsize + j1];
            }
        }
        /* Vectorizable loop 1 */
        /* Compute code */
        /* C99 loop */
        {
            int i;
            for (i = 0; i < vsize; i = i + 1) {
                fZec0[i] = fast_tanf(dsp->fConst3 * fRec1[i]);
            }
        }
        /* Vectorizable loop 2 */
        /* Compute code */
        /* C99 loop */
        {
            int i;
            for (i = 0; i < vsize; i = i + 1) {
                fZec1[i] = 1.0f / fZec0[i];
            }
        }
        /* Vectorizable loop 3 */
        /* Compute code */
        /* C99 loop */
        {
            int i;
            for (i = 0; i < vsize; i = i + 1) {
                fZec2[i] = (fZec1[i] + 1.4142135f) / fZec0[i] + 1.0f;
            }
        }
        /* Recursive loop 4 */
        /* Pre code */
        /* C99 loop */
        {
            int j2;
            for (j2 = 0; j2 < 4; j2 = j2 + 1) {
                fRec0_tmp[j2] = dsp->fRec0_perm[j2];
            }
        }
        /* Compute code */
        /* C99 loop */
        {
            int i;
            for (i = 0; i < vsize; i = i + 1) {
                fRec0[i] = (float)(input0[i]) - (fRec0[i - 2] * ((fZec1[i] + -1.4142135f) / fZec0[i] + 1.0f) + 2.0f * fRec0[i - 1] * (1.0f - 1.0f / faustlpf_faustpower2_f(fZec0[i]))) / fZec2[i];
            }
        }
        /* Post code */
        /* C99 loop */
        {
            int j3;
            for (j3 = 0; j3 < 4; j3 = j3 + 1) {
                dsp->fRec0_perm[j3] = fRec0_tmp[vsize + j3];
            }
        }
        /* Vectorizable loop 5 */
        /* Compute code */
        /* C99 loop */
        {
            int i;
            for (i = 0; i < vsize; i = i + 1) {
                output0[i] = (FAUSTFLOAT)((fRec0[i - 2] + fRec0[i] + 2.0f * fRec0[i - 1]) / fZec2[i]);
            }
        }
    }
    /* Remaining frames */
    if (vindex < count) {
        FAUSTFLOAT* input0 = &input0_ptr[vindex];
        FAUSTFLOAT* output0 = &output0_ptr[vindex];
        int vsize = count - vindex;
        /* Recursive loop 0 */
        /* Pre code */
        /* C99 loop */
        {
            int j0;
            for (j0 = 0; j0 < 4; j0 = j0 + 1) {
                fRec1_tmp[j0] = dsp->fRec1_perm[j0];
            }
        }
        /* Compute code */
        /* C99 loop */
        {
            int i;
            for (i = 0; i < vsize; i = i + 1) {
                fRec1[i] = fSlow0 + dsp->fConst2 * fRec1[i - 1];
            }
        }
        /* Post code */
        /* C99 loop */
        {
            int j1;
            for (j1 = 0; j1 < 4; j1 = j1 + 1) {
                dsp->fRec1_perm[j1] = fRec1_tmp[vsize + j1];
            }
        }
        /* Vectorizable loop 1 */
        /* Compute code */
        /* C99 loop */
        {
            int i;
            for (i = 0; i < vsize; i = i + 1) {
                fZec0[i] = fast_tanf(dsp->fConst3 * fRec1[i]);
            }
        }
        /* Vectorizable loop 2 */
        /* Compute code */
        /* C99 loop */
        {
            int i;
            for (i = 0; i < vsize; i = i + 1) {
                fZec1[i] = 1.0f / fZec0[i];
            }
        }
        /* Vectorizable loop 3 */
        /* Compute code */
        /* C99 loop */
        {
            int i;
            for (i = 0; i < vsize; i = i + 1) {
                fZec2[i] = (fZec1[i] + 1.4142135f) / fZec0[i] + 1.0f;
            }
        }
        /* Recursive loop 4 */
        /* Pre code */
        /* C99 loop */
        {
            int j2;
            for (j2 = 0; j2 < 4; j2 = j2 + 1) {
                fRec0_tmp[j2] = dsp->fRec0_perm[j2];
            }
        }
        /* Compute code */
        /* C99 loop */
        {
            int i;
            for (i = 0; i < vsize; i = i + 1) {
                fRec0[i] = (float)(input0[i]) - (fRec0[i - 2] * ((fZec1[i] + -1.4142135f) / fZec0[i] + 1.0f) + 2.0f * fRec0[i - 1] * (1.0f - 1.0f / faustlpf_faustpower2_f(fZec0[i]))) / fZec2[i];
            }
        }
        /* Post code */
        /* C99 loop */
        {
            int j3;
            for (j3 = 0; j3 < 4; j3 = j3 + 1) {
                dsp->fRec0_perm[j3] = fRec0_tmp[vsize + j3];
            }
        }
        /* Vectorizable loop 5 */
        /* Compute code */
        /* C99 loop */
        {
            int i;
            for (i = 0; i < vsize; i = i + 1) {
                output0[i] = (FAUSTFLOAT)((fRec0[i - 2] + fRec0[i] + 2.0f * fRec0[i - 1]) / fZec2[i]);
            }
        }
    }
}

#ifdef __cplusplus
}
#endif
// END CLASS CODE


#if defined(__GNUC__)
#   pragma GCC diagnostic pop
#endif

//------------------------------------------------------------------------------
// End the Faust code section

