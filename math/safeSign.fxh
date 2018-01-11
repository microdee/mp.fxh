#if !defined(math_safeSign_fxh)
#define math_safeSign_fxh

float sgn(float x) {
	return (x<0)?-1:1;
}
float2 sgn(float2 v) {
	return float2((v.x<0)?-1:1, (v.y<0)?-1:1);
}
float3 sgn(float3 v) {
	return float3((v.x<0)?-1:1, (v.y<0)?-1:1, (v.z<0)?-1:1);
}
float4 sgn(float4 v) {
	return float4((v.x<0)?-1:1, (v.y<0)?-1:1, (v.z<0)?-1:1, (v.w<0)?-1:1);
}
#endif