
#if !defined(TEXCOORDCOUNT) /// -type int
#define TEXCOORDCOUNT 0
#endif

#if TEXCOORDCOUNT > 0
#define TEXCOORD0_IN 1
#define HAS_TEXCOORD0 1
#endif
#if TEXCOORDCOUNT > 1
#define TEXCOORD1_IN 1
#define HAS_TEXCOORD1 1
#endif
#if TEXCOORDCOUNT > 2
#define TEXCOORD2_IN 1
#define HAS_TEXCOORD2 1
#endif
#if TEXCOORDCOUNT > 3
#define TEXCOORD3_IN 1
#define HAS_TEXCOORD3 1
#endif
#if TEXCOORDCOUNT > 4
#define TEXCOORD4_IN 1
#define HAS_TEXCOORD4 1
#endif
#if TEXCOORDCOUNT > 5
#define TEXCOORD5_IN 1
#define HAS_TEXCOORD5 1
#endif
#if TEXCOORDCOUNT > 6
#define TEXCOORD6_IN 1
#define HAS_TEXCOORD6 1
#endif
#if TEXCOORDCOUNT > 7
#define TEXCOORD7_IN 1
#define HAS_TEXCOORD7 1
#endif
#if TEXCOORDCOUNT > 8
#define TEXCOORD8_IN 1
#define HAS_TEXCOORD8 1
#endif
#if TEXCOORDCOUNT > 9
#define TEXCOORD9_IN 1
#define HAS_TEXCOORD9 1
#endif

struct VSin
{
	float3 cpoint : POSITION;
	#if defined(NORMAL_IN) /// -type switch -pin "-visibility hidden"
		float3 norm : NORMAL;
	#endif
	#if defined(TEXCOORD0_IN) /// -type switch -pin "-visibility hidden"
		float2 TexCd0: TEXCOORD0;
	#endif
	#if defined(TEXCOORD1_IN) /// -type switch -pin "-visibility hidden"
		float2 TexCd1: TEXCOORD1;
	#endif
	#if defined(TEXCOORD2_IN) /// -type switch -pin "-visibility hidden"
		float2 TexCd2: TEXCOORD2;
	#endif
	#if defined(TEXCOORD3_IN) /// -type switch -pin "-visibility hidden"
		float2 TexCd3: TEXCOORD3;
	#endif
	#if defined(TEXCOORD4_IN) /// -type switch -pin "-visibility hidden"
		float2 TexCd4: TEXCOORD4;
	#endif
	#if defined(TEXCOORD5_IN) /// -type switch -pin "-visibility hidden"
		float2 TexCd5: TEXCOORD5;
	#endif
	#if defined(TEXCOORD6_IN) /// -type switch -pin "-visibility hidden"
		float2 TexCd6: TEXCOORD6;
	#endif
	#if defined(TEXCOORD7_IN) /// -type switch -pin "-visibility hidden"
		float2 TexCd7: TEXCOORD7;
	#endif
	#if defined(TEXCOORD8_IN) /// -type switch -pin "-visibility hidden"
		float2 TexCd8: TEXCOORD8;
	#endif
	#if defined(TEXCOORD9_IN) /// -type switch -pin "-visibility hidden"
		float2 TexCd9: TEXCOORD9;
	#endif
	#if defined(TANGENT_IN) /// -type switch -pin "-visibility hidden"
		float3 Tangent : TANGENT;
		float3 Binormal : BINORMAL;
	#endif
	#if defined(BLENDWEIGHT_IN) /// -type switch -pin "-visibility hidden"
		float4 BlendId : BLENDINDICES;
		float4 BlendWeight : BLENDWEIGHT;
	#endif
	#if defined(SUBSETID_IN) /// -type switch -pin "-visibility hidden"
		float sid : SUBSETID;
	#endif
	#if defined(MATERIALID_IN) /// -type switch -pin "-visibility hidden"
		float mid : MATERIALID;
	#endif
	#if defined(REAL_INSTANCEID) /// -type switch -pin "-visibility hidden"
		uint iid : SV_InstanceID;
	#endif
	#if defined(INSTANCEID_IN) /// -type switch -pin "-visibility hidden"
		float iid : INSTANCEID;
	#endif
	uint vid : SV_VertexID;

    #if defined(MDL_VSIN_EXTRA)
    MDL_VSIN_EXTRA
    #endif
};

struct GSin
{
	float3 cpoint : POSITION;
	#if defined(HAS_NORMAL)
		float3 norm : NORMAL;
	#endif
	#if defined(HAS_TEXCOORD0)
		float2 TexCd0: TEXCOORD0;
	#endif
	#if defined(HAS_TEXCOORD1)
		float2 TexCd1: TEXCOORD1;
	#endif
	#if defined(HAS_TEXCOORD2)
		float2 TexCd2: TEXCOORD2;
	#endif
	#if defined(HAS_TEXCOORD3)
		float2 TexCd3: TEXCOORD3;
	#endif
	#if defined(HAS_TEXCOORD4)
		float2 TexCd4: TEXCOORD4;
	#endif
	#if defined(HAS_TEXCOORD5)
		float2 TexCd5: TEXCOORD5;
	#endif
	#if defined(HAS_TEXCOORD6)
		float2 TexCd6: TEXCOORD6;
	#endif
	#if defined(HAS_TEXCOORD7)
		float2 TexCd7: TEXCOORD7;
	#endif
	#if defined(HAS_TEXCOORD8)
		float2 TexCd8: TEXCOORD8;
	#endif
	#if defined(HAS_TEXCOORD9)
		float2 TexCd9: TEXCOORD9;
	#endif
	#if defined(HAS_TANGENT)
		float3 Tangent : TANGENT;
		float3 Binormal : BINORMAL;
	#endif
	#if defined(HAS_BLENDWEIGHT)
		float4 BlendId : BLENDINDICES;
		float4 BlendWeight : BLENDWEIGHT;
	#endif
	#if defined(HAS_SUBSETID)
		float sid : SUBSETID;
	#endif
	#if defined(HAS_MATERIALID)
		float mid : MATERIALID;
	#endif
	#if defined(HAS_INSTANCEID)
		float iid : INSTANCEID;
	#endif

    #if defined(MDL_VSIN_EXTRA)
    MDL_GSIN_EXTRA
    #endif
};