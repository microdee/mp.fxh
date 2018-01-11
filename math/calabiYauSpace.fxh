#if !defined(math_calabiYauSpace_fxh)
#define math_calabiYauSpace_fxh 1

#include <packs/mp.fxh/math/complex.fxh>

complex cU1(float a, float b)
{
	complex m1 = cC(a, b);
	complex m2 = cC(-a, -b);
	return cMul(cAdd(cExp(m1), cExp(m2)), cC(0.5, 0));
}
complex cU2(float a, float b)
{
	complex m1 = cC(a, b);
	complex m2 = cC(-a, -b);
	return cMul(cSub(cExp(m1), cExp(m2)), cC(0.5, 0));
}
complex cZ1(float a, float b, float n, float k)
{
	complex u1 = cMul(cU1(a, b), cC(2.0/n, 0));
	complex m1 = cExp(cMul(cC(0,1), cC((2*PI*k)/n, 0)));
	return cMul(m1, u1);
}
complex cZ2(float a, float b, float n, float k)
{
	complex u2 = cMul(cU2(a, b), cC(2.0/n, 0));
	complex m2 = cExp(cMul(cC(0,1), cC((2*PI*k)/n, 0)));
	return cMul(m2, u2);
}
float3 plotCYM(float k1, float k2, float a, float b, float n, float Rot)
{
	complex z1 = cZ1(a, b, n, k1);
	complex z2 = cZ2(a, b, n, k2);
	float3 res = 0;
	res.x = z1.R; res.y = z2.R;
	res.z = cos(Rot * PI) * z1.I + sin(Rot * PI) * z2.I;
	return res;
}

#endif