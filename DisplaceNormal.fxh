#if !defined(DISPLACENORMAL_FXH)
#define DISPLACENORMAL_FXH

float3 DisplacedNormal(float3 norm, float4 nsew, float me, float am)
{
	//find perpendicular vector to norm:        
	float3 temp = norm; //a temporary vector that is not parallel to norm
	if(norm.x==1)
		temp.y+=0.5;
	else
		temp.x+=0.5;
	
	//form a basis with norm being one of the axes:
	float3 perp1 = normalize(cross(norm,temp));
	float3 perp2 = normalize(cross(norm,perp1));
	
	//use the basis to move the normal in its own space by the offset        
	float3 normalOffset = -am*(((nsew.x-me)-(nsew.y-me))*perp1 + ((nsew.z-me)-(nsew.w-me))*perp2);
	return normalize(norm + normalOffset);
}

float3 SampleDisplaceNormal(float3 norm, Texture2D disp, sampler sS, float2 uv, float ww, float am, float LOD)
{
	float me = disp.SampleLevel(sS,uv,LOD).x-.5;
	float n = disp.SampleLevel(sS,float2(uv.x,uv.y+ww),LOD).x-.5;
	float s = disp.SampleLevel(sS,float2(uv.x,uv.y-ww),LOD).x-.5;
	float e = disp.SampleLevel(sS,float2(uv.x+ww,uv.y),LOD).x-.5;
	float w = disp.SampleLevel(sS,float2(uv.x-ww,uv.y),LOD).x-.5;
	
	return DisplacedNormal(norm, float4(n,s,e,w), me, am);
}
struct TangentSpace
{
	float3 n;
	float3 t;
	float3 b;
};

TangentSpace SampleDisplaceNormalTangents(TangentSpace normt, Texture2D disp, sampler sS, float2 uv, float ww, float am, float LOD)
{
	float me = disp.SampleLevel(sS,uv,LOD).x-.5;
	float n = disp.SampleLevel(sS,float2(uv.x,uv.y+ww),LOD).x-.5;
	float s = disp.SampleLevel(sS,float2(uv.x,uv.y-ww),LOD).x-.5;
	float e = disp.SampleLevel(sS,float2(uv.x+ww,uv.y),LOD).x-.5;
	float w = disp.SampleLevel(sS,float2(uv.x-ww,uv.y),LOD).x-.5;
	
	TangentSpace ret = (TangentSpace)0;
	ret.n = DisplacedNormal(normt.n, float4(n,s,e,w), me, am);
	ret.t = DisplacedNormal(normt.t, float4(n,s,e,w), me, am);
	ret.b = DisplacedNormal(normt.b, float4(n,s,e,w), me, am);
	return ret;
}

#endif