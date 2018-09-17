
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