#if !defined(df_curve_quad_fxh)
#define df_curve_quad_fxh 1

#include <packs/mp.fxh/math/const.fxh>
#include <packs/mp.fxh/df/operands.fxh>

float det( float2 a, float2 b ) { return a.x*b.y-b.x*a.y; }
float3 QuadCurveClosestPoint( float2 b0, float2 b1, float2 b2 ) 
{
    float a =     det(b0,b2);
    float b = 2.0*det(b1,b0);
    float d = 2.0*det(b2,b1);
    float f = b*d - a*a;
    float2  d21 = b2-b1;
    float2  d10 = b1-b0;
    float2  d20 = b2-b0;
    float2  gf = 2.0*(b*d21+d*d10+a*d20); gf = float2(gf.y,-gf.x);
    float2  pp = -f*gf/dot(gf,gf);
    float2  d0p = b0-pp;
    float ap = det(d0p,d20);
    float bp = 2.0*det(d10,d0p);
    float t = clamp( (ap+bp)/(2.0*a+b+d), 0.0 ,1.0 );
    return float3( lerp(lerp(b0,b1,t), lerp(b1,b2,t),t), t );
}

/*
    distance from quadratic bezier curve center
        A, B, C: control points
        pos: position in field
        return.x: distance from curve
        return.y: progress on curve
*/
#if defined(CURVE_QUAD_EXACT) /// -type Switch -pin "-name UseExactQuadraticCurve -visibility Hidden"

float2 pQuadCurve(float3 pos, float3 A, float3 B, float3 C)
{    
    float3 a = B - A;
    float3 b = A - 2.0*B + C;
    float3 c = a * 2.0;
    float3 d = A - pos;

    float kk = 1.0 / dot(b,b);
    float kx = kk * dot(a,b);
    float ky = kk * (2.0*dot(a,a)+dot(d,b)) / 3.0;
    float kz = kk * dot(d,a);      

    float2 res;

    float p = ky - kx*kx;
    float p3 = p*p*p;
    float q = kx*(2.0*kx*kx - 3.0*ky) + kz;
    float h = q*q + 4.0*p3;

    if(h >= 0.0) 
    { 
        h = sqrt(h);
        float2 x = (float2(h, -h) - q) / 2.0;
        float2 uv = sign(x)*pow(abs(x), (1.0/3.0));
        float t = uv.x + uv.y - kx;
        t = clamp( t, 0.0, 1.0 );

        // 1 root
        float3 qos = d + (c + b*t)*t;
        res = float2( length(qos),t);
    }
    else
    {
        float z = sqrt(-p);
        float v = acos( q/(p*z*2.0) ) / 3.0;
        float m = cos(v);
        float n = sin(v)*1.732050808;
        float3 t = float3(m + m, -n - m, n - m) * z - kx;
        t = clamp( t, 0.0, 1.0 );

        // 3 roots
        float3 qos = d + (c + b*t.x)*t.x;
        float dis = dot(qos,qos);
        
        res = float2(dis,t.x);

        qos = d + (c + b*t.y)*t.y;
        dis = dot(qos,qos);
        if( dis<res.x ) res = float2(dis,t.y );

        qos = d + (c + b*t.z)*t.z;
        dis = dot(qos,qos);
        if( dis<res.x ) res = float2(dis,t.z );

        res.x = sqrt( res.x );
    }
    
    return res;
}
#else // CURVE_QUAD_EXACT

float2 pQuadCurve(float3 pos, float3 A, float3 B, float3 C)
{
	float3 w = normalize( cross( C-B, A-B ) );
	float3 u = normalize( C-B );
	float3 v = normalize( cross( w, u ) );

	float2 a2 = float2( dot(A-B,u), dot(A-B,v) );
	float2 b2 = ( 0.0 );
	float2 c2 = float2( dot(C-B,u), dot(C-B,v) );
	float3 p3 = float3( dot(pos-B,u), dot(pos-B,v), dot(pos-B,w) );

	float3 cp = QuadCurveClosestPoint( a2-p3.xy, b2-p3.xy, c2-p3.xy );

	return float2( sqrt(dot(cp.xy,cp.xy)+p3.z*p3.z), cp.z );
}
#endif // CURVE_QUAD_EXACT

