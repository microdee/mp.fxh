#if !defined(mdp_mdp_fxh)
#define mdp_mdp_fxh

/*
	this fxh provides common VS, GS and tessellation for rendering triangular geometry with your own PS or GeomFX.
	define MDP_GEOMFX to use this fxh for streamout shaders and GeomFX nodes.
*/

// see structs and common global variables defines here:
#include <packs/mp.fxh/mdp/structs.fxh>
#include <packs/mp.fxh/math/vectors.fxh>
#include <packs/mp.fxh/texture/displaceNormal.fxh>
#include <packs/mp.fxh/math/const.fxh>

/*
	The main TEXCOORD which is used for the main texture input
*/
#if !defined(MDP_MAINUVLAYER) /// -type token -pin "-visibility Hidden"
#define MDP_MAINUVLAYER TEXCOORD0
#endif

#if defined(TESSELLATE) /// -type switch
#include <packs/mp.fxh/mdp/geom.pnTriangles.fxh>
#endif

VSOUTPUTTYPE MDP_VS(MDP_VSIN input)
{
	VSOUTPUTTYPE output = (VSOUTPUTTYPE)0;

	uint ssid = 0;
	uint mid = 0;
	uint iid = 0;

	#if defined(HAS_INSTANCEID) || defined(USE_SVINSTANCEID)
		iid = input.iid;
	#endif
	#if defined(HAS_SUBSETID)
		ssid = input.ssid;
	#endif
	#if defined(HAS_MATERIALID)
		mid = input.mid;
	#endif

	output.sid = ssid;
	output.mid = mid;
	output.iid = iid;

	/*
		MDP_VS_PRE is for custom VS preparation
	*/
	#if defined(MDP_VS_PRE)
	MDP_VS_PRE
	#endif

	#if defined(HAS_TEXCOORD0)
	    output.UV = mul(float4(input.UV, 0, 1), tTex).xy;
	    float2 puv = mul(float4(input.UV, 0, 1), ptTex).xy;
	#else
	    output.UV = 0;
	    float2 puv = 0;
	#endif

	float4x4 w = UNIT_MATRIX;
	#if defined(USE_SUBSETTRANSFORMS) && !defined(IGNORE_BUFFERS) /// -type switch
		w = Tr[ssid];
	#endif
	#if defined(HAS_INSTANCEID) || defined(USE_SVINSTANCEID)
		w = mul(w, iTr[iid]);
	#endif
	w = mul(w, tW);

	float4x4 pw = UNIT_MATRIX;
	#if defined(USE_SUBSETTRANSFORMS) && !defined(IGNORE_BUFFERS)
		pw = mul(pw, pTr[ssid]);
	#endif
	#if defined(HAS_INSTANCEID) || defined(USE_SVINSTANCEID)
		pw = mul(pw, ipTr[iid]);
	#endif
	pw = mul(pw, ptW);

	#if defined(TESSELLATE)
		output.Norm = normalize(mul(float4(input.Norm,0), w).xyz);
		#if defined(INV_NORMALS) /// -type switch
			output.Norm *= -1;
		#endif

		output.Pos = mul(float4(input.Pos,1), w).xyz;

	    #if defined(HAS_TANGENT)
			float4 intan = input.Tan;
			float4 inbin = input.Bin;
		    output.Tan = normalize(mul(float4(input.Tan.xyz,0), w).xyz);
		    output.Bin = normalize(mul(float4(input.Bin.xyz,0), w).xyz);
			#if defined(HAS_TANGENT_WINDING) /// -type switch -pin "-visibility OnlyInspector"
			    output.Tan *= -intan.w;
			    output.Bin *= -inbin.w;
		    #endif
			#if defined(INV_NORMALS)
				output.Tan *= -1;
				output.Bin *= -1;
			#endif
		#else
			float3x3 guessedTanSpace = GuessTangentSpace(input.Norm);
		    output.Tan = normalize(mul(float4(guessedTanSpace[0],0), w).xyz);
		    output.Bin = normalize(mul(float4(guessedTanSpace[1],0), w).xyz);
		#endif

	    float3 pp = input.Pos;
	    #if defined(HAS_PREVPOS)
	    	pp = input.ppos;
	    #endif

		output.ppos = mul(float4(pp,1), pw).xyz;
	    #if defined(HAS_TANGENT)
		    output.ppos += output.Tan * (output.UV.x-puv.x);
		    output.ppos += output.Bin * (output.UV.y-puv.y);
		#endif
	#else
		#if defined(MDP_GEOMFX)
    		float4x4 tWV = w;
		#else
    		float4x4 tWV = mul(w, tV);
		#endif

		output.Norm = normalize(mul(float4(input.Norm,0), tWV).xyz);
		#if defined(INV_NORMALS)
			output.Norm *= -1;
		#endif
		float2 disp = 0;
		if(Displace.x > 0.0001)
			disp = DispMap.SampleLevel(sT, output.UV, 0).rg;
		
		float3 posi = input.Pos + disp.r * input.Norm * Displace.x;
		#if defined(MDP_GEOMFX)
			output.Pos = mul(float4(posi,1), w).xyz;
		#else
			output.svpos = mul(float4(posi,1), w);
			output.posw = output.svpos.xyz;
			output.svpos = mul(output.svpos, tV);
			output.svpos = mul(output.svpos, tP);
			output.pspos = output.svpos;
		#endif

	    #if defined(HAS_TANGENT)
			float4 intan = input.Tan;
			float4 inbin = input.Bin;
			if(length(intan.xyz) <= 0.0001 || length(inbin.xyz) <= 0.0001)
			{
				intan = float4(1,0,0,1);
				inbin = float4(0,1,0,1);
			}
		    output.Tan = normalize(mul(float4(intan.xyz,0), tWV).xyz);
		    output.Bin = normalize(mul(float4(inbin.xyz,0), tWV).xyz);
			#if defined(HAS_TANGENT_WINDING)
			    output.Tan *= -intan.w;
			    output.Bin *= -inbin.w;
		    #endif
			#if defined(INV_NORMALS)
				output.Tan *= -1;
				output.Bin *= -1;
			#endif
		#else
			float3x3 guessedTanSpace = GuessTangentSpace(input.Norm);
		    output.Tan = normalize(mul(float4(guessedTanSpace[0],0), tWV).xyz);
		    output.Bin = normalize(mul(float4(guessedTanSpace[1],0), tWV).xyz);
		#endif
		if(Displace.x > 0.0001)
		{
			TangentSpace nt = (TangentSpace)0;
			nt.n = output.Norm;
			nt.t = output.Tan;
			nt.b = output.Bin;
			TangentSpace rnt = SampleDisplaceNormalTangents(nt, DispMap, sT, output.UV, 0.01, Displace.x * DisplaceNormalInfluence, 0);
			output.Norm = rnt.n;
			output.Tan = rnt.t;
			output.Bin = rnt.b;
		}

	    float3 pp = input.Pos;
	    #if defined(HAS_PREVPOS)
	    	pp = input.ppos;
	    #endif
		pp += disp.g * input.Norm * Displace.y;

		output.ppos = mul(float4(pp,1), pw);
		output.ppos = mul(output.ppos, ptV);

	    #if defined(HAS_TANGENT)
		#if defined(MDP_GEOMFX)
		    output.ppos += output.Tan * (output.UV.x-puv.x);
		    output.ppos += output.Bin * (output.UV.y-puv.y);
		#else
		    output.ppos.xyz += output.Tan * (output.UV.x-puv.x);
		    output.ppos.xyz += output.Bin * (output.UV.y-puv.y);
		#endif
		#endif

		output.ppos = mul(output.ppos, ptP);
	#endif
	
	/*
		MDP_VS_POST is for custom VS finalization
	*/
	#if defined(MDP_VS_POST)
	MDP_VS_POST
	#endif
	return output;
}

