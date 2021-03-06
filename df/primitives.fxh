#if !defined(df_primitives_fxh)
#define df_primitives_fxh
// combining stuff from IQ http://www.iquilezles.org/www/articles/distfunctions/distfunctions.htm
// and http://mercury.sexy/hg_sdf/

#include <packs/mp.fxh/math/pows.fxh>
#include <packs/mp.fxh/math/minmax.fxh>
#include <packs/mp.fxh/math/const.fxh>

// utilities
float dot2( float3 v ) { return dot(v,v); }
float lengthn(float2 v, float n) {return pow((pow(abs(v.x),n)+pow(abs(v.y),n)),1/n);}
float lengthn(float3 v, float n) {return pow((pow(abs(v.x),n)+pow(abs(v.y),n)+pow(abs(v.z),n)),1/n);}
float lengthn(float4 v, float n) {return pow((pow(abs(v.x),n)+pow(abs(v.y),n)+pow(abs(v.z),n)+pow(abs(v.w),n)),1/n);}

// primitives
/*
    p: position in field
    r: radius
    return: distance
*/
float sSphere(float3 p, float r) {return length(p)-r;}
float sSphere(float3 p, float r, float n) {return lengthn(p,n)-r;}

/*
    p: position in field
    c.xy: offset
    c.z: radius
    return: distance
*/
float sCylinder(float3 p, float3 c) {return length(p.xz-c.xy)-c.z;}
float sCylinder(float3 p, float3 c, float n) {return lengthn(p.xz-c.xy,n)-c.z;}

/*
    p: position in field
    d: offset
    n: normal
    return: distance
*/
float sPlane(float3 p, float3 n, float d)
{
	float3 nn = normalize(n);
	return dot(p,n) + d;
}

/*
    p: position in field
    b: bounds
    return: distance
*/
float sBox(float3 p, float3 b)
{
	float3 d = abs(p) - b;
	return min(max(d.x,max(d.y,d.z)),0.0) + length(max(d,0.0));
}
// Cheap Box: distance to corners is overestimated
float uBoxCheap(float3 p, float3 b) {
	return vmax(abs(p) - b);
}
// Same as above, but in two dimensions (an endless box)
float uBox2(float2 p, float2 b) {
	float2 d = abs(p) - b;
	return length(max(d, 0)) + vmax(min(d, 0));
}
float uBox2Cheap(float2 p, float2 b) {
	return vmax(abs(p)-b);
}

/*
    p: position in field
    r: radii
    return: distance
*/
float sEllipsoid( float3 p, float3 r )
{
    return (length( p/r ) - 1.0) * min(min(r.x,r.y),r.z);
}

/*
    p: position in field
    t.x: circle radius
    t.y: extrusion
    return: distance
*/
float sTorus( float3 p, float2 t )
{
	float2 q = float2(length(p.xz)-t.x,p.y);
	return length(q)-t.y;
}
float sTorus( float3 p, float2 t, float2 n)
{
	float2 q = float2(lengthn(p.xz,n.x)-t.x,p.y);
	return lengthn(q,n.y)-t.y;
}

/*
    p: position in field
    c: radii
    return: distance
*/
float sCone( float3 p, float2 c )
{
    float2 cc = normalize(c);
    float q = length(p.xy);
    return dot(cc,float2(q,p.z));
}
float sCone( float3 p, float2 c, float n )
{
    float2 cc = normalize(c);
    float q = lengthn(p.xy,n);
    return dot(cc,float2(q,p.z));
}

/*
    p: position in field
    a, b: start, end
    r: radius
    return: distance
*/
float sCapsule( float3 p, float3 a, float3 b, float r )
{
    float3 pa = p - a;
    float3 ba = b - a;
    float h = clamp( dot(pa,ba)/dot(ba,ba), 0.0, 1.0 );
    return length( pa - ba*h ) - r;
}
float sCapsule( float3 p, float3 a, float3 b, float r, float n)
{
    float3 pa = p - a;
    float3 ba = b - a;
    float h = clamp( dot(pa,ba)/dot(ba,ba), 0.0, 1.0 );
    return lengthn(pa - ba*h, n) - r;
}

/*
    p: position in field
    h.x: radius
    h.y: height
    return: distance
*/
float sHexPrism( float3 p, float2 h )
{
    float3 q = abs(p);
    return max(q.z-h.y,max((q.x*0.866025+q.y*0.5),q.y)-h.x);
}

/*
    p: position in field
    h.x: radius
    h.y: height
    return: distance
*/
float sTriPrism( float3 p, float2 h )
{
    float3 q = abs(p);
    return max(q.z-h.y,max(q.x*0.866025+p.y*0.5,-p.y)-h.x*0.5);
}

