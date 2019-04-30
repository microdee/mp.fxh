#if !defined(math_barycentric_fxh)
#define math_barycentric_fxh 1

/*
	blend 3 values based on their barycentric weight:
        input[3]: actual values
        uv: the barycentric coords
*/
#define BcBlend(verts, uv) (uv.x * verts[0] + uv.y * verts[1] + uv.z * verts[2])

/*
    Find barycentric coordinates in a triangle from a point
        p: point
        a, b, c: triangle vertices
*/
float3 BcFind(float3 p, float3 a, float3 b, float3 c)
{
    float3 v0 = b - a;
    float3 v1 = c - a;
    float3 v2 = p - a;
    float d00 = dot(v0, v0);
    float d01 = dot(v0, v1);
    float d11 = dot(v1, v1);
    float d20 = dot(v2, v0);
    float d21 = dot(v2, v1);
    float invDenom = 1.0 / (d00 * d11 - d01 * d01);
    float3 res;
    res.y = (d11 * d20 - d01 * d21) * invDenom;
    res.z = (d00 * d21 - d01 * d20) * invDenom;
    res.x = 1.0f - res.y - res.z;
    return res;
}

/*
    Find barycentric coordinates in a triangle from a point
        p: point
        tri: triangle vertices in a matrix
*/
float3 BcFind(float3 p, float3x3 tri)
{
    return BcFind(p, tri[0], tri[1], tri[2]);
}

/*
    define input argument triangle for BcFind
*/
#if !defined(BCFIND_TRI_ARG)
#define BCFIND_TRI_ARG float3 tri[3]
#endif

/*
    Define a getter for BcFind
*/
#if !defined(BCFIND_TRI_GETV)
#define BCFIND_TRI_GETV(I) tri[I]
#endif

/*
    Find barycentric coordinates in a triangle from a point
        p: point
        BCFIND_TRI_ARG: define arbitrary triangle container
            default is float3[3]
*/
float3 BcFind(float3 p, BCFIND_TRI_ARG)
{
    return BcFind(p, BCFIND_TRI_GETV(0), BCFIND_TRI_GETV(1), BCFIND_TRI_GETV(2));
}

#endif