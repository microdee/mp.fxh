#if !defined(math_complex_fxh)
#define math_complex_fxh 1

#define PI 3.14159265
#define EE 2.71828183

struct complex {
	float R;
	float I;
};
complex cC(float rr, float ii)
{
	complex res = (complex)rr;
	res.I = ii;
	return res;
}
complex cC(float2 c1)
{
	return cC(c1.x, c1.y);
}

complex cAdd(complex c1, complex c2)
{
	float a = c1.R;
	float b = c1.I;
	float c = c2.R;
	float d = c2.I;
	return cC(a + c, b + d);
}

complex cSub(complex c1, complex c2)
{
	float a = c1.R;
	float b = c1.I;
	float c = c2.R;
	float d = c2.I;
	return cC(a - c, b - d);
}

complex cMul(complex c1, complex c2)
{
	float a = c1.R;
	float b = c1.I;
	float c = c2.R;
	float d = c2.I;
	return cC(a*c - b*d, b*c + a*d);
}
complex cDiv(complex c1, complex c2)
{
	float a = c1.R;
	float b = c1.I;
	float c = c2.R;
	float d = c2.I;
	float real = (a*c + b*d) / (c*c + d*d);
	float imag = (b*c - a*d) / (c*c + d*d);
	return cC(real, imag);
}
float cAbs(complex c)
{
	return sqrt(c.R*c.R + c.I*c.I);
}
float cArg(complex c)
{
	return atan2(c.I, c.R);
}
complex cConj(complex c)
{
	return cC(c.R, -c.I);
}
float2 cToPol(complex c)
{
	float a = c.R;
	float b = c.I;
	float z = cAbs(c);
	float f = atan2(b, a);
	return float2(z, f);
}
complex cFromRec(float2 c)
{
	float z = abs(c.x);
	float f = c.y;
	float a = z * cos(f);
	float b = z * sin(f);
	return cC(a, b);
}
complex cPow(complex base, complex e)
{
	complex b = cC(cToPol(base));
	float r = b.R;
	float f = b.I;
	float c = e.R;
	float d = e.I;
	float z = pow(r, c) * pow(EE, -d * f);
	float fi = d * log(r) + c * f;
	float2 rpol = float2(z, fi);
	return cFromRec(rpol);
}
complex cSqrt(complex z)
{
	float r = sqrt(cAbs(z));
	float theta = cArg(z)/2;
	return cC(r * cos(theta), r * sin(theta));
}
complex cExp(complex z)
{
	return cC(exp(z.R) * cos(z.I), exp(z.R) * sin(z.I));
}
complex cLog(complex z)
{
	return cC(log(cAbs(z)), cArg(z));
}

complex cSin(complex c)
{
	return cC(cosh(c.I) * sin(c.R), sinh(c.I) * cos(c.R));
}
complex cCos(complex c)
{
	return cC(cosh(c.I) * cos(c.R), sinh(c.I) * sin(c.R));
}
complex cSinh(complex c)
{
	return cC(sinh(c.R) * cos(c.I), cosh(c.R) * sin(c.I));
}
complex cCosh(complex c)
{
	return cC(cosh(c.R) * cos(c.I), sinh(c.R) * sin(c.I));
}
complex cTan(complex c)
{
	return cDiv(cSin(c), cCos(c));
}
complex ChangeSign(complex c)
{
	return cC(-c.R, -c.I);
}
#endif