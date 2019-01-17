#if !defined(df_df_raymarch_fxh)
#define df_df_raymarch_fxh

#include <packs/mp.fxh/df/df.fxh>

struct defMarchResult
{
	DF_RETURNTYPE dfdat;
	float3 p;
	float iter;
	uint hit;
};

#if !defined(DF_MARCH_RETURNTYPE)
#define DF_MARCH_RETURNTYPE defMarchResult
#define DF_MARCH_RESINIT (DF_MARCH_RETURNTYPE)0
#define DF_MARCH_SETPOS(V, P) V.p = (P)
#define DF_MARCH_SETDFDAT(V, D) V.dfdat = (D)
#define DF_MARCH_SETHIT(V, H) V.hit = (H)
#define DF_MARCH_SETITER(V, I) V.iter = (I)
#endif

#if !defined(DF_MARCH_MAXITER) /// -type int -pin "-name RaymarchMaxIteration -visibility OnlyInspector"
#define DF_MARCH_MAXITER 128
#endif
#if !defined(DF_MARCH_EPSILON) /// -type float -pin "-name RaymarchEpsilon -visibility OnlyInspector"
#define DF_MARCH_EPSILON 0.002
#endif

DF_MARCH_RETURNTYPE dfMarch(float3 ro, float3 rd, float maxdist, iDF idf DF_ARGS_DEF)
{
	DF_MARCH_RETURNTYPE o = DF_MARCH_RESINIT;
	float td = 0;
	for(uint i = 0; i<DF_MARCH_MAXITER; i++)
	{
		float3 cpos = ro + td*rd;
		DF_RETURNTYPE dfres = idf.df(cpos DF_ARGS_PASS);
		float dd = (dfres)DF_GETDISTANCE;
		td += dd;
		if(td > maxdist)
		{
			DF_MARCH_SETHIT(o, 0);
			DF_MARCH_SETITER(o, i);
			DF_MARCH_SETDFDAT(o, dfres);
			DF_MARCH_SETPOS(o, cpos);
			break;
		}
		if(dd < DF_MARCH_EPSILON)
		{
			DF_MARCH_SETHIT(o, 1);
			DF_MARCH_SETITER(o, i);
			DF_MARCH_SETDFDAT(o, dfres);
			DF_MARCH_SETPOS(o, cpos);
			break;
		}
	}
	return o;
}

#endif