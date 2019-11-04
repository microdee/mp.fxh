#if !defined(texture_parallaxOccMap_fxh)
#define texture_parallaxOccMap_fxh 1

#if !defined(POM_HEIGHT_COMP)
#define POM_HEIGHT_COMP r
#endif

#if !defined(POM_SAMPLECOUNT)
#define POM_SAMPLECOUNT 16 /// -type int -pin "-visibility OnlyInspector"
#endif

#if !defined(PSHAD_SAMPLECOUNT)
#define PSHAD_FACTOR 8 /// -type int -pin "-visibility OnlyInspector"
#define PSHAD_SAMPLECOUNT 8 /// -type int -pin "-visibility OnlyInspector"
#define PSHAD_LAYER_HEIGHT 0.125
#endif

#if defined(POM_HEIGHTMAP_ARRAY)
#define POM_UV(inuv) float3(inuv, slice)
#else
#define POM_UV(inuv) inuv
#endif

/*
    Offset a texcoord via parallax occlusion mapping,
    view dir should be in tangent space already
    (use EyeDirToTangentSpace of math/vectors.fxh)

    stolen and generalized from SuperPhysical by Michael Burk
    https://github.com/michael-burk/SuperPhysical/blob/master/nodes/dx11/ParallaxOcclusionMapping.fxh
*/
void ParallaxOccMap(

#if defined(POM_HEIGHTMAP_ARRAY)
    Texture2DArray heightMapIn, SamplerState samplerIn, float slice,
#else
    Texture2D heightMapIn, SamplerState samplerIn,
#endif

    inout float2 texcoord, float3 tanV, float fHeightMapScale)
{
    float fParallaxLimit = -length( tanV.xy ) / tanV.z;
	
	fParallaxLimit *= -fHeightMapScale;
    
    float2 vOffsetDir = normalize( tanV.xy );
    float2 vMaxOffset = vOffsetDir * fParallaxLimit;
	
   	float fStepSize = 1.0 / POM_SAMPLECOUNT;
    
    float2 dx = ddx( texcoord );
    float2 dy = ddy( texcoord );
    
    float fCurrRayHeight = 1.0;
    float2 vCurrOffset = float2( 0, 0 );
    float2 vLastOffset = float2( 0, 0 );
    
    float fLastSampledHeight = 1;
    float fCurrSampledHeight = 1;

    uint nCurrSample = 0;
    
    float delta1;
	float delta2;
	float ratio;

    while ( nCurrSample < POM_SAMPLECOUNT )
    {
        fCurrSampledHeight = heightMapIn.SampleGrad(
            samplerIn,
            POM_UV(texcoord + vCurrOffset),
            dx, dy
        ).POM_HEIGHT_COMP;

        if ( fCurrSampledHeight > fCurrRayHeight )
        {
            delta1 = fCurrSampledHeight - fCurrRayHeight;
            delta2 = ( fCurrRayHeight + fStepSize ) - fLastSampledHeight;

            ratio = delta1/(delta1+delta2);

            vCurrOffset = (ratio) * vLastOffset + (1.0-ratio) * vCurrOffset;

            nCurrSample = POM_SAMPLECOUNT + 1;
        }
        else
        {
            nCurrSample++;

            fCurrRayHeight -= fStepSize;

            vLastOffset = vCurrOffset;
            vCurrOffset += fStepSize * vMaxOffset;

            fLastSampledHeight = fCurrSampledHeight;
        }
    }
	texcoord += vCurrOffset;
}

/*
    Cast surface self-shadows based on a height map,
    light dir should be in tangent space already
    (use LightDirToTangentSpace of math/vectors.fxh)
    
    stolen and generalized from SuperPhysical by Michael Burk
    https://github.com/michael-burk/SuperPhysical/blob/master/nodes/dx11/ParallaxOcclusionMapping.fxh
*/
float ParallaxShadows(

#if defined(POM_HEIGHTMAP_ARRAY)
    Texture2DArray heightMapIn, SamplerState samplerIn, float slice,
#else
    Texture2D heightMapIn, SamplerState samplerIn,
#endif

    in float2 initialTexCoord,
    in float3 tanL, float fHeightMapScale, float factor)
{
    float shadowMultiplier = 0;

    // calculate lighting only for surface oriented to the light source
    //if(dot(float3(0, 0, 1), tanL) > 0)
    //{
        // calculate initial parameters
        float numSamplesUnderSurface = 0;
        shadowMultiplier = 0;

        float startHeight = heightMapIn.SampleGrad(
            samplerIn, POM_UV(initialTexCoord),
            ddx( initialTexCoord ),
            ddy( initialTexCoord )
        ).POM_HEIGHT_COMP;

        float2 texStep	= fHeightMapScale * tanL.xy / (tanL.z + (tanL.z == 0) ) * PSHAD_LAYER_HEIGHT;

        // current parameters
        float currentLayerHeight = 1 - startHeight - PSHAD_LAYER_HEIGHT;
        float2 currentTextureCoords	= initialTexCoord + texStep;

        float heightFromTexture	= 1 - heightMapIn.SampleGrad(
            samplerIn, POM_UV(currentTextureCoords),
            ddx( currentTextureCoords ),
            ddy( currentTextureCoords )
        ).POM_HEIGHT_COMP;

        float stepIndex	= 1;

        while(currentLayerHeight > 0)
        {
            if(heightFromTexture < currentLayerHeight)
            {
                // calculate partial shadowing factor
                numSamplesUnderSurface	+= 1;
                float newShadowMultiplier	= (currentLayerHeight - heightFromTexture) * (1 - stepIndex * PSHAD_LAYER_HEIGHT);
                shadowMultiplier = (max(shadowMultiplier, newShadowMultiplier * PSHAD_FACTOR * (1 - stepIndex * PSHAD_LAYER_HEIGHT)));
            }

            // offset to the next layer
            stepIndex	+= 1;
            currentLayerHeight	-= PSHAD_LAYER_HEIGHT;
            currentTextureCoords	+= texStep;
            //         heightFromTexture	= 1 - heightMapIn.SampleGrad( samplerIn, float3(currentTextureCoords, texID), ddx( currentTextureCoords ), ddy( currentTextureCoords ) ).r;
        }

        // Shadowing factor should be 1 if there were no points under the surface
        shadowMultiplier = lerp(
            1.0 - shadowMultiplier * factor, 1,
            numSamplesUnderSurface < 1
        );
    //}
    return saturate(shadowMultiplier);
}

#endif