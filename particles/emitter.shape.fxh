#if !defined(particles_emitter_shape_fxh)
#define particles_emitter_shape_fxh

#include <packs/mp.fxh/math/noise.fxh>

interface iShapeVolume{
	float3 Emit(float3 p, float2 param);
};
class cSphereVolume : iShapeVolume{
	float3 Emit(float3 p, float2 param)
	{
		float3 res;
		res.x = p.x*sin(p.y*PI*2)*cos(p.z*PI*2);
		res.y = p.x*sin(p.y*PI*2)*sin(p.z*PI*2);
		res.z = p.x*cos(p.y*PI*2);
		return res;
	}
};
class cCylinderVolume : iShapeVolume{
	float3 Emit(float3 p, float2 param)
	{
		float3 res;
		res.y = saturate(p.y);
		float rad = lerp(param.x, param.y, res.y);
		res.x = sin(p.x*PI*2)*p.z*rad;
		res.z = cos(p.x*PI*2)*p.z*rad;
		res.y -= .5;
		res.y *= 2;
		return res;
	}
};
class cBoxVolume : iShapeVolume{
	float3 Emit(float3 p, float2 param)
	{
		return (p-.5)*2;
	}
};
class cTorusVolume : iShapeVolume{
	float3 Emit(float3 p, float2 param)
	{
		float3 res;
		res.x = (param.x + param.y * p.x * cos(p.z*PI*2)) * cos(p.y*PI*2);
		res.y = (param.x + param.y * p.x * cos(p.z*PI*2)) * sin(p.y*PI*2);
		res.z = param.y * p.x*sin(p.z*PI*2);
		return res;
	}
};

cSphereVolume SphereVolume;
cCylinderVolume CylinderVolume;
cBoxVolume BoxVolume;
cTorusVolume TorusVolume;

float3 EmitShapeVolume(iShapeVolume shape, float2 param, float seed)
{
    return shape.Emit(hash31(seed), param);
}

#endif