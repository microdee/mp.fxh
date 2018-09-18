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

#endif