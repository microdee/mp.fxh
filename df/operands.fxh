#if !defined(df_operands_fxh)
#define df_operands_fxh
// combining stuff from IQ http://www.iquilezles.org/www/articles/distfunctions/distfunctions.htm
// and http://mercury.sexy/hg_sdf/

#include <packs/mp.fxh/math/safesign.fxh>
#include <packs/mp.fxh/math/mod.fxh>

#if !defined(PI)
#define PI 3.14159265
#endif
// simple operations
float U(float a, float b) {return min(a,b);}
float S(float a, float b) {return max(a,-b);}
float I(float a, float b) {return max(a,b);}

// smooth operations
float sU( float a, float b, float k )
{
    float h = clamp( 0.5+0.5*(b-a)/k, 0.0, 1.0 );
    return lerp( b, a, h ) - k*h*(1.0-h);
}
float sS( float a, float b, float k )
{
    return log( exp(a/k) + exp(-b/k) ) * k;
}
float sI( float a, float b, float k )
{
    return log( exp(a/k) + exp(b/k) ) * k;
}

// Domain modifications

float3 Repeat(float3 p, float3 s)
{
    return frac(p/s)*s-s/2;
}

// from http://mercury.sexy/hg_sdf/:
// "
// Conventions:
//
// Many operate only on a subset of the three dimensions. For those,
// you must choose the dimensions that you want manipulated
// by supplying e.g. <p.x> or <p.zx>
//
// <inout p> is always the first argument and modified in place.
//
// Many of the operators partition space into cells. An identifier
// or cell index is returned, if possible. This return value is
// intended to be optionally used e.g. as a random seed to change
// parameters of the distance functions inside the cells.
//
// Unless stated otherwise, for cell index 0, <p> is unchanged and cells
// are centered on the origin so objects don't have to be moved to fit.
// "

// Rotate around a coordinate axis (i.e. in a plane perpendicular to that axis) by angle <a>.
// Read like this: R(p.xz, a) rotates "x towards z".
// This is fast if <a> is a compile-time constant and slower (but still practical) if not.
void oR(inout float2 p, float a) {
	p = cos(a)*p + sin(a)*float2(p.y, -p.x);
}
// Shortcut for 45-degrees rotation
void oR45(inout float2 p) {
	p = (p + float2(p.y, -p.x))*sqrt(0.5);
}
// Repeat space along one axis. Use like this to repeat along the x axis:
// <float cell = pMod1(p.x,5);> - using the return value is optional.
float oMod1(inout float p, float size) {
	float halfsize = size*0.5;
	float c = floor((p + halfsize)/size);
	p = mod(p + halfsize, size) - halfsize;
	return c;
}
// Same, but mirror every second cell so they match at the boundaries
float oModMirror1(inout float p, float size) {
	float halfsize = size*0.5;
	float c = floor((p + halfsize)/size);
	p = mod(p + halfsize,size) - halfsize;
	p *= mod(c, 2.0)*2 - 1;
	return c;
}
// Repeat the domain only in positive direction. Everything in the negative half-space is unchanged.
float oModSingle1(inout float p, float size) {
	float halfsize = size*0.5;
	float c = floor((p + halfsize)/size);
	if (p >= 0)
		p = mod(p + halfsize, size) - halfsize;
	return c;
}
// Repeat only a few times: from indices <start> to <stop> (similar to above, but more flexible)
float oModInterval1(inout float p, float size, float start, float stop) {
	float halfsize = size*0.5;
	float c = floor((p + halfsize)/size);
	p = mod(p+halfsize, size) - halfsize;
	if (c > stop) { //yes, this might not be the best thing numerically.
		p += size*(c - stop);
		c = stop;
	}
	if (c <start) {
		p += size*(c - start);
		c = start;
	}
	return c;
}
// Repeat around the origin by a fixed angle.
// For easier use, num of repetitions is use to specify the angle.
float oModPolar(inout float2 p, float repetitions) {
	float angle = 2*PI/repetitions;
	float a = atan2(p.y, p.x) + angle/2.;
	float r = length(p);
	float c = floor(a/angle);
	a = mod(a,angle) - angle/2.;
	p = float2(cos(a), sin(a))*r;
	// For an odd number of repetitions, fix cell index of the cell in -x direction
	// (cell index would be e.g. -5 and 5 in the two halves of the cell):
	if (abs(c) >= (repetitions/2)) c = abs(c);
	return c;
}
// Repeat in two dimensions
float2 oMod2(inout float2 p, float2 size) {
	float2 c = floor((p + size*0.5)/size);
	p = mod(p + size*0.5,size) - size*0.5;
	return c;
}
// Same, but mirror every second cell so all boundaries match
float2 oModMirror2(inout float2 p, float2 size) {
	float2 halfsize = size*0.5;
	float2 c = floor((p + halfsize)/size);
	p = mod(p + halfsize, size) - halfsize;
	p *= mod(c,2)*2 - 1;
	return c;
}
// Same, but mirror every second cell at the diagonal as well
float2 oModGrid2(inout float2 p, float2 size) {
	float2 c = floor((p + size*0.5)/size);
	p = mod(p + size*0.5, size) - size*0.5;
	p *= mod(c,2)*2 - 1;
	p -= size/2;
	if (p.x > p.y) p.xy = p.yx;
	return floor(c/2);
}
// Repeat in three dimensions
float3 oMod3(inout float3 p, float3 size) {
	float3 c = floor((p + size*0.5)/size);
	p = mod(p + size*0.5, size) - size*0.5;
	return c;
}
// Mirror at an axis-aligned plane which is at a specified distance <dist> from the origin.
float oMirror (inout float p, float dist) {
	float s = sgn(p);
	p = abs(p)-dist;
	return s;
}
// Mirror in both dimensions and at the diagonal, yielding one eighth of the space.
// translate by dist before mirroring.
float2 oMirrorOctant (inout float2 p, float2 dist) {
	float2 s = sgn(p);
	oMirror(p.x, dist.x);
	oMirror(p.y, dist.y);
	if (p.y > p.x)
		p.xy = p.yx;
	return s;
}
// Reflect space at a plane
float oReflect(inout float3 p, float3 planeNormal, float offset) {
	float t = dot(p, planeNormal)+offset;
	if (t < 0) {
		p = p - (2*t)*planeNormal;
	}
	return sgn(t);
}

