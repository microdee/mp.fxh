#if !defined(math_common_fxh)
#define math_common_fxh 1

#include <packs/mp.fxh/math/const.fxh>
#include <packs/mp.fxh/math/minmax.fxh>
#include <packs/mp.fxh/math/safeSign.fxh>
#include <packs/mp.fxh/math/vectors.fxh>

#define sqr(x) (x*x)
#define square(x) (x*x)
#define lsqr(x) dot(x, x);
#define lengthSqr(x) dot(x, x);

#define copysign(a, b) (a * sign(b))

#define pows(a, b) (pow(abs(a), b)*sign(a))

#define safediv(a, b) (abs(a) / max(abs(b), FLOAT_MIN) * sign(a * b))

#define map(l, smin, smax, dmin, dmax) (dmin + ((l - smin) / (smax - smin)) * (dmax - dmin))
#define mapClamp(l, smin, smax, dmin, dmax) map(clamp(l, min(smin, smax), max(smin, smax)), smin, smax, dmin, dmax)
#define mapWrap(l, smin, smax, dmin, dmax) (dmin + ((((l - smin) / (smax - smin)) + ((l - smin) / (smax - smin)) < 0) % 1) * (dmax - dmin))
#define mapMirror(l, smin, smax, dmin, dmax) (dmin + ((1-2*abs(frac((l - smin) / (smax - smin) * 0.5) - 0.5)) % 1) * (dmax - dmin))

#define modf(x, y) (x - y * floor(x/y))

#define scale(s) float4x4(s.x, 0, 0, 0, 0, s.y, 0, 0, 0, 0, s.z, 0, 0, 0, 0, 1)
#define translate(t) float4x4(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, t.x, t.y, t.z, 1)

#endif