
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
#if defined(PREVPOS_IN) /// -type switch -pin "-visibility hidden"
    float3 ppos : PREVPOS;
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