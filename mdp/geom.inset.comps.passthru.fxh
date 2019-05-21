/*
    Passthrough inset for GeomFX for components of md.pipeline.geom.layout
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

OUTVAR.Pos = INVAR.Pos;

#if defined(NORMAL_IN) && defined(HAS_NORMAL)
OUTVAR.Norm = INVAR.Norm;
#endif

#include <packs/mp.fxh/mdp/geom.inset.uvPassthru.fxh>

#if defined(TANGENT_IN) && defined(HAS_TANGENT)
OUTVAR.Tan = INVAR.Tan;
OUTVAR.Bin = INVAR.Bin;
#endif

#if defined(BLENDWEIGHT_IN) && defined(HAS_BLENDWEIGHT)
OUTVAR.BlendId = INVAR.BlendId;
OUTVAR.BlendWeight = INVAR.BlendWeight;
#endif

#if defined(PREVPOS_IN) && defined(HAS_PREVPOS)
OUTVAR.ppos = INVAR.ppos;
#endif

#if defined(SUBSETID_IN) && defined(HAS_SUBSETID)
OUTVAR.sid = INVAR.sid;
#endif

#if defined(MATERIALID_IN) && defined(HAS_MATERIALID)
OUTVAR.mid = INVAR.mid;
#endif

#if defined(REAL_INSTANCEID) && defined(HAS_INSTANCEID)
OUTVAR.iid = INVAR.iid;
#elif defined(INSTANCEID_IN) && defined(HAS_INSTANCEID)
OUTVAR.iid = INVAR.iid;
#endif