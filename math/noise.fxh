#if !defined(math_noise_fxh)
#define math_noise_fxh

float mpfxh_dnoise1(float3 u){
	u=dot(u+.2,float3(1,57,21));
	return (u.x*(.1+sin(u.x)));
}
float dnoise(float2 x,float RandomSeed){
	RandomSeed+=.00001;
	float c=mpfxh_dnoise1(float3((x+RandomSeed*13+41)+11,length(sin((x-59)/151+RandomSeed*float2(11,7))))+.5);
	return frac(c+x.x*2+RandomSeed);
}
float2 dnoise2(float2 x,float RandomSeed){
	RandomSeed+=.00001;
	float2 c={
	mpfxh_dnoise1(float3((x+RandomSeed*13+41)+11,length(sin((x-59)/151+RandomSeed*float2(11,7))))+.5),
	mpfxh_dnoise1(float3((x+RandomSeed*7+293)+5,length(sin((x+127)/163+RandomSeed*float2(13,5))))+.5)
	};
	return frac(c+x.x*2+RandomSeed+dot(c,1));
}
float3 dnoise3(float2 x,float RandomSeed){
	RandomSeed+=.00001;
	float3 c={
	mpfxh_dnoise1(float3((x+RandomSeed*13+41)+11,length(sin((x-59)/151+RandomSeed*float2(11,7))))+.5),
	mpfxh_dnoise1(float3((x+RandomSeed*7+293)+5,length(sin((x+127)/163+RandomSeed*float2(13,5))))+.5),
	mpfxh_dnoise1(float3((x+RandomSeed*5+113)+7,length(sin((x+191)/173+RandomSeed*float2(7,17))))+.5)
	};
	return frac(c+x.x*2+RandomSeed+dot(c,1));
}
float4 dnoise4(float2 x,float RandomSeed){
	RandomSeed+=.00001;
	float4 c={
	mpfxh_dnoise1(float3((x+RandomSeed*13+41)+11,length(sin((x-59)/151+RandomSeed*float2(11,7))))+.5),
	mpfxh_dnoise1(float3((x+RandomSeed*7+293)+5,length(sin((x+127)/163+RandomSeed*float2(13,5))))+.5),
	mpfxh_dnoise1(float3((x+RandomSeed*5+113)+7,length(sin((x+191)/173+RandomSeed*float2(7,17))))+.5),
	mpfxh_dnoise1(float3((x+RandomSeed*11+97)+13,length(sin((x-37)/181+RandomSeed*float2(5,23))))+.5)
	};
	return frac(c+x.x*2+RandomSeed+dot(c,1));
}
#endif