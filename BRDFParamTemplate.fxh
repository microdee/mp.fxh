
#define BRDF_ARGSDEF
#define BRDF_ARGSPASS

#define BRDF_PARAM_AshikminShirley_Rs 0.1
#define BRDF_PARAM_AshikminShirley_Rd 1
#define BRDF_PARAM_AshikminShirley_nu 100
#define BRDF_PARAM_AshikminShirley_nv 100
#define BRDF_PARAM_AshikminShirley_isotropic true
#define BRDF_DEF_AshikminShirley_coupled_diffuse true

#define BRDF_PARAM_Blinn_n 10
#define BRDF_PARAM_Blinn_ior 1.5
#define BRDF_PARAM_Blinn_include_Fresnel false
#define BRDF_DEF_Blinn_divide_by_NdotL true

#define BRDF_PARAM_BlinnPhong_n 100
#define BRDF_DEF_BlinnPhong_divide_by_NdotL true

#define BRDF_PARAM_CookTorrance_m 0.1
#define BRDF_PARAM_CookTorrance_f0 0.1
#define BRDF_DEF_CookTorrance_include_F true
#define BRDF_DEF_CookTorrance_include_G true

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

#define BRDF_PARAM_DisneyAnisoSpec_roughness 0.01
#define BRDF_PARAM_DisneyAnisoSpec_falloff 0.1
#define BRDF_PARAM_DisneyAnisoSpec_orient false
#define BRDF_DEF_DisneyAnisoSpec_clampLights false
#define BRDF_DEF_DisneyAnisoSpec_kajiya false

#define BRDF_PARAM_Edwards06_n 10
#define BRDF_PARAM_Edwards06_R 1

#define BRDF_PARAM_Gaussian_c 0.1

#define BRDF_PARAM_GgxWalter_alpha 0.1

#define BRDF_PARAM_WalterG_alphaG 0.1
#define BRDF_DEF_WalterG_includeInvNdotLNdotV false

#define BRDF_PARAM_Ward_alpha_x 0.15
#define BRDF_PARAM_Ward_alpha_y 0.15
#define BRDF_PARAM_Ward_Cs 1
#define BRDF_PARAM_Ward_Cd 1
#define BRDF_PARAM_Ward_isotropic false