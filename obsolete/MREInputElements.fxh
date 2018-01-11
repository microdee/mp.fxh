
#define MREINPUTELEMENTS_FXH 1
/*
	custom defines from vvvv
	if you have a mandatory feature then do the following
	before including this file:

#if !defined(FEATURE_DIR)
#define FEATURE_DIR 1
#endif
	
	where FEATURE_DIR is one of the following:

	input has:
	TEXCOORD_IN
	TANGENTS_IN
	BLENDWEIGHTS_IN
	PREVPOS_IN
	SUBSETID_IN

	output has:
	TEXCOORD_OUT
	TANGENTS_OUT
	BLENDWEIGHTS_OUT
	PREVPOS_OUT
	SUBSETID_OUT
*/

struct VSin
{
	float3 cpoint : POSITION;
	float3 norm : NORMAL;
	#if defined(TEXCOORD_IN)
		float2 TexCd: TEXCOORD0;
	#endif
	#if defined(TANGENTS_IN)
		float3 Tangent : TANGENT;
		float3 Binormal : BINORMAL;
	#endif
	#if defined(BLENDWEIGHTS_IN)
		float4 BlendId : BLENDINDICES;
		float4 BlendWeight : BLENDWEIGHT;
	#endif
	#if defined(PREVPOS_IN)
		float3 PrevPos : PREVPOS;
	#endif
	#if defined(SUBSETID_IN)
		float SubsetID : SUBSETID;
	#endif
	uint vid : SV_VertexID;
	uint iid : SV_InstanceID;
};

struct GSin
{
	float3 cpoint : POSITION;
	float3 norm : NORMAL;
	#if defined(TEXCOORD_OUT)
		float2 TexCd: TEXCOORD0;
	#endif
	#if defined(TANGENTS_OUT)
		float3 Tangent : TANGENT;
		float3 Binormal : BINORMAL;
	#endif
	#if defined(BLENDWEIGHTS_OUT)
		float4 BlendId : BLENDINDICES;
		float4 BlendWeight : BLENDWEIGHT;
	#endif
	#if defined(PREVPOS_OUT)
		float3 PrevPos : PREVPOS;
	#endif
	#if defined(SUBSETID_OUT)
		float SubsetID : SUBSETID;
	#endif
};

// copy the below code for the StreamOut stage:
/*

GeometryShader StreamOutGS = ConstructGSWithSO( CompileShader( gs_5_0, GS() ),
	"POSITION.xyz;"
	"NORMAL.xyz"
	#if defined(TEXCOORD_OUT)
		";TEXCOORD0.xy"
	#endif
	#if defined(TANGENTS_OUT)
		";TANGENT.xyz"
		";BINORMAL.xyz"
	#endif
	#if defined(BLENDWEIGHTS_OUT)
		";BLENDINDICES.xyzw"
		";BLENDWEIGHT.xyzw"
	#endif
	#if defined(PREVPOS_OUT)
		";PREVPOS.xyz"
	#endif
	#if defined(SUBSETID_OUT)
		";SUBSETID.x"
	#endif
);
*/