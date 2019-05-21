#if !defined(mdp_geom_layout_fxh)
#define mdp_geom_layout_fxh 1

/*
	Geometry IO for md.pipeline
*/

#if !defined(TEXCOORDCOUNT) /// -type int -pin "-visibility OnlyInspector"
#define TEXCOORDCOUNT 0
#endif

#if TEXCOORDCOUNT > 0
#define TEXCOORD0_IN 1
#define HAS_TEXCOORD0 1
#endif
#if TEXCOORDCOUNT > 1
#define TEXCOORD1_IN 1
#define HAS_TEXCOORD1 1
#endif
#if TEXCOORDCOUNT > 2
#define TEXCOORD2_IN 1
#define HAS_TEXCOORD2 1
#endif
#if TEXCOORDCOUNT > 3
#define TEXCOORD3_IN 1
#define HAS_TEXCOORD3 1
#endif
#if TEXCOORDCOUNT > 4
#define TEXCOORD4_IN 1
#define HAS_TEXCOORD4 1
#endif
#if TEXCOORDCOUNT > 5
#define TEXCOORD5_IN 1
#define HAS_TEXCOORD5 1
#endif
#if TEXCOORDCOUNT > 6
#define TEXCOORD6_IN 1
#define HAS_TEXCOORD6 1
#endif
#if TEXCOORDCOUNT > 7
#define TEXCOORD7_IN 1
#define HAS_TEXCOORD7 1
#endif
#if TEXCOORDCOUNT > 8
#define TEXCOORD8_IN 1
#define HAS_TEXCOORD8 1
#endif
#if TEXCOORDCOUNT > 9
#define TEXCOORD9_IN 1
#define HAS_TEXCOORD9 1
#endif

/*
    Name for VS input struct
*/
#if !defined(MDL_VSIN)
#define MDL_VSIN VSin
#endif

/*
    Name for GS input struct
*/
#if !defined(MDL_GSIN)
#define MDL_GSIN GSin
#endif

struct VSin
{
#include <packs/mp.fxh/mdp/geom.inset.comps.in.fxh>
    #if defined(MDL_VSIN_EXTRA)
    MDL_VSIN_EXTRA
    #endif
};

struct GSin
{
#include <packs/mp.fxh/mdp/geom.inset.comps.out.fxh>
    #if defined(MDL_GSIN_EXTRA)
    MDL_GSIN_EXTRA
    #endif
};

#if defined(INSTANCEID_IN) || defined(REAL_INSTANCEID)
#define INSTANCED 1
#endif

#endif