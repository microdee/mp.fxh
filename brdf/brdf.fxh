#if !defined(brdf_brdf_fxh)
#define brdf_brdf_fxh
#include <packs/mp.fxh/math/pows.fxh>
#include <packs/mp.fxh/math/safeDivide.fxh>

#if !defined(PI)
#define PI 3.14159265358979323846
#endif

#if !defined(BRDF_ARGSDEF)
#define BRDF_ARGSDEF
#define BRDF_ARGSPASS
#endif

interface iBrdf
{
	/*
	return color
	args: L light dir, V view dir, N normal, X tangent, Y binormal
	*/
	float3 brdf(float3 L, float3 V, float3 N, float3 X, float3 Y BRDF_ARGSDEF);
};

// Ashikhman-Shirley

#if !defined(BRDF_PARAM_AshikminShirley_Rs)
#define BRDF_PARAM_AshikminShirley_Rs 0.1
#define BRDF_PARAM_AshikminShirley_Rd 1
#define BRDF_PARAM_AshikminShirley_nu 100
#define BRDF_PARAM_AshikminShirley_nv 100
#define BRDF_PARAM_AshikminShirley_isotropic true
#endif
#if !defined(BRDF_DEF_AshikminShirley_isotropic)
#define BRDF_DEF_AshikminShirley_coupled_diffuse true
#endif

float sqr(float x)
{
	return x * x;
}

float Fresnel(float f0, float u)
{
    // from Schlick
	return f0 + (1 - f0) * pow(1 - u, 5);
}

class cAshikminShirley : iBrdf
{
	float3 brdf(float3 L, float3 V, float3 N, float3 X, float3 Y BRDF_ARGSDEF)
	{
		float Rs = BRDF_PARAM_AshikminShirley_Rs;
		float Rd = BRDF_PARAM_AshikminShirley_Rd;
		float nu = BRDF_PARAM_AshikminShirley_nu;
		float nv = BRDF_PARAM_AshikminShirley_nv;
		bool isotropic = BRDF_PARAM_AshikminShirley_isotropic;

		float3 H = normalize(L + V);
		float HdotV = dot(H, V);
		float HdotX = dot(H, X);
		float HdotY = dot(H, Y);
		float NdotH = dot(N, H);
		float NdotV = dot(N, V);
		float NdotL = dot(N, L);
    
		float F = Fresnel(Rs, HdotV);
		float norm_s = sqrt((nu + 1) * ((isotropic ? nu : nv) + 1)) / (8 * PI);
		float n = isotropic ? nu : (nu * sqr(HdotX) + nv * sqr(HdotY)) / (1 - sqr(NdotH));
		float rho_s = norm_s * F * pow(max(NdotH, 0), n) / (HdotV * max(NdotV, NdotL));

		float rho_d = 28 / (23 * PI) * Rd * (1 - pow(1 - NdotV / 2, 5)) * (1 - pow(1 - NdotL / 2, 5));
		#if BRDF_DEF_AshikminShirley_coupled_diffuse
			rho_d *= (1 - Rs);
		#endif

		return rho_s + rho_d;
	}
};
cAshikminShirley AshikminShirley;

// Blinn

#if !defined(BRDF_PARAM_Blinn_n)
#define BRDF_PARAM_Blinn_n 10
#define BRDF_PARAM_Blinn_ior 1.5
#define BRDF_PARAM_Blinn_include_Fresnel false
#endif
#if !defined(BRDF_DEF_Blinn_divide_by_NdotL)
#define BRDF_DEF_Blinn_divide_by_NdotL true
#endif
class cBlinn : iBrdf
{
	float3 brdf(float3 L, float3 V, float3 N, float3 X, float3 Y BRDF_ARGSDEF)
	{
		float n = BRDF_PARAM_Blinn_n;
		float ior = BRDF_PARAM_Blinn_ior;
		bool include_Fresnel = BRDF_PARAM_Blinn_include_Fresnel;
		float3 H = normalize(L + V);

		float NdotH = dot(N, H);
		float VdotH = dot(V, H);
		float NdotL = dot(N, L);
		float NdotV = dot(N, V);

		float x = acos(NdotH) * n;
		float D = exp(-x * x);
		float G = (NdotV < NdotL) ?
        ((2 * NdotV * NdotH < VdotH) ?
         2 * NdotH / VdotH :
         1.0 / NdotV)
        :
        ((2 * NdotL * NdotH < VdotH) ?
         2 * NdotH * NdotL / (VdotH * NdotV) :
         1.0 / NdotV);

    // fresnel
		float c = VdotH;
		float g = sqrt(ior * ior + c * c - 1);
		float F = 0.5 * pow(g - c, 2) / pow(g + c, 2) * (1 + pow(c * (g + c) - 1, 2) / pow(c * (g - c) + 1, 2));

		float val = NdotH < 0 ? 0.0 : D * G * (include_Fresnel ? F : 1.0);

#if BRDF_DEF_Blinn_divide_by_NdotL
		val = val / dot(N, L);
#endif
		return val;
	}
};
cBlinn Blinn;

