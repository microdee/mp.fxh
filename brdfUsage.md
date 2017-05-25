
example with a fixed material buffer and Walter07 G term (from GGX distribution):

#define BRDF_PARAM_WalterG_alphaG matbuf[i].alphaG
#define BRDF_ARGSDEF , StructuredBuffer<MyMatStruct> matbuf, int i
#define BRDF_ARGSPASS , matbuf, i

#include <packs/mp.fxh/brdf.fxh>

StructuredBuffer<MyMatStruct> MyMatBuffer;

... blablabla rest of the shader code ...

float4 MyPS(PSin psin)
{
	float4 col = 1;
	// class instance is already created in brdf.fxh (here: cWalterG WalterG)
	// note the extra 2 arguments at the end we defined earlier for the BRDF funtion:
	col.rgb = WalterG.brdf(psin.lDir, psin.vDir, psin.Normal, psin.Tangent, psin.Binormal, MyMatBuffer, psin.MatID);
	return col;
}