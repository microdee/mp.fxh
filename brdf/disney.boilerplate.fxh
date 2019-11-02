#if !defined(brdf_disney_boilerplate_fxh)
#define brdf_disney_boilerplate_fxh 1

struct MatData /// input struct
{
	float4 AlbedoAlpha;
	float4 Emit;
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

	#if defined(MATDATA_EXT)
	MATDATA_EXT
	#endif
};

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
#define BRDF_PARAM_Disney_Emit mat.Emit

#include <packs/mp.fxh/brdf/brdf.fxh>
//#include <packs/mp.fxh/brdf/anisotropicEnvSample.fxh>
#include <packs/mp.fxh/math/quaternion.fxh>

float3 DisneyPoint(float3 lp, float3 pos, float3 vdir, float3 norm, float3 tangent, float3 binorm, float attenstart, float attenend, MatData mat)
{
	float3 ld = lp-pos;
	float d = length(ld);
	ld = normalize(ld);
	float3 light = 0;
	if(d < attenend)
	{
		float attend = attenend - attenstart;
		light = Disney.brdf(ld, vdir, norm, tangent, binorm, mat) * smoothstep(1, 0, saturate(d/attend-attenstart/attend));
	}
	return light;
}

#endif