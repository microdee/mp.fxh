#if !defined(df_df_fxh)
#define df_df_fxh

/* interface for distance function
implement this interface in a class where you actually do your distance field
so you can use these utilities.

Also behold this hacky generalization
if you have additional arguments for your distance function other than the
position, you have to define them with DFARGSDEF and DFARGSPASS before
including df/df.fxh like this:

#define DFARGSDEF ,float param
#define DFARGSPASS ,param

note the comma ',' is important before definition body so it compiles without
extra arguments too.

if you have custom return type other than float you can also define that in
similar fashion to the arguments but you also have to define an appendix which
will select the distance component from your return type. example:

#define DFRETURNTYPE float4
#define DFGETDISTANCE .y

obviously your implementing class should also reflect the same declaration.
example:

#define DFARGSDEF ,float param
#define DFARGSPASS ,param
#define DFRETURNTYPE float4
#define DFGETDISTANCE .y
#include <packs/mp.fxh/df/df.fxh>

class cDF : iDF
{
    DFRETURNTYPE df(float3 p DFARGSDEF)
    {
        // my scene goes here
        return float4(...);
    }
};

cDF map;
*/

#if !defined(DFARGSDEF)
#define DFARGSDEF
#define DFARGSPASS
#endif

#if !defined(DFRETURNTYPE)
#define DFRETURNTYPE float
#define DFGETDISTANCE
#endif

interface iDF
{
	DFRETURNTYPE df(float3 p DFARGSDEF);
};

// calculate normals
float3 DFNormals(float3 p, float width, iDF idf DFARGSDEF)
{
	float3 grad;
	grad.x = idf.df(p + float3( width, 0, 0) DFARGSPASS)DFGETDISTANCE -
	         idf.df(p + float3(-width, 0, 0) DFARGSPASS)DFGETDISTANCE;
	grad.y = idf.df(p + float3( 0, width, 0) DFARGSPASS)DFGETDISTANCE -
	         idf.df(p + float3( 0,-width, 0) DFARGSPASS)DFGETDISTANCE;
	grad.z = idf.df(p + float3( 0, 0, width) DFARGSPASS)DFGETDISTANCE -
	         idf.df(p + float3( 0, 0,-width) DFARGSPASS)DFGETDISTANCE;
	return normalize(grad);
};

float DFAO(float3 p, float3 norm, float stepsize, float strength, iDF idf DFARGSDEF) {
    float stp = stepsize;
    float ao = 0.0;
    float dist;
    for (int i = 1; i <= 3; i++) {
        dist = stp * (float)i;
		ao += max(0.0, (dist - idf.df(p + norm * dist DFARGSPASS)DFGETDISTANCE) / dist);
    }
    return saturate(1-ao*strength);
}

float NaiveEdge( float3 p, float3 norm, float ew, float nw, iDF idf DFARGSDEF)
{
	float3 nx = DFNormals(p + float3(ew, 0, 0), nw, idf DFARGSPASS);
	float3 ny = DFNormals(p + float3(0, ew, 0), nw, idf DFARGSPASS);
	float3 nz = DFNormals(p + float3(0, 0, ew), nw, idf DFARGSPASS);
	float e = -(dot(nx, norm)-1)-(dot(ny, norm)-1)-(dot(nz, norm)-1);
	return saturate(abs(e));
}
#endif