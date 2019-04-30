#if !defined(math_map_fxh)
#define math_map_fxh

#define map(l, smin, smax, dmin, dmax) (dmin + ((l - smin) / (smax - smin)) * (dmax - dmin))

#define mapClamp(l, smin, smax, dmin, dmax) map(clamp(l, min(smin, smax), max(smin, smax)), smin, smax, dmin, dmax)

#define mapWrap(l, smin, smax, dmin, dmax) (dmin + ((((l - smin) / (smax - smin)) + ((l - smin) / (smax - smin)) < 0) % 1) * (dmax - dmin))
	
#define mapMirror(l, smin, smax, dmin, dmax) (dmin + ((1-2*abs(frac((l - smin) / (smax - smin) * 0.5) - 0.5)) % 1) * (dmax - dmin))

#endif