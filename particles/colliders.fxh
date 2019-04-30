#if !defined(particles_colliders_fxh)
#define particles_colliders_fxh

void CollidePlane(
    float3 pos, float3 vel, float damping, float4x4 groundTr, float4x4 invGroundTr
    out float3 outPos, out float3 outVel)
{
	float3 npos = mul(float4(pos,1),invGroundTr).xyz;
	float3 nvel = mul(float4(vel,0),invGroundTr).xyz;
    if(npos.y < 0)
    {
		nvel.y *= -damping;
		float2 uv = mul(float4(pos,1),groundTr).xy;
		//nvel.xyz += (DirTex.SampleLevel(s0, uv, 0).rgb-.5) * DirAm * saturate(nvel.y-1);
		nvel = mul(float4(nvel,0),groundTr).xyz;
		npos = mul(float4(npos.x,0,npos.z,1),groundTr).xyz;
        outPos = npos;
        outVel = nvel;
    }
    else
    {
        outPos = pos;
        outVel = vel;
    }
}

#endif