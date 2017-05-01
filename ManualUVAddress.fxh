#if !defined(MANUALUVADDRESS_FXH)
#define MANUALUVADDRESS_FXH


interface IAddress
{
	float Address(float res);
};
class CWrap : IAddress
{
	float Address(float res)
	{
		return frac(res);
	}
};
class CMirror : IAddress
{
	float Address(float res)
	{
		if(floor(res)%2==0)
			return frac(res);
		else
			return 1-frac(res);
	}
};
class CClamp : IAddress
{
	float Address(float res)
	{
		return saturate(res);
	}
};
class CUnlimited : IAddress
{
	float Address(float res)
	{
		return res;
	}
};

CWrap AWrap;
CMirror AMirror;
CClamp AClamp;
CUnlimited Unlimited;

IAddress addressU <string uiname="AddressU"; string linkclass="AWrap,AMirror,AClamp,Unlimited";> = AWrap;
IAddress addressV <string uiname="AddressV"; string linkclass="AWrap,AMirror,AClamp,Unlimited";> = AWrap;

float2 AddressUV(float2 uv)
{
	float2 res = uv;
	res.x = addressU.Address(res.x);
	res.y = addressV.Address(res.y);
	return res;
}
#endif
