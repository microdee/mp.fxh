#if !defined(df_df_disney_boilerplate_fxh)
#define df_df_disney_boilerplate_fxh

struct MatData
{
	float4 AlbedoAlpha;
	float Rough;
	float Metal;
	float Anisotropic;
	float Rotate;
	float SSS;
	float Specular;
	float SpecTint;
	float Sheen;
	float SheenTint;
	float Clearcoat;
	float CCGloss;
};
struct dfResult
{
    MatData mat;
    float d;
};
struct marchResult
{
    dfResult dfdat;
	float3 p;
	float iter;
	uint hit;
};

struct PointLight
{
    float3 Position;
    float AttenuationStart;
    float3 Color;
    float AttenuationEnd;
};

struct VSin
{
    float4 pos : POSITION;
};
struct PSin
{
    float4 svpos : SV_Position;
    float4 pos : POS;
};

struct LitResult
{
    float4 Lit;
    float4 VelUV;
    float d;
};

/*
    Motion blur coefficient
*/
#define DF_ARGS_DEF ,float mbcoeff
#define DF_ARGS_PASS ,mbcoeff

/*
    Return type and distance getter
*/
#define DF_RETURNTYPE dfResult
#define DF_GETDISTANCE .d

#define DF_MARCH_RETURNTYPE marchResult
#define DF_MARCH_RESINIT (DF_MARCH_RETURNTYPE)0
#define DF_MARCH_SETPOS(V, P) V.p = (P)
#define DF_MARCH_SETDFDAT(V, D) V.dfdat = (D)
#define DF_MARCH_SETHIT(V, H) V.hit = (H)
#define DF_MARCH_SETITER(V, I) V.iter = (I)

#include <packs/mp.fxh/df/df.raymarch.fxh>

#define BRDF_ARGSDEF , MatData mat
#define BRDF_ARGSPASS , mat

#define BRDF_PARAM_Disney_baseColor mat.AlbedoAlpha.rgb
#define BRDF_PARAM_Disney_metallic mat.Metal
#define BRDF_PARAM_Disney_subsurface mat.SSS
#define BRDF_PARAM_Disney_specular mat.Specular
#define BRDF_PARAM_Disney_roughness mat.Rough
#define BRDF_PARAM_Disney_specularTint mat.SpecTint
#define BRDF_PARAM_Disney_anisotropic mat.Anisotropic
#define BRDF_PARAM_Disney_sheen mat.Sheen
#define BRDF_PARAM_Disney_sheenTint mat.SheenTint
#define BRDF_PARAM_Disney_clearcoat mat.Clearcoat
#define BRDF_PARAM_Disney_clearcoatGloss mat.CCGloss

#include <packs/mp.fxh/brdf/brdf.fxh>
#include <packs/mp.fxh/math/quaternion.fxh>
#include <packs/mp.fxh/math/vectors.fxh>

StructuredBuffer<PointLight> PointLights : POINTLIGHTS;
float PointCount : POINTLIGHTCOUNT;


cbuffer cbPerDraw : register( b1 )
{
    //float4 gAlbedoCol <string uiname="Albedo Color"; bool color=true;> = 1;
	//float gRough <string uiname="Default Rough";> = 0.25;
	//float gMetal <string uiname="Default Metal";> = 0;
	//float gAnisotropic <string uiname="Default Anisotropic";> = 0;
	//float ggRotate <string uiname="Default Anisotropic Rotation";> = 0;
	//float gSpecular <string uiname="Default Specular";> = 1;
	//float gSpecTint <string uiname="Default Specular Tint";> = 0;
	//float gSheen <string uiname="Default Sheen";> = 0;
	//float gSheenTint <string uiname="Default Sheen Tint";> = 0;
	//float gClearcoat <string uiname="Default Clearcoat";> = 0;
	//float gClearcoatGloss <string uiname="Default Clearcoat Gloss";> = 0;
	//float gSSS <string uiname="Default SSS";> = 0;
	//float4x4 tV : VIEW;
	//float4x4 tVI : VIEWINVERSE;
    //float4x4 tP : PROJECTION;
    float4x4 tVP : VIEWPROJECTION;
    float4x4 tVPI : VIEWPROJECTIONINVERSE;
    float4x4 ptV : PREVIOUSVIEW;
    float4x4 ptP : PREVIOUSPROJECTION;
    float3 campos : CAMERAPOSITION;
	float3 SunDir = float3(1,1,0);
	float4 SunColor <bool color=true;> = 1;
	float VelAm <string uiname="Velocity Amount";> = 1;
}

