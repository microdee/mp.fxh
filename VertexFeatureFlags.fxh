#define VERTEXFEATUREFLAGS_FXH 1

#define FLAG_POSITION 0x1
#define FLAG_NORMAL 0x2
#define FLAG_PREVPOS 0x4
#define FLAG_TEXCOORD0 0x8
#define FLAG_TEXCOORD1 0x10
#define FLAG_TEXCOORD2 0x20
#define FLAG_TEXCOORD3 0x40
#define FLAG_TEXCOORD4 0x80
#define FLAG_TEXCOORD5 0x100
#define FLAG_TEXCOORD6 0x200
#define FLAG_TEXCOORD7 0x400
#define FLAG_TEXCOORD8 0x800
#define FLAG_TEXCOORD9 0x1000
#define FLAG_TANGENT 0x2000
#define FLAG_BINORMAL 0x4000
#define FLAG_SUBSETID 0x8000
#define FLAG_MATERIALID 0x10000
#define FLAG_INSTANCEID 0x20000
#define FLAG_SUBSETVERTEXID 0x40000
#define FLAG_FEATUREFLAGS 0x80000

#define MOD_BLENDSHAPE 0x80000000;
#define MOD_SKINNING 0x40000000;