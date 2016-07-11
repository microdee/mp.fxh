#define DFPRIMITIVEINTERFACE_FXH

#if !defined(DFPRIMITIVESELECTOR_FXH)
#include <packs/mp.fxh/DFPrimitiveSelector.fxh>
#endif

interface iPrimitive{
	float Primitive(float3 p, uint i);
	uint PropSize();
};
class cSphere : iPrimitive{
	uint PropSize(){return 1;}
	float Primitive(float3 p, uint i)
	{
		uint ii = i*this.PropSize();
		return PSphere(p,ii);
	}
};
class cSphereN : iPrimitive{
	uint PropSize(){return 2;}
	float Primitive(float3 p, uint i)
	{
		uint ii = i*this.PropSize();
		return PSphereN(p,ii);
	}
};
class cCylinder : iPrimitive{
	uint PropSize(){return 3;}
	float Primitive(float3 p, uint i)
	{
		uint ii = i*this.PropSize();
		return PCylinder(p,ii);
	}
};
class cCylinderN : iPrimitive{
	uint PropSize(){return 4;}
	float Primitive(float3 p, uint i)
	{
		uint ii = i*this.PropSize();
		return PCylinderN(p,ii);
	}
};
class cPlane : iPrimitive{
	uint PropSize(){return 4;}
	float Primitive(float3 p, uint i)
	{
		uint ii = i*this.PropSize();
		return PPlane(p,ii);
	}
};
class cBox : iPrimitive{
	uint PropSize(){return 3;}
	float Primitive(float3 p, uint i)
	{
		uint ii = i*this.PropSize();
		return PBox(p,ii);
	}
};
class cTorus : iPrimitive{
	uint PropSize(){return 2;}
	float Primitive(float3 p, uint i)
	{
		uint ii = i*this.PropSize();
		return PTorus(p,ii);
	}
};
class cTorusN : iPrimitive{
	uint PropSize(){return 4;}
	float Primitive(float3 p, uint i)
	{
		uint ii = i*this.PropSize();
		return PTorusN(p,ii);
	}
};
class cCone : iPrimitive{
	uint PropSize(){return 2;}
	float Primitive(float3 p, uint i)
	{
		uint ii = i*this.PropSize();
		return PCone(p,ii);
	}
};
class cConeN : iPrimitive{
	uint PropSize(){return 3;}
	float Primitive(float3 p, uint i)
	{
		uint ii = i*this.PropSize();
		return PConeN(p,ii);
	}
};
class cCapsule : iPrimitive{
	uint PropSize(){return 7;}
	float Primitive(float3 p, uint i)
	{
		uint ii = i*this.PropSize();
		return PCapsule(p,ii);
	}
};
class cCapsuleN : iPrimitive{
	uint PropSize(){return 8;}
	float Primitive(float3 p, uint i)
	{
		uint ii = i*this.PropSize();
		return PCapsuleN(p,ii);
	}
};
cSphere Sphere;
cSphereN SphereN;
cCylinder Cylinder;
cCylinderN CylinderN;
cPlane Plane;
cBox Box;
cTorus Torus;
cTorusN TorusN;
cCone Cone;
cConeN ConeN;
cCapsule Capsule;
cCapsuleN CapsuleN;

iPrimitive iprim <string uiname="Primitive";string linkclass="Sphere,SphereN,Cylinder,CylinderN,Plane,Box,Torus,TorusN,Cone,ConeN,Capsule,CapsuleN";> = Sphere;
