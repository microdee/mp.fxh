#define COPYSIGN_FXH

float copysign(float a, float b) { return a * sign(b); }
float2 copysign(float2 a, float2 b) { return a * sign(b); }
float3 copysign(float3 a, float3 b) { return a * sign(b); }
float4 copysign(float4 a, float4 b) { return a * sign(b); }
