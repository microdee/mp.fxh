#if !defined(df_df_fxh)
#define df_df_fxh

/* interface for distance function
implement this interface in a class where you actually do your distance field
so you can use these utilities.

Also behold this hacky generalization
if you have additional arguments for your distance function other than the
position, you have to define them with DF_ARGS_DEF and DF_ARGS_PASS before
including df/df.fxh like this:

#define DF_ARGS_DEF ,float param
#define DF_ARGS_PASS ,param

note the comma ',' is important before definition body so it compiles without
extra arguments too.

if you have custom return type other than float you can also define that in
similar fashion to the arguments but you also have to define an appendix which
will select the distance component from your return type. example:

#define DF_RETURNTYPE float4
#define DF_GETDISTANCE .y

obviously your implementing class should also reflect the same declaration.
example:

#define DF_ARGS_DEF ,float param
#define DF_ARGS_PASS ,param
#define DF_RETURNTYPE float4
#define DF_GETDISTANCE .y
#include <packs/mp.fxh/df/df.fxh>

class cDF : iDF
{
    DF_RETURNTYPE df(float3 p DF_ARGS_DEF)
    {
        // my scene goes here
        return float4(...);
    }
};

cDF map;
*/

#if !defined(DF_ARGS_DEF)
#define DF_ARGS_DEF
#define DF_ARGS_PASS
#endif

#if !defined(DF_RETURNTYPE)
#define DF_RETURNTYPE float
#define DF_GETDISTANCE
#endif

interface iDF
{
	DF_RETURNTYPE df(float3 p DF_ARGS_DEF);
};

// calculate normals
float3 dfNormals(float3 p, float width, iDF idf DF_ARGS_DEF)
{
	float3 grad;
	grad.x = idf.df(p + float3( width, 0, 0) DF_ARGS_PASS)DF_GETDISTANCE -
	         idf.df(p + float3(-width, 0, 0) DF_ARGS_PASS)DF_GETDISTANCE;
	grad.y = idf.df(p + float3( 0, width, 0) DF_ARGS_PASS)DF_GETDISTANCE -
	         idf.df(p + float3( 0,-width, 0) DF_ARGS_PASS)DF_GETDISTANCE;
	grad.z = idf.df(p + float3( 0, 0, width) DF_ARGS_PASS)DF_GETDISTANCE -
	         idf.df(p + float3( 0, 0,-width) DF_ARGS_PASS)DF_GETDISTANCE;
	return normalize(grad);
};

float dfAO(float3 p, float3 norm, float stepsize, float strength, iDF idf DF_ARGS_DEF) {
    float stp = stepsize;
    float ao = 0.0;
    float dist;
    for (int i = 1; i <= 3; i++) {
        dist = stp * (float)i;
		ao += max(0.0, (dist - idf.df(p + norm * dist DF_ARGS_PASS)DF_GETDISTANCE) / dist);
    }
    return saturate(1-ao*strength);
}

float dfNaiveEdge( float3 p, float3 norm, float ew, float nw, iDF idf DF_ARGS_DEF)
{
	float3 nx = dfNormals(p + float3(ew, 0, 0), nw, idf DF_ARGS_PASS);
	float3 ny = dfNormals(p + float3(0, ew, 0), nw, idf DF_ARGS_PASS);
	float3 nz = dfNormals(p + float3(0, 0, ew), nw, idf DF_ARGS_PASS);
	float e = -(dot(nx, norm)-1)-(dot(ny, norm)-1)-(dot(nz, norm)-1);
	return saturate(abs(e));
}
#endif