/*
    Construct complex curves with array of quadratic curves
        pos: position
        segments: list of connected vertices
        segcnt: vertex count
        r: spline radius
        k: connection smoothness
        return.x: distance
        return.y: segment progress
        return.z: segment id
*/
float3 pQuadCurve(float3 pos, StructuredBuffer<float3> segments, uint segcnt, float r, float k)
{
    float3 res = float3(FLOAT_MAX, 0, -1);
    for(uint i=1; i<segcnt-1; i+= 2)
    {
        float3 seg0 = segments[i-1];
        float3 seg1 = segments[i];
        float3 seg2 = segments[i+1];
        float2 d = pQuadCurve(pos, seg0, seg1, seg2);
        res.x = sU(res.x, d.x-r, k);
        if(d.x < res.x)
        {
            res = float3(d, i);
        }
    }
    return res;
}
float3 pQuadCurveMb(float3 pos, StructuredBuffer<float3> segments, StructuredBuffer<float3> psegments, uint segcnt, float r, float k, float mbcoeff)
{
    float3 res = float3(FLOAT_MAX, 0, -1);
    for(uint i=1; i<segcnt-1; i+= 2)
    {
        float3 seg0 = lerp(segments[i-1], psegments[i-1], mbcoeff);
        float3 seg1 = lerp(segments[i], psegments[i], mbcoeff);
        float3 seg2 = lerp(segments[i+1], psegments[i+1], mbcoeff);
        float2 d = pQuadCurve(pos, seg0, seg1, seg2);
        res.x = sU(res.x, d.x-r, k);
        if(d.x < res.x)
        {
            res = float3(d, i);
        }
    }
    return res;
}

// Test if point p crosses line (a, b), returns sign of result
float testCross(float2 a, float2 b, float2 p) {
    return sign((b.y-a.y) * (p.x-a.x) - (b.x-a.x) * (p.y-a.y));
}
// Determine which side we're on (using barycentric parameterization)
float signBezier(float2 A, float2 B, float2 C, float2 p)
{ 
    float2 a = C - A, b = B - A, c = p - A;
    float2 bary = float2(c.x*b.y-b.x*c.y,a.x*c.y-c.x*a.y) / (a.x*b.y-b.x*a.y);
    float2 d = float2(bary.y * 0.5, 0.0) + 1.0 - bary.x - bary.y;
    return lerp(sign(d.x * d.x - d.y), lerp(-1.0, 1.0, 
        step(testCross(A, B, p) * testCross(B, C, p), 0.0)),
        step((d.x - d.y), 0.0)) * testCross(A, C, B);
}
// Solve cubic equation for roots
float3 solveCubic(float a, float b, float c)
{
    float p = b - a*a / 3.0, p3 = p*p*p;
    float q = a * (2.0*a*a - 9.0*b) / 27.0 + c;
    float d = q*q + 4.0*p3 / 27.0;
    float offset = -a / 3.0;
    if(d >= 0.0) { 
        float z = sqrt(d);
        float2 x = (float2(z, -z) - q) / 2.0;
        float2 uv = sign(x)*pow(abs(x), (1.0/3.0));
        return (offset + uv.x + uv.y);
    }
    float v = acos(-sqrt(-27.0 / p3) * q / 2.0) / 3.0;
    float m = cos(v), n = sin(v)*1.732050808;
    return float3(m + m, -n - m, n - m) * sqrt(-p / 3.0) + offset;
}

/*
    2D quadratic curve with signed side
        A, B, C: control points
        pos: position in field
        return: distance from curve
*/
float sQuadCurve2(float2 p, float2 A, float2 B, float2 C)
{    
    B = lerp(B + (1e-4), B, abs(sign(B * 2.0 - A - C)));
    float2 a = B - A, b = A - B * 2.0 + C, c = a * 2.0, d = A - p;
    float3 k = float3(3.*dot(a,b),2.*dot(a,a)+dot(d,b),dot(d,a)) / dot(b,b);      
    float3 t = clamp(solveCubic(k.x, k.y, k.z), 0.0, 1.0);
    float2 pos = A + (c + b*t.x)*t.x;
    float dis = length(pos - p);
    pos = A + (c + b*t.y)*t.y;
    dis = min(dis, length(pos - p));
    pos = A + (c + b*t.z)*t.z;
    dis = min(dis, length(pos - p));
    return dis * signBezier(A, B, C, p);
}

#endif