#if !defined(RWBYTEADDRESSBUFFERUTILS_FXH)
#define RWBYTEADDRESSBUFFERUTILS_FXH

float RWBABLoad(RWByteAddressBuffer bab, uint i) { return asfloat(bab.Load( i*4 )); }
float2 RWBABLoad2(RWByteAddressBuffer bab, uint i) { return asfloat(bab.Load2( i*4 )); }
float3 RWBABLoad3(RWByteAddressBuffer bab, uint i) { return asfloat(bab.Load3( i*4 )); }
float4 RWBABLoad4(RWByteAddressBuffer bab, uint i) { return asfloat(bab.Load4( i*4 )); }
float4x4 RWBABLoad4x4(RWByteAddressBuffer bab, uint ii)
{
    float4x4 tmp = 0;
    [unroll]
    for(uint i=0; i<4; i++)
    {
        [unroll]
        for(uint j=0; j<4; j++)
        {
            tmp[i][j] = asfloat(bab.Load( ii*64 + i*16 + j*4 ));
        }
    }
    return tmp;
}

void RWBABStore(RWByteAddressBuffer bab, uint i, float src) { bab.Store( i*4, asuint(src) ); }
void RWBABStore2(RWByteAddressBuffer bab, uint i, float2 src) { bab.Store2( i*4, asuint(src) ); }
void RWBABStore3(RWByteAddressBuffer bab, uint i, float3 src) { bab.Store3( i*4, asuint(src) ); }
void RWBABStore4(RWByteAddressBuffer bab, uint i, float4 src) { bab.Store4( i*4, asuint(src) ); }
void RWBABStore4x4(RWByteAddressBuffer bab, uint ii, float4x4 src)
{
    [unroll]
    for(uint i=0; i<4; i++)
    {
        [unroll]
        for(uint j=0; j<4; j++)
        {
            bab.Store( ii*64 + i*16 + j*4, asuint(src[i][j]));
        }
    }
}
void InterlockedAddFloat(RWByteAddressBuffer bab, uint addr, float value)
{
    uint comp,orig = bab.Load(addr);
    [allow_uav_condition]do
    {
        bab.InterlockedCompareExchange(addr, comp = orig, asuint(asfloat(orig) + value), orig);
    }
    while(orig != comp);
}
void InterlockedAddFloat(RWByteAddressBuffer bab, uint addr, float2 value)
{
    InterlockedAddFloat(bab, addr + 0, value.x);
    InterlockedAddFloat(bab, addr + 4, value.y);
}
void InterlockedAddFloat(RWByteAddressBuffer bab, uint addr, float3 value)
{
    InterlockedAddFloat(bab, addr + 0, value.x);
    InterlockedAddFloat(bab, addr + 4, value.y);
    InterlockedAddFloat(bab, addr + 8, value.z);
}
void InterlockedAddFloat(RWByteAddressBuffer bab, uint addr, float4 value)
{
    InterlockedAddFloat(bab, addr + 0, value.x);
    InterlockedAddFloat(bab, addr + 4, value.y);
    InterlockedAddFloat(bab, addr + 8, value.z);
    InterlockedAddFloat(bab, addr + 12, value.w);
}
#endif