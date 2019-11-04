#if !defined(mdp_structs_fxh)
#define mdp_structs_fxh

// See defines in there
#include <packs/mp.fxh/mdp/defines.fxh>

// Set output type of VS depending on Tessellation turned on
#if defined(TESSELLATE)
#define VSOUTPUTTYPE MDP_HDSIN
#elif defined(MDP_GEOMFX)
#define VSOUTPUTTYPE MDP_GEOMFX_GSIN
#else
#define VSOUTPUTTYPE MDP_PSIN
#endif

#if defined(MDP_GEOMFX)
#define GSOUTPUTTYPE MDP_GEOMFX_GSIN
#else
#define GSOUTPUTTYPE MDP_PSIN
#endif

// VS Input
struct MDP_VSIN
{
    float3 Pos : POSITION;
    float3 Norm : NORMAL;

	#if defined(HAS_TEXCOORD0) /// -type switch
    float2 UV : MDP_MAINUVLAYER;
	#endif
  
    /*
        Define MDP_EXTRAUVS for extra texcoords (TEXCOORD1..N)
    */
    #if defined(MDP_EXTRAUVS)
    MDP_EXTRAUVS
    #endif

    #if defined(HAS_TANGENT) /// -type switch -pin "-visibility hidden"
    float4 Tan : TANGENT;
    float4 Bin : BINORMAL;
    #endif

    /*
        Geometry has previous position per-vertex
    */
    #if defined(HAS_PREVPOS) /// -type switch -pin "-visibility hidden"
    float3 ppos : PREVPOS;
    #endif
    
    /*
        Geometry has Subset ID indicator on vertices
    */
    #if defined(HAS_SUBSETID) /// -type switch -pin "-visibility OnlyInspector"
    float ssid : SUBSETID;
    #endif
    
    /*
        Geometry has Material ID indicator on vertices
    */
    #if defined(HAS_MATERIALID) /// -type switch -pin "-visibility OnlyInspector"
    float mid : MATERIALID;
    #endif
    
    /*
        Geometry has Instance ID indicator on vertices
    */
    #if defined(HAS_INSTANCEID) && !defined(USE_SVINSTANCEID) /// -type switch -pin "-visibility OnlyInspector"
    float iid : INSTANCEID;
    #endif
    
    /*
        Instance ID should be read from system values
    */
	#if defined(USE_SVINSTANCEID)
    uint iid : SV_InstanceID;
	#endif

    /*
        Define MDP_VSIN_EXTRA for anything more
    */
    #if defined(MDP_VSIN_EXTRA)
    MDP_VSIN_EXTRA
    #endif
};

// PS Input
struct MDP_PSIN
{
    float4 svpos : SV_Position;
	float4 pspos : POSPROJ;
    float3 posw : POSWORLD;
    float3 posv : POSVIEW;
    
    float3 Norm : NORMAL;
    float2 UV : TEXCOORD0;

    #if defined(MDP_EXTRAUVS)
    MDP_EXTRAUVS
    #endif

    float3 Tan : TANGENT;
    float3 Bin : BINORMAL;
    float4 ppos : PREVPOS;

    float sid : SUBSETID;
    float mid : MATID;
    float iid : INSTID;

    #if defined(MDP_PSIN_EXTRA)
    MDP_PSIN_EXTRA
    #endif
};

// GS Input in GeomFX mode
struct MDP_GEOMFX_GSIN
{
	float3 Pos : POSITION;

    float3 Norm : NORMAL;
    float2 UV : TEXCOORD0;

    float3 Tan : TANGENT;
    float3 Bin : BINORMAL;
    float3 ppos : PREVPOS;

    float sid : SUBSETID;
    float mid : MATID;
    float iid : INSTID;
};

#define MDP_GEOMFX_STREAMOUT "POSITION.xyz;NORMAL.xyz;TEXCOORD0.xy;TANGENT.xyz;BINORMAL.xyz;PREVPOS.xyz;SUBSETID.x;MATID.x;INSTID.x"

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