#if !defined(math_vectors_fxh)
#define math_vectors_fxh

float3x3 GuessTangentSpace(float3 n, float3 up)
{
    float3 t = normalize(cross(n, up));
    float3 b = normalize(cross(n, t));
    float3x3 res;
    res[0] = t;
    res[1] = b;
    res[2] = n;
    return res;
}

float3x3 GuessTangentSpace(float3 n)
{
    float ndotu = dot(n, float3(0,1,0));
    float3 uv = smoothstep(float3(0,1,0), float3(1,0,0), saturate((ndotu-0.9) * 10));
    return GuessTangentSpace(n, uv);
}

#define EyeDirToTangentSpace(eye, tan, bin, norm) \
    mul(eye, transpose(float3x3(-tan, bin, norm)))

#define LightDirToTangentSpace(ldir, tan, bin, norm) \
    mul(-ldir, transpose(float3x3(tan, -bin, norm)))

float2 RectToPolar(float2 cart)
{
    return float2(atan2(cart.y, cart.x), length(cart));
}
float2 PolarToRect(float2 pol)
{
    return float2(cos(pol.x)*pol.y, sin(pol.x)*pol.y);
}
float3 RectToSphere(float3 cart)
{
    float r = length(cart);
    return float3(atan2(cart.y, cart.x), acos(cart.z/r), r);
}
float3 SphereToRect(float3 sph)
{
    return float3(sph.z*cos(sph.x)*sin(sph.y), sph.z*sin(sph.x)*sin(sph.y), sph.z*cos(sph.y));
}

#endif