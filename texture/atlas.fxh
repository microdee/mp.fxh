#if !defined(texture_atlas_fxh)
#define texture_atlas_fxh 1

#include <packs/mp.fxh/texture/manualUVAddress.fxh>

struct AtlasElement
{
	float4 UVBounds;
	float Layer;
	uint Rotated;
}

float3 AtlasUV(float4 uvbounds, float layer, uint rotated, float2 inuv, out bool empty)
{
	float2 uv = AddressUV(inuv);
	float2 inuva = AddressUV(inuv);
	empty = false;
	if(rotated > 1)
	{
		empty = true;
		return(float3(1,1,0));
	}
	if(rotated > 0)
	{
		inuva = VRotate(inuva-0.5, -0.25)+0.5;
	}
	uv.x = lerp(uvpos.x, uvpos.z, inuva.x);
	uv.y = lerp(uvpos.y, uvpos.w, inuva.y);
	return float3(uv, element.Layer);
}

float4 AtlasSample(Texture2DArray atlas, SamplerState samp, AtlasElement element, float2 uv)
{
	float3 nuv = AtlasUV(element.UVBounds, element.Layer, element.Rotated, uv);
	return atlas.Sample(samp, nuv);
}
float4 AtlasSampleLevel(Texture2DArray atlas, SamplerState samp, AtlasElement element, float2 uv, float lod)
{
	float3 nuv = AtlasUV(element.UVBounds, element.Layer, element.Rotated, uv);
	return atlas.SampleLevel(samp, nuv, lod);
}
#endif