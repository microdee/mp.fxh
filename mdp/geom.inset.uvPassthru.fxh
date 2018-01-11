
#if !defined(OUTVAR)
#define OUTVAR output
#endif
#if !defined(INVAR)
#define INVAR input
#endif

#if defined(TEXCOORD0_IN) && defined(HAS_TEXCOORD0)
	OUTVAR.TexCd0 = INVAR.TexCd0;
#endif
#if defined(TEXCOORD1_IN) && defined(HAS_TEXCOORD1)
	OUTVAR.TexCd1 = INVAR.TexCd1;
#endif
#if defined(TEXCOORD2_IN) && defined(HAS_TEXCOORD2)
	OUTVAR.TexCd2 = INVAR.TexCd2;
#endif
#if defined(TEXCOORD3_IN) && defined(HAS_TEXCOORD3)
	OUTVAR.TexCd3 = INVAR.TexCd3;
#endif
#if defined(TEXCOORD4_IN) && defined(HAS_TEXCOORD4)
	OUTVAR.TexCd4 = INVAR.TexCd4;
#endif
#if defined(TEXCOORD5_IN) && defined(HAS_TEXCOORD5)
	OUTVAR.TexCd5 = INVAR.TexCd5;
#endif
#if defined(TEXCOORD6_IN) && defined(HAS_TEXCOORD6)
	OUTVAR.TexCd6 = INVAR.TexCd6;
#endif
#if defined(TEXCOORD7_IN) && defined(HAS_TEXCOORD7)
	OUTVAR.TexCd7 = INVAR.TexCd7;
#endif
#if defined(TEXCOORD8_IN) && defined(HAS_TEXCOORD8)
	OUTVAR.TexCd8 = INVAR.TexCd8;
#endif
#if defined(TEXCOORD9_IN) && defined(HAS_TEXCOORD9)
	OUTVAR.TexCd9 = INVAR.TexCd9;
#endif