#if !defined(particles_wobbles_fxh)
#define particles_wobbles_fxh

#include <packs/mp.fxh/math/plasmanoise.fxh>
#include <packs/mp.fxh/math/noise.fxh>
#include <packs/mp.fxh/math/quaternion.fxh>

#define ROTWOBBLE(r, a) normalize(aa2q(normalize(r), a))

void plasmaWobbleRot(
    float3 pos, float rotAmount, float4x4 fieldTr, float saturation,
    out float3 result, out float4 rotOut)
{
    result = plasmaNoise(pos, fieldTr, saturation);
    rotOut = ROTWOBBLE(result, rotAmount);
}

float3 voronoiseWobble(float3 pos, float4x4 fieldTr, float voronoi, float smoothness)
{
    return voronoise3(mul(float4(pos, 1), fieldTr).xyz, voronoi, smoothness);
}

void voronoiseWobbleRot(
    float3 pos, float rotAmount, float4x4 fieldTr, float voronoi, float smoothness,
    out float3 result, out float4 rotOut)
{
    result = voronoiseWobble(pos, fieldTr, voronoi, smoothness);
    rotOut = ROTWOBBLE(result, rotAmount);
}

#endif