// BlinnPhong

#if !defined(BRDF_PARAM_BlinnPhong_n)
#define BRDF_PARAM_BlinnPhong_n 100
#endif
#if !defined(BRDF_DEF_BlinnPhong_divide_by_NdotL)
#define BRDF_DEF_BlinnPhong_divide_by_NdotL true
#endif
class cBlinnPhong : iBrdf
{
	float3 brdf(float3 L, float3 V, float3 N, float3 X, float3 Y BRDF_ARGSDEF)
	{
		float3 H = normalize(L + V);
		float val = pow(max(0, dot(N, H)), BRDF_PARAM_BlinnPhong_n);
#if BRDF_DEF_BlinnPhong_divide_by_NdotL
		val = val / dot(N, L);
#endif
		return val;
	}
};
cBlinnPhong BlinnPhong;

// CookTorrance

#if !defined(BRDF_PARAM_CookTorrance_m)
#define BRDF_PARAM_CookTorrance_m 0.1
#define BRDF_PARAM_CookTorrance_f0 0.1
#endif
#if !defined(BRDF_DEF_CookTorrance_include_F)
#define BRDF_DEF_CookTorrance_include_F true
#define BRDF_DEF_CookTorrance_include_G true
#endif

float Beckmann(float m, float t)
{
	float M = m * m;
	float T = t * t;
	return exp((T - 1) / (M * T)) / (M * T * T);
}
class cCookTorrance : iBrdf
{
	float3 brdf(float3 L, float3 V, float3 N, float3 X, float3 Y BRDF_ARGSDEF)
	{
		float m = BRDF_PARAM_CookTorrance_m;
		float f0 = BRDF_PARAM_CookTorrance_f0;
		// compute the half
		float3 H = normalize(L + V);

		float NdotH = dot(N, H);
		float VdotH = dot(V, H);
		float NdotL = dot(N, L);
		float NdotV = dot(N, V);
		float oneOverNdotV = 1.0 / NdotV;

		float D = Beckmann(m, NdotH);
		float F = Fresnel(f0, VdotH);

		NdotH = NdotH + NdotH;
		float G = (NdotV < NdotL) ?
        ((NdotV * NdotH < VdotH) ?
         NdotH / VdotH :
         oneOverNdotV)
        :
        ((NdotL * NdotH < VdotH) ?
         NdotH * NdotL / (VdotH * NdotV) :
         oneOverNdotV);

		#if BRDF_DEF_CookTorrance_include_G
			G = oneOverNdotV;
		#endif
		float val = NdotH < 0 ? 0.0 : D * G;

		#if BRDF_DEF_CookTorrance_include_F
			val *= F;
		#endif
		val = val / NdotL;
		return val;
	}
};
cCookTorrance CookTorrance;

// Disney

#if !defined(BRDF_PARAM_Disney_roughness)
#define BRDF_PARAM_Disney_baseColor 1
#define BRDF_PARAM_Disney_metallic 0
#define BRDF_PARAM_Disney_subsurface 0
#define BRDF_PARAM_Disney_specular 0.5
#define BRDF_PARAM_Disney_roughness 0.5
#define BRDF_PARAM_Disney_specularTint 0
#define BRDF_PARAM_Disney_anisotropic 0
#define BRDF_PARAM_Disney_sheen 0
#define BRDF_PARAM_Disney_sheenTint 0.5
#define BRDF_PARAM_Disney_clearcoat 0
#define BRDF_PARAM_Disney_clearcoatGloss 1
#endif

float SchlickFresnel(float u)
{
	float m = clamp(1 - u, 0, 1);
	float m2 = m * m;
	return m2 * m2 * m; // pow(m,5)
}

float GTR1(float NdotH, float a)
{
	if (a >= 1)
		return 1 / PI;
	float a2 = a * a;
	float t = 1 + (a2 - 1) * NdotH * NdotH;
	return (a2 - 1) / (PI * log(a2) * t);
}