[maxvertexcount(3)]
void MDP_GS(triangle GSOUTPUTTYPE input[3], inout TriangleStream<GSOUTPUTTYPE> gsout)
{
	GSOUTPUTTYPE o = (GSOUTPUTTYPE)0;

	/*
		MDP_GS_PERPRIMITIVE_PRE is for custom GS preparation
	*/
	#if defined(MDP_GS_PERPRIMITIVE_PRE)
	MDP_GS_PERPRIMITIVE_PRE
	#endif

	#if defined(MDP_GEOMFX)
	float3 f1 = input[1].Pos - input[0].Pos;
    float3 f2 = input[2].Pos - input[0].Pos;
	#else
	float3 f1 = input[1].posw.xyz - input[0].posw.xyz;
    float3 f2 = input[2].posw.xyz - input[0].posw.xyz;
	#endif

	float3 norm = 0;
	
	/*
		if defined normals will be calculated in GS
	*/
	#if defined(FLATNORMALS) /// -type switch
		norm = normalize(cross(f1, f2));

		#if !defined(MDP_GEOMFX)
			norm = mul(float4(norm, 0), tV).xyz;
		#endif
	#endif

	/*
		if tangents are not present calculate them based on triangle UV's
	*/
	#if !defined(HAS_TANGENT) && defined(HAS_TEXCOORD0)
		float2 uU = input[1].UV - input[0].UV;
	    float2 uV = input[2].UV - input[0].UV;
		float2x3 ts1 = (1/(uU.x*uV.y - uU.y*uV.x)) * mul(float2x2(uV.y, -uU.y, -uV.x, uU.x), float2x3(f1, f2));
		float3 tangent = ts1[0];
		float area = determinant(float2x2(uV, uU));
		tangent = area < 0 ? -tangent : tangent;

		#if !defined(MDP_GEOMFX)
			tangent = mul(float4(tangent,0), tV).xyz;
		#endif
		#if defined(INV_NORMALS)
			tangent *= -1;
		#endif
	#endif

	/*
		MDP_GS_PERPRIMITIVE_POST is for custom GS finalization
	*/
	#if defined(MDP_GS_PERPRIMITIVE_POST)
	MDP_GS_PERPRIMITIVE_POST
	#endif
	
	for(uint i=0; i<3; i++)
	{
		/*
			MDP_GS_PERVERTEX_PRE is for custom per-vertex GS preparation
		*/
		#if defined(MDP_GS_PERVERTEX_PRE)
		MDP_GS_PERVERTEX_PRE
		#endif

		o = input[i];
		#if defined(FLATNORMALS)
			o.Norm = norm;
		#else
			o.Norm = input[i].Norm;
		#endif
		#if !defined(HAS_TANGENT) && defined(HAS_TEXCOORD0)
			o.Tan = normalize(tangent);
			o.Bin = cross(o.Tan, o.Norm);
		#endif

		/*
			MDP_GS_PERVERTEX_PRE is for custom per-vertex GS finalization
		*/
		#if defined(MDP_GS_PERVERTEX_POST)
		MDP_GS_PERVERTEX_POST
		#endif

		gsout.Append(o);
	}
	gsout.RestartStrip();
}

#endif