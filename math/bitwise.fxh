#if !defined(math_bitwise_fxh)
#define math_bitwise_fxh 1

uint Join(float a, float b)
{
	uint ab = f32tof16(a);
	uint bb = f32tof16(b);
	bb = bb << 16;
	return ab | bb;
}

float2 Split(uint a)
{
	uint2 ret = 0;
	ret.x = f16tof32(a);
	ret.y = f16tof32(a >> 16);
	return asfloat(ret);
}

uint Join(uint a, uint b)
{
	uint ab = 0x0000FFFF & a;
	uint bb = 0xFFFF0000 & (a << 16);
	return ab | bb;
}

uint2 SplitUint(uint a)
{
	uint2 ret = 0;
	ret.x = 0x0000FFFF & a;
	ret.y = 0x0000FFFF & (a >> 16);
	return ret;
}

uint JoinHalf(uint a, uint b)
{
	uint ab = 0x000000FF & a;
	uint bb = 0x0000FF00 & (a << 8);
	return ab | bb;
}

uint2 SplitHalf(uint a)
{
	uint2 ret = 0;
	ret.x = 0x000000FF & a;
	ret.y = 0x000000FF & (a >> 8);
	return ret;
}
#endif