float GTR2(float NdotH, float a)
{
	float a2 = a * a;
	float t = 1 + (a2 - 1) * NdotH * NdotH;
	return a2 / (PI * t * t);
}

float GTR2_aniso(float NdotH, float HdotX, float HdotY, float ax, float ay)
{
	return sdiv(1, PI * ax * ay * sqr(sqr(HdotX / ax) + sqr(HdotY / ay) + NdotH * NdotH));
}

float smithG_GGX(float NdotV, float alphaG)
{
	float a = alphaG * alphaG;
	float b = NdotV * NdotV;
	return 1 / (NdotV + pows(a + b - a * b, 0.5));
}

float smithG_GGX_aniso(float NdotV, float VdotX, float VdotY, float ax, float ay)
{
	return sdiv(1, NdotV + pows(sqr(VdotX * ax) + sqr(VdotY * ay) + sqr(NdotV), 0.5));
	//return 1 / (NdotV + pows(sqr(VdotX * ax) + sqr(VdotY * ay) + sqr(NdotV), 0.5));
}

float3 mon2lin(float3 x)
{
	return float3(pows(x[0], 2.2), pows(x[1], 2.2), pows(x[2], 2.2));
}

class cDisney : iBrdf
{
	float3 brdf(float3 L, float3 V, float3 N, float3 X, float3 Y BRDF_ARGSDEF)
	{
		
		float3 baseColor = BRDF_PARAM_Disney_baseColor;
		float metallic = BRDF_PARAM_Disney_metallic;
		float subsurface = BRDF_PARAM_Disney_subsurface;
		float specular = BRDF_PARAM_Disney_specular;
		float roughness = BRDF_PARAM_Disney_roughness + 0.0280;
		float specularTint = BRDF_PARAM_Disney_specularTint;
		float anisotropic = BRDF_PARAM_Disney_anisotropic;
		float sheen = BRDF_PARAM_Disney_sheen;
		float sheenTint = BRDF_PARAM_Disney_sheenTint;
		float clearcoat = BRDF_PARAM_Disney_clearcoat;
		float clearcoatGloss = BRDF_PARAM_Disney_clearcoatGloss;

		float NdotV = dot(N, V);
		float NdotL = dot(N, L);

		float3 H = normalize(L + V);
		float NdotH = dot(N, H);
		float LdotH = dot(L, H);

		float3 Cdlin = mon2lin(baseColor);
		float Cdlum = .3 * Cdlin[0] + .6 * Cdlin[1] + .1 * Cdlin[2]; // luminance approx.

		float3 Ctint = Cdlum > 0 ? Cdlin / Cdlum : 1; // normalize lum. to isolate hue+sat
		float3 Cspec0 = lerp(specular * .08 * lerp(1, Ctint, specularTint), Cdlin, metallic);
		float3 Csheen = lerp(1, Ctint, sheenTint);

    // Diffuse fresnel - go from 1 at normal incidence to .5 at grazing
    // and lerp in diffuse retro-reflection based on roughness
		float FL = SchlickFresnel(NdotL), FV = SchlickFresnel(NdotV);
		float Fd90 = 0.5 + 2 * LdotH * LdotH * roughness;
		float Fd = lerp(1.0, Fd90, saturate(FL)) * lerp(1.0, Fd90, saturate(FV));
        //Fd *= saturate(NdotL*3+0.1);

    // Based on Hanrahan-Krueger brdf approximation of isotropic bssrdf
    // 1.25 scale is used to (roughly) preserve albedo
    // Fss90 used to "flatten" retroreflection based on roughness
		float Fss90 = LdotH * LdotH * roughness;
		float Fss = lerp(1.0, Fss90, FL) * lerp(1.0, Fss90, FV);
		float ss = 1.25 * (Fss * (1 / (NdotL + NdotV) - .5) + .5);

    // specular
		float aspect = pows(1 - anisotropic * 0.9, 0.5);
		float ax = max(.001, sqr(roughness) / aspect);
		float ay = max(.001, sqr(roughness) * aspect);
		float Ds = GTR2_aniso(NdotH, dot(H, X), dot(H, Y), ax, ay);
		float FH = SchlickFresnel(LdotH);
		float3 Fs = lerp(Cspec0, 1, saturate(FH));
		float Gs = smithG_GGX_aniso(NdotL, dot(L, X), dot(L, Y), ax, ay);
		Gs *= smithG_GGX_aniso(NdotV, dot(V, X), dot(V, Y), ax, ay);
		Gs *= pow(saturate(NdotL*4+0.25), 2);

    // sheen
		float3 Fsheen = FH * sheen * Csheen;

    // clearcoat (ior = 1.5 -> F0 = 0.04)
		float Dr = GTR1(NdotH, lerp(.1, .001, clearcoatGloss));
		float Fr = lerp(.04, 1.0, FH);
		float Gr = smithG_GGX(NdotL, .25) * smithG_GGX(NdotV, .25);

		float3 res =  ((1 / PI) * saturate(lerp(Fd, ss, subsurface)) * Cdlin + Fsheen);
        res *= (1 - metallic);
        res += Gs * Fs * Ds * saturate(NdotL+0.60);
        res += .25 * clearcoat * Gr * Fr * Dr;
        //res *= saturate(NdotL+0.70);
        res *= pow(saturate(NdotV*4+1), 2);
        res = max(res,0);
		return res;
	}
};
cDisney Disney;

