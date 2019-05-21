
float3 Pos : POSITION;
#if defined(HAS_NORMAL)  /// -type switch -pin "-visibility hidden"
    float3 Norm : NORMAL;
#endif
#if defined(HAS_TEXCOORD0)  /// -type switch -pin "-visibility hidden"
    float2 Uv0: TEXCOORD0;
#endif
#if defined(HAS_TEXCOORD1)  /// -type switch -pin "-visibility hidden"
    float2 Uv1: TEXCOORD1;
#endif
#if defined(HAS_TEXCOORD2)  /// -type switch -pin "-visibility hidden"
    float2 Uv2: TEXCOORD2;
#endif
#if defined(HAS_TEXCOORD3)  /// -type switch -pin "-visibility hidden"
    float2 Uv3: TEXCOORD3;
#endif
#if defined(HAS_TEXCOORD4)  /// -type switch -pin "-visibility hidden"
    float2 Uv4: TEXCOORD4;
#endif
#if defined(HAS_TEXCOORD5)  /// -type switch -pin "-visibility hidden"
    float2 Uv5: TEXCOORD5;
#endif
#if defined(HAS_TEXCOORD6)  /// -type switch -pin "-visibility hidden"
    float2 Uv6: TEXCOORD6;
#endif
#if defined(HAS_TEXCOORD7)  /// -type switch -pin "-visibility hidden"
    float2 Uv7: TEXCOORD7;
#endif
#if defined(HAS_TEXCOORD8)  /// -type switch -pin "-visibility hidden"
    float2 Uv8: TEXCOORD8;
#endif
#if defined(HAS_TEXCOORD9)  /// -type switch -pin "-visibility hidden"
    float2 Uv9: TEXCOORD9;
#endif
#if defined(HAS_TANGENT)  /// -type switch -pin "-visibility hidden"
    float4 Tan : TANGENT;
    float4 Bin : BINORMAL;
#endif
#if defined(HAS_BLENDWEIGHT)  /// -type switch -pin "-visibility hidden"
    float4 BlendId : BLENDINDICES;
    float4 BlendWeight : BLENDWEIGHT;
#endif
#if defined(HAS_PREVPOS)  /// -type switch -pin "-visibility hidden"
    float3 ppos : PREVPOS;
#endif
#if defined(HAS_SUBSETID)  /// -type switch -pin "-visibility hidden"
    float sid : SUBSETID;
#endif
#if defined(HAS_MATERIALID)  /// -type switch -pin "-visibility hidden"
    float mid : MATERIALID;
#endif
#if defined(HAS_INSTANCEID)  /// -type switch -pin "-visibility hidden"
    float iid : INSTANCEID;
#endif