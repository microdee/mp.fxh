#if !defined(MINMAX_FXH)
#define MINMAX_FXH

float vmax(float2 v) {
	return max(v.x, v.y);
}
float vmax(float3 v) {
	return max(max(v.x, v.y), v.z);
}
float vmax(float4 v) {
	return max(max(v.x, v.y), max(v.z, v.w));
}
float vmin(float2 v) {
	return min(v.x, v.y);
}
float vmin(float3 v) {
	return min(min(v.x, v.y), v.z);
}
float vmin(float4 v) {
	return min(min(v.x, v.y), min(v.z, v.w));
}
#endif