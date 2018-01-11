#if !defined(texture_anisotropicEnvSample_fxh)
#define texture_anisotropicEnvSample_fxh

#include <packs/mp.fxh/texture/panorama.fxh>
#include <packs/mp.fxh/math/minmax.fxh>
#include <packs/mp.fxh/math/noise.fxh>

#if !defined(AESAMPLES_W) /// -type int
#define AESAMPLES_W 10
#define AESAMPLES_H 10
#endif

//#define FIXSHALLOWEYE 1

float4 AnisotropicSample(
		Texture2D envtex,
		SamplerState ss,
		float3 dir,
		float3 tangent,
		float3 bitangent,
		float2 blur,
        float stepsmul,
		float maxmiplevel)
{
	float4 col = envtex.SampleLevel(ss, DirToUV(dir), 0);
	if(all(blur < 0.0005))
		return col;
	else
	{
		col = 0;
        blur = saturate(blur);
        float bw = min(blur.x / (blur.x+blur.y), blur.y / (blur.x+blur.y));
        float2 steps = pow(blur, lerp(0.25, 1, bw)) * float2(AESAMPLES_W, AESAMPLES_H) * stepsmul * lerp(0.5, 1, bw);
        steps = floor(steps/2)*2+1;
        steps = max(floor(steps)+1,1);
		float sampcount = steps.x * steps.y;
        float wg = 0;
		for(float i=0; i<steps.x; i++)
		{
            for(float j=0; j<steps.y; j++)
            {
                float2 prog = float2(
                    i/steps.x-0.5,
                    j/steps.y-0.5
                );
                float2 pmul = 1-pow(abs(prog.yx*2),2);
                float2 progp = prog * pmul;
                progp *= blur;
                // might avoid potential shallow eye-vector problem
                #if defined(FIXSHALLOWEYE) /// -type switch
                    progp.x /= max(0.001, 1-abs(dot(dir, tangent)));
                    progp.y /= max(0.001, 1-abs(dot(dir, bitangent)));
                #endif

                float lodmod = vmin(blur);
    			float lod = lerp(0, maxmiplevel, pow(lodmod, 0.5));
                float3 rd = normalize(dir + tangent*progp.x + bitangent*progp.y);
                rd += dnoise3(rd.xy,rd.z) * (tangent*blur.x + bitangent*blur.y) * 0.2;
                float cw = lerp(0.5, 1, pmul.x * pmul.y);
    			col += envtex.SampleLevel(ss, DirToUV(normalize(rd)), lod) * cw;
                wg += cw;
            }
		}
		return col / wg;
	}
}
#endif