/*
    p: position in field
    h.x: radius
    h.y: height
    return: distance
*/
float sCappedCylinder( float3 p, float2 h )
{
  float2 d = abs(float2(length(p.xz),p.y)) - h;
  return min(max(d.x,d.y),0.0) + length(max(d,0.0));
}

/*
    p: position in field
    c.xy: radius
    c.z: height
    return: distance
*/
float sCappedCone( float3 p, float3 c )
{
    float2 q = float2( length(p.xz), p.y );
    float2 v = float2( c.z*c.y/c.x, -c.z );
    float2 w = v - q;
    float2 vv = float2( dot(v,v), v.x*v.x );
    float2 qv = float2( dot(v,w), v.x*w.x );
    float2 d = max(qv,0.0)*qv/vv;
    return sqrt( dot(w,w) - max(d.x,d.y) )* sign(max(q.y*v.x-q.x*v.y,w.y));
}

// Blobby ball object. You've probably seen it somewhere. This is not a correct distance bound, beware.
float sBlob(float3 p) {
	p = abs(p);
	if (p.x < max(p.y, p.z)) p = p.yzx;
	if (p.x < max(p.y, p.z)) p = p.yzx;
	float b = max(max(max(
		dot(p, normalize(float3(1, 1, 1))),
		dot(p.xz, normalize(float2(PHI+1, 1)))),
		dot(p.yx, normalize(float2(1, PHI)))),
		dot(p.xz, normalize(float2(1, PHI))));
	float l = length(p);
	return l - 1.5 - 0.2 * (1.5 / 2)* cos(min(sqrt(1.01 - b / l)*(PI / 0.25), PI));
}

/*
    p: position in field
    a, b, c: triangle vertices
*/
float uTriangle( float3 p, float3 a, float3 b, float3 c )
{
    float3 ba = b - a; float3 pa = p - a;
    float3 cb = c - b; float3 pb = p - b;
    float3 ac = a - c; float3 pc = p - c;
    float3 nor = cross( ba, ac );

    return sqrt(
    (sign(dot(cross(ba,nor),pa)) +
     sign(dot(cross(cb,nor),pb)) +
     sign(dot(cross(ac,nor),pc))<2.0)
     ?
     min( min(
     dot2(ba*clamp(dot(ba,pa)/dot2(ba),0.0,1.0)-pa),
     dot2(cb*clamp(dot(cb,pb)/dot2(cb),0.0,1.0)-pb) ),
     dot2(ac*clamp(dot(ac,pc)/dot2(ac),0.0,1.0)-pc) )
     :
     dot(nor,pa)*dot(nor,pa)/dot2(nor) );
}
float uTriangle(float3 p, float3x3 v) { return uTriangle(p, v[0], v[1], v[2]); }
float uTriangle(float3 p, float3 v[3]) { return uTriangle(p, v[0], v[1], v[2]); }

/*
    p: position in field
    a, b, c, d: quad vertices
*/
float uQuad( float3 p, float3 a, float3 b, float3 c, float3 d )
{
    float3 ba = b - a; float3 pa = p - a;
    float3 cb = c - b; float3 pb = p - b;
    float3 dc = d - c; float3 pc = p - c;
    float3 ad = a - d; float3 pd = p - d;
    float3 nor = cross( ba, ad );

    return sqrt(
    (sign(dot(cross(ba,nor),pa)) +
     sign(dot(cross(cb,nor),pb)) +
     sign(dot(cross(dc,nor),pc)) +
     sign(dot(cross(ad,nor),pd))<3.0)
     ?
     min( min( min(
     dot2(ba*clamp(dot(ba,pa)/dot2(ba),0.0,1.0)-pa),
     dot2(cb*clamp(dot(cb,pb)/dot2(cb),0.0,1.0)-pb) ),
     dot2(dc*clamp(dot(dc,pc)/dot2(dc),0.0,1.0)-pc) ),
     dot2(ad*clamp(dot(ad,pd)/dot2(ad),0.0,1.0)-pd) )
     :
     dot(nor,pa)*dot(nor,pa)/dot2(nor) );
}
float uQuad(float3 p, float4x4 v) { return uQuad(p, v[0].xyz, v[1].xyz, v[2].xyz, v[3].xyz); }
float uQuad(float3 p, float4x3 v) { return uQuad(p, v[0], v[1], v[2], v[3]); }
float uQuad(float3 p, float3 v[4]) { return uQuad(p, v[0], v[1], v[2], v[3]); }
#endif