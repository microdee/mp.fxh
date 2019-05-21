
/*
	Inset fxh for passing through texcoords of md.pipeline.geom.layout
*/

/*
	Identifier intended to hold the output structure
*/
#if !defined(OUTVAR)
#define OUTVAR output
#endif

/*
	Identifier intended to hold the input structure
*/
#if !defined(INVAR)
#define INVAR input
#endif

#if defined(TEXCOORD0_IN) && defined(HAS_TEXCOORD0)
	OUTVAR.Uv0 = INVAR.Uv0;
#endif
#if defined(TEXCOORD1_IN) && defined(HAS_TEXCOORD1)
	OUTVAR.Uv1 = INVAR.Uv1;
#endif
#if defined(TEXCOORD2_IN) && defined(HAS_TEXCOORD2)
	OUTVAR.Uv2 = INVAR.Uv2;
#endif
#if defined(TEXCOORD3_IN) && defined(HAS_TEXCOORD3)
	OUTVAR.Uv3 = INVAR.Uv3;
#endif
#if defined(TEXCOORD4_IN) && defined(HAS_TEXCOORD4)
	OUTVAR.Uv4 = INVAR.Uv4;
#endif
#if defined(TEXCOORD5_IN) && defined(HAS_TEXCOORD5)
	OUTVAR.Uv5 = INVAR.Uv5;
#endif
#if defined(TEXCOORD6_IN) && defined(HAS_TEXCOORD6)
	OUTVAR.Uv6 = INVAR.Uv6;
#endif
#if defined(TEXCOORD7_IN) && defined(HAS_TEXCOORD7)
	OUTVAR.Uv7 = INVAR.Uv7;
#endif
#if defined(TEXCOORD8_IN) && defined(HAS_TEXCOORD8)
	OUTVAR.Uv8 = INVAR.Uv8;
#endif
#if defined(TEXCOORD9_IN) && defined(HAS_TEXCOORD9)
	OUTVAR.Uv9 = INVAR.Uv9;
#endif