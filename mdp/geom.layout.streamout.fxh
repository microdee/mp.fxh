#if !defined(mdp_geom_layout_streamout_fxh)
#define mdp_geom_layout_streamout_fxh 1

#if !defined MDL_GS_FUNC
#define MDL_GS_FUNC GS
#endif

GeometryShader MdpGeomLayoutStreamout = ConstructGSWithSO( CompileShader( gs_5_0, MDL_GS_FUNC() ),
#if defined(STREAMOUTLAYOUT)
    STREAMOUTLAYOUT
#else
	"POSITION.xyz"
    #if defined(HAS_NORMAL)
	    ";NORMAL.xyz"
    #endif
    #if defined(HAS_TEXCOORD0)
        ";TEXCOORD0.xy"
    #endif
    #if defined(HAS_TEXCOORD1)
        ";TEXCOORD1.xy"
    #endif
    #if defined(HAS_TEXCOORD2)
        ";TEXCOORD2.xy"
    #endif
    #if defined(HAS_TEXCOORD3)
        ";TEXCOORD3.xy"
    #endif
    #if defined(HAS_TEXCOORD4)
        ";TEXCOORD4.xy"
    #endif
    #if defined(HAS_TEXCOORD5)
        ";TEXCOORD5.xy"
    #endif
    #if defined(HAS_TEXCOORD6)
        ";TEXCOORD6.xy"
    #endif
    #if defined(HAS_TEXCOORD7)
        ";TEXCOORD7.xy"
    #endif
    #if defined(HAS_TEXCOORD8)
        ";TEXCOORD8.xy"
    #endif
    #if defined(HAS_TEXCOORD9)
        ";TEXCOORD9.xy"
    #endif
	#if defined(HAS_TANGENT)
		";TANGENT.xyz"
		";BINORMAL.xyz"
	#endif
	#if defined(HAS_BLENDWEIGHT)
		";BLENDINDICES.xyzw"
		";BLENDWEIGHT.xyzw"
	#endif
	#if defined(HAS_PREVPOS)
		";PREVPOS.xyz"
	#endif
    #if defined(HAS_SUBSETID)
        ";SUBSETID.x"
    #endif
    #if defined(HAS_MATERIALID)
        ";MATERIALID.x"
    #endif
    #if defined(HAS_INSTANCEID)
        ";INSTANCEID.x"
    #endif
#endif
);

#endif