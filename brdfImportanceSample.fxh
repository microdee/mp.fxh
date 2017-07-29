#if !defined(BRDFIMPORTANCESAMPLE_FXH)
#define BRDFIMPORTANCESAMPLE_FXH

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

#include <packs/mp.fxh/PoissonDisc.fxh>
#include <packs/mp.fxh/PanoTools.fxh>
#include <packs/mp.fxh/brdf.fxh>
#include <packs/mp.fxh/noise.fxh>
#include <packs/mp.fxh/quaternion.fxh>

#if !defined(PI)
	#define PI 3.14159265358979
#endif

#if !defined(IMPORTANTSAMPLES) /// Type int
	#define IMPORTANTSAMPLES 8
#endif
#if !defined(DIFFUSESAMPLES) /// Type int
	#define DIFFUSESAMPLES 8
#endif

float3 DisneyImportanceSample(
	float3 V, float3 N, float3 X, float3 Y,
	Texture2DArray envtex,
	SamplerState ss,
	float slice,
	float diffrough,
	float maxmiplevel BRDF_ARGSDEF) {

	float metallic = BRDF_PARAM_Disney_metallic;
	float roughness = BRDF_PARAM_Disney_roughness;
	float anisotropic = BRDF_PARAM_Disney_anisotropic;

	float3 rdir = reflect(V, N);
	//float4 reflspace = axes2q(X, Y, N);
	//float4 invreflspace = qinvert(reflspace);
	float3 col = 0;

	//float sampcount = DIFFUSESAMPLES;
	for(float i=0; i<DIFFUSESAMPLES; i++)
	{
		float tt = (i/DIFFUSESAMPLES) * PI * 2;
		float rn = 0.05 + dnoise(0, tt);
		float3 discray = PoissonDiscDir(rdir, tt, diffrough);

		/*discray.x -= rdir.x;
		discray = mul(float4(discray, 0), qrot(invreflspace)).xyz;
		discray.x *= 1 + anisotropic * 4;
		discray = mul(float4(discray, 0), qrot(reflspace)).xyz;
		discray.x += rdir.x;*/

		float lod = lerp(0, maxmiplevel, pow(diffrough, 0.25));
		float3 ccol = envtex.SampleLevel(ss, float3(DirToUV(discray), slice), lod).rgb;
		col += (Disney.brdf(discray, V, N, X, Y BRDF_ARGSPASS) * ccol) / DIFFUSESAMPLES;
	}
	for(float i=0; i<IMPORTANTSAMPLES; i++)
	{
		float tt = (i/IMPORTANTSAMPLES) * PI * 2;
		float rn = 0.5 + dnoise(0, tt);
		float3 discray = PoissonDiscDir(rdir, tt, roughness);

		/*discray.x -= rdir.x;
		discray = mul(float4(discray, 0), qrot(invreflspace)).xyz;
		discray.x *= 1 + anisotropic * 4;
		discray = mul(float4(discray, 0), qrot(reflspace)).xyz;
		discray.x += rdir.x;*/

		float lod = lerp(0, maxmiplevel, pow(roughness, 0.25));
		float3 ccol = envtex.SampleLevel(ss, float3(DirToUV(discray), slice), lod).rgb;
		col += (Disney.brdf(discray, V, N, X, Y BRDF_ARGSPASS) * ccol) / IMPORTANTSAMPLES;
	}
	return col/2;
}
#endif