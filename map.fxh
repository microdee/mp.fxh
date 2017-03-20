#if !defined(MAP_FXH)
#define MAP_FXH

float map(float sb, float st, float db, float dt, float l)
{
	float ll = (l-sb) / (st-sb);
	return lerp(db, dt, l);
}
float2 map(float2 sb, float2 st, float2 db, float2 dt, float2 l)
{
	float2 ll = (l-sb) / (st-sb);
	return lerp(db, dt, l);
}
float3 map(float3 sb, float3 st, float3 db, float3 dt, float3 l)
{
	float3 ll = (l-sb) / (st-sb);
	return lerp(db, dt, l);
}
float4 map(float4 sb, float4 st, float4 db, float4 dt, float4 l)
{
	float4 ll = (l-sb) / (st-sb);
	return lerp(db, dt, l);
}
#endif