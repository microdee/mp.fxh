#if !defined(DFPRIMITIVESELECTOR_FXH)
#define DFPRIMITIVESELECTOR_FXH

#if defined(__INTELLISENSE__)
#include <DFPrimitives.fxh>
#else
#include <packs/mp.fxh/DFPrimitives.fxh>
#endif

/*
	(uint Sel)	(Name)		(floats) (bytes)
	 0			sphere		1        4
	 1			sphereN		2        8
	 2			cylinder	3        12
	 3			cylinderN	4        16
	 4			plane		4        16
	 5			box			3        12
	 6			torus		2        8
	 7			torusN		4        16
	 8			cone		2        8
	 9			coneN		3        12
	10			capsule		7        28
	11			capsuleN	8        32
*/

float PSphere(float3 p, uint PropAddress, StructuredBuffer<float> Prop)
{
	uint ii = PropAddress;
	return sSphere(p,Prop[ii+0]);
}
float PSphereN(float3 p, uint PropAddress, StructuredBuffer<float> Prop)
{
	uint ii = PropAddress;
	return sSphere(p,Prop[ii+0],Prop[ii+1]);
}
float PCylinder(float3 p, uint PropAddress, StructuredBuffer<float> Prop)
{
	uint ii = PropAddress;
	float3 cc;
	cc.x = Prop[ii+0];
	cc.y = Prop[ii+1];
	cc.z = Prop[ii+2];
	return sCylinder(p,cc);
}
float PCylinderN(float3 p, uint PropAddress, StructuredBuffer<float> Prop)
{
	uint ii = PropAddress;
	float3 cc;
	cc.x = Prop[ii+0];
	cc.y = Prop[ii+1];
	cc.z = Prop[ii+2];
	return sCylinder(p,cc,Prop[ii+3]);
}
float PPlane(float3 p, uint PropAddress, StructuredBuffer<float> Prop)
{
	uint ii = PropAddress;
	float4 cc;
	cc.x = Prop[ii+0];
	cc.y = Prop[ii+1];
	cc.z = Prop[ii+2];
	cc.w = Prop[ii+3];
	return sPlane(p,cc);
}
float PBox(float3 p, uint PropAddress, StructuredBuffer<float> Prop)
{
	uint ii = PropAddress;
	float3 cc;
	cc.x = Prop[ii+0];
	cc.y = Prop[ii+1];
	cc.z = Prop[ii+2];
	return sBox(p,cc);
}
float PTorus(float3 p, uint PropAddress, StructuredBuffer<float> Prop)
{
	uint ii = PropAddress;
	float2 cc;
	cc.x = Prop[ii+0];
	cc.y = Prop[ii+1];
	return sTorus(p,cc);
}
float PTorusN(float3 p, uint PropAddress, StructuredBuffer<float> Prop)
{
	uint ii = PropAddress;
	float2 cc;
	cc.x = Prop[ii+0];
	cc.y = Prop[ii+1];
	float2 nn;
	nn.x = Prop[ii+2];
	nn.y = Prop[ii+3];
	return sTorus(p,cc,nn);
}
float PCone(float3 p, uint PropAddress, StructuredBuffer<float> Prop)
{
	uint ii = PropAddress;
	float2 cc;
	cc.x = Prop[ii+0];
	cc.y = Prop[ii+1];
	return sCone(p,cc);
}
float PConeN(float3 p, uint PropAddress, StructuredBuffer<float> Prop)
{
	uint ii = PropAddress;
	float2 cc;
	cc.x = Prop[ii+0];
	cc.y = Prop[ii+1];
	return sCone(p,cc,Prop[ii+2]);
}
float PCapsule(float3 p, uint PropAddress, StructuredBuffer<float> Prop)
{
	uint ii = PropAddress;
	float3 aa;
	aa.x = Prop[ii+0];
	aa.y = Prop[ii+1];
	aa.z = Prop[ii+2];
	float3 bb;
	bb.x = Prop[ii+3];
	bb.y = Prop[ii+4];
	bb.z = Prop[ii+5];
	return sCapsule(p,aa,bb,Prop[ii+6]);
}
float PCapsuleN(float3 p, uint PropAddress, StructuredBuffer<float> Prop)
{
	uint ii = PropAddress;
	float3 aa;
	aa.x = Prop[ii+0];
	aa.y = Prop[ii+1];
	aa.z = Prop[ii+2];
	float3 bb;
	bb.x = Prop[ii+3];
	bb.y = Prop[ii+4];
	bb.z = Prop[ii+5];
	return sCapsule(p,aa,bb,Prop[ii+6],Prop[ii+7]);
}

// selector:
float Primitive(float3 p, uint Select, uint PropAddress, StructuredBuffer<float> Prop)
{
	float res = 0;
	if(Select == 0)
        res = PSphere(p, PropAddress, Prop);
    if (Select == 1)
        res = PSphereN(p, PropAddress, Prop);
    if (Select == 2)
        res = PCylinder(p, PropAddress, Prop);
    if (Select == 3)
        res = PCylinderN(p, PropAddress, Prop);
    if (Select == 4)
        res = PPlane(p, PropAddress, Prop);
    if (Select == 5)
        res = PBox(p, PropAddress, Prop);
    if (Select == 6)
        res = PTorus(p, PropAddress, Prop);
    if (Select == 7)
        res = PTorusN(p, PropAddress, Prop);
    if (Select == 8)
        res = PCone(p, PropAddress, Prop);
    if (Select == 9)
        res = PConeN(p, PropAddress, Prop);
    if (Select == 10)
        res = PCapsule(p, PropAddress, Prop);
    if (Select == 11)
        res = PCapsuleN(p, PropAddress, Prop);
	return res;
}
#endif