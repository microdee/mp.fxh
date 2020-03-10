#if !defined(texture_reshade_fx_fxh)
#define texture_reshade_fx_fxh 1

// syntax conversion

#define ctex2D(t, uv) t.Sample(ReShade_sL, (uv))
#define ctex2Dlod(t, uv) t.SampleLevel(ReShade_sL, (uv).xy, (uv).w)
#define stex2D(s, t, uv) t.Sample(s, (uv))
#define stex2Dlod(s, t, uv) t.SampleLevel(s, (uv).xy, (uv).w)

#define RESHADE_DEPTH_INPUT_IS_UPSIDE_DOWN 0

#if !defined(RESHADE_DEPTH_INPUT_IS_REVERSED) /// -type int -pin "-visibility onlyinspector"
	#define RESHADE_DEPTH_INPUT_IS_REVERSED 0
#endif
#if !defined(RESHADE_DEPTH_INPUT_IS_LOGARITHMIC) /// -type int -pin "-visibility onlyinspector"
	#define RESHADE_DEPTH_INPUT_IS_LOGARITHMIC 0
#endif 
#if !defined(DEFAULT_SAMPLER_ADDRESS) /// -type token -pin "-visibility onlyinspector"
	#define DEFAULT_SAMPLER_ADDRESS CLAMP
#endif 
#if !defined(DEFAULT_SAMPLER_FILTER) /// -type token -pin "-visibility onlyinspector"
	#define DEFAULT_SAMPLER_FILTER MIN_MAG_MIP_LINEAR
#endif 

#define RESHADE_DEPTH_LINEARIZATION_FAR_PLANE ReShade_GetLinearFarPlane()
#define __RENDERER__ 0x0B000

#define BUFFER_WIDTH ReShade_ScreenSize.x
#define BUFFER_RCP_WIDTH (1/ReShade_ScreenSize.x)
#define BUFFER_HEIGHT ReShade_ScreenSize.y
#define BUFFER_RCP_HEIGHT (1/ReShade_ScreenSize.y)
#define ReShade_AspectRatio (BUFFER_WIDTH*BUFFER_RCP_HEIGHT)
#define ReShade_PixelSize float2(BUFFER_RCP_WIDTH, BUFFER_RCP_HEIGHT)


cbuffer glob : register(b3)
{
    float2 ReShade_ScreenSize : TARGETSIZE;
    float4x4 ReShade_tPI : PROJECTIONINVERSE;
}


// Global textures and samplers
//Texture2D ReShade_Initial : INITIAL;
#if defined(IS_IN_TFX)
    Texture2D ReShade_BackBuffer : PREVIOUS;
#else
    Texture2D ReShade_BackBuffer;
#endif

Texture2D<float> ReShade_DepthBuffer;

#define ReShade_BackBufferTex ReShade_BackBuffer
    
SamplerState ReShade_sL <string uiname="Sampler";>
{
    Filter = DEFAULT_SAMPLER_FILTER;
    AddressU = DEFAULT_SAMPLER_ADDRESS;
    AddressV = DEFAULT_SAMPLER_ADDRESS;
    MipLODBias = 0;
};

// Helper functions

float ReShade_GetLinearFarPlane()
{
    float2 farplanew = mul(float4(0, 0, 1, 1), ReShade_tPI).zw;
    return farplanew.x / farplanew.y;
}

float ReShade_GetLinearizedDepth(float2 texcoord, out float farplaneout)
{
    float depth = ReShade_DepthBuffer.SampleLevel(ReShade_sL, texcoord, 0);

#if RESHADE_DEPTH_INPUT_IS_LOGARITHMIC
	const float C = 0.01;
	depth = (exp(depth * log(C + 1.0)) - 1.0) / C;
#endif
#if RESHADE_DEPTH_INPUT_IS_REVERSED
	depth = 1.0 - depth;
#endif
	const float N = 1.0;
    float2 farplanew = mul(float4(0, 0, 1, 1), ReShade_tPI).zw;
    float farplane = farplanew.x / farplanew.y;
	farplane *= 1;
    depth /= farplane - depth * (farplane - N);
    farplaneout = farplane;

	return depth;
}
float ReShade_GetLinearizedDepth(float2 texcoord)
{
    float dummy;
    return ReShade_GetLinearizedDepth(texcoord, dummy);
}

struct ReShade_VSOut {
    float4 position : SV_Position;
    float2 texcoord : TEXCOORD;
};

// Vertex shader generating a triangle covering the entire screen
ReShade_VSOut PostProcessVS(uint id : SV_VertexID)
{
    ReShade_VSOut o = (ReShade_VSOut)0;
	o.texcoord.x = (id == 2) ? 2.0 : 0.0;
	o.texcoord.y = (id == 1) ? 2.0 : 0.0;
	o.position = float4(o.texcoord * float2(2.0, -2.0) + float2(-1.0, 1.0), 0.0, 1.0);
    return o;
}

#endif