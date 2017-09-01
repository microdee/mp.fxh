#if !defined(PNTRIANGLEUTILS_FXH)
#define PNTRIANGLEUTILS_FXH

#include <packs/mp.fxh/mdpipeline-defs.fxh>
#include <packs/mp.fxh/DisplaceNormal.fxh>

struct MDP_HSCONST
{
    float fTessFactor[3]    : SV_TessFactor ;
    float fInsideTessFactor : SV_InsideTessFactor ;
    float3 f3B210    : POSITION3 ;
    float3 f3B120    : POSITION4 ;
    float3 f3B021    : POSITION5 ;
    float3 f3B012    : POSITION6 ;
    float3 f3B102    : POSITION7 ;
    float3 f3B201    : POSITION8 ;
    float3 f3B111    : CENTER ;
    float3 f3N110    : NORMAL3 ;
    float3 f3N011    : NORMAL4 ;
    float3 f3N101    : NORMAL5 ;
};

struct MDP_HDSIN
{
    float4 Pos : POSITION;
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

    #if defined(MDP_HDSIN_EXTRA)
    MDP_HDSIN_EXTRA
    #endif
};

float3 InterpolateDir(
    MDP_HSCONST HSConstantData,
    float3 in0, float3 in1, float3 in2,
    float3 fUVW2, float3 fUVW, float curve)
{

    float3 f3 = in0 * fUVW.z +
        in1 * fUVW.x +
        in2 * fUVW.y +
        HSConstantData.f3N110 * fUVW2.z * fUVW2.x +
        HSConstantData.f3N011 * fUVW2.x * fUVW2.y +
        HSConstantData.f3N101 * fUVW2.z * fUVW2.y;
    float3 o = in0 * fUVW.z +
        in1 * fUVW.x +
        in2 * fUVW.y;
    f3 = lerp(o,f3,curve);
    return normalize(f3);
}

float3 InterpolatePos(
    MDP_HSCONST HSConstantData,
    float3 in0, float3 in1, float3 in2,
    float3 fUVW2, float3 fUVW, float curve,
    out float3 f3, out float3 o)
{
    float fUU3 = fUVW2.x * 3.0f;
    float fVV3 = fUVW2.y * 3.0f;
    float fWW3 = fUVW2.z * 3.0f;

    f3 = in0 * fUVW2.z * fUVW.z +
        in1 * fUVW2.x * fUVW.x +
        in2 * fUVW2.y * fUVW.y +
        HSConstantData.f3B210 * fWW3 * fUVW.x +
        HSConstantData.f3B120 * fUVW.z * fUU3 +
        HSConstantData.f3B201 * fWW3 * fUVW.y +
        HSConstantData.f3B021 * fUU3 * fUVW.y +
        HSConstantData.f3B102 * fUVW.z * fVV3 +
        HSConstantData.f3B012 * fUVW.x * fVV3 +
        HSConstantData.f3B111 * 6.0f * fUVW.z * fUVW.x * fUVW.y ;
    o = in0 * fUVW.z +
        in1 * fUVW.x +
        in2 * fUVW.y ;
    return lerp(o,f3,curve);
}

MDP_HSCONST MDP_HSC( InputPatch<MDP_HDSIN, 3> I )
{
    MDP_HSCONST O = (MDP_HSCONST)0;
    O.fTessFactor[0] = Factor;
	O.fTessFactor[1] = Factor;
    O.fTessFactor[2] = Factor;
    O.fInsideTessFactor = ( O.fTessFactor[0] + O.fTessFactor[1] + O.fTessFactor[2] ) / 3.0f;  
		
    float3 f3B003 = I[0].Pos;
    float3 f3B030 = I[1].Pos;
    float3 f3B300 = I[2].Pos;
    // And Normals
    float3 f3N002 = I[0].Norm;
    float3 f3N020 = I[1].Norm;
    float3 f3N200 = I[2].Norm;

	O.f3B210 = ( ( 2.0f * f3B003 ) + f3B030 - ( dot( ( f3B030 - f3B003 ), f3N002 ) * f3N002 ) ) / 3.0f;
	O.f3B120 = ( ( 2.0f * f3B030 ) + f3B003 - ( dot( ( f3B003 - f3B030 ), f3N020 ) * f3N020 ) ) / 3.0f;
    O.f3B021 = ( ( 2.0f * f3B030 ) + f3B300 - ( dot( ( f3B300 - f3B030 ), f3N020 ) * f3N020 ) ) / 3.0f;
    O.f3B012 = ( ( 2.0f * f3B300 ) + f3B030 - ( dot( ( f3B030 - f3B300 ), f3N200 ) * f3N200 ) ) / 3.0f;
    O.f3B102 = ( ( 2.0f * f3B300 ) + f3B003 - ( dot( ( f3B003 - f3B300 ), f3N200 ) * f3N200 ) ) / 3.0f;
    O.f3B201 = ( ( 2.0f * f3B003 ) + f3B300 - ( dot( ( f3B300 - f3B003 ), f3N002 ) * f3N002 ) ) / 3.0f;

    float3 f3E = ( O.f3B210 + O.f3B120 + O.f3B021 + O.f3B012 + O.f3B102 + O.f3B201 ) / 6.0f;
    float3 f3V = ( f3B003 + f3B030 + f3B300 ) / 3.0f;
    O.f3B111 = f3E + ( ( f3E - f3V ) / 2.0f );
    
    float fV12 = 2.0f * dot( f3B030 - f3B003, f3N002 + f3N020 ) / dot( f3B030 - f3B003, f3B030 - f3B003 );
    O.f3N110 = normalize( f3N002 + f3N020 - fV12 * ( f3B030 - f3B003 ) );
    float fV23 = 2.0f * dot( f3B300 - f3B030, f3N020 + f3N200 ) / dot( f3B300 - f3B030, f3B300 - f3B030 );
    O.f3N011 = normalize( f3N020 + f3N200 - fV23 * ( f3B300 - f3B030 ) );
    float fV31 = 2.0f * dot( f3B003 - f3B300, f3N200 + f3N002 ) / dot( f3B003 - f3B300, f3B003 - f3B300 );
    O.f3N101 = normalize( f3N200 + f3N002 - fV31 * ( f3B003 - f3B300 ) );
    return O;
}

