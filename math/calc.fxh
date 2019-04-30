#if !defined(math_calc_fxh)
#define math_calc_fxh 1

// originally from https://github.com/everyoneishappy/happy.fxh/blob/master/calc.fxh
// thanks Kyle McLean (Everyoneishappy)

/*
    f: function,
    p: postion,
    dT: delta time or stepsize,
    v: vector size (2..4),
    e: epsilon
*/

#define calcEuler(f, p, dT)  ( p += f(p) * dT )

/*
    RK2 & RK4 will create some variables as 'FOO_FunctionName'
*/
#define calcRK2(f, p, dT, v) \
	float halfDT_##f = dT * 0.5; \
	float##v v1_##f = f(p); \
	float##v v2_##f = f(p + v1_##f * halfDT_##f); \
	p += (v1_##f + v2_##f)  * halfDT_##f

#define calcRK4(f, p, dT, v) \
	float halfDT_##f = dT * 0.5; \
	float##v v1_##f = f(p); \
	float##v v2_##f = f(p + v1_##f * halfDT_##f); \
	float##v v3_##f = f(p + v2_##f * halfDT_##f); \
	float##v v4_##f = f(p + v3_##f * dT); \
	p += (v1_##f + v2_##f*2 + v3_##f*2 + v4_##f)/6 *dT 

/*
    Partial derivatives
*/

// Partial Derivatives in 2D domain
#define calcDx2D(f, p, e) ( (f(p + float2(e,0)) - f(p - float2(e,0))) / (2*e) )
#define calcDy2D(f, p, e) ( (f(p + float2(0,e)) - f(p - float2(0,e))) / (2*e) )

// 2nd Order Partial Derivatives in 2D domain
#define calcDxx2D(f, p, e) ( (f(p + float2(e,0)) + f(p - float2(e,0)) - 2 * f(p)) / (e*e) )
#define calcDyy2D(f, p, e) ( (f(p + float2(0,e)) + f(p - float2(0,e)) - 2 * f(p)) / (e*e) )
#define calcDxy2D(f, p, e) ( (calcDy2D(f, p + float2(0,e), e) - calcDy2D(f, p - float2(0,e), e)) / (2*e) )


// Partial Derivatives in 3D domain
#define calcDx3D(f, p, e) ( (f(p + float3(e,0,0)) - f(p - float3(e,0,0))) / (2*e) )
#define calcDy3D(f, p, e) ( (f(p + float3(0,e,0)) - f(p - float3(0,e,0))) / (2*e) )
#define calcDz3D(f, p, e) ( (f(p + float3(0,0,e)) - f(p - float3(0,0,e))) / (2*e) )

// 2nd Order Partial Derivatives in 3D domain
#define calcDxx3D(f, p, e) ( (f(p + float3(e,0,0)) + f(p - float3(e,0,0)) - 2 * f(p)) / (e*e) )
#define calcDyy3D(f, p, e) ( (f(p + float3(0,e,0)) + f(p - float3(0,e,0)) - 2 * f(p)) / (e*e) )
#define calcDzz3D(f, p, e) ( (f(p + float3(0,0,e)) + f(p - float3(0,0,e)) - 2 * f(p)) / (e*e) )
#define calcDxy3D(f, p, e) ( (calcDx3D(f, p + float3(0,e,0), e) - calcDx3D(f, p - float3(0,e,0), e)) / (2*e) )
#define calcDxz3D(f, p, e) ( (calcDx3D(f, p + float3(0,0,e), e) - calcDx3D(f, p - float3(0,0,e), e)) / (2*e) )
#define calcDyz3D(f, p, e) ( (calcDy3D(f, p + float3(0,0,e), e) - calcDy3D(f, p - float3(0,0,e), e)) / (2*e) )

/*
    Gradients
*/

//  2D & 3D scalar field gradients
#define calcGradS2(f, p, e) ( float2(calcDx2D(f, p, e), calcDy2D(f, p, e)) )
#define calcGradS3(f, p, e) ( float3(calcDx3D(f, p, e), calcDy3D(f, p, e), calcDz3D(f, p, e)) )

// Normals
#define calcNormS2(f, p, e) normalize( float2(calcDx2D(f, p, e), calcDy2D(f, p, e)) )
#define calcNormS3(f, p, e) normalize( float3(calcDx3D(f, p, e), calcDy3D(f, p, e), calcDz3D(f, p, e)) )

// Jacobian (gradients) of a 2D vector field as 2x2 matrix
#define calcGradV2(f, p, e)(transpose(float2x2(calcDx2D, calcDy2D)))

// Jacobian (gradients) of a 3D vector field as 3x3 matrix
#define calcGradV3(f, p, e)(transpose(float3x3(calcDx3D(f, p, e), calcDy3D(f, p, e), calcDz3D(f, p, e))))

// Hessian aka Jacobian of gradient of a 2D or 3D scalr field
#define calcHessS2(f, p, e) (float2x2 m = {	calcDxx2D(f, p, e), calcDxy2D(f, p, e), 	\
											calcDxy2D(f, p, e), calcDyy2D(f, p, e)  })

#define calcHessS3(f, p, e) (float3x3 m = {	calcDxx3D(f, p, e), calcDxy3D(f, p, e), calcDxz3D(f, p, e),	\
											calcDxy3D(f, p, e), calcDyy3D(f, p, e), calcDyz3D(f, p, e), \
											calcDxz3D(f, p, e), calcDyz3D(f, p, e), calcDzz3D(f, p, e)} )

/*
	Divergence
*/

#define calcDivV2(f, p, e) ( calcDx2D(f, p, e).x + calcDy2D(f, p, e).y )
#define calcDivV3(f, p, e) ( calcDx3D(f, p, e).x + calcDy3D(f, p, e).y + calcDz3D(f, p, e).z )

// Laplacian aka Divergence of gradient
#define calcLapS2(f, p, e) ( calcDxx2D(f, p, e) + calcDyy2D(f, p, e) )
#define calcLapS3(f, p, e) ( calcDxx3D(f, p, e) + calcDyy3D(f, p, e) + calcDzz3D(f, p, e) )
#define calcLapV2(f, p, e) float2( calcDxx2D(f, p, e) + calcDyy2D(f, p, e) )
#define calcLapV3(f, p, e) float3( calcDxx3D(f, p, e) + calcDyy3D(f, p, e) + calcDzz3D(f, p, e) )

#endif