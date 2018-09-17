
/*
    Name for PS input struct
*/
#if !defined(MDP_PSIN)
#define MDP_PSIN PSin
#endif

/*
    Name for VS input struct
*/
#if !defined(MDP_VSIN)
#define MDP_VSIN VSin
#endif

/*
    Name for Hull/Domain shader input struct
*/
#if !defined(MDP_HDSIN)
#define MDP_HDSIN HDSin
#endif

/*
    Name for Hull constant input struct
*/
#if !defined(MDP_HSCONST)
#define MDP_HSCONST hsconst
#endif

/*
    Name of VS func
*/
#if !defined(MDP_VS)
#define MDP_VS VS
#endif

/*
    Name of GS func
*/
#if !defined(MDP_GS)
#define MDP_GS GS
#endif

/*
    Name of HS func
*/
#if !defined(MDP_HS)
#define MDP_HS HS
#endif

/*
    Name of HS const func
*/
#if !defined(MDP_HSC) && !defined(MDP_HSC_STRING)
#define MDP_HSC HSC
#define MDP_HSC_STRING "HSC"
#endif

/*
    Register of the Per-draw cbuffer
*/
#if !defined(MDP_CBPERDRAW_REGISTER)
#define MDP_CBPERDRAW_REGISTER b1
#endif

/*
    Register of the Per-object cbuffer
*/
#if !defined(MDP_CBPEROBJ_REGISTER)
#define MDP_CBPEROBJ_REGISTER b2
#endif