[domain("tri")]
[partitioning("fractional_even")]
[outputtopology("triangle_cw")]
[patchconstantfunc(MDP_HSC_STRING)]
[outputcontrolpoints(3)]
MDP_HDSIN MDP_HS( InputPatch<MDP_HDSIN, 3> I, uint uCPID : SV_OutputControlPointID )
{
    MDP_HDSIN O = I[uCPID];
    return O;
}

[domain("tri")]
MDP_PSIN DS( MDP_HSCONST HSConstantData, const OutputPatch<MDP_HDSIN, 3> I, float3 f3BarycentricCoords : SV_DomainLocation )
{
	MDP_PSIN output;
    output.sid = I[0].sid;
	output.mid = I[0].mid;
	output.iid = I[0].iid;
	
    float3 fUVW = f3BarycentricCoords;
    float3 fUVW2 = fUVW * fUVW;
	
    float3 f3Normal = InterpolateDir(
        HSConstantData,
        I[0].Norm, I[1].Norm, I[2].Norm,
        fUVW2, fUVW, CurveAmount
        );
	
	float2 f3UV = I[0].UV * fUVW.z + I[1].UV * fUVW.x + I[2].UV * fUVW.y;
	output.UV = f3UV;
	
    float3 cPos, fPos;
	
	float3 f3Position = InterpolatePos(
        HSConstantData,
        I[0].Pos.xyz, I[1].Pos.xyz, I[2].Pos.xyz,
        fUVW2, fUVW, CurveAmount,
        cPos, fPos
    );
    float3 pcPos, pfPos;
    float3 pf3Position = InterpolatePos(
        HSConstantData,
        I[0].ppos.xyz, I[1].ppos.xyz, I[2].ppos.xyz,
        fUVW2, fUVW, PrevCurveAmount,
    	pcPos, pfPos
    );
	float2 disp = 0;
	if(Displace.x > 0.0001)
		disp = DispMap.SampleLevel(sT, output.UV, 0).rg;
	float3 posi = f3Position + disp.r * f3Normal * Displace.x;
	float3 posflat = fPos + disp.r * f3Normal * Displace.x;
    output.posw = posi;
	output.svpos = mul(float4(posi,1), tVP);
	output.pspos = mul(float4(posflat,1), tVP);

    float3 f3Tangent = InterpolateDir(
        HSConstantData,
        I[0].Tan, I[1].Tan, I[2].Tan,
        fUVW2, fUVW, CurveAmount
    );

    float3 f3Binormal = InterpolateDir(
        HSConstantData,
        I[0].Bin, I[1].Bin, I[2].Bin,
        fUVW2, fUVW, CurveAmount
    );
	
	TangentSpace nt = (TangentSpace)0;
	nt.n = f3Normal;
	nt.t = f3Tangent;
	nt.b = f3Binormal;
	if(Displace.x > 0.0001)
		nt = SampleDisplaceNormalTangents(nt, DispMap, sT, output.UV, 0.01, Displace.x * DisplaceNormalInfluence, 0);
	
	output.Norm = normalize(mul(float4(nt.n,0), tV).xyz);
    output.Tan = normalize(mul(float4(nt.t,0), tV).xyz);
    output.Bin = normalize(mul(float4(nt.b,0), tV).xyz);

	float pdisp = disp.g + (disp.r - disp.g) * DisplaceVelocityGain;
    float3 pp = pfPos + pdisp * f3Normal * Displace.y;

	output.ppos = mul(float4(pp,1), ptV);
	output.ppos = mul(output.ppos, ptP);

	return output;
}

#endif