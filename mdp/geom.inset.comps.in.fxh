
float3 Pos : POSITION;
#if defined(NORMAL_IN) /// -type switch -pin "-visibility OnlyInspector"
    float3 Norm : NORMAL;
#endif
#if defined(TEXCOORD0_IN) /// -type switch -pin "-visibility OnlyInspector"
    float2 Uv0: TEXCOORD0;
#endif
#if defined(TEXCOORD1_IN) /// -type switch -pin "-visibility OnlyInspector"
    float2 Uv1: TEXCOORD1;
#endif
#if defined(TEXCOORD2_IN) /// -type switch -pin "-visibility OnlyInspector"
    float2 Uv2: TEXCOORD2;
#endif
#if defined(TEXCOORD3_IN) /// -type switch -pin "-visibility OnlyInspector"
    float2 Uv3: TEXCOORD3;
#endif
#if defined(TEXCOORD4_IN) /// -type switch -pin "-visibility OnlyInspector"
    float2 Uv4: TEXCOORD4;
#endif
#if defined(TEXCOORD5_IN) /// -type switch -pin "-visibility OnlyInspector"
    float2 Uv5: TEXCOORD5;
#endif
#if defined(TEXCOORD6_IN) /// -type switch -pin "-visibility OnlyInspector"
    float2 Uv6: TEXCOORD6;
#endif
#if defined(TEXCOORD7_IN) /// -type switch -pin "-visibility OnlyInspector"
    float2 Uv7: TEXCOORD7;
#endif
#if defined(TEXCOORD8_IN) /// -type switch -pin "-visibility OnlyInspector"
    float2 Uv8: TEXCOORD8;
#endif
#if defined(TEXCOORD9_IN) /// -type switch -pin "-visibility OnlyInspector"
    float2 Uv9: TEXCOORD9;
#endif
#if defined(TANGENT_IN) /// -type switch -pin "-visibility OnlyInspector"
    float4 Tan : TANGENT;
    float4 Bin : BINORMAL;
#endif
#if defined(BLENDWEIGHT_IN) /// -type switch -pin "-visibility OnlyInspector"
    float4 BlendId : BLENDINDICES;
    float4 BlendWeight : BLENDWEIGHT;
#endif
#if defined(PREVPOS_IN) /// -type switch -pin "-visibility OnlyInspector"
    float3 ppos : PREVPOS;
#endif
#if defined(SUBSETID_IN) /// -type switch -pin "-visibility OnlyInspector"
    float sid : SUBSETID;
#endif
#if defined(MATERIALID_IN) /// -type switch -pin "-visibility OnlyInspector"
    float mid : MATERIALID;
#endif
#if defined(REAL_INSTANCEID) /// -type switch -pin "-visibility OnlyInspector"
    uint iid : SV_InstanceID;
#endif
#if defined(INSTANCEID_IN) /// -type switch -pin "-visibility OnlyInspector"
    float iid : INSTANCEID;
#endif
uint vid : SV_VertexID;