// Disney anisoSpecular - based on Kajiya-Kay 1989

#if !defined(BRDF_PARAM_DisneyAnisoSpec_roughness)
#define BRDF_PARAM_DisneyAnisoSpec_roughness 0.01
#define BRDF_PARAM_DisneyAnisoSpec_falloff 0.1
#define BRDF_PARAM_DisneyAnisoSpec_orient false
#endif
#if !defined(BRDF_DEF_DisneyAnisoSpec_clampLights)
#define BRDF_DEF_DisneyAnisoSpec_clampLights false
#define BRDF_DEF_DisneyAnisoSpec_kajiya false
#endif

float cSmoothstep(float a, float b, float x)
{
	if (a < b)
	{
		if (x < a)
			return 0.0;
		if (x >= b)
			return 1.0;
		x = (x - a) / (b - a);
	}
	else if (a > b)
	{
		if (x <= b)
			return 1.0;
		if (x > a)
			return 0.0;
		x = 1 - (x - b) / (a - b);
	}
	else
		return x < a ? 0.0 : 1.0;
	return x * x * (3 - 2 * x);
}

float3 cReflect(float3 I, float3 N)
{
	return 2 * dot(I, N) * N - I;
}

class cDisneyAnisoSpec : iBrdf
{
	float3 brdf(float3 L, float3 V, float3 N, float3 X, float3 Y BRDF_ARGSDEF)
	{
		float roughness = BRDF_PARAM_DisneyAnisoSpec_roughness;
		float falloff = BRDF_PARAM_DisneyAnisoSpec_falloff;
		bool orient = BRDF_PARAM_DisneyAnisoSpec_orient;
		float3 T = orient ? X : Y;
		float glossiness = roughness != 0 ? (1 / roughness) : 999999.0;
		float LdotN = dot(L, N);
		float lightAngle = acos(LdotN);
		float cosAngleLT = dot(L, T);
		float sinAngleLT = sqrt(1 - (cosAngleLT * cosAngleLT));
		float cosAngleVT = dot(V, T);
		float spec = pow(((sinAngleLT * sqrt(1 - (cosAngleVT * cosAngleVT)))
                      - (cosAngleLT * cosAngleVT)),
                     glossiness);

		#if BRDF_DEF_DisneyAnisoSpec_kajiya
			float3 R = cReflect(L, N);
			float t = acos(dot(L, T)) - acos(dot(R, T));
			spec = pow(cos(t), glossiness);
		#endif

		#if BRDF_DEF_DisneyAnisoSpec_clampLights
			spec *= cSmoothstep(0.0, falloff * 0.5 * PI, 0.5 * PI - lightAngle);
		#endif
		return spec;
	}
};
cDisneyAnisoSpec DisneyAnisoSpec;

// Edwards halfway-vector disk 2006

#if !defined(BRDF_PARAM_Edwards06_n)
#define BRDF_PARAM_Edwards06_n 10
#define BRDF_PARAM_Edwards06_R 1
#endif

float lump(float3 h, float R, float n)
{
	return (n + 1) / (PI * R * R) * pow(1 - dot(h, h) / (R * R), n);
}
class cEdwards06 : iBrdf
{
	float3 brdf(float3 L, float3 V, float3 N, float3 X, float3 Y BRDF_ARGSDEF)
	{
		float n = BRDF_PARAM_Edwards06_n;
		float R = BRDF_PARAM_Edwards06_R;

		float NdotV = dot(N, V);
		float NdotL = dot(N, L);

		if (NdotL < 0 || NdotV < 0)
			return 0;

		float3 H = normalize(L + V);
		float NdotH = dot(N, H);
		float LdotH = dot(L, H);

    // scaling projection
		float3 uH = L + V; // unnormalized H
		float3 h = NdotV / dot(N, uH) * uH;
		float3 huv = h - NdotV * N;

    // specular term (D and G)
		float p = lump(huv, R, n);
		return p * pow(NdotV, 2) / (4 * NdotL * LdotH * pow(NdotH, 3));
	}
};
cEdwards06 Edwards06;

