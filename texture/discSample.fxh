#if !defined(texture_discSample_fxh)
#define texture_discSample_fxh 1

#include <packs/mp.fxh/math/poissonDisc.fxh>
#include <packs/mp.fxh/texture/panorama.fxh>

#include <packs/mp.fxh/math/const.fxh>

#if !defined(DISCSAMPLES) /// -type int
	#define DISCSAMPLES 16
#endif

float4 DiscSample(
		Texture2DArray envtex,
		SamplerState ss,
		float3 dir,
		float blur,
		float slice,
		float maxmiplevel)
{
	float4 col = envtex.SampleLevel(ss, float3(DirToUV(dir), slice), 0);
	if(blur < 0.0001)
		return col;
	else
	{
		col = 0;
		float sampcount = DISCSAMPLES;
		for(float i=0; i<DISCSAMPLES; i++)
		{
			float tt = (i/sampcount) * PI * 2;
			float3 discray = PoissonDiscDir(dir, tt, blur);
			float lod = lerp(0, maxmiplevel, pow(blur, 0.25));
			col += envtex.SampleLevel(ss, float3(DirToUV(discray), slice), lod) / sampcount;
		}
		return col;
	}
}

float4 DiscSample(
		Texture2D envtex,
		SamplerState ss,
		float3 dir,
		float blur,
		float maxmiplevel)
{
	float4 col = envtex.SampleLevel(ss, DirToUV(dir), 0);
	if(blur < 0.0001)
		return col;
	else
	{
		col = 0;
		float sampcount = DISCSAMPLES;
		for(float i=0; i<DISCSAMPLES; i++)
		{
			float tt = (i/sampcount) * PI * 2;
			float3 discray = PoissonDiscDir(dir, tt, blur);
			float lod = lerp(0, maxmiplevel, pow(blur, 0.25));
			col += envtex.SampleLevel(ss, DirToUV(discray), lod) / sampcount;
		}
		return col;
	}
}

float4 DiscSample(
		Texture2DArray envtex,
		SamplerState ss,
		float3 dir,
		float blur,
		float slice)
{
	float4 col = envtex.SampleLevel(ss, float3(DirToUV(dir), slice), 0);
	if(blur < 0.0001)
		return col;
	else
	{
		col = 0;
		float sampcount = DISCSAMPLES;
		for(float i=0; i<DISCSAMPLES; i++)
		{
			float tt = (i/sampcount) * PI * 2;
			float3 discray = PoissonDiscDir(dir, tt, blur);
			col += envtex.SampleLevel(ss, float3(DirToUV(discray), slice), 0) / sampcount;
		}
		return col;
	}
}
#endif