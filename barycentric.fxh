#if !defined(BARYCENTRIC_FXH)
#define BARYCENTRIC_FXH 1


float3 BC(float3 input[3] , float3 uv)
{
	for(uint i=0 ; i<3; i++)
	{
		float3 p = uv.x * input[i]
        + uv.y * input[i]
        + uv.z * input[i];
    }
    return p; 	
}

#endif