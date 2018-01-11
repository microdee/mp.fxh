#if !defined(math_pows_fxh)
#define math_pows_fxh 1
float pows(float a, float b) {return pow(abs(a),b)*sign(a);}
float2 pows(float a, float2 b) {return pow(abs(a),b)*sign(a);}
float3 pows(float a, float3 b) {return pow(abs(a),b)*sign(a);}
float4 pows(float a, float4 b) {return pow(abs(a),b)*sign(a);}

float2 pows(float2 a, float b) {return pow(abs(a),b)*sign(a);}
float2 pows(float2 a, float2 b) {return pow(abs(a),b)*sign(a);}

float3 pows(float3 a, float b) {return pow(abs(a),b)*sign(a);}
float3 pows(float3 a, float3 b) {return pow(abs(a),b)*sign(a);}

float4 pows(float4 a, float b) {return pow(abs(a),b)*sign(a);}
float4 pows(float4 a, float4 b) {return pow(abs(a),b)*sign(a);}
#endif