
float3 cpoint : POSITION;
#if defined(HAS_NORMAL)  /// -type switch -pin "-visibility hidden"
    float3 norm : NORMAL;
#endif
#if defined(HAS_TEXCOORD0)  /// -type switch -pin "-visibility hidden"
    float2 TexCd0: TEXCOORD0;
#endif
#if defined(HAS_TEXCOORD1)  /// -type switch -pin "-visibility hidden"
    float2 TexCd1: TEXCOORD1;
#endif
#if defined(HAS_TEXCOORD2)  /// -type switch -pin "-visibility hidden"
    float2 TexCd2: TEXCOORD2;
#endif
#if defined(HAS_TEXCOORD3)  /// -type switch -pin "-visibility hidden"
    float2 TexCd3: TEXCOORD3;
#endif
#if defined(HAS_TEXCOORD4)  /// -type switch -pin "-visibility hidden"
    float2 TexCd4: TEXCOORD4;
#endif
#if defined(HAS_TEXCOORD5)  /// -type switch -pin "-visibility hidden"
    float2 TexCd5: TEXCOORD5;
#endif
#if defined(HAS_TEXCOORD6)  /// -type switch -pin "-visibility hidden"
    float2 TexCd6: TEXCOORD6;
#endif
#if defined(HAS_TEXCOORD7)  /// -type switch -pin "-visibility hidden"
    float2 TexCd7: TEXCOORD7;
#endif
#if defined(HAS_TEXCOORD8)  /// -type switch -pin "-visibility hidden"
    float2 TexCd8: TEXCOORD8;
#endif
#if defined(HAS_TEXCOORD9)  /// -type switch -pin "-visibility hidden"
    float2 TexCd9: TEXCOORD9;
#endif
#if defined(HAS_TANGENT)  /// -type switch -pin "-visibility hidden"
    float4 Tangent : TANGENT;
    float4 Binormal : BINORMAL;
#endif
#if defined(HAS_BLENDWEIGHT)  /// -type switch -pin "-visibility hidden"
    float4 BlendId : BLENDINDICES;
    float4 BlendWeight : BLENDWEIGHT;
#endif
#if defined(HAS_PREVPOS)  /// -type switch -pin "-visibility hidden"
    float3 PrevPos : PREVPOS;
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