MatData MatDataDefault()
{
    MatData res = (MatData)0;
    res.AlbedoAlpha = 1;
    res.Rough = 0.3;
    res.Metal = 0;
    res.Anisotropic = 0;
    res.Rotate = 0;
    res.SSS = 0;
    res.Specular = 1;
    res.SpecTint = 0;
    res.Sheen = 0;
    res.SheenTint = 0;
    res.Clearcoat = 0;
    res.CCGloss = 0;
    return res;
}

MatData BlendMat(MatData a, MatData b, float t)
{
    MatData res = (MatData)0;
    res.AlbedoAlpha = lerp(a.AlbedoAlpha, b.AlbedoAlpha, t);
    res.Rough = lerp(a.Rough, b.Rough, t);
    res.Metal = lerp(a.Metal, b.Metal, t);
    res.Anisotropic = lerp(a.Anisotropic, b.Anisotropic, t);
    res.Rotate = lerp(a.Rotate, b.Rotate, t);
    res.SSS = lerp(a.SSS, b.SSS, t);
    res.Specular = lerp(a.Specular, b.Specular, t);
    res.SpecTint = lerp(a.SpecTint, b.SpecTint, t);
    res.Sheen = lerp(a.Sheen, b.Sheen, t);
    res.SheenTint = lerp(a.SheenTint, b.SheenTint, t);
    res.Clearcoat = lerp(a.Clearcoat, b.Clearcoat, t);
    res.CCGloss = lerp(a.CCGloss, b.CCGloss, t);
    return res;
}

MatData BlendMatViaDistances(float cd, float ad, float bd, MatData am, MatData bm)
{
    float cad = abs(cd-ad);
    float cbd = abs(cd-bd);
    if(cad < DF_MARCH_EPSILON)
        return am;
    if(cbd < DF_MARCH_EPSILON)
        return bm;
    cad = cad/(cad+cbd);
    return BlendMat(am, bm, smoothstep(0,1,cad));
}

PSin VSThru(VSin i)
{
    PSin o = (PSin)0;
    o.svpos = i.pos * float4(2, 2, 1, 1);
    o.svpos.zw = float2(0, 1);
    o.pos = o.svpos;
    return o;
}

LitResult RaymarchDisney(PSin i, float maxdist, iDF idf DF_ARGS_DEF)
{
    float4 ro = mul(i.pos, tVPI);
    ro /= ro.w;
    float4 re = mul(i.pos + float4(0, 0, 1, 0), tVPI);
    re /= re.w;
    float3 rd = normalize(re.xyz - ro.xyz);
    marchResult mres = dfMarch(ro.xyz, rd, maxdist, idf DF_ARGS_PASS);
    float3 norm = dfNormals(mres.p, 0.01, idf DF_ARGS_PASS);

    float ndotu = dot(norm, float3(0,1,0));
    float3 uv = smoothstep(float3(0,1,0), float3(1,0,0), saturate((ndotu-0.9) * 10));

    float3x3 tanspace = GuessTangentSpace(norm, normalize(uv));

	tanspace = mul(tanspace, qrot(aa2q(norm, mres.dfdat.mat.Rotate*2)));
	//float3 rbin = normalize(mul(float4(tanspace[1], 0), qrot(aa2q(input.Norm, rot*2))).xyz);

	float3 outcol = 0;
    float3 vdir = normalize(campos - mres.p);

	if(SunColor.a > 0.0001)
	{
		float3 light = Disney.brdf(normalize(SunDir), vdir, tanspace[2], tanspace[0], tanspace[1], mres.dfdat.mat);
		outcol += light * SunColor.rgb * SunColor.a;
	}

	//if(dot(norm, float3(0,0,1)) > 0) norm = -norm;
	for(float i=0; i<PointCount; i++)
	{
		PointLight pl = PointLights[i];
		float3 ld = pl.Position - mres.p;
		float d = length(ld);
		ld = normalize(ld);
		
		if(d < pl.AttenuationEnd)
		{
			float3 light = Disney.brdf(ld, vdir, tanspace[2], tanspace[0], tanspace[1], mres.dfdat.mat);
			//light *= pow(saturate(dot(wnorm, ld)*2), 2);
			float attend = pl.AttenuationEnd - pl.AttenuationStart;
			outcol += light * pl.Color * smoothstep(1, 0, saturate(d/attend-pl.AttenuationStart/attend));
		}
	}

    outcol *= dfAO(mres.p, norm, 0.1, 0.4, idf DF_ARGS_PASS);

    float4 opos = mul(float4(mres.p, 1), tVP);
    float4 ppos = mul(float4(mres.p, 1), mul(ptV, ptP));
    opos /= opos.w;
    ppos /= ppos.w;

    LitResult o = (LitResult)0;
    o.Lit = float4(outcol, 1);
    o.VelUV = float4((opos.xy - ppos.xy)*0.5*VelAm + 0.5, 1, 1);
    o.d = opos.z;
    return o;
}

#endif