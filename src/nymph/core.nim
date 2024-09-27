const
    lv2CoreBaseUri* = "http://lv2plug.in/ns/lv2core"
    lv2CorePrefix = lv2CoreBaseUri & "#"

    # Classes (http://lv2plug.in/ns/lv2core#ref-classes):
    lv2CoreClassAllpassPlugin* = lv2CorePrefix & "AllpassPlugin"
    lv2CoreClassAmplifierPlugin* = lv2CorePrefix & "AmplifierPlugin"
    lv2CoreClassAnalyserPlugin* = lv2CorePrefix & "AnalyserPlugin"
    lv2CoreClassAudioPort* = lv2CorePrefix & "AudioPort"
    lv2CoreClassBandpassPlugin* = lv2CorePrefix & "BandpassPlugin"
    lv2CoreClassCVPort* = lv2CorePrefix & "CVPort"
    lv2CoreClassChorusPlugin* = lv2CorePrefix & "ChorusPlugin"
    lv2CoreClassCombPlugin* = lv2CorePrefix & "CombPlugin"
    lv2CoreClassCompressorPlugin* = lv2CorePrefix & "CompressorPlugin"
    lv2CoreClassConstantPlugin* = lv2CorePrefix & "ConstantPlugin"
    lv2CoreClassControlPort* = lv2CorePrefix & "ControlPort"
    lv2CoreClassConverterPlugin* = lv2CorePrefix & "ConverterPlugin"
    lv2CoreClassDelayPlugin* = lv2CorePrefix & "DelayPlugin"
    lv2CoreClassDistortionPlugin* = lv2CorePrefix & "DistortionPlugin"
    lv2CoreClassDynamicsPlugin* = lv2CorePrefix & "DynamicsPlugin"
    lv2CoreClassEQPlugin* = lv2CorePrefix & "EQPlugin"
    lv2CoreClassEnvelopePlugin* = lv2CorePrefix & "EnvelopePlugin"
    lv2CoreClassExpanderPlugin* = lv2CorePrefix & "ExpanderPlugin"
    lv2CoreClassExtensionData* = lv2CorePrefix & "ExtensionData"
    lv2CoreClassFeature* = lv2CorePrefix & "Feature"
    lv2CoreClassFilterPlugin* = lv2CorePrefix & "FilterPlugin"
    lv2CoreClassFlangerPlugin* = lv2CorePrefix & "FlangerPlugin"
    lv2CoreClassFunctionPlugin* = lv2CorePrefix & "FunctionPlugin"
    lv2CoreClassGatePlugin* = lv2CorePrefix & "GatePlugin"
    lv2CoreClassGeneratorPlugin* = lv2CorePrefix & "GeneratorPlugin"
    lv2CoreClassHighpassPlugin* = lv2CorePrefix & "HighpassPlugin"
    lv2CoreClassInputPort* = lv2CorePrefix & "InputPort"
    lv2CoreClassInstrumentPlugin* = lv2CorePrefix & "InstrumentPlugin"
    lv2CoreClassLimiterPlugin* = lv2CorePrefix & "LimiterPlugin"
    lv2CoreClassLowpassPlugin* = lv2CorePrefix & "LowpassPlugin"
    lv2CoreClassMixerPlugin* = lv2CorePrefix & "MixerPlugin"
    lv2CoreClassModulatorPlugin* = lv2CorePrefix & "ModulatorPlugin"
    lv2CoreClassMultiEQPlugin* = lv2CorePrefix & "MultiEQPlugin"
    lv2CoreClassOscillatorPlugin* = lv2CorePrefix & "OscillatorPlugin"
    lv2CoreClassOutputPort* = lv2CorePrefix & "OutputPort"
    lv2CoreClassParaEQPlugin* = lv2CorePrefix & "ParaEQPlugin"
    lv2CoreClassPhaserPlugin* = lv2CorePrefix & "PhaserPlugin"
    lv2CoreClassPitchPlugin* = lv2CorePrefix & "PitchPlugin"
    lv2CoreClassPlugin* = lv2CorePrefix & "Plugin"
    lv2CoreClassPluginBase* = lv2CorePrefix & "PluginBase"
    lv2CoreClassPoint* = lv2CorePrefix & "Point"
    lv2CoreClassPort* = lv2CorePrefix & "Port"
    lv2CoreClassPortProperty* = lv2CorePrefix & "Port"
    lv2CoreClassResource* = lv2CorePrefix & "Resource"
    lv2CoreClassReverbPlugin* = lv2CorePrefix & "ReverbPlugin"
    lv2CoreClassScalePoint* = lv2CorePrefix & "ScalePoint"
    lv2CoreClassSimulatorPlugin* = lv2CorePrefix & "SimulatorPlugin"
    lv2CoreClassSpatialPlugin* = lv2CorePrefix & "SpatialPlugin"
    lv2CoreClassSpecification* = lv2CorePrefix & "Specification"
    lv2CoreClassSpectralPlugin* = lv2CorePrefix & "SpectralPlugin"
    lv2CoreClassUtilityPlugin* = lv2CorePrefix & "UtilityPlugin"
    lv2CoreClassWaveshaperPlugin* = lv2CorePrefix & "WaveshaperPlugin"

    # Properties (http://lv2plug.in/ns/lv2core#ref-properties):
    lv2CorePropertyAppliesTo* = lv2CorePrefix & "appliesTo"
    lv2CorePropertyBinary* = lv2CorePrefix & "binary"
    lv2CorePropertyDefault* = lv2CorePrefix & "default"
    lv2CorePropertyDesignation* = lv2CorePrefix & "designation"
    lv2CorePropertyDocumentation* = lv2CorePrefix & "documentation"
    lv2CorePropertyExtensionData* = lv2CorePrefix & "extensionData"
    lv2CorePropertyIndex* = lv2CorePrefix & "index"
    lv2CorePropertyLatency* = lv2CorePrefix & "latency"
    lv2CorePropertyMaximum* = lv2CorePrefix & "maximum"
    lv2CorePropertyMicroVersion* = lv2CorePrefix & "microVersion"
    lv2CorePropertyMinimum* = lv2CorePrefix & "minimum"
    lv2CorePropertyMinorVersion* = lv2CorePrefix & "minorVersion"
    lv2CorePropertyName* = lv2CorePrefix & "name"
    lv2CorePropertyOptionalFeature* = lv2CorePrefix & "optionalFeature"
    lv2CorePropertyPort* = lv2CorePrefix & "port"
    lv2CorePropertyPortProperty* = lv2CorePrefix & "portProperty"
    lv2CorePropertyProject* = lv2CorePrefix & "project"
    lv2CorePropertyPrototype* = lv2CorePrefix & "prototype"
    lv2CorePropertyReportsLatency* = lv2CorePrefix & "reportsLatency"
    lv2CorePropertyRequiredFeature* = lv2CorePrefix & "requiredFeature"
    lv2CorePropertyScalePoint* = lv2CorePrefix & "scalePoint"
    lv2CorePropertySymbol* = lv2CorePrefix & "symbol"

    # Instances (http://lv2plug.in/ns/lv2core#ref-instances)
    lv2CoreInstanceConnectionOptional* = lv2CorePrefix & "connectionOptional"
    lv2CoreInstanceControl* = lv2CorePrefix & "control"
    lv2CoreInstanceEnumeration* = lv2CorePrefix & "enumeration"
    lv2CoreInstanceFreeWheeling* = lv2CorePrefix & "freeWheeling"
    lv2CoreInstanceHardRTCapable* = lv2CorePrefix & "hardRTCapable"
    lv2CoreInstanceInPlaceBroken* = lv2CorePrefix & "inPlaceBroken"
    lv2CoreInstanceInteger* = lv2CorePrefix & "integer"
    lv2CoreInstanceIsLive* = lv2CorePrefix & "isLive"
    lv2CoreInstanceSampleRate* = lv2CorePrefix & "sampleRate"
    lv2CoreInstanceToggled* = lv2CorePrefix & "toggled"

type Lv2Handle* = pointer

type Lv2Feature* = object
    uri*: cstring
    data*: pointer

type Lv2Descriptor* = object
    uri*: cstring

    instantiate*: proc(descriptor: ptr Lv2Descriptor, sampleRate: cdouble, bundlePath: cstring,
                       features: ptr UncheckedArray[ptr Lv2Feature]): Lv2Handle {.cdecl.}

    connectPort*: proc(instance: Lv2Handle, port: cuint, dataLocation: pointer) {.cdecl.}

    activate*: proc(instance: Lv2Handle) {.cdecl.}

    run*: proc(instance: Lv2Handle, sampleCount: cuint) {.cdecl.}

    deactivate*: proc(instance: Lv2Handle) {.cdecl.}

    cleanup*: proc(instance: Lv2Handle) {.cdecl.}

    extensionData*: proc(uri: cstring): pointer {.cdecl.}

type lv2Descriptor* = proc(index: cuint): ptr Lv2Descriptor {.cdecl.}

