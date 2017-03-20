#define SQUARE_FXH

float sqr(float x)
{
    return x * x;
}
float2 sqr(float2 x)
{
    return x * x;
}
float3 sqr(float3 x)
{
    return x * x;
}
float4 sqr(float4 x)
{
    return x * x;
}
float square (float x) {
	return x*x;
}
float2 square (float2 x) {
	return x*x;
}
float3 square (float3 x) {
	return x*x;
}
float4 square (float4 x) {
	return x*x;
}

float lengthSqr(float2 x) {
	return dot(x, x);
}
float lengthSqr(float3 x) {
	return dot(x, x);
}
float lengthSqr(float4 x) {
	return dot(x, x);
}
