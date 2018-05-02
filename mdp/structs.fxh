#if !defined(mdp_structs_fxh)
#define mdp_structs_fxh

#include <packs/mp.fxh/mdp/defines.fxh>

#if defined(TESSELLATE)
#define VSOUTPUTTYPE MDP_HDSIN
#else
#define VSOUTPUTTYPE MDP_PSIN
#endif

struct MDP_VSIN
{
    float3 Pos : POSITION;
    float3 Norm : NORMAL;

	#if defined(HAS_TEXCOORD0) /// -type switch -pin "-visibility hidden"
    float2 UV : MDP_MAINUVLAYER;
	#endif

    #if defined(MDP_EXTRAUVS)
    MDP_EXTRAUVS
    #endif

    #if defined(HAS_TANGENT) /// -type switch -pin "-visibility hidden"
    float4 Tan : TANGENT;
    float4 Bin : BINORMAL;
    #endif

    #if defined(HAS_PREVPOS) /// -type switch -pin "-visibility hidden"
    float3 ppos : PREVPOS;
    #endif

    #if defined(HAS_SUBSETID) /// -type switch -pin "-visibility hidden"
    uint ssid : SUBSETID;
    #endif
    #if defined(HAS_MATERIALID) /// -type switch -pin "-visibility hidden"
    uint mid : MATERIALID;
    #endif
    #if defined(HAS_INSTANCEID) && !defined(USE_SVINSTANCEID) /// -type switch -pin "-visibility hidden"
    uint iid : INSTANCEID;
    #endif
	#if defined(USE_SVINSTANCEID)
    uint iid : SV_InstanceID;
	#endif

    #if defined(MDP_VSIN_EXTRA)
    MDP_VSIN_EXTRA
    #endif
};

struct MDP_PSIN
{
    float4 svpos : SV_Position;
	float4 pspos : POSPROJ;
    float3 posw : POSWORLD;

    float3 Norm : NORMAL;
    float2 UV : TEXCOORD0;

    #if defined(MDP_EXTRAUVS)
    MDP_EXTRAUVS
    #endif

    float3 Tan : TANGENT;
    float3 Bin : BINORMAL;
    float4 ppos : PREVPOS;

    nointerpolation float sid : SUBSETID;
    nointerpolation float mid : MATID;
    nointerpolation float iid : INSTID;

    #if defined(MDP_PSIN_EXTRA)
    MDP_PSIN_EXTRA
    #endif
};

SamplerState sT <string uiname="Textures Sampler";>
{
    Filter = MIN_MAG_MIP_LINEAR;
    AddressU = Wrap;
    AddressV = Wrap;
};

cbuffer mdpPerDraw : register( MDP_CBPERDRAW_REGISTER )
{
	float4x4 tV : VIEW;
	float4x4 tVI : VIEWINVERSE;
    float4x4 tP : PROJECTION;
    float4x4 tVP : VIEWPROJECTION;
    float4x4 ptV : PREVIOUSVIEW;
    float4x4 ptP : PREVIOUSPROJECTION;
	float CurveAmount = 1;
	float PrevCurveAmount = 1;
	float DisplaceNormalInfluence = 1;
	float DisplaceVelocityGain = 0;
	float Factor = 5;
};
cbuffer mdpPerObj : register( MDP_CBPEROBJ_REGISTER )
{
	float4x4 tW : WORLD;
    float4x4 ptW <string uiname="Previous World";>;
    float4x4 tTex <string uiname="Texture Transform"; bool uvspace=true;>;
    float4x4 ptTex <string uiname="Previous Texture Transform";>;
    float ndepth <string uiname="Normal Depth";> = 0;
	float2 Displace = 0;
};

StructuredBuffer<float4x4> iTr <string uiname="Instance Transforms";>;
StructuredBuffer<float4x4> ipTr <string uiname="Previous Instance Transforms";>;
StructuredBuffer<float4x4> Tr <string uiname="Subset Transforms";>;
StructuredBuffer<float4x4> pTr <string uiname="Previous Subset Transforms";>;
Texture2D DispMap;

#endif