// mercury operations

// The "Chamfer" flavour makes a 45-degree chamfered edge (the diagonal of a square of size <r>):
float UChamfer(float a, float b, float r) {
	return min(min(a, b), (a - r + b)*sqrt(0.5));
}
// Intersection has to deal with what is normally the inside of the resulting object
// when using union, which we normally don't care about too much. Thus, intersection
// implementations sometimes differ from union implementations.
float IChamfer(float a, float b, float r) {
	return max(max(a, b), (a + r + b)*sqrt(0.5));
}
// Difference can be built from Intersection or Union:
float SChamfer (float a, float b, float r) {
	return IChamfer(a, -b, r);
}

// The "Round" variant uses a quarter-circle to join the two objects smoothly:
float URound(float a, float b, float r) {
	float2 u = max(float2(r - a,r - b), 0);
	return max(r, min (a, b)) - length(u);
}
float IRound(float a, float b, float r) {
	float2 u = max(float2(r + a,r + b), 0);
	return min(-r, max (a, b)) + length(u);
}
float SRound (float a, float b, float r) {
	return IRound(a, -b, r);
}

// The "Columns" flavour makes n-1 circular columns at a 45 degree angle:
float UColumns(float a, float b, float r, float n) {
	if ((a < r) && (b < r)) {
		float2 p = float2(a, b);
		float columnradius = r*sqrt(2)/((n-1)*2+sqrt(2));
		oR45(p);
		p.x -= sqrt(2)/2*r;
		p.x += columnradius*sqrt(2);
		if (mod(n,2) == 1) {
			p.y += columnradius;
		}
		// At this point, we have turned 45 degrees and moved at a point on the
		// diagonal that we want to place the columns on.
		// Now, repeat the domain along this direction and place a circle.
		oMod1(p.y, columnradius*2);
		float result = length(p) - columnradius;
		result = min(result, p.x);
		result = min(result, a);
		return min(result, b);
	} else {
		return min(a, b);
	}
}
float SColumns(float a, float b, float r, float n) {
	a = -a;
	float m = min(a, b);
	//avoid the expensive computation where not needed (produces discontinuity though)
	if ((a < r) && (b < r)) {
		float2 p = float2(a, b);
		float columnradius = r*sqrt(2)/n/2.0;
		columnradius = r*sqrt(2)/((n-1)*2+sqrt(2));

		oR45(p);
		p.y += columnradius;
		p.x -= sqrt(2)/2*r;
		p.x += -columnradius*sqrt(2)/2;

		if (mod(n,2) == 1) {
			p.y += columnradius;
		}
		oMod1(p.y,columnradius*2);

		float result = -length(p) + columnradius;
		result = max(result, p.x);
		result = min(result, a);
		return -min(result, b);
	} else {
		return -m;
	}
}
float IColumns(float a, float b, float r, float n) {
	return SColumns(a,-b,r, n);
}

// The "Stairs" flavour produces n-1 steps of a staircase:
// much less stupid version by paniq
float UStairs(float a, float b, float r, float n) {
	float s = r/n;
	float u = b-r;
	return min(min(a,b), 0.5 * (u + a + abs ((mod (u - a + s, 2 * s)) - s)));
}
// We can just call Union since stairs are symmetric.
float IStairs(float a, float b, float r, float n) {
	return -UStairs(-a, -b, r, n);
}
float SStairs(float a, float b, float r, float n) {
	return -UStairs(-a, b, r, n);
}

// Similar to fOpUnionRound, but more lipschitz-y at acute angles
// (and less so at 90 degrees). Useful when fudging around too much
// by MediaMolecule, from Alex Evans' siggraph slides
float USoft(float a, float b, float r) {
	float e = max(r - abs(a - b), 0);
	return min(a, b) - e*e*0.25/r;
}

// produces a cylindical pipe that runs along the intersection.
// No objects remain, only the pipe. This is not a boolean operator.
float oPipe(float a, float b, float r) {
	return length(float2(a, b)) - r;
}
// first object gets a v-shaped engraving where it intersect the second
float oEngrave(float a, float b, float r) {
	return max(a, (a + r - abs(b))*sqrt(0.5));
}
// first object gets a capenter-style groove cut out
float oGroove(float a, float b, float ra, float rb) {
	return max(a, min(a + ra, rb - abs(b)));
}
// first object gets a capenter-style tongue attached
float oTongue(float a, float b, float ra, float rb) {
	return min(a, max(a - ra, abs(b) - rb));
}

float blend(float a, float b, uint s, float mass)
{
	float res = b;
	if(s==1) res = U(a,b);
	if(s==2) res = S(a,b);
	if(s==3) res = I(a,b);
	if(s==4) res = sU(a,b,mass);
	if(s==5) res = sS(a,b,mass/4);
	if(s==6) res = sI(a,b,mass/4);
	if(s==7) res = a;
	return res;
}
#endif