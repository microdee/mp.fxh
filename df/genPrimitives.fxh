#if !defined(df_genPrimitives_fxh)
#define df_genPrimitives_fxh

// from http://mercury.sexy/hg_sdf/

#include <packs/mp.fxh/math/const.fxh>

const float3 GDFVectors[19] : IMMUTABLE = {
	normalize(float3(1, 0, 0)),
	normalize(float3(0, 1, 0)),
	normalize(float3(0, 0, 1)),

	normalize(float3(1, 1, 1 )),
	normalize(float3(-1, 1, 1)),
	normalize(float3(1, -1, 1)),
	normalize(float3(1, 1, -1)),

	normalize(float3(0, 1, PHI+1)),
	normalize(float3(0, -1, PHI+1)),
	normalize(float3(PHI+1, 0, 1)),
	normalize(float3(-PHI-1, 0, 1)),
	normalize(float3(1, PHI+1, 0)),
	normalize(float3(-1, PHI+1, 0)),

	normalize(float3(0, PHI, 1)),
	normalize(float3(0, -PHI, 1)),
	normalize(float3(1, 0, PHI)),
	normalize(float3(-1, 0, PHI)),
	normalize(float3(PHI, 1, 0)),
	normalize(float3(-PHI, 1, 0))
};

// Version with variable exponent.
// This is slow and does not produce correct distances, but allows for bulging of objects.
float fGDF(float3 p, float r, float e, int begin, int end) {
	float d = 0;
	for (int i = begin; i <= end; ++i)
		d += pow(abs(dot(p, GDFVectors[i])), e);
	return pow(d, 1/e) - r;
}
// Version with without exponent, creates objects with sharp edges and flat faces
float fGDF(float3 p, float r, int begin, int end) {
	float d = 0;
	for (int i = begin; i <= end; ++i)
		d = max(d, abs(dot(p, GDFVectors[i])));
	return d - r;
}

float gOctahedron(float3 p, float r, float e) {
	return fGDF(p, r, e, 3, 6);
}

float gDodecahedron(float3 p, float r, float e) {
	return fGDF(p, r, e, 13, 18);
}

float gIcosahedron(float3 p, float r, float e) {
	return fGDF(p, r, e, 3, 12);
}

float gTruncatedOctahedron(float3 p, float r, float e) {
	return fGDF(p, r, e, 0, 6);
}

float gTruncatedIcosahedron(float3 p, float r, float e) {
	return fGDF(p, r, e, 3, 18);
}

float gOctahedron(float3 p, float r) {
	return fGDF(p, r, 3, 6);
}

float gDodecahedron(float3 p, float r) {
	return fGDF(p, r, 13, 18);
}

float gIcosahedron(float3 p, float r) {
	return fGDF(p, r, 3, 12);
}

float gTruncatedOctahedron(float3 p, float r) {
	return fGDF(p, r, 0, 6);
}

float gTruncatedIcosahedron(float3 p, float r) {
	return fGDF(p, r, 3, 18);
}
#endif