// Gaussian

#if !defined(BRDF_PARAM_Gaussian_c)
#define BRDF_PARAM_Gaussian_c 0.1
#endif

float fGaussian(float c, float thetaH)
{
	return exp(-thetaH * thetaH / (c * c));
}

class cGaussian : iBrdf
{
	float3 brdf(float3 L, float3 V, float3 N, float3 X, float3 Y BRDF_ARGSDEF)
	{
		float c = BRDF_PARAM_Gaussian_c;
		float3 H = normalize(L + V);
		float NdotH = dot(N, H);
		float D = fGaussian(c, acos(NdotH));
		return D;
	}
};
cGaussian Gaussian;

// GGX from Walter 07

#if !defined(BRDF_PARAM_GgxWalter_alpha)
#define BRDF_PARAM_GgxWalter_alpha 0.1
#endif

float GGX(float alpha, float cosThetaM)
{
	float CosSquared = cosThetaM * cosThetaM;
	float TanSquared = (1 - CosSquared) / CosSquared;
	return (1.0 / PI) * sqr(alpha / (CosSquared * (alpha * alpha + TanSquared)));
}
class cGgxWalter : iBrdf
{
	float3 brdf(float3 L, float3 V, float3 N, float3 X, float3 Y BRDF_ARGSDEF)
	{
		float3 H = normalize(L + V);
		float D = GGX(BRDF_PARAM_GgxWalter_alpha, dot(N, H));
		return D;
	}
};
cGgxWalter GgxWalter;

// Walter07 G term (from GGX distribution)

#if !defined(BRDF_PARAM_WalterG_alphaG)
#define BRDF_PARAM_WalterG_alphaG 0.1
#endif
#if !defined(BRDF_DEF_WalterG_includeInvNdotLNdotV)
#define BRDF_DEF_WalterG_includeInvNdotLNdotV false
#endif

float G1_GGX(float Ndotv, float alphaG)
{
	return 2 / (1 + sqrt(1 + alphaG * alphaG * (1 - Ndotv * Ndotv) / (Ndotv * Ndotv)));
}
class cWalterG : iBrdf
{
	float3 brdf(float3 L, float3 V, float3 N, float3 X, float3 Y BRDF_ARGSDEF)
	{
		float NdotL = dot(N, L);
		float NdotV = dot(N, V);
		float G = G1_GGX(NdotL, BRDF_PARAM_WalterG_alphaG) * G1_GGX(NdotV, BRDF_PARAM_WalterG_alphaG);
#if BRDF_DEF_WalterG_includeInvNdotLNdotV
			G *= 1 / (NdotL * NdotV);
#endif
		return G;
	}
};
cWalterG WalterG;

// Ward BRDF
// this is the formulation specified in "Notes on the Ward BRDF" - Bruce Walter, 2005

#if !defined(BRDF_PARAM_Ward_alpha_x)
#define BRDF_PARAM_Ward_alpha_x 0.15
#define BRDF_PARAM_Ward_alpha_y 0.15
#define BRDF_PARAM_Ward_Cs 1
#define BRDF_PARAM_Ward_Cd 1
#define BRDF_PARAM_Ward_isotropic false
#endif

class cWard : iBrdf
{
	float3 brdf(float3 L, float3 V, float3 N, float3 X, float3 Y BRDF_ARGSDEF)
	{
		float alpha_x = BRDF_PARAM_Ward_alpha_x;
		float alpha_y = BRDF_PARAM_Ward_alpha_y;
		float3 Cs = BRDF_PARAM_Ward_Cs;
		float3 Cd = BRDF_PARAM_Ward_Cd;
		bool isotropic = BRDF_PARAM_Ward_isotropic;
		
		float3 H = normalize(L + V);

    // specular
		float ax = alpha_x;
		float ay = isotropic ? alpha_x : alpha_y;
		float exponent = -(
        sqr(dot(H, X) / ax) +
        sqr(dot(H, Y) / ay)
    ) / sqr(dot(H, N));

		float spec = 1.0 / (4.0 * PI * ax * ay * sqrt(dot(L, N) * dot(V, N)));
		spec *= exp(exponent);

		return Cd / PI + Cs * spec;
	}
};
cWard Ward;

#endif