Shader "VAT_RigidBodyDynamics_SSG"
{
Properties
{
[ToggleUI]_B_autoPlayback("Auto Playback", Float) = 1
_gameTimeAtFirstFrame("Game Time at First Frame", Float) = 0
_displayFrame("Display Frame", Float) = 1
_playbackSpeed("Playback Speed", Float) = 1
_houdiniFPS("Houdini FPS", Float) = 60
[ToggleUI]_B_interpolate("Interframe Interpolation", Float) = 0
[ToggleUI]_B_interpolateCol("Interpolate Color", Float) = 0
[ToggleUI]_B_interpolateSpareCol("Interpolate Spare Color", Float) = 0
[ToggleUI]_B_surfaceNormals("Support Surface Normal Maps", Float) = 1
[ToggleUI]_B_twoSidedNorms("Two Sided Normals", Float) = 0
[NoScaleOffset]_posTexture("Position Texture", 2D) = "white" {}
[NoScaleOffset]_posTexture2("Position Texture 2", 2D) = "white" {}
[NoScaleOffset]_rotTexture("Rotation Texture", 2D) = "white" {}
[NoScaleOffset]_colTexture("Color Texture", 2D) = "white" {}
[NoScaleOffset]_spareColTexture("Spare Color Texture", 2D) = "white" {}
[ToggleUI]_B_pscaleAreInPosA("Piece Scales Are in Position Alpha", Float) = 1
_globalPscaleMul("Global Piece Scale Multiplier", Float) = 1
[ToggleUI]_B_stretchByVel("Stretch by Velocity", Float) = 0
_stretchByVelAmount("Stretch by Velocity Amount", Float) = 0
[ToggleUI]_B_animateFirstFrame("Animate First Frame", Float) = 0
[Toggle(_B_LOAD_COL_TEX)]_B_LOAD_COL_TEX("Load Color Texture", Float) = 1
[Toggle(_B_SMOOTH_TRAJECTORIES)]_B_SMOOTH_TRAJECTORIES("Smoothly Interpolated Trajectories", Float) = 0
[Toggle(_B_LOAD_NORM_TEX)]_B_LOAD_NORM_TEX("Load Surface Normal Map", Float) = 0
[Toggle(_B_LOAD_POS_TWO_TEX)]_B_LOAD_POS_TWO_TEX("Positions Require Two Textures", Float) = 0
_frameCount("Frame Count", Float) = 0
_boundMaxX("Bound Max X", Float) = 0
_boundMaxY("Bound Max Y", Float) = 0
_boundMaxZ("Bound Max Z", Float) = 0
_boundMinX("Bound Min X", Float) = 0
_boundMinY("Bound Min Y", Float) = 0
_boundMinZ("Bound Min Z", Float) = 0
}
SubShader
{
Tags
{
// RenderPipeline: <None>
"RenderType"="Opaque"
"Queue"="Geometry"
"ShaderGraphShader"="true"
}
Pass
{
    // Name: <None>
    Tags
    {
        // LightMode: <None>
    }

    // Render State
    // RenderState: <None>

    // Debug
    // <None>

    // --------------------------------------------------
    // Pass

    HLSLPROGRAM

    // Pragmas
    #pragma vertex vert
#pragma fragment frag

    // DotsInstancingOptions: <None>
    // HybridV1InjectedBuiltinProperties: <None>

    // Keywords
    // PassKeywords: <None>
    #pragma shader_feature_local_vertex _ _B_LOAD_POS_TWO_TEX
#pragma shader_feature_local_vertex _ _B_SMOOTH_TRAJECTORIES
#pragma shader_feature_local _ _B_LOAD_COL_TEX
#pragma shader_feature_local_fragment _ _B_LOAD_NORM_TEX

#if defined(_B_LOAD_POS_TWO_TEX) && defined(_B_SMOOTH_TRAJECTORIES) && defined(_B_LOAD_COL_TEX) && defined(_B_LOAD_NORM_TEX)
#define KEYWORD_PERMUTATION_0
#elif defined(_B_LOAD_POS_TWO_TEX) && defined(_B_SMOOTH_TRAJECTORIES) && defined(_B_LOAD_COL_TEX)
#define KEYWORD_PERMUTATION_1
#elif defined(_B_LOAD_POS_TWO_TEX) && defined(_B_SMOOTH_TRAJECTORIES) && defined(_B_LOAD_NORM_TEX)
#define KEYWORD_PERMUTATION_2
#elif defined(_B_LOAD_POS_TWO_TEX) && defined(_B_SMOOTH_TRAJECTORIES)
#define KEYWORD_PERMUTATION_3
#elif defined(_B_LOAD_POS_TWO_TEX) && defined(_B_LOAD_COL_TEX) && defined(_B_LOAD_NORM_TEX)
#define KEYWORD_PERMUTATION_4
#elif defined(_B_LOAD_POS_TWO_TEX) && defined(_B_LOAD_COL_TEX)
#define KEYWORD_PERMUTATION_5
#elif defined(_B_LOAD_POS_TWO_TEX) && defined(_B_LOAD_NORM_TEX)
#define KEYWORD_PERMUTATION_6
#elif defined(_B_LOAD_POS_TWO_TEX)
#define KEYWORD_PERMUTATION_7
#elif defined(_B_SMOOTH_TRAJECTORIES) && defined(_B_LOAD_COL_TEX) && defined(_B_LOAD_NORM_TEX)
#define KEYWORD_PERMUTATION_8
#elif defined(_B_SMOOTH_TRAJECTORIES) && defined(_B_LOAD_COL_TEX)
#define KEYWORD_PERMUTATION_9
#elif defined(_B_SMOOTH_TRAJECTORIES) && defined(_B_LOAD_NORM_TEX)
#define KEYWORD_PERMUTATION_10
#elif defined(_B_SMOOTH_TRAJECTORIES)
#define KEYWORD_PERMUTATION_11
#elif defined(_B_LOAD_COL_TEX) && defined(_B_LOAD_NORM_TEX)
#define KEYWORD_PERMUTATION_12
#elif defined(_B_LOAD_COL_TEX)
#define KEYWORD_PERMUTATION_13
#elif defined(_B_LOAD_NORM_TEX)
#define KEYWORD_PERMUTATION_14
#else
#define KEYWORD_PERMUTATION_15
#endif


    // Defines
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define ATTRIBUTES_NEED_NORMAL
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define ATTRIBUTES_NEED_TANGENT
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define ATTRIBUTES_NEED_TEXCOORD1
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define ATTRIBUTES_NEED_TEXCOORD2
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define ATTRIBUTES_NEED_TEXCOORD3
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define VARYINGS_NEED_POSITION_WS
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define VARYINGS_NEED_NORMAL_WS
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define VARYINGS_NEED_TANGENT_WS
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define VARYINGS_NEED_TEXCOORD1
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define VARYINGS_NEED_TEXCOORD2
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define VARYINGS_NEED_TEXCOORD3
#endif

    /* WARNING: $splice Could not find named fragment 'PassInstancing' */
    #define SHADERPASS SHADERPASS_PREVIEW
#define SHADERGRAPH_PREVIEW 1
    /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

    // Includes
    /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreInclude' */

    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Packing.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/NormalSurfaceGradient.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/UnityInstancing.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/EntityLighting.hlsl"
#include "Packages/com.unity.shadergraph/ShaderGraphLibrary/ShaderVariables.hlsl"
#include "Packages/com.unity.shadergraph/ShaderGraphLibrary/ShaderVariablesFunctions.hlsl"
#include "Packages/com.unity.shadergraph/ShaderGraphLibrary/Functions.hlsl"

    // --------------------------------------------------
    // Structs and Packing

    /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */

    struct Attributes
{
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float3 positionOS : POSITION;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float3 normalOS : NORMAL;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 tangentOS : TANGENT;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 uv1 : TEXCOORD1;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 uv2 : TEXCOORD2;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 uv3 : TEXCOORD3;
#endif
#if UNITY_ANY_INSTANCING_ENABLED
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 uint instanceID : INSTANCEID_SEMANTIC;
#endif
#endif
};
struct Varyings
{
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 positionCS : SV_POSITION;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float3 positionWS;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float3 normalWS;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 tangentWS;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 texCoord1;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 texCoord2;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 texCoord3;
#endif
#if UNITY_ANY_INSTANCING_ENABLED
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
#endif
};
struct SurfaceDescriptionInputs
{
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float3 ObjectSpaceNormal;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float3 WorldSpaceNormal;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float3 ObjectSpaceTangent;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float3 WorldSpaceTangent;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float3 ObjectSpacePosition;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 uv1;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 uv2;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 uv3;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float3 TimeParameters;
#endif
};
struct VertexDescriptionInputs
{
};
struct PackedVaryings
{
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 positionCS : SV_POSITION;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 tangentWS : INTERP0;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 texCoord1 : INTERP1;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 texCoord2 : INTERP2;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 texCoord3 : INTERP3;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float3 positionWS : INTERP4;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float3 normalWS : INTERP5;
#endif
#if UNITY_ANY_INSTANCING_ENABLED
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
#endif
};

    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
PackedVaryings PackVaryings (Varyings input)
{
PackedVaryings output;
ZERO_INITIALIZE(PackedVaryings, output);
output.positionCS = input.positionCS;
output.tangentWS.xyzw = input.tangentWS;
output.texCoord1.xyzw = input.texCoord1;
output.texCoord2.xyzw = input.texCoord2;
output.texCoord3.xyzw = input.texCoord3;
output.positionWS.xyz = input.positionWS;
output.normalWS.xyz = input.normalWS;
#if UNITY_ANY_INSTANCING_ENABLED
output.instanceID = input.instanceID;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
output.cullFace = input.cullFace;
#endif
return output;
}

Varyings UnpackVaryings (PackedVaryings input)
{
Varyings output;
output.positionCS = input.positionCS;
output.tangentWS = input.tangentWS.xyzw;
output.texCoord1 = input.texCoord1.xyzw;
output.texCoord2 = input.texCoord2.xyzw;
output.texCoord3 = input.texCoord3.xyzw;
output.positionWS = input.positionWS.xyz;
output.normalWS = input.normalWS.xyz;
#if UNITY_ANY_INSTANCING_ENABLED
output.instanceID = input.instanceID;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
output.cullFace = input.cullFace;
#endif
return output;
}
#endif

    // --------------------------------------------------
    // Graph

    // Graph Properties
    CBUFFER_START(UnityPerMaterial)
float _gameTimeAtFirstFrame;
float _stretchByVelAmount;
float _B_stretchByVel;
float _B_interpolate;
float _B_interpolateCol;
float _B_interpolateSpareCol;
float _B_autoPlayback;
float _displayFrame;
float _B_surfaceNormals;
float4 _posTexture_TexelSize;
float4 _posTexture2_TexelSize;
float4 _rotTexture_TexelSize;
float4 _colTexture_TexelSize;
float4 _spareColTexture_TexelSize;
float _playbackSpeed;
float _houdiniFPS;
float _frameCount;
float _boundMaxX;
float _boundMaxY;
float _boundMaxZ;
float _boundMinX;
float _boundMinY;
float _boundMinZ;
float _B_twoSidedNorms;
float _B_pscaleAreInPosA;
float _globalPscaleMul;
float _B_animateFirstFrame;
CBUFFER_END

// Object and Global properties
SAMPLER(SamplerState_Linear_Repeat);
TEXTURE2D(_posTexture);
SAMPLER(sampler_posTexture);
TEXTURE2D(_posTexture2);
SAMPLER(sampler_posTexture2);
TEXTURE2D(_rotTexture);
SAMPLER(sampler_rotTexture);
TEXTURE2D(_colTexture);
SAMPLER(sampler_colTexture);
TEXTURE2D(_spareColTexture);
SAMPLER(sampler_spareColTexture);

    // Graph Includes
    // GraphIncludes: <None>

    // -- Property used by ScenePickingPass
    #ifdef SCENEPICKINGPASS
    float4 _SelectionID;
    #endif

    // -- Properties used by SceneSelectionPass
    #ifdef SCENESELECTIONPASS
    int _ObjectId;
    int _PassValue;
    #endif

    // Graph Functions
    
void Unity_Comparison_LessOrEqual_float(float A, float B, out float Out)
{
    Out = A <= B ? 1 : 0;
}

void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
{
    RGBA = float4(R, G, B, A);
    RGB = float3(R, G, B);
    RG = float2(R, G);
}

void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
{
Out = A * B;
}

void Unity_Floor_float(float In, out float Out)
{
    Out = floor(In);
}

void Unity_Subtract_float(float A, float B, out float Out)
{
    Out = A - B;
}

void Unity_Comparison_GreaterOrEqual_float(float A, float B, out float Out)
{
    Out = A >= B ? 1 : 0;
}

void Unity_Ceiling_float(float In, out float Out)
{
    Out = ceil(In);
}

void Unity_OneMinus_float(float In, out float Out)
{
    Out = 1 - In;
}

void Unity_Multiply_float_float(float A, float B, out float Out)
{
Out = A * B;
}

void Unity_Divide_float(float A, float B, out float Out)
{
    Out = A / B;
}

void Unity_Fraction_float(float In, out float Out)
{
    Out = frac(In);
}

void Unity_Add_float(float A, float B, out float Out)
{
    Out = A + B;
}

void Unity_Branch_float(float Predicate, float True, float False, out float Out)
{
    Out = Predicate ? True : False;
}

void Unity_Modulo_float(float A, float B, out float Out)
{
    Out = fmod(A, B);
}

void Unity_Subtract_float4(float4 A, float4 B, out float4 Out)
{
    Out = A - B;
}

void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
{
Out = A * B;
}

void Unity_Branch_float4(float Predicate, float4 True, float4 False, out float4 Out)
{
    Out = Predicate ? True : False;
}

void Unity_Comparison_NotEqual_float(float A, float B, out float Out)
{
    Out = A != B ? 1 : 0;
}

void Decode_Quaternion_float(float3 XYZ, float MaxComponent, out float4 Out_XYZW){
float w = sqrt(1.0 - pow(XYZ.x, 2) - pow(XYZ.y, 2) - pow(XYZ.z, 2));

float4 q = float4(0, 0, 0, 1);



switch(MaxComponent)

{

    case 0:

        q = float4(XYZ.x, XYZ.y, XYZ.z, w);

        break;

    case 1:

        q = float4(w, XYZ.y, XYZ.z, XYZ.x);

        break;

    case 2:

        q = float4(XYZ.x, -w, XYZ.z, -XYZ.y);

        break;

    case 3:

        q = float4(XYZ.x, XYZ.y, -w, -XYZ.z);

        break;

    default:

        q = float4(XYZ.x, XYZ.y, XYZ.z, w);

        break;

}



Out_XYZW = q;
}

void Unity_Absolute_float(float In, out float Out)
{
    Out = abs(In);
}

void Unity_Sine_float(float In, out float Out)
{
    Out = sin(In);
}

void Unity_Sign_float(float In, out float Out)
{
    Out = sign(In);
}

void Unity_Add_float4(float4 A, float4 B, out float4 Out)
{
    Out = A + B;
}

void Unity_Divide_float4(float4 A, float4 B, out float4 Out)
{
    Out = A / B;
}

void Unity_Normalize_float4(float4 In, out float4 Out)
{
    Out = normalize(In);
}

void Unity_Subtract_float3(float3 A, float3 B, out float3 Out)
{
    Out = A - B;
}

void Unity_CrossProduct_float(float3 A, float3 B, out float3 Out)
{
    Out = cross(A, B);
}

void Unity_Add_float3(float3 A, float3 B, out float3 Out)
{
    Out = A + B;
}

void Unity_And_float(float A, float B, out float Out)
{
    Out = A && B;
}

void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
{
    Out = lerp(A, B, T);
}

void Unity_Branch_float3(float Predicate, float3 True, float3 False, out float3 Out)
{
    Out = Predicate ? True : False;
}

void Unity_Absolute_float3(float3 In, out float3 Out)
{
    Out = abs(In);
}

void Unity_Lerp_float(float A, float B, float T, out float Out)
{
    Out = lerp(A, B, T);
}

void Unity_Saturate_float(float In, out float Out)
{
    Out = saturate(In);
}

void Unity_Comparison_Greater_float(float A, float B, out float Out)
{
    Out = A > B ? 1 : 0;
}

void Interframe_Position_float(float3 V, float3 A, float3 P, float T, out float3 Out_InterframeP){
Out_InterframeP = V * T + 0.5 * A * T * T + P;
}

void Unity_Lerp_float3(float3 A, float3 B, float3 T, out float3 Out)
{
    Out = lerp(A, B, T);
}

void Unity_Normalize_float3(float3 In, out float3 Out)
{
    Out = normalize(In);
}

struct Bindings_VATRigidBodyDynamicsSSG_a4f0f42d0478d0747b2f528d548fb71b_float
{
float3 ObjectSpaceNormal;
float3 ObjectSpaceTangent;
float3 ObjectSpacePosition;
half4 uv1;
half4 uv2;
half4 uv3;
};

void SG_VATRigidBodyDynamicsSSG_a4f0f42d0478d0747b2f528d548fb71b_float(float Boolean_c6d95f0261604ee2b8dc25eb23063490, float _Game_Time_at_First_Frame, float Vector1_74248139a46a4241857eb5ea760cd76e, float Vector1_616132c8d66348e59f938fc7754536ce, float Vector1_779a70dd0d5f497682265941a24919dc, float _Interframe_Interpolation, float _Interpolate_Color, float _Interpolate_Spare_Color, float Boolean_452ee7b85a19421f84aedbe953332219, UnityTexture2D Texture2D_3449ceac7550445ab7147121e9c2dda7, UnityTexture2D Texture2D_754e74d5eb0c4d92affb773f974ae100, UnityTexture2D Texture2D_71642968826b49feb5cbdfb5ec5105db, UnityTexture2D Texture2D_e2d9e8f7eef04f15ad7d3a47dcf08a66, UnityTexture2D Texture2D_dc3c6e2909694510a2bce97b5d611620, float _Piece_Scales_Are_in_Position_Alpha, float _Global_Piece_Scale_Multiplier, float _Stretch_by_Velocity, float _Stretch_by_Velocity_Amount, float _Animate_First_Frame, float Vector1_408ce11275b14434bf1948469ee3966c, float Vector1_ccbea577a96e404faf689f6aec5b88a1, float Vector1_dd8d8ffd66fb4dc8b22b2f2bf50a8045, float Vector1_777dc7214cdf45828b8dd360191bde10, float Vector1_d98d868368384a49a83c61a9e9723b40, float Vector1_1256f3f5f1ae4569984c02d8e880fbc1, float Vector1_4373686283fd4fe0a811860575a0582b, float _Input_Time, float3 Vector3_d2bfcc1e36e143fb8998c41bd35e34ce, Bindings_VATRigidBodyDynamicsSSG_a4f0f42d0478d0747b2f528d548fb71b_float IN, out float3 Out_Position_1, out float3 Out_Normal_2, out float3 Out_Tangent_3, out float3 Out_ColorRGB_4, out float Out_ColorAlpha_6, out float4 Out_SpareColorRGBA_5, out float Out_SamplingVThisFrame_8, out float Out_SamplingVNextFrame_9, out float3 Out_PieceLocalPositionThisFrame_10, out float3 Out_PieceLocalPositionNextFrame_11, out float Out_DataInPositionAlphaThisFrame_12, out float Out_DataInPositionAlphaNextFrame_13, out float4 Out_ColorRGBAThisFrame_17, out float4 Out_ColorRGBANextFrame_14, out float4 Out_SpareColorRGBAThisFrame_18, out float4 Out_SpareColorRGBANextFrame_15, out float Out_InterframeInterpolationAlpha_16, out float Out_AnimationProgressThisFrame_21, out float Out_AnimationProgressNextFrame_22, out float3 Out_PieceRestFrameLocalPosition_19, out float3 Out_PieceLocalPositionFinal_20)
{
float4 _UV_6862cbe6995046fc899d32f8ba0baa6d_Out_0 = IN.uv1;
float _Split_f0e64cc1768d45dd8b151ea65f78fde0_R_1 = _UV_6862cbe6995046fc899d32f8ba0baa6d_Out_0[0];
float _Split_f0e64cc1768d45dd8b151ea65f78fde0_G_2 = _UV_6862cbe6995046fc899d32f8ba0baa6d_Out_0[1];
float _Split_f0e64cc1768d45dd8b151ea65f78fde0_B_3 = _UV_6862cbe6995046fc899d32f8ba0baa6d_Out_0[2];
float _Split_f0e64cc1768d45dd8b151ea65f78fde0_A_4 = _UV_6862cbe6995046fc899d32f8ba0baa6d_Out_0[3];
float _Comparison_05395f032a9d41f883deb216f4f78844_Out_2;
Unity_Comparison_LessOrEqual_float(_Split_f0e64cc1768d45dd8b151ea65f78fde0_G_2, float(0.1), _Comparison_05395f032a9d41f883deb216f4f78844_Out_2);
float _Property_41c0700d390b42eb9578b110d952f492_Out_0 = _Animate_First_Frame;
float _Property_e1b472109c904495bfad45a873a6aaaf_Out_0 = _Interframe_Interpolation;
float _Property_4217789df82b4209a71e34fd26496efd_Out_0 = Vector1_ccbea577a96e404faf689f6aec5b88a1;
float _Property_29651f35c4064687a81374ee5ad44fc4_Out_0 = Vector1_dd8d8ffd66fb4dc8b22b2f2bf50a8045;
float _Property_189de79eec3e4c0ca1cca21498cd3735_Out_0 = Vector1_777dc7214cdf45828b8dd360191bde10;
float4 _Combine_e339454ae4ab446eab26fa05e5da4305_RGBA_4;
float3 _Combine_e339454ae4ab446eab26fa05e5da4305_RGB_5;
float2 _Combine_e339454ae4ab446eab26fa05e5da4305_RG_6;
Unity_Combine_float(_Property_4217789df82b4209a71e34fd26496efd_Out_0, _Property_29651f35c4064687a81374ee5ad44fc4_Out_0, _Property_189de79eec3e4c0ca1cca21498cd3735_Out_0, float(0), _Combine_e339454ae4ab446eab26fa05e5da4305_RGBA_4, _Combine_e339454ae4ab446eab26fa05e5da4305_RGB_5, _Combine_e339454ae4ab446eab26fa05e5da4305_RG_6);
float3 _Vector3_0eb7ffa0098e4750927324bbfad3f6fc_Out_0 = float3(float(10), float(10), float(10));
float3 _Multiply_4d68c8f298964b98b16e66da11ecf8e0_Out_2;
Unity_Multiply_float3_float3(_Combine_e339454ae4ab446eab26fa05e5da4305_RGB_5, _Vector3_0eb7ffa0098e4750927324bbfad3f6fc_Out_0, _Multiply_4d68c8f298964b98b16e66da11ecf8e0_Out_2);
float _Split_c57cc6c2a4714679969ca15abe6b868d_R_1 = _Multiply_4d68c8f298964b98b16e66da11ecf8e0_Out_2[0];
float _Split_c57cc6c2a4714679969ca15abe6b868d_G_2 = _Multiply_4d68c8f298964b98b16e66da11ecf8e0_Out_2[1];
float _Split_c57cc6c2a4714679969ca15abe6b868d_B_3 = _Multiply_4d68c8f298964b98b16e66da11ecf8e0_Out_2[2];
float _Split_c57cc6c2a4714679969ca15abe6b868d_A_4 = 0;
float _Floor_f206c8cf6fba4f088f8a985a5a2ec4f1_Out_1;
Unity_Floor_float(_Split_c57cc6c2a4714679969ca15abe6b868d_B_3, _Floor_f206c8cf6fba4f088f8a985a5a2ec4f1_Out_1);
float _Subtract_77492447a2e24ffa89bf91720c777460_Out_2;
Unity_Subtract_float(_Split_c57cc6c2a4714679969ca15abe6b868d_B_3, _Floor_f206c8cf6fba4f088f8a985a5a2ec4f1_Out_1, _Subtract_77492447a2e24ffa89bf91720c777460_Out_2);
float _Comparison_322cfaaadddd4969978d57a8c96084ef_Out_2;
Unity_Comparison_GreaterOrEqual_float(_Subtract_77492447a2e24ffa89bf91720c777460_Out_2, float(0.5), _Comparison_322cfaaadddd4969978d57a8c96084ef_Out_2);
UnityTexture2D _Property_9114fd6d110d4133883ddd3127a123c9_Out_0 = Texture2D_71642968826b49feb5cbdfb5ec5105db;
float4 _UV_6799e03a023e45e3845a013c09e28a23_Out_0 = IN.uv1;
float _Split_7157ab551da04777b88f5fa2a8cb91d2_R_1 = _UV_6799e03a023e45e3845a013c09e28a23_Out_0[0];
float _Split_7157ab551da04777b88f5fa2a8cb91d2_G_2 = _UV_6799e03a023e45e3845a013c09e28a23_Out_0[1];
float _Split_7157ab551da04777b88f5fa2a8cb91d2_B_3 = _UV_6799e03a023e45e3845a013c09e28a23_Out_0[2];
float _Split_7157ab551da04777b88f5fa2a8cb91d2_A_4 = _UV_6799e03a023e45e3845a013c09e28a23_Out_0[3];
float _Property_59601290c1414961893ef4a6538b3854_Out_0 = Vector1_d98d868368384a49a83c61a9e9723b40;
float _Property_c0406d5f413f4a77a2942e83d6a42255_Out_0 = Vector1_1256f3f5f1ae4569984c02d8e880fbc1;
float _Property_f22990298caa41e6b1859596db73e4f2_Out_0 = Vector1_4373686283fd4fe0a811860575a0582b;
float4 _Combine_b7dc50f2401c46dca6eed4b19e0862d8_RGBA_4;
float3 _Combine_b7dc50f2401c46dca6eed4b19e0862d8_RGB_5;
float2 _Combine_b7dc50f2401c46dca6eed4b19e0862d8_RG_6;
Unity_Combine_float(_Property_59601290c1414961893ef4a6538b3854_Out_0, _Property_c0406d5f413f4a77a2942e83d6a42255_Out_0, _Property_f22990298caa41e6b1859596db73e4f2_Out_0, float(0), _Combine_b7dc50f2401c46dca6eed4b19e0862d8_RGBA_4, _Combine_b7dc50f2401c46dca6eed4b19e0862d8_RGB_5, _Combine_b7dc50f2401c46dca6eed4b19e0862d8_RG_6);
float3 _Multiply_0b6e25661079480989cd42d5c79db7ec_Out_2;
Unity_Multiply_float3_float3(_Combine_b7dc50f2401c46dca6eed4b19e0862d8_RGB_5, _Vector3_0eb7ffa0098e4750927324bbfad3f6fc_Out_0, _Multiply_0b6e25661079480989cd42d5c79db7ec_Out_2);
float _Split_f748d5d3b6004c4cbb1ac014769880d9_R_1 = _Multiply_0b6e25661079480989cd42d5c79db7ec_Out_2[0];
float _Split_f748d5d3b6004c4cbb1ac014769880d9_G_2 = _Multiply_0b6e25661079480989cd42d5c79db7ec_Out_2[1];
float _Split_f748d5d3b6004c4cbb1ac014769880d9_B_3 = _Multiply_0b6e25661079480989cd42d5c79db7ec_Out_2[2];
float _Split_f748d5d3b6004c4cbb1ac014769880d9_A_4 = 0;
float _Ceiling_4a89909a89be4b7cbb1020b457413672_Out_1;
Unity_Ceiling_float(_Split_f748d5d3b6004c4cbb1ac014769880d9_B_3, _Ceiling_4a89909a89be4b7cbb1020b457413672_Out_1);
float _Subtract_6310376d71fd4a54982f986e4fd538ef_Out_2;
Unity_Subtract_float(_Ceiling_4a89909a89be4b7cbb1020b457413672_Out_1, _Split_f748d5d3b6004c4cbb1ac014769880d9_B_3, _Subtract_6310376d71fd4a54982f986e4fd538ef_Out_2);
float _OneMinus_4e4177ba42e5455facc1c738da762c00_Out_1;
Unity_OneMinus_float(_Subtract_6310376d71fd4a54982f986e4fd538ef_Out_2, _OneMinus_4e4177ba42e5455facc1c738da762c00_Out_1);
float _Multiply_9b6c319d4f9f4f64afb5813d2670c683_Out_2;
Unity_Multiply_float_float(_Split_7157ab551da04777b88f5fa2a8cb91d2_R_1, _OneMinus_4e4177ba42e5455facc1c738da762c00_Out_1, _Multiply_9b6c319d4f9f4f64afb5813d2670c683_Out_2);
float _OneMinus_65096401cdc946379bc7a6883c28c7ff_Out_1;
Unity_OneMinus_float(_Split_7157ab551da04777b88f5fa2a8cb91d2_G_2, _OneMinus_65096401cdc946379bc7a6883c28c7ff_Out_1);
float _Multiply_4f3363e9a75e410085c77799834cdfb3_Out_2;
Unity_Multiply_float_float(_Split_c57cc6c2a4714679969ca15abe6b868d_R_1, -1, _Multiply_4f3363e9a75e410085c77799834cdfb3_Out_2);
float _Floor_f97124efdafb4cf6bcb64b0500ff2bf9_Out_1;
Unity_Floor_float(_Multiply_4f3363e9a75e410085c77799834cdfb3_Out_2, _Floor_f97124efdafb4cf6bcb64b0500ff2bf9_Out_1);
float _Subtract_c5cb943ce45a4d19a2d265bc11877583_Out_2;
Unity_Subtract_float(_Multiply_4f3363e9a75e410085c77799834cdfb3_Out_2, _Floor_f97124efdafb4cf6bcb64b0500ff2bf9_Out_1, _Subtract_c5cb943ce45a4d19a2d265bc11877583_Out_2);
float _OneMinus_6a6f086f607e42bb8409559598119dd2_Out_1;
Unity_OneMinus_float(_Subtract_c5cb943ce45a4d19a2d265bc11877583_Out_2, _OneMinus_6a6f086f607e42bb8409559598119dd2_Out_1);
float _Multiply_5a5cd519af8341f3b924960c61aaffff_Out_2;
Unity_Multiply_float_float(_OneMinus_65096401cdc946379bc7a6883c28c7ff_Out_1, _OneMinus_6a6f086f607e42bb8409559598119dd2_Out_1, _Multiply_5a5cd519af8341f3b924960c61aaffff_Out_2);
float _Property_1385c4534688495ba3c996fbab6c5bfa_Out_0 = Boolean_c6d95f0261604ee2b8dc25eb23063490;
float _Property_1f7af2a0f7a8453e8c781c7598142785_Out_0 = _Input_Time;
float _Property_c81c0e719ee745c38b3dd19d04125a2e_Out_0 = _Game_Time_at_First_Frame;
float _Subtract_0f837762e57f49caa9eceda62d39a402_Out_2;
Unity_Subtract_float(_Property_1f7af2a0f7a8453e8c781c7598142785_Out_0, _Property_c81c0e719ee745c38b3dd19d04125a2e_Out_0, _Subtract_0f837762e57f49caa9eceda62d39a402_Out_2);
float _Property_5fc6f43cd22541d08c4627c56b36c0ad_Out_0 = Vector1_779a70dd0d5f497682265941a24919dc;
float _Property_36bda8feb9f646a589a5298330a8efb5_Out_0 = Vector1_408ce11275b14434bf1948469ee3966c;
float _Subtract_908b2be8d0fd42feaf2c2021d682789d_Out_2;
Unity_Subtract_float(_Property_36bda8feb9f646a589a5298330a8efb5_Out_0, float(0.01), _Subtract_908b2be8d0fd42feaf2c2021d682789d_Out_2);
float _Divide_e4f1fca752404084a4a4c8881fed898e_Out_2;
Unity_Divide_float(_Property_5fc6f43cd22541d08c4627c56b36c0ad_Out_0, _Subtract_908b2be8d0fd42feaf2c2021d682789d_Out_2, _Divide_e4f1fca752404084a4a4c8881fed898e_Out_2);
float _Multiply_3c4f5926b6424c9d96b4b2e3a575326d_Out_2;
Unity_Multiply_float_float(_Subtract_0f837762e57f49caa9eceda62d39a402_Out_2, _Divide_e4f1fca752404084a4a4c8881fed898e_Out_2, _Multiply_3c4f5926b6424c9d96b4b2e3a575326d_Out_2);
float _Property_b36ff413394b49caaa18e8e7611655fe_Out_0 = Vector1_616132c8d66348e59f938fc7754536ce;
float _Multiply_c936f9a54f8d4368a6b8c56e0773c8aa_Out_2;
Unity_Multiply_float_float(_Multiply_3c4f5926b6424c9d96b4b2e3a575326d_Out_2, _Property_b36ff413394b49caaa18e8e7611655fe_Out_0, _Multiply_c936f9a54f8d4368a6b8c56e0773c8aa_Out_2);
float _Fraction_cfedc089a9174d5e9884fdb029048b87_Out_1;
Unity_Fraction_float(_Multiply_c936f9a54f8d4368a6b8c56e0773c8aa_Out_2, _Fraction_cfedc089a9174d5e9884fdb029048b87_Out_1);
float _Multiply_93477a679f5e46959ff06b9cec3b7c01_Out_2;
Unity_Multiply_float_float(_Fraction_cfedc089a9174d5e9884fdb029048b87_Out_1, _Property_36bda8feb9f646a589a5298330a8efb5_Out_0, _Multiply_93477a679f5e46959ff06b9cec3b7c01_Out_2);
float _Floor_66dec685fd2d4e17a6c4776858547d83_Out_1;
Unity_Floor_float(_Multiply_93477a679f5e46959ff06b9cec3b7c01_Out_2, _Floor_66dec685fd2d4e17a6c4776858547d83_Out_1);
float _Add_1cc37e2034bb4425ac8cb738ac068967_Out_2;
Unity_Add_float(_Floor_66dec685fd2d4e17a6c4776858547d83_Out_1, float(1), _Add_1cc37e2034bb4425ac8cb738ac068967_Out_2);
float _Property_bbaa27bcd1cd41f2af6709b866a5a0cf_Out_0 = Vector1_74248139a46a4241857eb5ea760cd76e;
float _Floor_f870587305e44cd2b52a32da5e9a1e7e_Out_1;
Unity_Floor_float(_Property_bbaa27bcd1cd41f2af6709b866a5a0cf_Out_0, _Floor_f870587305e44cd2b52a32da5e9a1e7e_Out_1);
float _Branch_49a68901b23c4894bfa1af72c26bfc34_Out_3;
Unity_Branch_float(_Property_1385c4534688495ba3c996fbab6c5bfa_Out_0, _Add_1cc37e2034bb4425ac8cb738ac068967_Out_2, _Floor_f870587305e44cd2b52a32da5e9a1e7e_Out_1, _Branch_49a68901b23c4894bfa1af72c26bfc34_Out_3);
float _Subtract_fb669c5626cc433db25f98f7f0912c63_Out_2;
Unity_Subtract_float(_Branch_49a68901b23c4894bfa1af72c26bfc34_Out_3, float(1), _Subtract_fb669c5626cc433db25f98f7f0912c63_Out_2);
float _Modulo_0944b94fd8654e1696895b7e282bc6b0_Out_2;
Unity_Modulo_float(_Subtract_fb669c5626cc433db25f98f7f0912c63_Out_2, _Property_36bda8feb9f646a589a5298330a8efb5_Out_0, _Modulo_0944b94fd8654e1696895b7e282bc6b0_Out_2);
float _Divide_8940f8cc6cc745d28630ad7d2e2ba98d_Out_2;
Unity_Divide_float(float(1), _Property_36bda8feb9f646a589a5298330a8efb5_Out_0, _Divide_8940f8cc6cc745d28630ad7d2e2ba98d_Out_2);
float _Multiply_8ecd22e403084ffeac4fda6da39b7880_Out_2;
Unity_Multiply_float_float(_Modulo_0944b94fd8654e1696895b7e282bc6b0_Out_2, _Divide_8940f8cc6cc745d28630ad7d2e2ba98d_Out_2, _Multiply_8ecd22e403084ffeac4fda6da39b7880_Out_2);
float _Multiply_659a4f149aa848898e31ad47bf8e243a_Out_2;
Unity_Multiply_float_float(_Multiply_8ecd22e403084ffeac4fda6da39b7880_Out_2, _OneMinus_6a6f086f607e42bb8409559598119dd2_Out_1, _Multiply_659a4f149aa848898e31ad47bf8e243a_Out_2);
float _Add_1fc73c4ac8ed420895dc22580cd38980_Out_2;
Unity_Add_float(_Multiply_5a5cd519af8341f3b924960c61aaffff_Out_2, _Multiply_659a4f149aa848898e31ad47bf8e243a_Out_2, _Add_1fc73c4ac8ed420895dc22580cd38980_Out_2);
float _OneMinus_65f54edfb84f406289b8ea2083a34fcf_Out_1;
Unity_OneMinus_float(_Add_1fc73c4ac8ed420895dc22580cd38980_Out_2, _OneMinus_65f54edfb84f406289b8ea2083a34fcf_Out_1);
float4 _Combine_7acf849c0cd74d32b462c613ff310511_RGBA_4;
float3 _Combine_7acf849c0cd74d32b462c613ff310511_RGB_5;
float2 _Combine_7acf849c0cd74d32b462c613ff310511_RG_6;
Unity_Combine_float(_Multiply_9b6c319d4f9f4f64afb5813d2670c683_Out_2, _OneMinus_65f54edfb84f406289b8ea2083a34fcf_Out_1, float(0), float(0), _Combine_7acf849c0cd74d32b462c613ff310511_RGBA_4, _Combine_7acf849c0cd74d32b462c613ff310511_RGB_5, _Combine_7acf849c0cd74d32b462c613ff310511_RG_6);
#if defined(SHADER_API_GLES) && (SHADER_TARGET < 30)
  float4 _SampleTexture2DLOD_8e8df1d93cfb4e04a9dfbdf3daaa236c_RGBA_0 = float4(0.0f, 0.0f, 0.0f, 1.0f);
#else
  float4 _SampleTexture2DLOD_8e8df1d93cfb4e04a9dfbdf3daaa236c_RGBA_0 = SAMPLE_TEXTURE2D_LOD(_Property_9114fd6d110d4133883ddd3127a123c9_Out_0.tex, _Property_9114fd6d110d4133883ddd3127a123c9_Out_0.samplerstate, _Property_9114fd6d110d4133883ddd3127a123c9_Out_0.GetTransformedUV(_Combine_7acf849c0cd74d32b462c613ff310511_RG_6), float(0));
#endif
float _SampleTexture2DLOD_8e8df1d93cfb4e04a9dfbdf3daaa236c_R_5 = _SampleTexture2DLOD_8e8df1d93cfb4e04a9dfbdf3daaa236c_RGBA_0.r;
float _SampleTexture2DLOD_8e8df1d93cfb4e04a9dfbdf3daaa236c_G_6 = _SampleTexture2DLOD_8e8df1d93cfb4e04a9dfbdf3daaa236c_RGBA_0.g;
float _SampleTexture2DLOD_8e8df1d93cfb4e04a9dfbdf3daaa236c_B_7 = _SampleTexture2DLOD_8e8df1d93cfb4e04a9dfbdf3daaa236c_RGBA_0.b;
float _SampleTexture2DLOD_8e8df1d93cfb4e04a9dfbdf3daaa236c_A_8 = _SampleTexture2DLOD_8e8df1d93cfb4e04a9dfbdf3daaa236c_RGBA_0.a;
float4 _Subtract_70127b6cf05b4da0b41f0a9ece639cdb_Out_2;
Unity_Subtract_float4(_SampleTexture2DLOD_8e8df1d93cfb4e04a9dfbdf3daaa236c_RGBA_0, float4(0.5, 0.5, 0.5, 0.5), _Subtract_70127b6cf05b4da0b41f0a9ece639cdb_Out_2);
float4 _Multiply_2eb20ec590924cb58efa835c25eeffce_Out_2;
Unity_Multiply_float4_float4(_Subtract_70127b6cf05b4da0b41f0a9ece639cdb_Out_2, float4(2, 2, 2, 2), _Multiply_2eb20ec590924cb58efa835c25eeffce_Out_2);
float4 _Branch_f90416c7d9ec4a1abf31994122d466a2_Out_3;
Unity_Branch_float4(_Comparison_322cfaaadddd4969978d57a8c96084ef_Out_2, _SampleTexture2DLOD_8e8df1d93cfb4e04a9dfbdf3daaa236c_RGBA_0, _Multiply_2eb20ec590924cb58efa835c25eeffce_Out_2, _Branch_f90416c7d9ec4a1abf31994122d466a2_Out_3);
float _Split_abf23ca3bd0842eab3977324259feb60_R_1 = _Branch_f90416c7d9ec4a1abf31994122d466a2_Out_3[0];
float _Split_abf23ca3bd0842eab3977324259feb60_G_2 = _Branch_f90416c7d9ec4a1abf31994122d466a2_Out_3[1];
float _Split_abf23ca3bd0842eab3977324259feb60_B_3 = _Branch_f90416c7d9ec4a1abf31994122d466a2_Out_3[2];
float _Split_abf23ca3bd0842eab3977324259feb60_A_4 = _Branch_f90416c7d9ec4a1abf31994122d466a2_Out_3[3];
float _Comparison_438e9817473f4f1fab2ea5dd9ce5bcf8_Out_2;
Unity_Comparison_NotEqual_float(_Split_abf23ca3bd0842eab3977324259feb60_A_4, float(0), _Comparison_438e9817473f4f1fab2ea5dd9ce5bcf8_Out_2);
float4 _Combine_c7bf0dadd94f44eba3b7d6b3cbf257f7_RGBA_4;
float3 _Combine_c7bf0dadd94f44eba3b7d6b3cbf257f7_RGB_5;
float2 _Combine_c7bf0dadd94f44eba3b7d6b3cbf257f7_RG_6;
Unity_Combine_float(_Split_abf23ca3bd0842eab3977324259feb60_R_1, _Split_abf23ca3bd0842eab3977324259feb60_G_2, _Split_abf23ca3bd0842eab3977324259feb60_B_3, float(0), _Combine_c7bf0dadd94f44eba3b7d6b3cbf257f7_RGBA_4, _Combine_c7bf0dadd94f44eba3b7d6b3cbf257f7_RGB_5, _Combine_c7bf0dadd94f44eba3b7d6b3cbf257f7_RG_6);
UnityTexture2D _Property_7dbd408acfee4e078cd82cbe1e5f572b_Out_0 = Texture2D_3449ceac7550445ab7147121e9c2dda7;
#if defined(SHADER_API_GLES) && (SHADER_TARGET < 30)
  float4 _SampleTexture2DLOD_de27d463cc6a4aa49ace2fa8becc61eb_RGBA_0 = float4(0.0f, 0.0f, 0.0f, 1.0f);
#else
  float4 _SampleTexture2DLOD_de27d463cc6a4aa49ace2fa8becc61eb_RGBA_0 = SAMPLE_TEXTURE2D_LOD(_Property_7dbd408acfee4e078cd82cbe1e5f572b_Out_0.tex, _Property_7dbd408acfee4e078cd82cbe1e5f572b_Out_0.samplerstate, _Property_7dbd408acfee4e078cd82cbe1e5f572b_Out_0.GetTransformedUV(_Combine_7acf849c0cd74d32b462c613ff310511_RG_6), float(0));
#endif
float _SampleTexture2DLOD_de27d463cc6a4aa49ace2fa8becc61eb_R_5 = _SampleTexture2DLOD_de27d463cc6a4aa49ace2fa8becc61eb_RGBA_0.r;
float _SampleTexture2DLOD_de27d463cc6a4aa49ace2fa8becc61eb_G_6 = _SampleTexture2DLOD_de27d463cc6a4aa49ace2fa8becc61eb_RGBA_0.g;
float _SampleTexture2DLOD_de27d463cc6a4aa49ace2fa8becc61eb_B_7 = _SampleTexture2DLOD_de27d463cc6a4aa49ace2fa8becc61eb_RGBA_0.b;
float _SampleTexture2DLOD_de27d463cc6a4aa49ace2fa8becc61eb_A_8 = _SampleTexture2DLOD_de27d463cc6a4aa49ace2fa8becc61eb_RGBA_0.a;
float _Multiply_95ca52288ea140a788cd9e349cad7773_Out_2;
Unity_Multiply_float_float(_SampleTexture2DLOD_de27d463cc6a4aa49ace2fa8becc61eb_A_8, 4, _Multiply_95ca52288ea140a788cd9e349cad7773_Out_2);
float _Floor_b526f048d3b74316b3d83f5f9528bf6e_Out_1;
Unity_Floor_float(_Multiply_95ca52288ea140a788cd9e349cad7773_Out_2, _Floor_b526f048d3b74316b3d83f5f9528bf6e_Out_1);
float4 _DecodeQuaternionCustomFunction_6de7e7521c444a8fa56b1fc4c08b5518_OutXYZW_2;
Decode_Quaternion_float(_Combine_c7bf0dadd94f44eba3b7d6b3cbf257f7_RGB_5, _Floor_b526f048d3b74316b3d83f5f9528bf6e_Out_1, _DecodeQuaternionCustomFunction_6de7e7521c444a8fa56b1fc4c08b5518_OutXYZW_2);
float _Absolute_613421c39e244536a4db652ebd863719_Out_1;
Unity_Absolute_float(_Split_abf23ca3bd0842eab3977324259feb60_A_4, _Absolute_613421c39e244536a4db652ebd863719_Out_1);
float _Multiply_b6fec1ad8ed94f25ac4248cd8d6cbd2b_Out_2;
Unity_Multiply_float_float(_Split_f748d5d3b6004c4cbb1ac014769880d9_R_1, -1, _Multiply_b6fec1ad8ed94f25ac4248cd8d6cbd2b_Out_2);
float _Floor_13ef645218ac4392b61d83cf018165fd_Out_1;
Unity_Floor_float(_Multiply_b6fec1ad8ed94f25ac4248cd8d6cbd2b_Out_2, _Floor_13ef645218ac4392b61d83cf018165fd_Out_1);
float _Subtract_937ffa0d8978415a8bbe9c011d5f81b4_Out_2;
Unity_Subtract_float(_Multiply_b6fec1ad8ed94f25ac4248cd8d6cbd2b_Out_2, _Floor_13ef645218ac4392b61d83cf018165fd_Out_1, _Subtract_937ffa0d8978415a8bbe9c011d5f81b4_Out_2);
float _OneMinus_b15350733f714030bbb8e51adc3f2ffa_Out_1;
Unity_OneMinus_float(_Subtract_937ffa0d8978415a8bbe9c011d5f81b4_Out_2, _OneMinus_b15350733f714030bbb8e51adc3f2ffa_Out_1);
float _Divide_c936b70edb214825844278843c43a5b4_Out_2;
Unity_Divide_float(float(1), _OneMinus_b15350733f714030bbb8e51adc3f2ffa_Out_1, _Divide_c936b70edb214825844278843c43a5b4_Out_2);
float _Multiply_4ebec976c0de473485c3c03bcd80f237_Out_2;
Unity_Multiply_float_float(_Absolute_613421c39e244536a4db652ebd863719_Out_1, _Divide_c936b70edb214825844278843c43a5b4_Out_2, _Multiply_4ebec976c0de473485c3c03bcd80f237_Out_2);
float _Branch_0bf1a5152d0d4e409b2a8ac4c9a19c6c_Out_3;
Unity_Branch_float(_Comparison_322cfaaadddd4969978d57a8c96084ef_Out_2, _Absolute_613421c39e244536a4db652ebd863719_Out_1, _Multiply_4ebec976c0de473485c3c03bcd80f237_Out_2, _Branch_0bf1a5152d0d4e409b2a8ac4c9a19c6c_Out_3);
float _Fraction_ffa3d7988daa4641b5a50431f32bca43_Out_1;
Unity_Fraction_float(_Branch_0bf1a5152d0d4e409b2a8ac4c9a19c6c_Out_3, _Fraction_ffa3d7988daa4641b5a50431f32bca43_Out_1);
float _Multiply_f947dbc1e8a749beb38558e0bef1b8fa_Out_2;
Unity_Multiply_float_float(_Fraction_ffa3d7988daa4641b5a50431f32bca43_Out_1, 0.5, _Multiply_f947dbc1e8a749beb38558e0bef1b8fa_Out_2);
float _Branch_eff1171da1214341b2c0342c1c420eaa_Out_3;
Unity_Branch_float(_Property_1385c4534688495ba3c996fbab6c5bfa_Out_0, _Multiply_93477a679f5e46959ff06b9cec3b7c01_Out_2, _Property_bbaa27bcd1cd41f2af6709b866a5a0cf_Out_0, _Branch_eff1171da1214341b2c0342c1c420eaa_Out_3);
float _Fraction_c62e039143ec48078706377fd40a9b87_Out_1;
Unity_Fraction_float(_Branch_eff1171da1214341b2c0342c1c420eaa_Out_3, _Fraction_c62e039143ec48078706377fd40a9b87_Out_1);
float _Multiply_88201bca4eba4105a838005eef534fbf_Out_2;
Unity_Multiply_float_float(_Branch_0bf1a5152d0d4e409b2a8ac4c9a19c6c_Out_3, _Fraction_c62e039143ec48078706377fd40a9b87_Out_1, _Multiply_88201bca4eba4105a838005eef534fbf_Out_2);
float _Fraction_da1e533528374e429677766f263c6e5b_Out_1;
Unity_Fraction_float(_Multiply_88201bca4eba4105a838005eef534fbf_Out_2, _Fraction_da1e533528374e429677766f263c6e5b_Out_1);
float _Multiply_dd4b4a21ed7c4847a21f9ead321ccf75_Out_2;
Unity_Multiply_float_float(_Fraction_da1e533528374e429677766f263c6e5b_Out_1, 0.5, _Multiply_dd4b4a21ed7c4847a21f9ead321ccf75_Out_2);
float _Subtract_410ed77411134dffa6af813286383dd3_Out_2;
Unity_Subtract_float(_Multiply_f947dbc1e8a749beb38558e0bef1b8fa_Out_2, _Multiply_dd4b4a21ed7c4847a21f9ead321ccf75_Out_2, _Subtract_410ed77411134dffa6af813286383dd3_Out_2);
float Constant_a2d9bf5ca18e45dd9771a08b506e2fd6 = 6.283185;
float _Multiply_e4ab046e3cdc40f2b5a3257171ce80eb_Out_2;
Unity_Multiply_float_float(_Subtract_410ed77411134dffa6af813286383dd3_Out_2, Constant_a2d9bf5ca18e45dd9771a08b506e2fd6, _Multiply_e4ab046e3cdc40f2b5a3257171ce80eb_Out_2);
float _Sine_bdffb5ea491c475f8e3864f029104205_Out_1;
Unity_Sine_float(_Multiply_e4ab046e3cdc40f2b5a3257171ce80eb_Out_2, _Sine_bdffb5ea491c475f8e3864f029104205_Out_1);
float4 _Multiply_f867ff437f684bc4810cdb80278dd084_Out_2;
Unity_Multiply_float4_float4(_DecodeQuaternionCustomFunction_6de7e7521c444a8fa56b1fc4c08b5518_OutXYZW_2, (_Sine_bdffb5ea491c475f8e3864f029104205_Out_1.xxxx), _Multiply_f867ff437f684bc4810cdb80278dd084_Out_2);
float _Modulo_1516a1ff77cb45dc94ae896cd3ac7467_Out_2;
Unity_Modulo_float(_Branch_49a68901b23c4894bfa1af72c26bfc34_Out_3, _Property_36bda8feb9f646a589a5298330a8efb5_Out_0, _Modulo_1516a1ff77cb45dc94ae896cd3ac7467_Out_2);
float _Multiply_cfb7fa4be2094158a058e2c60bbf86e0_Out_2;
Unity_Multiply_float_float(_Modulo_1516a1ff77cb45dc94ae896cd3ac7467_Out_2, _Divide_8940f8cc6cc745d28630ad7d2e2ba98d_Out_2, _Multiply_cfb7fa4be2094158a058e2c60bbf86e0_Out_2);
float _Multiply_543fbeed774e4177b11301a6f0ddea3e_Out_2;
Unity_Multiply_float_float(_Multiply_cfb7fa4be2094158a058e2c60bbf86e0_Out_2, _OneMinus_6a6f086f607e42bb8409559598119dd2_Out_1, _Multiply_543fbeed774e4177b11301a6f0ddea3e_Out_2);
float _Add_ec5f1cbe56ae4bc3adc07cab0b3cada0_Out_2;
Unity_Add_float(_Multiply_5a5cd519af8341f3b924960c61aaffff_Out_2, _Multiply_543fbeed774e4177b11301a6f0ddea3e_Out_2, _Add_ec5f1cbe56ae4bc3adc07cab0b3cada0_Out_2);
float _OneMinus_9d3490960b384871a31943f989e612cd_Out_1;
Unity_OneMinus_float(_Add_ec5f1cbe56ae4bc3adc07cab0b3cada0_Out_2, _OneMinus_9d3490960b384871a31943f989e612cd_Out_1);
float4 _Combine_a5e0df8891744ba98da48d60a7cffd50_RGBA_4;
float3 _Combine_a5e0df8891744ba98da48d60a7cffd50_RGB_5;
float2 _Combine_a5e0df8891744ba98da48d60a7cffd50_RG_6;
Unity_Combine_float(_Multiply_9b6c319d4f9f4f64afb5813d2670c683_Out_2, _OneMinus_9d3490960b384871a31943f989e612cd_Out_1, float(0), float(0), _Combine_a5e0df8891744ba98da48d60a7cffd50_RGBA_4, _Combine_a5e0df8891744ba98da48d60a7cffd50_RGB_5, _Combine_a5e0df8891744ba98da48d60a7cffd50_RG_6);
#if defined(SHADER_API_GLES) && (SHADER_TARGET < 30)
  float4 _SampleTexture2DLOD_9b73f7cc5d31427ebb8a4386ca348b98_RGBA_0 = float4(0.0f, 0.0f, 0.0f, 1.0f);
#else
  float4 _SampleTexture2DLOD_9b73f7cc5d31427ebb8a4386ca348b98_RGBA_0 = SAMPLE_TEXTURE2D_LOD(_Property_9114fd6d110d4133883ddd3127a123c9_Out_0.tex, _Property_9114fd6d110d4133883ddd3127a123c9_Out_0.samplerstate, _Property_9114fd6d110d4133883ddd3127a123c9_Out_0.GetTransformedUV(_Combine_a5e0df8891744ba98da48d60a7cffd50_RG_6), float(0));
#endif
float _SampleTexture2DLOD_9b73f7cc5d31427ebb8a4386ca348b98_R_5 = _SampleTexture2DLOD_9b73f7cc5d31427ebb8a4386ca348b98_RGBA_0.r;
float _SampleTexture2DLOD_9b73f7cc5d31427ebb8a4386ca348b98_G_6 = _SampleTexture2DLOD_9b73f7cc5d31427ebb8a4386ca348b98_RGBA_0.g;
float _SampleTexture2DLOD_9b73f7cc5d31427ebb8a4386ca348b98_B_7 = _SampleTexture2DLOD_9b73f7cc5d31427ebb8a4386ca348b98_RGBA_0.b;
float _SampleTexture2DLOD_9b73f7cc5d31427ebb8a4386ca348b98_A_8 = _SampleTexture2DLOD_9b73f7cc5d31427ebb8a4386ca348b98_RGBA_0.a;
float4 _Subtract_b7a51a54673b44099537220b53a5e575_Out_2;
Unity_Subtract_float4(_SampleTexture2DLOD_9b73f7cc5d31427ebb8a4386ca348b98_RGBA_0, float4(0.5, 0.5, 0.5, 0.5), _Subtract_b7a51a54673b44099537220b53a5e575_Out_2);
float4 _Multiply_07e5298166d34c888eb055a582947143_Out_2;
Unity_Multiply_float4_float4(_Subtract_b7a51a54673b44099537220b53a5e575_Out_2, float4(2, 2, 2, 2), _Multiply_07e5298166d34c888eb055a582947143_Out_2);
float4 _Branch_9c64c7604ee44c2f9984f4e9f853e1db_Out_3;
Unity_Branch_float4(_Comparison_322cfaaadddd4969978d57a8c96084ef_Out_2, _SampleTexture2DLOD_9b73f7cc5d31427ebb8a4386ca348b98_RGBA_0, _Multiply_07e5298166d34c888eb055a582947143_Out_2, _Branch_9c64c7604ee44c2f9984f4e9f853e1db_Out_3);
float _Split_80fcb0c4e8804af29cbb37674aadea2c_R_1 = _Branch_9c64c7604ee44c2f9984f4e9f853e1db_Out_3[0];
float _Split_80fcb0c4e8804af29cbb37674aadea2c_G_2 = _Branch_9c64c7604ee44c2f9984f4e9f853e1db_Out_3[1];
float _Split_80fcb0c4e8804af29cbb37674aadea2c_B_3 = _Branch_9c64c7604ee44c2f9984f4e9f853e1db_Out_3[2];
float _Split_80fcb0c4e8804af29cbb37674aadea2c_A_4 = _Branch_9c64c7604ee44c2f9984f4e9f853e1db_Out_3[3];
float4 _Combine_d2560aa0bd5045799a1d6b0e31b48add_RGBA_4;
float3 _Combine_d2560aa0bd5045799a1d6b0e31b48add_RGB_5;
float2 _Combine_d2560aa0bd5045799a1d6b0e31b48add_RG_6;
Unity_Combine_float(_Split_80fcb0c4e8804af29cbb37674aadea2c_R_1, _Split_80fcb0c4e8804af29cbb37674aadea2c_G_2, _Split_80fcb0c4e8804af29cbb37674aadea2c_B_3, float(0), _Combine_d2560aa0bd5045799a1d6b0e31b48add_RGBA_4, _Combine_d2560aa0bd5045799a1d6b0e31b48add_RGB_5, _Combine_d2560aa0bd5045799a1d6b0e31b48add_RG_6);
#if defined(SHADER_API_GLES) && (SHADER_TARGET < 30)
  float4 _SampleTexture2DLOD_d92919bca21f48e29f52a6d33023c4aa_RGBA_0 = float4(0.0f, 0.0f, 0.0f, 1.0f);
#else
  float4 _SampleTexture2DLOD_d92919bca21f48e29f52a6d33023c4aa_RGBA_0 = SAMPLE_TEXTURE2D_LOD(_Property_7dbd408acfee4e078cd82cbe1e5f572b_Out_0.tex, _Property_7dbd408acfee4e078cd82cbe1e5f572b_Out_0.samplerstate, _Property_7dbd408acfee4e078cd82cbe1e5f572b_Out_0.GetTransformedUV(_Combine_a5e0df8891744ba98da48d60a7cffd50_RG_6), float(0));
#endif
float _SampleTexture2DLOD_d92919bca21f48e29f52a6d33023c4aa_R_5 = _SampleTexture2DLOD_d92919bca21f48e29f52a6d33023c4aa_RGBA_0.r;
float _SampleTexture2DLOD_d92919bca21f48e29f52a6d33023c4aa_G_6 = _SampleTexture2DLOD_d92919bca21f48e29f52a6d33023c4aa_RGBA_0.g;
float _SampleTexture2DLOD_d92919bca21f48e29f52a6d33023c4aa_B_7 = _SampleTexture2DLOD_d92919bca21f48e29f52a6d33023c4aa_RGBA_0.b;
float _SampleTexture2DLOD_d92919bca21f48e29f52a6d33023c4aa_A_8 = _SampleTexture2DLOD_d92919bca21f48e29f52a6d33023c4aa_RGBA_0.a;
float _Multiply_3bef55aa6ed148a398fe70ea0b10dafc_Out_2;
Unity_Multiply_float_float(_SampleTexture2DLOD_d92919bca21f48e29f52a6d33023c4aa_A_8, 4, _Multiply_3bef55aa6ed148a398fe70ea0b10dafc_Out_2);
float _Floor_e0a98d028f1749d3b749bc97c81a569e_Out_1;
Unity_Floor_float(_Multiply_3bef55aa6ed148a398fe70ea0b10dafc_Out_2, _Floor_e0a98d028f1749d3b749bc97c81a569e_Out_1);
float4 _DecodeQuaternionCustomFunction_08bdc03b6109407d96635e4daa8cb042_OutXYZW_2;
Decode_Quaternion_float(_Combine_d2560aa0bd5045799a1d6b0e31b48add_RGB_5, _Floor_e0a98d028f1749d3b749bc97c81a569e_Out_1, _DecodeQuaternionCustomFunction_08bdc03b6109407d96635e4daa8cb042_OutXYZW_2);
float _Sign_7914421bf9ea49859d084a55fc0b937e_Out_1;
Unity_Sign_float(_Split_abf23ca3bd0842eab3977324259feb60_A_4, _Sign_7914421bf9ea49859d084a55fc0b937e_Out_1);
float4 _Multiply_954d292058014c3780fc85e85b37ff58_Out_2;
Unity_Multiply_float4_float4(_DecodeQuaternionCustomFunction_08bdc03b6109407d96635e4daa8cb042_OutXYZW_2, (_Sign_7914421bf9ea49859d084a55fc0b937e_Out_1.xxxx), _Multiply_954d292058014c3780fc85e85b37ff58_Out_2);
float _Multiply_3934041d4da34f33a378403df611cb3b_Out_2;
Unity_Multiply_float_float(_Multiply_dd4b4a21ed7c4847a21f9ead321ccf75_Out_2, Constant_a2d9bf5ca18e45dd9771a08b506e2fd6, _Multiply_3934041d4da34f33a378403df611cb3b_Out_2);
float _Sine_44c8fe0289b44c2baa95d34b5f14564b_Out_1;
Unity_Sine_float(_Multiply_3934041d4da34f33a378403df611cb3b_Out_2, _Sine_44c8fe0289b44c2baa95d34b5f14564b_Out_1);
float4 _Multiply_43567b2eb3b54a958fbdf2132c76c3db_Out_2;
Unity_Multiply_float4_float4(_Multiply_954d292058014c3780fc85e85b37ff58_Out_2, (_Sine_44c8fe0289b44c2baa95d34b5f14564b_Out_1.xxxx), _Multiply_43567b2eb3b54a958fbdf2132c76c3db_Out_2);
float4 _Add_37b459ad577245e7adc9018101dd96e6_Out_2;
Unity_Add_float4(_Multiply_f867ff437f684bc4810cdb80278dd084_Out_2, _Multiply_43567b2eb3b54a958fbdf2132c76c3db_Out_2, _Add_37b459ad577245e7adc9018101dd96e6_Out_2);
float _Multiply_949e9ecdf588438bbf90616ea0fa6358_Out_2;
Unity_Multiply_float_float(_Multiply_f947dbc1e8a749beb38558e0bef1b8fa_Out_2, Constant_a2d9bf5ca18e45dd9771a08b506e2fd6, _Multiply_949e9ecdf588438bbf90616ea0fa6358_Out_2);
float _Sine_9716d493df4c4225b1be55410aa3b6d8_Out_1;
Unity_Sine_float(_Multiply_949e9ecdf588438bbf90616ea0fa6358_Out_2, _Sine_9716d493df4c4225b1be55410aa3b6d8_Out_1);
float4 _Divide_20fbc487f25240c7802ac61ae2d336c6_Out_2;
Unity_Divide_float4(_Add_37b459ad577245e7adc9018101dd96e6_Out_2, (_Sine_9716d493df4c4225b1be55410aa3b6d8_Out_1.xxxx), _Divide_20fbc487f25240c7802ac61ae2d336c6_Out_2);
float4 _Normalize_c028599e0d1d4c5985b78c33212f9a0c_Out_1;
Unity_Normalize_float4(_Divide_20fbc487f25240c7802ac61ae2d336c6_Out_2, _Normalize_c028599e0d1d4c5985b78c33212f9a0c_Out_1);
float4 _Branch_eb507c876e864ee08168417cee04d1fc_Out_3;
Unity_Branch_float4(_Comparison_438e9817473f4f1fab2ea5dd9ce5bcf8_Out_2, _Normalize_c028599e0d1d4c5985b78c33212f9a0c_Out_1, _DecodeQuaternionCustomFunction_6de7e7521c444a8fa56b1fc4c08b5518_OutXYZW_2, _Branch_eb507c876e864ee08168417cee04d1fc_Out_3);
float4 _Branch_2db7ae80ee1a4fa7aad5c113e11603b8_Out_3;
Unity_Branch_float4(_Property_e1b472109c904495bfad45a873a6aaaf_Out_0, _Branch_eb507c876e864ee08168417cee04d1fc_Out_3, _DecodeQuaternionCustomFunction_6de7e7521c444a8fa56b1fc4c08b5518_OutXYZW_2, _Branch_2db7ae80ee1a4fa7aad5c113e11603b8_Out_3);
float _Split_70d7fe38e42f4a49b6a12b4a28073bfb_R_1 = _Branch_2db7ae80ee1a4fa7aad5c113e11603b8_Out_3[0];
float _Split_70d7fe38e42f4a49b6a12b4a28073bfb_G_2 = _Branch_2db7ae80ee1a4fa7aad5c113e11603b8_Out_3[1];
float _Split_70d7fe38e42f4a49b6a12b4a28073bfb_B_3 = _Branch_2db7ae80ee1a4fa7aad5c113e11603b8_Out_3[2];
float _Split_70d7fe38e42f4a49b6a12b4a28073bfb_A_4 = _Branch_2db7ae80ee1a4fa7aad5c113e11603b8_Out_3[3];
float4 _Combine_c62cf49352cf4def93cd35bff786a4f8_RGBA_4;
float3 _Combine_c62cf49352cf4def93cd35bff786a4f8_RGB_5;
float2 _Combine_c62cf49352cf4def93cd35bff786a4f8_RG_6;
Unity_Combine_float(_Split_70d7fe38e42f4a49b6a12b4a28073bfb_R_1, _Split_70d7fe38e42f4a49b6a12b4a28073bfb_G_2, _Split_70d7fe38e42f4a49b6a12b4a28073bfb_B_3, float(0), _Combine_c62cf49352cf4def93cd35bff786a4f8_RGBA_4, _Combine_c62cf49352cf4def93cd35bff786a4f8_RGB_5, _Combine_c62cf49352cf4def93cd35bff786a4f8_RG_6);
float4 _UV_fa8f02ef2e484ce2a563a00bd562b3c7_Out_0 = IN.uv2;
float _Split_7afd517dccf7404b99a40dd3c607f89b_R_1 = _UV_fa8f02ef2e484ce2a563a00bd562b3c7_Out_0[0];
float _Split_7afd517dccf7404b99a40dd3c607f89b_G_2 = _UV_fa8f02ef2e484ce2a563a00bd562b3c7_Out_0[1];
float _Split_7afd517dccf7404b99a40dd3c607f89b_B_3 = _UV_fa8f02ef2e484ce2a563a00bd562b3c7_Out_0[2];
float _Split_7afd517dccf7404b99a40dd3c607f89b_A_4 = _UV_fa8f02ef2e484ce2a563a00bd562b3c7_Out_0[3];
float _Multiply_d6360a1521fb48a0a05cd08d73eed501_Out_2;
Unity_Multiply_float_float(_Split_7afd517dccf7404b99a40dd3c607f89b_R_1, -1, _Multiply_d6360a1521fb48a0a05cd08d73eed501_Out_2);
float4 _UV_8b83443e55e74c1e9ec329aea8e41f00_Out_0 = IN.uv3;
float _Split_a3e34a5b0d534cd59d8920be9a923edf_R_1 = _UV_8b83443e55e74c1e9ec329aea8e41f00_Out_0[0];
float _Split_a3e34a5b0d534cd59d8920be9a923edf_G_2 = _UV_8b83443e55e74c1e9ec329aea8e41f00_Out_0[1];
float _Split_a3e34a5b0d534cd59d8920be9a923edf_B_3 = _UV_8b83443e55e74c1e9ec329aea8e41f00_Out_0[2];
float _Split_a3e34a5b0d534cd59d8920be9a923edf_A_4 = _UV_8b83443e55e74c1e9ec329aea8e41f00_Out_0[3];
float _OneMinus_098c078147344a55a81768b536131833_Out_1;
Unity_OneMinus_float(_Split_a3e34a5b0d534cd59d8920be9a923edf_G_2, _OneMinus_098c078147344a55a81768b536131833_Out_1);
float4 _Combine_c5b8f60c79034bba86a0dcdd200aaf52_RGBA_4;
float3 _Combine_c5b8f60c79034bba86a0dcdd200aaf52_RGB_5;
float2 _Combine_c5b8f60c79034bba86a0dcdd200aaf52_RG_6;
Unity_Combine_float(_Multiply_d6360a1521fb48a0a05cd08d73eed501_Out_2, _Split_a3e34a5b0d534cd59d8920be9a923edf_R_1, _OneMinus_098c078147344a55a81768b536131833_Out_1, float(0), _Combine_c5b8f60c79034bba86a0dcdd200aaf52_RGBA_4, _Combine_c5b8f60c79034bba86a0dcdd200aaf52_RGB_5, _Combine_c5b8f60c79034bba86a0dcdd200aaf52_RG_6);
float3 _Subtract_7d4d4fd0026a43aba75a54d7606035d0_Out_2;
Unity_Subtract_float3(IN.ObjectSpacePosition, _Combine_c5b8f60c79034bba86a0dcdd200aaf52_RGB_5, _Subtract_7d4d4fd0026a43aba75a54d7606035d0_Out_2);
float3 _CrossProduct_34801cb8e20c421c9c778d4af18a612f_Out_2;
Unity_CrossProduct_float(_Combine_c62cf49352cf4def93cd35bff786a4f8_RGB_5, _Subtract_7d4d4fd0026a43aba75a54d7606035d0_Out_2, _CrossProduct_34801cb8e20c421c9c778d4af18a612f_Out_2);
float3 _Multiply_25a9cad507fe42db8daf9dcecc21befc_Out_2;
Unity_Multiply_float3_float3(_Subtract_7d4d4fd0026a43aba75a54d7606035d0_Out_2, (_Split_70d7fe38e42f4a49b6a12b4a28073bfb_A_4.xxx), _Multiply_25a9cad507fe42db8daf9dcecc21befc_Out_2);
float3 _Add_e51d5fd36c61408ab4ff0f915e815b9d_Out_2;
Unity_Add_float3(_CrossProduct_34801cb8e20c421c9c778d4af18a612f_Out_2, _Multiply_25a9cad507fe42db8daf9dcecc21befc_Out_2, _Add_e51d5fd36c61408ab4ff0f915e815b9d_Out_2);
float3 _CrossProduct_f6d776468af0467fa5a8e9c53c8ded57_Out_2;
Unity_CrossProduct_float(_Combine_c62cf49352cf4def93cd35bff786a4f8_RGB_5, _Add_e51d5fd36c61408ab4ff0f915e815b9d_Out_2, _CrossProduct_f6d776468af0467fa5a8e9c53c8ded57_Out_2);
float3 _Multiply_d5c943298de44bc68d77c2a6ef0e2021_Out_2;
Unity_Multiply_float3_float3(_CrossProduct_f6d776468af0467fa5a8e9c53c8ded57_Out_2, float3(2, 2, 2), _Multiply_d5c943298de44bc68d77c2a6ef0e2021_Out_2);
float3 _Add_35cadb8beba84319b7c86c86694dcab6_Out_2;
Unity_Add_float3(_Multiply_d5c943298de44bc68d77c2a6ef0e2021_Out_2, _Subtract_7d4d4fd0026a43aba75a54d7606035d0_Out_2, _Add_35cadb8beba84319b7c86c86694dcab6_Out_2);
float _Property_c7e79dafca81422598d644abb0295581_Out_0 = _Stretch_by_Velocity;
float _Property_a0ba1f43faf044b68041f47417cbd7af_Out_0 = _Interframe_Interpolation;
float _Property_eadb5ba513a6498e8244047c79345758_Out_0 = _Interpolate_Color;
float _And_f3054b8d20aa48bfae7a5d53c8acc3cc_Out_2;
Unity_And_float(_Property_a0ba1f43faf044b68041f47417cbd7af_Out_0, _Property_eadb5ba513a6498e8244047c79345758_Out_0, _And_f3054b8d20aa48bfae7a5d53c8acc3cc_Out_2);
UnityTexture2D _Property_2aa42de9e6e04e418c75ca022cb8072c_Out_0 = Texture2D_e2d9e8f7eef04f15ad7d3a47dcf08a66;
#if defined(SHADER_API_GLES) && (SHADER_TARGET < 30)
  float4 _SampleTexture2DLOD_1c09d18b469d42cba4408dce5ff8f8ab_RGBA_0 = float4(0.0f, 0.0f, 0.0f, 1.0f);
#else
  float4 _SampleTexture2DLOD_1c09d18b469d42cba4408dce5ff8f8ab_RGBA_0 = SAMPLE_TEXTURE2D_LOD(_Property_2aa42de9e6e04e418c75ca022cb8072c_Out_0.tex, _Property_2aa42de9e6e04e418c75ca022cb8072c_Out_0.samplerstate, _Property_2aa42de9e6e04e418c75ca022cb8072c_Out_0.GetTransformedUV(_Combine_7acf849c0cd74d32b462c613ff310511_RG_6), float(0));
#endif
float _SampleTexture2DLOD_1c09d18b469d42cba4408dce5ff8f8ab_R_5 = _SampleTexture2DLOD_1c09d18b469d42cba4408dce5ff8f8ab_RGBA_0.r;
float _SampleTexture2DLOD_1c09d18b469d42cba4408dce5ff8f8ab_G_6 = _SampleTexture2DLOD_1c09d18b469d42cba4408dce5ff8f8ab_RGBA_0.g;
float _SampleTexture2DLOD_1c09d18b469d42cba4408dce5ff8f8ab_B_7 = _SampleTexture2DLOD_1c09d18b469d42cba4408dce5ff8f8ab_RGBA_0.b;
float _SampleTexture2DLOD_1c09d18b469d42cba4408dce5ff8f8ab_A_8 = _SampleTexture2DLOD_1c09d18b469d42cba4408dce5ff8f8ab_RGBA_0.a;
float4 _Vector4_a3433028d24348f4bacad3b6e061f9d5_Out_0 = float4(float(0), float(0), float(0), float(0));
#if defined(_B_LOAD_COL_TEX)
float4 _LoadColorTexture_f0d31671e10846148e10ff6f6ddcce87_Out_0 = _SampleTexture2DLOD_1c09d18b469d42cba4408dce5ff8f8ab_RGBA_0;
#else
float4 _LoadColorTexture_f0d31671e10846148e10ff6f6ddcce87_Out_0 = _Vector4_a3433028d24348f4bacad3b6e061f9d5_Out_0;
#endif
#if defined(SHADER_API_GLES) && (SHADER_TARGET < 30)
  float4 _SampleTexture2DLOD_c6fd58a33ebf447694f7269eaf935a8b_RGBA_0 = float4(0.0f, 0.0f, 0.0f, 1.0f);
#else
  float4 _SampleTexture2DLOD_c6fd58a33ebf447694f7269eaf935a8b_RGBA_0 = SAMPLE_TEXTURE2D_LOD(_Property_2aa42de9e6e04e418c75ca022cb8072c_Out_0.tex, _Property_2aa42de9e6e04e418c75ca022cb8072c_Out_0.samplerstate, _Property_2aa42de9e6e04e418c75ca022cb8072c_Out_0.GetTransformedUV(_Combine_a5e0df8891744ba98da48d60a7cffd50_RG_6), float(0));
#endif
float _SampleTexture2DLOD_c6fd58a33ebf447694f7269eaf935a8b_R_5 = _SampleTexture2DLOD_c6fd58a33ebf447694f7269eaf935a8b_RGBA_0.r;
float _SampleTexture2DLOD_c6fd58a33ebf447694f7269eaf935a8b_G_6 = _SampleTexture2DLOD_c6fd58a33ebf447694f7269eaf935a8b_RGBA_0.g;
float _SampleTexture2DLOD_c6fd58a33ebf447694f7269eaf935a8b_B_7 = _SampleTexture2DLOD_c6fd58a33ebf447694f7269eaf935a8b_RGBA_0.b;
float _SampleTexture2DLOD_c6fd58a33ebf447694f7269eaf935a8b_A_8 = _SampleTexture2DLOD_c6fd58a33ebf447694f7269eaf935a8b_RGBA_0.a;
#if defined(_B_LOAD_COL_TEX)
float4 _LoadColorTexture_cc743dddac284c769882b4847ff7576b_Out_0 = _SampleTexture2DLOD_c6fd58a33ebf447694f7269eaf935a8b_RGBA_0;
#else
float4 _LoadColorTexture_cc743dddac284c769882b4847ff7576b_Out_0 = _Vector4_a3433028d24348f4bacad3b6e061f9d5_Out_0;
#endif
float4 _Lerp_711aa73fbc3f4d319b13362297282106_Out_3;
Unity_Lerp_float4(_LoadColorTexture_f0d31671e10846148e10ff6f6ddcce87_Out_0, _LoadColorTexture_cc743dddac284c769882b4847ff7576b_Out_0, (_Fraction_c62e039143ec48078706377fd40a9b87_Out_1.xxxx), _Lerp_711aa73fbc3f4d319b13362297282106_Out_3);
float4 _Branch_3c68277c1c8744a59f98768785e6c5e7_Out_3;
Unity_Branch_float4(_And_f3054b8d20aa48bfae7a5d53c8acc3cc_Out_2, _Lerp_711aa73fbc3f4d319b13362297282106_Out_3, _LoadColorTexture_f0d31671e10846148e10ff6f6ddcce87_Out_0, _Branch_3c68277c1c8744a59f98768785e6c5e7_Out_3);
float _Split_4d8e2369f047422c8b3838da41666224_R_1 = _Branch_3c68277c1c8744a59f98768785e6c5e7_Out_3[0];
float _Split_4d8e2369f047422c8b3838da41666224_G_2 = _Branch_3c68277c1c8744a59f98768785e6c5e7_Out_3[1];
float _Split_4d8e2369f047422c8b3838da41666224_B_3 = _Branch_3c68277c1c8744a59f98768785e6c5e7_Out_3[2];
float _Split_4d8e2369f047422c8b3838da41666224_A_4 = _Branch_3c68277c1c8744a59f98768785e6c5e7_Out_3[3];
float _Multiply_ce19a663a8d547228ed9314e5bc8dea9_Out_2;
Unity_Multiply_float_float(_Split_4d8e2369f047422c8b3838da41666224_R_1, -1, _Multiply_ce19a663a8d547228ed9314e5bc8dea9_Out_2);
float4 _Combine_1840611a245a41ba91ab0037d21ece7c_RGBA_4;
float3 _Combine_1840611a245a41ba91ab0037d21ece7c_RGB_5;
float2 _Combine_1840611a245a41ba91ab0037d21ece7c_RG_6;
Unity_Combine_float(_Multiply_ce19a663a8d547228ed9314e5bc8dea9_Out_2, _Split_4d8e2369f047422c8b3838da41666224_G_2, _Split_4d8e2369f047422c8b3838da41666224_B_3, float(0), _Combine_1840611a245a41ba91ab0037d21ece7c_RGBA_4, _Combine_1840611a245a41ba91ab0037d21ece7c_RGB_5, _Combine_1840611a245a41ba91ab0037d21ece7c_RG_6);
float3 _Vector3_15aecf0488824eeea4967cba0231c95e_Out_0 = float3(float(0), float(0), float(0));
float3 _Branch_242e07af2d894b35bfd183d5797f6838_Out_3;
Unity_Branch_float3(_Property_c7e79dafca81422598d644abb0295581_Out_0, _Combine_1840611a245a41ba91ab0037d21ece7c_RGB_5, _Vector3_15aecf0488824eeea4967cba0231c95e_Out_0, _Branch_242e07af2d894b35bfd183d5797f6838_Out_3);
float3 _Absolute_447686bfd2ba4354a5e54d566a3007d7_Out_1;
Unity_Absolute_float3(_Branch_242e07af2d894b35bfd183d5797f6838_Out_3, _Absolute_447686bfd2ba4354a5e54d566a3007d7_Out_1);
float _Property_bd4c17c3b42945fc8b675c6d8b2657c4_Out_0 = _Stretch_by_Velocity_Amount;
float3 _Multiply_f4488f9db2d54d4eb411deee45cdaec0_Out_2;
Unity_Multiply_float3_float3(_Absolute_447686bfd2ba4354a5e54d566a3007d7_Out_1, (_Property_bd4c17c3b42945fc8b675c6d8b2657c4_Out_0.xxx), _Multiply_f4488f9db2d54d4eb411deee45cdaec0_Out_2);
float3 _Add_9d3cdc7ed2da4ff287ed700521fb79cb_Out_2;
Unity_Add_float3(_Multiply_f4488f9db2d54d4eb411deee45cdaec0_Out_2, float3(1, 1, 1), _Add_9d3cdc7ed2da4ff287ed700521fb79cb_Out_2);
float _Property_8ee8917f00e3449395c5eea43291705f_Out_0 = _Global_Piece_Scale_Multiplier;
float3 _Multiply_f845b91c6da540e183cbcdfaed766334_Out_2;
Unity_Multiply_float3_float3(_Add_9d3cdc7ed2da4ff287ed700521fb79cb_Out_2, (_Property_8ee8917f00e3449395c5eea43291705f_Out_0.xxx), _Multiply_f845b91c6da540e183cbcdfaed766334_Out_2);
float _Property_186f741aac5e416aa8ebd42eae9efe37_Out_0 = _Piece_Scales_Are_in_Position_Alpha;
float _Floor_85c378b26acf448082167d21248936fd_Out_1;
Unity_Floor_float(_Split_c57cc6c2a4714679969ca15abe6b868d_G_2, _Floor_85c378b26acf448082167d21248936fd_Out_1);
float _Subtract_6e96b166ec394865919eea36f8129ff9_Out_2;
Unity_Subtract_float(_Split_c57cc6c2a4714679969ca15abe6b868d_G_2, _Floor_85c378b26acf448082167d21248936fd_Out_1, _Subtract_6e96b166ec394865919eea36f8129ff9_Out_2);
float _OneMinus_af2916e9237347d78467467e0d2806a4_Out_1;
Unity_OneMinus_float(_Subtract_6e96b166ec394865919eea36f8129ff9_Out_2, _OneMinus_af2916e9237347d78467467e0d2806a4_Out_1);
float _Divide_569c994b2ab34847bd4a297c59a7ca80_Out_2;
Unity_Divide_float(float(1), _OneMinus_af2916e9237347d78467467e0d2806a4_Out_1, _Divide_569c994b2ab34847bd4a297c59a7ca80_Out_2);
float _Property_107ccb5b88da4d1cad7d392c75edb794_Out_0 = _Interframe_Interpolation;
float _Fraction_0dc32141f20a48d3b9756b16c416b3a4_Out_1;
Unity_Fraction_float(_Multiply_95ca52288ea140a788cd9e349cad7773_Out_2, _Fraction_0dc32141f20a48d3b9756b16c416b3a4_Out_1);
float _OneMinus_9b87aca1ae574fd289bcfc7b1beb7820_Out_1;
Unity_OneMinus_float(_Fraction_0dc32141f20a48d3b9756b16c416b3a4_Out_1, _OneMinus_9b87aca1ae574fd289bcfc7b1beb7820_Out_1);
float _Fraction_741137d353274eaca925a62fc252e2f7_Out_1;
Unity_Fraction_float(_Multiply_3bef55aa6ed148a398fe70ea0b10dafc_Out_2, _Fraction_741137d353274eaca925a62fc252e2f7_Out_1);
float _OneMinus_fe03f4b292834b7991037367f130cefa_Out_1;
Unity_OneMinus_float(_Fraction_741137d353274eaca925a62fc252e2f7_Out_1, _OneMinus_fe03f4b292834b7991037367f130cefa_Out_1);
float _Lerp_c236e21084c048258b89aa1f6f8df177_Out_3;
Unity_Lerp_float(_OneMinus_9b87aca1ae574fd289bcfc7b1beb7820_Out_1, _OneMinus_fe03f4b292834b7991037367f130cefa_Out_1, _Fraction_c62e039143ec48078706377fd40a9b87_Out_1, _Lerp_c236e21084c048258b89aa1f6f8df177_Out_3);
float _Branch_15ae6925b3d54c46a9b155c30c08257d_Out_3;
Unity_Branch_float(_Property_107ccb5b88da4d1cad7d392c75edb794_Out_0, _Lerp_c236e21084c048258b89aa1f6f8df177_Out_3, _OneMinus_9b87aca1ae574fd289bcfc7b1beb7820_Out_1, _Branch_15ae6925b3d54c46a9b155c30c08257d_Out_3);
float _Multiply_864a587ed0774fceb6983b19629dca8b_Out_2;
Unity_Multiply_float_float(_Divide_569c994b2ab34847bd4a297c59a7ca80_Out_2, _Branch_15ae6925b3d54c46a9b155c30c08257d_Out_3, _Multiply_864a587ed0774fceb6983b19629dca8b_Out_2);
float _Branch_e19e3a90853948fcb7579b26d288868c_Out_3;
Unity_Branch_float(_Property_186f741aac5e416aa8ebd42eae9efe37_Out_0, _Multiply_864a587ed0774fceb6983b19629dca8b_Out_2, float(1), _Branch_e19e3a90853948fcb7579b26d288868c_Out_3);
float3 _Multiply_3bb4a7e6c4104359a4a521977dc04358_Out_2;
Unity_Multiply_float3_float3(_Multiply_f845b91c6da540e183cbcdfaed766334_Out_2, (_Branch_e19e3a90853948fcb7579b26d288868c_Out_3.xxx), _Multiply_3bb4a7e6c4104359a4a521977dc04358_Out_2);
float3 _Multiply_ae9a523d22654befb80a94a4d9838cfe_Out_2;
Unity_Multiply_float3_float3(_Add_35cadb8beba84319b7c86c86694dcab6_Out_2, _Multiply_3bb4a7e6c4104359a4a521977dc04358_Out_2, _Multiply_ae9a523d22654befb80a94a4d9838cfe_Out_2);
float _Property_1238b8669b754229a924fa19745c9a3a_Out_0 = _Interframe_Interpolation;
float _Floor_8451392599f740c2aaf9026063cf9e17_Out_1;
Unity_Floor_float(_Branch_49a68901b23c4894bfa1af72c26bfc34_Out_3, _Floor_8451392599f740c2aaf9026063cf9e17_Out_1);
float _Modulo_31665d96abb54fd6894ec4d43962941c_Out_2;
Unity_Modulo_float(_Floor_8451392599f740c2aaf9026063cf9e17_Out_1, _Property_36bda8feb9f646a589a5298330a8efb5_Out_0, _Modulo_31665d96abb54fd6894ec4d43962941c_Out_2);
float _Subtract_9a3fa8f96fab4c788c2a9eece8c414f5_Out_2;
Unity_Subtract_float(_Modulo_31665d96abb54fd6894ec4d43962941c_Out_2, float(1), _Subtract_9a3fa8f96fab4c788c2a9eece8c414f5_Out_2);
float _Absolute_1593ad46b9904444acb0ca8f23eb1242_Out_1;
Unity_Absolute_float(_Subtract_9a3fa8f96fab4c788c2a9eece8c414f5_Out_2, _Absolute_1593ad46b9904444acb0ca8f23eb1242_Out_1);
float _Saturate_746ef44d6a8b412f8ee64846753f0c6b_Out_1;
Unity_Saturate_float(_Absolute_1593ad46b9904444acb0ca8f23eb1242_Out_1, _Saturate_746ef44d6a8b412f8ee64846753f0c6b_Out_1);
float _Subtract_5ff69817d07a41e7b6302a18951b02c9_Out_2;
Unity_Subtract_float(_Modulo_31665d96abb54fd6894ec4d43962941c_Out_2, _Property_36bda8feb9f646a589a5298330a8efb5_Out_0, _Subtract_5ff69817d07a41e7b6302a18951b02c9_Out_2);
float _Absolute_46cc16ef94cf404288d82dd9f79350d8_Out_1;
Unity_Absolute_float(_Subtract_5ff69817d07a41e7b6302a18951b02c9_Out_2, _Absolute_46cc16ef94cf404288d82dd9f79350d8_Out_1);
float _Saturate_842a3cbdf84c440b8c50b27eaa68917f_Out_1;
Unity_Saturate_float(_Absolute_46cc16ef94cf404288d82dd9f79350d8_Out_1, _Saturate_842a3cbdf84c440b8c50b27eaa68917f_Out_1);
float _Multiply_2407536f9f5d449daed4b604dd11a1e7_Out_2;
Unity_Multiply_float_float(_Saturate_746ef44d6a8b412f8ee64846753f0c6b_Out_1, _Saturate_842a3cbdf84c440b8c50b27eaa68917f_Out_1, _Multiply_2407536f9f5d449daed4b604dd11a1e7_Out_2);
float _Comparison_a8c089c976024f2ebd3b2c6e3f328243_Out_2;
Unity_Comparison_Greater_float(_Multiply_2407536f9f5d449daed4b604dd11a1e7_Out_2, float(0), _Comparison_a8c089c976024f2ebd3b2c6e3f328243_Out_2);
float4 _Combine_3a3a46b2dd084ef5b50d1c94bd1bf662_RGBA_4;
float3 _Combine_3a3a46b2dd084ef5b50d1c94bd1bf662_RGB_5;
float2 _Combine_3a3a46b2dd084ef5b50d1c94bd1bf662_RG_6;
Unity_Combine_float(_SampleTexture2DLOD_d92919bca21f48e29f52a6d33023c4aa_R_5, _SampleTexture2DLOD_d92919bca21f48e29f52a6d33023c4aa_G_6, _SampleTexture2DLOD_d92919bca21f48e29f52a6d33023c4aa_B_7, float(0), _Combine_3a3a46b2dd084ef5b50d1c94bd1bf662_RGBA_4, _Combine_3a3a46b2dd084ef5b50d1c94bd1bf662_RGB_5, _Combine_3a3a46b2dd084ef5b50d1c94bd1bf662_RG_6);
UnityTexture2D _Property_88cc07c51d1d4c2ea2801e86f6a9f044_Out_0 = Texture2D_754e74d5eb0c4d92affb773f974ae100;
#if defined(SHADER_API_GLES) && (SHADER_TARGET < 30)
  float4 _SampleTexture2DLOD_d1665f30f3c74d54b5b2be5e322ee59e_RGBA_0 = float4(0.0f, 0.0f, 0.0f, 1.0f);
#else
  float4 _SampleTexture2DLOD_d1665f30f3c74d54b5b2be5e322ee59e_RGBA_0 = SAMPLE_TEXTURE2D_LOD(_Property_88cc07c51d1d4c2ea2801e86f6a9f044_Out_0.tex, _Property_88cc07c51d1d4c2ea2801e86f6a9f044_Out_0.samplerstate, _Property_88cc07c51d1d4c2ea2801e86f6a9f044_Out_0.GetTransformedUV(_Combine_a5e0df8891744ba98da48d60a7cffd50_RG_6), float(0));
#endif
float _SampleTexture2DLOD_d1665f30f3c74d54b5b2be5e322ee59e_R_5 = _SampleTexture2DLOD_d1665f30f3c74d54b5b2be5e322ee59e_RGBA_0.r;
float _SampleTexture2DLOD_d1665f30f3c74d54b5b2be5e322ee59e_G_6 = _SampleTexture2DLOD_d1665f30f3c74d54b5b2be5e322ee59e_RGBA_0.g;
float _SampleTexture2DLOD_d1665f30f3c74d54b5b2be5e322ee59e_B_7 = _SampleTexture2DLOD_d1665f30f3c74d54b5b2be5e322ee59e_RGBA_0.b;
float _SampleTexture2DLOD_d1665f30f3c74d54b5b2be5e322ee59e_A_8 = _SampleTexture2DLOD_d1665f30f3c74d54b5b2be5e322ee59e_RGBA_0.a;
float4 _Combine_dff050d017d340c2800db94c26ef03c5_RGBA_4;
float3 _Combine_dff050d017d340c2800db94c26ef03c5_RGB_5;
float2 _Combine_dff050d017d340c2800db94c26ef03c5_RG_6;
Unity_Combine_float(_SampleTexture2DLOD_d1665f30f3c74d54b5b2be5e322ee59e_R_5, _SampleTexture2DLOD_d1665f30f3c74d54b5b2be5e322ee59e_G_6, _SampleTexture2DLOD_d1665f30f3c74d54b5b2be5e322ee59e_B_7, float(0), _Combine_dff050d017d340c2800db94c26ef03c5_RGBA_4, _Combine_dff050d017d340c2800db94c26ef03c5_RGB_5, _Combine_dff050d017d340c2800db94c26ef03c5_RG_6);
float3 _Multiply_074bdcbed8984aa8bfbb7d64f7394db2_Out_2;
Unity_Multiply_float3_float3(_Combine_dff050d017d340c2800db94c26ef03c5_RGB_5, float3(0.01, 0.01, 0.01), _Multiply_074bdcbed8984aa8bfbb7d64f7394db2_Out_2);
float3 _Add_c52759803daa4e8db8b2073f1ca73d5a_Out_2;
Unity_Add_float3(_Combine_3a3a46b2dd084ef5b50d1c94bd1bf662_RGB_5, _Multiply_074bdcbed8984aa8bfbb7d64f7394db2_Out_2, _Add_c52759803daa4e8db8b2073f1ca73d5a_Out_2);
#if defined(_B_LOAD_POS_TWO_TEX)
float3 _PositionsRequireTwoTextures_953c53d9543e4e83863d6f6fc765ab90_Out_0 = _Add_c52759803daa4e8db8b2073f1ca73d5a_Out_2;
#else
float3 _PositionsRequireTwoTextures_953c53d9543e4e83863d6f6fc765ab90_Out_0 = _Combine_3a3a46b2dd084ef5b50d1c94bd1bf662_RGB_5;
#endif
float3 _Subtract_83069528d6794190a7bbec7f91d26eb4_Out_2;
Unity_Subtract_float3(_Combine_e339454ae4ab446eab26fa05e5da4305_RGB_5, _Combine_b7dc50f2401c46dca6eed4b19e0862d8_RGB_5, _Subtract_83069528d6794190a7bbec7f91d26eb4_Out_2);
float3 _Multiply_76ae98c658fe4213ac5482dd0c399267_Out_2;
Unity_Multiply_float3_float3(_PositionsRequireTwoTextures_953c53d9543e4e83863d6f6fc765ab90_Out_0, _Subtract_83069528d6794190a7bbec7f91d26eb4_Out_2, _Multiply_76ae98c658fe4213ac5482dd0c399267_Out_2);
float3 _Add_dda8c9ca0e7d43e2a04a2882c29f90d7_Out_2;
Unity_Add_float3(_Multiply_76ae98c658fe4213ac5482dd0c399267_Out_2, _Combine_b7dc50f2401c46dca6eed4b19e0862d8_RGB_5, _Add_dda8c9ca0e7d43e2a04a2882c29f90d7_Out_2);
float3 _Branch_6abcc2317e104339a2decf93e9aee587_Out_3;
Unity_Branch_float3(_Comparison_322cfaaadddd4969978d57a8c96084ef_Out_2, _PositionsRequireTwoTextures_953c53d9543e4e83863d6f6fc765ab90_Out_0, _Add_dda8c9ca0e7d43e2a04a2882c29f90d7_Out_2, _Branch_6abcc2317e104339a2decf93e9aee587_Out_3);
float _Subtract_23e431f62c684e8a8c79463d4883d924_Out_2;
Unity_Subtract_float(_Branch_49a68901b23c4894bfa1af72c26bfc34_Out_3, float(2), _Subtract_23e431f62c684e8a8c79463d4883d924_Out_2);
float _Modulo_4fa22a36c1a74f2caca4dde1485497a5_Out_2;
Unity_Modulo_float(_Subtract_23e431f62c684e8a8c79463d4883d924_Out_2, _Property_36bda8feb9f646a589a5298330a8efb5_Out_0, _Modulo_4fa22a36c1a74f2caca4dde1485497a5_Out_2);
float _Multiply_86c00bc3990045fbbce849f2ee279dc8_Out_2;
Unity_Multiply_float_float(_Modulo_4fa22a36c1a74f2caca4dde1485497a5_Out_2, _Divide_8940f8cc6cc745d28630ad7d2e2ba98d_Out_2, _Multiply_86c00bc3990045fbbce849f2ee279dc8_Out_2);
float _Multiply_48ab7ff273e047839ee54f47a6412481_Out_2;
Unity_Multiply_float_float(_Multiply_86c00bc3990045fbbce849f2ee279dc8_Out_2, _OneMinus_6a6f086f607e42bb8409559598119dd2_Out_1, _Multiply_48ab7ff273e047839ee54f47a6412481_Out_2);
float _Add_54623ae385a0479db3407044f6434b68_Out_2;
Unity_Add_float(_Multiply_5a5cd519af8341f3b924960c61aaffff_Out_2, _Multiply_48ab7ff273e047839ee54f47a6412481_Out_2, _Add_54623ae385a0479db3407044f6434b68_Out_2);
float _OneMinus_42761850f55345a2817d77c53379b8e3_Out_1;
Unity_OneMinus_float(_Add_54623ae385a0479db3407044f6434b68_Out_2, _OneMinus_42761850f55345a2817d77c53379b8e3_Out_1);
float4 _Combine_3239577421b246bbaaa02adf4ba9b356_RGBA_4;
float3 _Combine_3239577421b246bbaaa02adf4ba9b356_RGB_5;
float2 _Combine_3239577421b246bbaaa02adf4ba9b356_RG_6;
Unity_Combine_float(_Multiply_9b6c319d4f9f4f64afb5813d2670c683_Out_2, _OneMinus_42761850f55345a2817d77c53379b8e3_Out_1, float(0), float(0), _Combine_3239577421b246bbaaa02adf4ba9b356_RGBA_4, _Combine_3239577421b246bbaaa02adf4ba9b356_RGB_5, _Combine_3239577421b246bbaaa02adf4ba9b356_RG_6);
#if defined(SHADER_API_GLES) && (SHADER_TARGET < 30)
  float4 _SampleTexture2DLOD_287579fcd49d4a6bb2ef93878e6bb97a_RGBA_0 = float4(0.0f, 0.0f, 0.0f, 1.0f);
#else
  float4 _SampleTexture2DLOD_287579fcd49d4a6bb2ef93878e6bb97a_RGBA_0 = SAMPLE_TEXTURE2D_LOD(_Property_7dbd408acfee4e078cd82cbe1e5f572b_Out_0.tex, _Property_7dbd408acfee4e078cd82cbe1e5f572b_Out_0.samplerstate, _Property_7dbd408acfee4e078cd82cbe1e5f572b_Out_0.GetTransformedUV(_Combine_3239577421b246bbaaa02adf4ba9b356_RG_6), float(0));
#endif
float _SampleTexture2DLOD_287579fcd49d4a6bb2ef93878e6bb97a_R_5 = _SampleTexture2DLOD_287579fcd49d4a6bb2ef93878e6bb97a_RGBA_0.r;
float _SampleTexture2DLOD_287579fcd49d4a6bb2ef93878e6bb97a_G_6 = _SampleTexture2DLOD_287579fcd49d4a6bb2ef93878e6bb97a_RGBA_0.g;
float _SampleTexture2DLOD_287579fcd49d4a6bb2ef93878e6bb97a_B_7 = _SampleTexture2DLOD_287579fcd49d4a6bb2ef93878e6bb97a_RGBA_0.b;
float _SampleTexture2DLOD_287579fcd49d4a6bb2ef93878e6bb97a_A_8 = _SampleTexture2DLOD_287579fcd49d4a6bb2ef93878e6bb97a_RGBA_0.a;
float4 _Combine_9c39a564551e4a1dab2cc722d58cfed9_RGBA_4;
float3 _Combine_9c39a564551e4a1dab2cc722d58cfed9_RGB_5;
float2 _Combine_9c39a564551e4a1dab2cc722d58cfed9_RG_6;
Unity_Combine_float(_SampleTexture2DLOD_287579fcd49d4a6bb2ef93878e6bb97a_R_5, _SampleTexture2DLOD_287579fcd49d4a6bb2ef93878e6bb97a_G_6, _SampleTexture2DLOD_287579fcd49d4a6bb2ef93878e6bb97a_B_7, float(0), _Combine_9c39a564551e4a1dab2cc722d58cfed9_RGBA_4, _Combine_9c39a564551e4a1dab2cc722d58cfed9_RGB_5, _Combine_9c39a564551e4a1dab2cc722d58cfed9_RG_6);
#if defined(SHADER_API_GLES) && (SHADER_TARGET < 30)
  float4 _SampleTexture2DLOD_360702360c8c40eeb628fd723c0d1f36_RGBA_0 = float4(0.0f, 0.0f, 0.0f, 1.0f);
#else
  float4 _SampleTexture2DLOD_360702360c8c40eeb628fd723c0d1f36_RGBA_0 = SAMPLE_TEXTURE2D_LOD(_Property_88cc07c51d1d4c2ea2801e86f6a9f044_Out_0.tex, _Property_88cc07c51d1d4c2ea2801e86f6a9f044_Out_0.samplerstate, _Property_88cc07c51d1d4c2ea2801e86f6a9f044_Out_0.GetTransformedUV(_Combine_3239577421b246bbaaa02adf4ba9b356_RG_6), float(0));
#endif
float _SampleTexture2DLOD_360702360c8c40eeb628fd723c0d1f36_R_5 = _SampleTexture2DLOD_360702360c8c40eeb628fd723c0d1f36_RGBA_0.r;
float _SampleTexture2DLOD_360702360c8c40eeb628fd723c0d1f36_G_6 = _SampleTexture2DLOD_360702360c8c40eeb628fd723c0d1f36_RGBA_0.g;
float _SampleTexture2DLOD_360702360c8c40eeb628fd723c0d1f36_B_7 = _SampleTexture2DLOD_360702360c8c40eeb628fd723c0d1f36_RGBA_0.b;
float _SampleTexture2DLOD_360702360c8c40eeb628fd723c0d1f36_A_8 = _SampleTexture2DLOD_360702360c8c40eeb628fd723c0d1f36_RGBA_0.a;
float4 _Combine_7084182552c241bdb6d0512cb1155a3f_RGBA_4;
float3 _Combine_7084182552c241bdb6d0512cb1155a3f_RGB_5;
float2 _Combine_7084182552c241bdb6d0512cb1155a3f_RG_6;
Unity_Combine_float(_SampleTexture2DLOD_360702360c8c40eeb628fd723c0d1f36_R_5, _SampleTexture2DLOD_360702360c8c40eeb628fd723c0d1f36_G_6, _SampleTexture2DLOD_360702360c8c40eeb628fd723c0d1f36_B_7, float(0), _Combine_7084182552c241bdb6d0512cb1155a3f_RGBA_4, _Combine_7084182552c241bdb6d0512cb1155a3f_RGB_5, _Combine_7084182552c241bdb6d0512cb1155a3f_RG_6);
float3 _Multiply_7a5859a14b5d45cfbf932206d683f2d0_Out_2;
Unity_Multiply_float3_float3(_Combine_7084182552c241bdb6d0512cb1155a3f_RGB_5, float3(0.01, 0.01, 0.01), _Multiply_7a5859a14b5d45cfbf932206d683f2d0_Out_2);
float3 _Add_097f634a10154558b7d3955ab7a9b3c2_Out_2;
Unity_Add_float3(_Combine_9c39a564551e4a1dab2cc722d58cfed9_RGB_5, _Multiply_7a5859a14b5d45cfbf932206d683f2d0_Out_2, _Add_097f634a10154558b7d3955ab7a9b3c2_Out_2);
#if defined(_B_LOAD_POS_TWO_TEX)
float3 _PositionsRequireTwoTextures_398d49e0a9e745c3be0cb6dd43f9bdb2_Out_0 = _Add_097f634a10154558b7d3955ab7a9b3c2_Out_2;
#else
float3 _PositionsRequireTwoTextures_398d49e0a9e745c3be0cb6dd43f9bdb2_Out_0 = _Combine_9c39a564551e4a1dab2cc722d58cfed9_RGB_5;
#endif
float3 _Multiply_9a42a47779a74789b63390a9d333158b_Out_2;
Unity_Multiply_float3_float3(_PositionsRequireTwoTextures_398d49e0a9e745c3be0cb6dd43f9bdb2_Out_0, _Subtract_83069528d6794190a7bbec7f91d26eb4_Out_2, _Multiply_9a42a47779a74789b63390a9d333158b_Out_2);
float3 _Add_9c03ef247e144a429e1065251468edf1_Out_2;
Unity_Add_float3(_Multiply_9a42a47779a74789b63390a9d333158b_Out_2, _Combine_b7dc50f2401c46dca6eed4b19e0862d8_RGB_5, _Add_9c03ef247e144a429e1065251468edf1_Out_2);
float3 _Branch_214a74645ca6492b89141f31e6ea5a7f_Out_3;
Unity_Branch_float3(_Comparison_322cfaaadddd4969978d57a8c96084ef_Out_2, _PositionsRequireTwoTextures_398d49e0a9e745c3be0cb6dd43f9bdb2_Out_0, _Add_9c03ef247e144a429e1065251468edf1_Out_2, _Branch_214a74645ca6492b89141f31e6ea5a7f_Out_3);
float3 _Subtract_030df86ef0634ac481fba96527ff242c_Out_2;
Unity_Subtract_float3(_Branch_6abcc2317e104339a2decf93e9aee587_Out_3, _Branch_214a74645ca6492b89141f31e6ea5a7f_Out_3, _Subtract_030df86ef0634ac481fba96527ff242c_Out_2);
float3 _Multiply_544b3b7d0858480cad712d97b73febff_Out_2;
Unity_Multiply_float3_float3(_Subtract_030df86ef0634ac481fba96527ff242c_Out_2, float3(0.5, 0.5, 0.5), _Multiply_544b3b7d0858480cad712d97b73febff_Out_2);
float3 _Multiply_e51eff6f24a64bf2aef49ed99220a97c_Out_2;
Unity_Multiply_float3_float3(_Multiply_544b3b7d0858480cad712d97b73febff_Out_2, (_Property_5fc6f43cd22541d08c4627c56b36c0ad_Out_0.xxx), _Multiply_e51eff6f24a64bf2aef49ed99220a97c_Out_2);
float _Split_720aa7f35a6b490aaf7a2154ebc4da24_R_1 = _LoadColorTexture_f0d31671e10846148e10ff6f6ddcce87_Out_0[0];
float _Split_720aa7f35a6b490aaf7a2154ebc4da24_G_2 = _LoadColorTexture_f0d31671e10846148e10ff6f6ddcce87_Out_0[1];
float _Split_720aa7f35a6b490aaf7a2154ebc4da24_B_3 = _LoadColorTexture_f0d31671e10846148e10ff6f6ddcce87_Out_0[2];
float _Split_720aa7f35a6b490aaf7a2154ebc4da24_A_4 = _LoadColorTexture_f0d31671e10846148e10ff6f6ddcce87_Out_0[3];
float _Multiply_d460d4376ec443478b75affab2a6484f_Out_2;
Unity_Multiply_float_float(_Split_720aa7f35a6b490aaf7a2154ebc4da24_R_1, -1, _Multiply_d460d4376ec443478b75affab2a6484f_Out_2);
float4 _Combine_0030b1857d35451ab7953bc224675699_RGBA_4;
float3 _Combine_0030b1857d35451ab7953bc224675699_RGB_5;
float2 _Combine_0030b1857d35451ab7953bc224675699_RG_6;
Unity_Combine_float(_Multiply_d460d4376ec443478b75affab2a6484f_Out_2, _Split_720aa7f35a6b490aaf7a2154ebc4da24_G_2, _Split_720aa7f35a6b490aaf7a2154ebc4da24_B_3, float(0), _Combine_0030b1857d35451ab7953bc224675699_RGBA_4, _Combine_0030b1857d35451ab7953bc224675699_RGB_5, _Combine_0030b1857d35451ab7953bc224675699_RG_6);
#if defined(_B_SMOOTH_TRAJECTORIES)
float3 _SmoothlyInterpolatedTrajectories_8c042b0f8b114723960f856f38e1f8c0_Out_0 = _Combine_0030b1857d35451ab7953bc224675699_RGB_5;
#else
float3 _SmoothlyInterpolatedTrajectories_8c042b0f8b114723960f856f38e1f8c0_Out_0 = _Vector3_15aecf0488824eeea4967cba0231c95e_Out_0;
#endif
float4 _Combine_d49aa133f0fe4d09ae08fdeb68792238_RGBA_4;
float3 _Combine_d49aa133f0fe4d09ae08fdeb68792238_RGB_5;
float2 _Combine_d49aa133f0fe4d09ae08fdeb68792238_RG_6;
Unity_Combine_float(_SampleTexture2DLOD_de27d463cc6a4aa49ace2fa8becc61eb_R_5, _SampleTexture2DLOD_de27d463cc6a4aa49ace2fa8becc61eb_G_6, _SampleTexture2DLOD_de27d463cc6a4aa49ace2fa8becc61eb_B_7, float(0), _Combine_d49aa133f0fe4d09ae08fdeb68792238_RGBA_4, _Combine_d49aa133f0fe4d09ae08fdeb68792238_RGB_5, _Combine_d49aa133f0fe4d09ae08fdeb68792238_RG_6);
#if defined(SHADER_API_GLES) && (SHADER_TARGET < 30)
  float4 _SampleTexture2DLOD_855392d9245a455d941374694e57f0c7_RGBA_0 = float4(0.0f, 0.0f, 0.0f, 1.0f);
#else
  float4 _SampleTexture2DLOD_855392d9245a455d941374694e57f0c7_RGBA_0 = SAMPLE_TEXTURE2D_LOD(_Property_88cc07c51d1d4c2ea2801e86f6a9f044_Out_0.tex, _Property_88cc07c51d1d4c2ea2801e86f6a9f044_Out_0.samplerstate, _Property_88cc07c51d1d4c2ea2801e86f6a9f044_Out_0.GetTransformedUV(_Combine_7acf849c0cd74d32b462c613ff310511_RG_6), float(0));
#endif
float _SampleTexture2DLOD_855392d9245a455d941374694e57f0c7_R_5 = _SampleTexture2DLOD_855392d9245a455d941374694e57f0c7_RGBA_0.r;
float _SampleTexture2DLOD_855392d9245a455d941374694e57f0c7_G_6 = _SampleTexture2DLOD_855392d9245a455d941374694e57f0c7_RGBA_0.g;
float _SampleTexture2DLOD_855392d9245a455d941374694e57f0c7_B_7 = _SampleTexture2DLOD_855392d9245a455d941374694e57f0c7_RGBA_0.b;
float _SampleTexture2DLOD_855392d9245a455d941374694e57f0c7_A_8 = _SampleTexture2DLOD_855392d9245a455d941374694e57f0c7_RGBA_0.a;
float4 _Combine_85e12c5db5f74b81b34cc35bf980f496_RGBA_4;
float3 _Combine_85e12c5db5f74b81b34cc35bf980f496_RGB_5;
float2 _Combine_85e12c5db5f74b81b34cc35bf980f496_RG_6;
Unity_Combine_float(_SampleTexture2DLOD_855392d9245a455d941374694e57f0c7_R_5, _SampleTexture2DLOD_855392d9245a455d941374694e57f0c7_G_6, _SampleTexture2DLOD_855392d9245a455d941374694e57f0c7_B_7, float(0), _Combine_85e12c5db5f74b81b34cc35bf980f496_RGBA_4, _Combine_85e12c5db5f74b81b34cc35bf980f496_RGB_5, _Combine_85e12c5db5f74b81b34cc35bf980f496_RG_6);
float3 _Multiply_57b4f75333624583be0873db92dedf96_Out_2;
Unity_Multiply_float3_float3(_Combine_85e12c5db5f74b81b34cc35bf980f496_RGB_5, float3(0.01, 0.01, 0.01), _Multiply_57b4f75333624583be0873db92dedf96_Out_2);
float3 _Add_caa93fff586040738eb0fd2b1ec136f9_Out_2;
Unity_Add_float3(_Combine_d49aa133f0fe4d09ae08fdeb68792238_RGB_5, _Multiply_57b4f75333624583be0873db92dedf96_Out_2, _Add_caa93fff586040738eb0fd2b1ec136f9_Out_2);
#if defined(_B_LOAD_POS_TWO_TEX)
float3 _PositionsRequireTwoTextures_c8e450f1058a4432b4c548b5e53b7946_Out_0 = _Add_caa93fff586040738eb0fd2b1ec136f9_Out_2;
#else
float3 _PositionsRequireTwoTextures_c8e450f1058a4432b4c548b5e53b7946_Out_0 = _Combine_d49aa133f0fe4d09ae08fdeb68792238_RGB_5;
#endif
float3 _Multiply_8e5558b18d83439a9981812720701597_Out_2;
Unity_Multiply_float3_float3(_PositionsRequireTwoTextures_c8e450f1058a4432b4c548b5e53b7946_Out_0, _Subtract_83069528d6794190a7bbec7f91d26eb4_Out_2, _Multiply_8e5558b18d83439a9981812720701597_Out_2);
float3 _Add_80715fe518cd4ad1a9a73a23b690774d_Out_2;
Unity_Add_float3(_Multiply_8e5558b18d83439a9981812720701597_Out_2, _Combine_b7dc50f2401c46dca6eed4b19e0862d8_RGB_5, _Add_80715fe518cd4ad1a9a73a23b690774d_Out_2);
float3 _Branch_4f4f2009002c4eafa0b38571d20172b2_Out_3;
Unity_Branch_float3(_Comparison_322cfaaadddd4969978d57a8c96084ef_Out_2, _PositionsRequireTwoTextures_c8e450f1058a4432b4c548b5e53b7946_Out_0, _Add_80715fe518cd4ad1a9a73a23b690774d_Out_2, _Branch_4f4f2009002c4eafa0b38571d20172b2_Out_3);
float _Divide_03c6ba4deacf4ae583578eda86eb0d6c_Out_2;
Unity_Divide_float(_Fraction_c62e039143ec48078706377fd40a9b87_Out_1, _Property_5fc6f43cd22541d08c4627c56b36c0ad_Out_0, _Divide_03c6ba4deacf4ae583578eda86eb0d6c_Out_2);
float3 _InterframePositionCustomFunction_f2c5f95f36674ad4820e14112ab81b58_OutInterframeP_4;
Interframe_Position_float(_Multiply_e51eff6f24a64bf2aef49ed99220a97c_Out_2, _SmoothlyInterpolatedTrajectories_8c042b0f8b114723960f856f38e1f8c0_Out_0, _Branch_4f4f2009002c4eafa0b38571d20172b2_Out_3, _Divide_03c6ba4deacf4ae583578eda86eb0d6c_Out_2, _InterframePositionCustomFunction_f2c5f95f36674ad4820e14112ab81b58_OutInterframeP_4);
float3 _Lerp_575c9c879bd54a02896fea66ac682590_Out_3;
Unity_Lerp_float3(_Branch_4f4f2009002c4eafa0b38571d20172b2_Out_3, _Branch_6abcc2317e104339a2decf93e9aee587_Out_3, (_Fraction_c62e039143ec48078706377fd40a9b87_Out_1.xxx), _Lerp_575c9c879bd54a02896fea66ac682590_Out_3);
float3 _Branch_61123dba8a02420981f4eddc0122eadc_Out_3;
Unity_Branch_float3(_Comparison_a8c089c976024f2ebd3b2c6e3f328243_Out_2, _InterframePositionCustomFunction_f2c5f95f36674ad4820e14112ab81b58_OutInterframeP_4, _Lerp_575c9c879bd54a02896fea66ac682590_Out_3, _Branch_61123dba8a02420981f4eddc0122eadc_Out_3);
#if defined(_B_SMOOTH_TRAJECTORIES)
float3 _SmoothlyInterpolatedTrajectories_b2ed49e7c6884dcb836a6829cb6a74a8_Out_0 = _Branch_61123dba8a02420981f4eddc0122eadc_Out_3;
#else
float3 _SmoothlyInterpolatedTrajectories_b2ed49e7c6884dcb836a6829cb6a74a8_Out_0 = _Lerp_575c9c879bd54a02896fea66ac682590_Out_3;
#endif
float3 _Branch_a95062aee478445eb238301f4077b46b_Out_3;
Unity_Branch_float3(_Property_1238b8669b754229a924fa19745c9a3a_Out_0, _SmoothlyInterpolatedTrajectories_b2ed49e7c6884dcb836a6829cb6a74a8_Out_0, _Branch_4f4f2009002c4eafa0b38571d20172b2_Out_3, _Branch_a95062aee478445eb238301f4077b46b_Out_3);
float3 _Add_4a9418dc3a174f3882e94203ce727c53_Out_2;
Unity_Add_float3(_Multiply_ae9a523d22654befb80a94a4d9838cfe_Out_2, _Branch_a95062aee478445eb238301f4077b46b_Out_3, _Add_4a9418dc3a174f3882e94203ce727c53_Out_2);
float _Modulo_06e767356ff446e988538299493c5368_Out_2;
Unity_Modulo_float(_Branch_49a68901b23c4894bfa1af72c26bfc34_Out_3, _Property_36bda8feb9f646a589a5298330a8efb5_Out_0, _Modulo_06e767356ff446e988538299493c5368_Out_2);
float _Comparison_c9e7d128e0ea4aa59ccdf144224f8e95_Out_2;
Unity_Comparison_NotEqual_float(_Modulo_06e767356ff446e988538299493c5368_Out_2, float(1), _Comparison_c9e7d128e0ea4aa59ccdf144224f8e95_Out_2);
float3 _Branch_1ac08f9a9c2f42628f75369930c90d03_Out_3;
Unity_Branch_float3(_Comparison_c9e7d128e0ea4aa59ccdf144224f8e95_Out_2, _Add_4a9418dc3a174f3882e94203ce727c53_Out_2, IN.ObjectSpacePosition, _Branch_1ac08f9a9c2f42628f75369930c90d03_Out_3);
float3 _Branch_51ea135983084664b04a144b570d0456_Out_3;
Unity_Branch_float3(_Property_41c0700d390b42eb9578b110d952f492_Out_0, _Add_4a9418dc3a174f3882e94203ce727c53_Out_2, _Branch_1ac08f9a9c2f42628f75369930c90d03_Out_3, _Branch_51ea135983084664b04a144b570d0456_Out_3);
float3 _Property_8b9e36bcab644a8a8de5aa7a5f8c87cc_Out_0 = Vector3_d2bfcc1e36e143fb8998c41bd35e34ce;
float3 _Add_cfc4c853d1734b97a576111ad82a4646_Out_2;
Unity_Add_float3(_Branch_51ea135983084664b04a144b570d0456_Out_3, _Property_8b9e36bcab644a8a8de5aa7a5f8c87cc_Out_0, _Add_cfc4c853d1734b97a576111ad82a4646_Out_2);
float3 _Branch_ba93d84f34e744b6a0798505c9ceae34_Out_3;
Unity_Branch_float3(_Comparison_05395f032a9d41f883deb216f4f78844_Out_2, float3(0, 0, 0), _Add_cfc4c853d1734b97a576111ad82a4646_Out_2, _Branch_ba93d84f34e744b6a0798505c9ceae34_Out_3);
float3 _Multiply_5081d7eb1fdb4fc093265e623fbf81be_Out_2;
Unity_Multiply_float3_float3((_Split_70d7fe38e42f4a49b6a12b4a28073bfb_A_4.xxx), IN.ObjectSpaceNormal, _Multiply_5081d7eb1fdb4fc093265e623fbf81be_Out_2);
float3 _CrossProduct_09f100e05a724ab799c461db618ee59c_Out_2;
Unity_CrossProduct_float(_Combine_c62cf49352cf4def93cd35bff786a4f8_RGB_5, IN.ObjectSpaceNormal, _CrossProduct_09f100e05a724ab799c461db618ee59c_Out_2);
float3 _Add_7ffc599647db4fcbbd0be8e1c9c5199e_Out_2;
Unity_Add_float3(_Multiply_5081d7eb1fdb4fc093265e623fbf81be_Out_2, _CrossProduct_09f100e05a724ab799c461db618ee59c_Out_2, _Add_7ffc599647db4fcbbd0be8e1c9c5199e_Out_2);
float3 _CrossProduct_db59763f2af2444faaf6a0df5cab782a_Out_2;
Unity_CrossProduct_float(_Combine_c62cf49352cf4def93cd35bff786a4f8_RGB_5, _Add_7ffc599647db4fcbbd0be8e1c9c5199e_Out_2, _CrossProduct_db59763f2af2444faaf6a0df5cab782a_Out_2);
float3 _Multiply_82421ac159f64abd8757d369cef3ca2b_Out_2;
Unity_Multiply_float3_float3(_CrossProduct_db59763f2af2444faaf6a0df5cab782a_Out_2, float3(2, 2, 2), _Multiply_82421ac159f64abd8757d369cef3ca2b_Out_2);
float3 _Add_4055c3505ca44c9cb83eed649da64efc_Out_2;
Unity_Add_float3(_Multiply_82421ac159f64abd8757d369cef3ca2b_Out_2, IN.ObjectSpaceNormal, _Add_4055c3505ca44c9cb83eed649da64efc_Out_2);
float3 _Normalize_6ff0bb5959824712b3c1a9d455332917_Out_1;
Unity_Normalize_float3(_Add_4055c3505ca44c9cb83eed649da64efc_Out_2, _Normalize_6ff0bb5959824712b3c1a9d455332917_Out_1);
float _Property_e82ce2070ecc4580b8cc7e2957a8b387_Out_0 = Boolean_452ee7b85a19421f84aedbe953332219;
float3 _Multiply_2683d56e97a94688a0cd18f0f377c461_Out_2;
Unity_Multiply_float3_float3((_Split_70d7fe38e42f4a49b6a12b4a28073bfb_A_4.xxx), IN.ObjectSpaceTangent, _Multiply_2683d56e97a94688a0cd18f0f377c461_Out_2);
float3 _CrossProduct_fe4b33b782c94a958908c6d0fda7f1f2_Out_2;
Unity_CrossProduct_float(_Combine_c62cf49352cf4def93cd35bff786a4f8_RGB_5, IN.ObjectSpaceTangent, _CrossProduct_fe4b33b782c94a958908c6d0fda7f1f2_Out_2);
float3 _Add_d4d4404f29b5478da05d90333fa2646e_Out_2;
Unity_Add_float3(_Multiply_2683d56e97a94688a0cd18f0f377c461_Out_2, _CrossProduct_fe4b33b782c94a958908c6d0fda7f1f2_Out_2, _Add_d4d4404f29b5478da05d90333fa2646e_Out_2);
float3 _CrossProduct_9e211350ebb44f2b9f167a39dbe5d0c1_Out_2;
Unity_CrossProduct_float(_Combine_c62cf49352cf4def93cd35bff786a4f8_RGB_5, _Add_d4d4404f29b5478da05d90333fa2646e_Out_2, _CrossProduct_9e211350ebb44f2b9f167a39dbe5d0c1_Out_2);
float3 _Multiply_f8c674663fcb47739695e51f81080da2_Out_2;
Unity_Multiply_float3_float3(_CrossProduct_9e211350ebb44f2b9f167a39dbe5d0c1_Out_2, float3(2, 2, 2), _Multiply_f8c674663fcb47739695e51f81080da2_Out_2);
float3 _Add_53834285195c4c39aa433be810aa07ea_Out_2;
Unity_Add_float3(_Multiply_f8c674663fcb47739695e51f81080da2_Out_2, IN.ObjectSpaceTangent, _Add_53834285195c4c39aa433be810aa07ea_Out_2);
float3 _Normalize_182c6b7faf5a4d4e9d83e30a084d9c3f_Out_1;
Unity_Normalize_float3(_Add_53834285195c4c39aa433be810aa07ea_Out_2, _Normalize_182c6b7faf5a4d4e9d83e30a084d9c3f_Out_1);
float3 _Vector3_334362fd0ae04d9c8d077e7724248b0f_Out_0 = float3(float(0), float(0), float(0));
float3 _Branch_937bb7ab707947f3939fbece2363d768_Out_3;
Unity_Branch_float3(_Property_e82ce2070ecc4580b8cc7e2957a8b387_Out_0, _Normalize_182c6b7faf5a4d4e9d83e30a084d9c3f_Out_1, _Vector3_334362fd0ae04d9c8d077e7724248b0f_Out_0, _Branch_937bb7ab707947f3939fbece2363d768_Out_3);
float _Split_c5593124f90046678b7f159106c72a73_R_1 = _Branch_3c68277c1c8744a59f98768785e6c5e7_Out_3[0];
float _Split_c5593124f90046678b7f159106c72a73_G_2 = _Branch_3c68277c1c8744a59f98768785e6c5e7_Out_3[1];
float _Split_c5593124f90046678b7f159106c72a73_B_3 = _Branch_3c68277c1c8744a59f98768785e6c5e7_Out_3[2];
float _Split_c5593124f90046678b7f159106c72a73_A_4 = _Branch_3c68277c1c8744a59f98768785e6c5e7_Out_3[3];
float4 _Combine_4377c6dcc5d345eca19f49e271a380a1_RGBA_4;
float3 _Combine_4377c6dcc5d345eca19f49e271a380a1_RGB_5;
float2 _Combine_4377c6dcc5d345eca19f49e271a380a1_RG_6;
Unity_Combine_float(_Split_c5593124f90046678b7f159106c72a73_R_1, _Split_c5593124f90046678b7f159106c72a73_G_2, _Split_c5593124f90046678b7f159106c72a73_B_3, float(0), _Combine_4377c6dcc5d345eca19f49e271a380a1_RGBA_4, _Combine_4377c6dcc5d345eca19f49e271a380a1_RGB_5, _Combine_4377c6dcc5d345eca19f49e271a380a1_RG_6);
float _Property_1a2077ccac00451180694756814bdb14_Out_0 = _Interframe_Interpolation;
float _Property_d21add728a344d5aa22e5521939df28a_Out_0 = _Interpolate_Spare_Color;
float _And_01fa23b3b0054ee285a642ea984c79bd_Out_2;
Unity_And_float(_Property_1a2077ccac00451180694756814bdb14_Out_0, _Property_d21add728a344d5aa22e5521939df28a_Out_0, _And_01fa23b3b0054ee285a642ea984c79bd_Out_2);
UnityTexture2D _Property_fdb0c4a7b4304cf7aa5f4f3b27b8156e_Out_0 = Texture2D_dc3c6e2909694510a2bce97b5d611620;
#if defined(SHADER_API_GLES) && (SHADER_TARGET < 30)
  float4 _SampleTexture2DLOD_91d8eb10f6014791b31ca62331d89a27_RGBA_0 = float4(0.0f, 0.0f, 0.0f, 1.0f);
#else
  float4 _SampleTexture2DLOD_91d8eb10f6014791b31ca62331d89a27_RGBA_0 = SAMPLE_TEXTURE2D_LOD(_Property_fdb0c4a7b4304cf7aa5f4f3b27b8156e_Out_0.tex, _Property_fdb0c4a7b4304cf7aa5f4f3b27b8156e_Out_0.samplerstate, _Property_fdb0c4a7b4304cf7aa5f4f3b27b8156e_Out_0.GetTransformedUV(_Combine_7acf849c0cd74d32b462c613ff310511_RG_6), float(0));
#endif
float _SampleTexture2DLOD_91d8eb10f6014791b31ca62331d89a27_R_5 = _SampleTexture2DLOD_91d8eb10f6014791b31ca62331d89a27_RGBA_0.r;
float _SampleTexture2DLOD_91d8eb10f6014791b31ca62331d89a27_G_6 = _SampleTexture2DLOD_91d8eb10f6014791b31ca62331d89a27_RGBA_0.g;
float _SampleTexture2DLOD_91d8eb10f6014791b31ca62331d89a27_B_7 = _SampleTexture2DLOD_91d8eb10f6014791b31ca62331d89a27_RGBA_0.b;
float _SampleTexture2DLOD_91d8eb10f6014791b31ca62331d89a27_A_8 = _SampleTexture2DLOD_91d8eb10f6014791b31ca62331d89a27_RGBA_0.a;
#if defined(SHADER_API_GLES) && (SHADER_TARGET < 30)
  float4 _SampleTexture2DLOD_25f85af0492d4a22a920ab930ef4024f_RGBA_0 = float4(0.0f, 0.0f, 0.0f, 1.0f);
#else
  float4 _SampleTexture2DLOD_25f85af0492d4a22a920ab930ef4024f_RGBA_0 = SAMPLE_TEXTURE2D_LOD(_Property_fdb0c4a7b4304cf7aa5f4f3b27b8156e_Out_0.tex, _Property_fdb0c4a7b4304cf7aa5f4f3b27b8156e_Out_0.samplerstate, _Property_fdb0c4a7b4304cf7aa5f4f3b27b8156e_Out_0.GetTransformedUV(_Combine_a5e0df8891744ba98da48d60a7cffd50_RG_6), float(0));
#endif
float _SampleTexture2DLOD_25f85af0492d4a22a920ab930ef4024f_R_5 = _SampleTexture2DLOD_25f85af0492d4a22a920ab930ef4024f_RGBA_0.r;
float _SampleTexture2DLOD_25f85af0492d4a22a920ab930ef4024f_G_6 = _SampleTexture2DLOD_25f85af0492d4a22a920ab930ef4024f_RGBA_0.g;
float _SampleTexture2DLOD_25f85af0492d4a22a920ab930ef4024f_B_7 = _SampleTexture2DLOD_25f85af0492d4a22a920ab930ef4024f_RGBA_0.b;
float _SampleTexture2DLOD_25f85af0492d4a22a920ab930ef4024f_A_8 = _SampleTexture2DLOD_25f85af0492d4a22a920ab930ef4024f_RGBA_0.a;
float4 _Lerp_5b84de47bc154d2eab428508120ea672_Out_3;
Unity_Lerp_float4(_SampleTexture2DLOD_91d8eb10f6014791b31ca62331d89a27_RGBA_0, _SampleTexture2DLOD_25f85af0492d4a22a920ab930ef4024f_RGBA_0, (_Fraction_c62e039143ec48078706377fd40a9b87_Out_1.xxxx), _Lerp_5b84de47bc154d2eab428508120ea672_Out_3);
float4 _Branch_a6360ef37f69476dad27377056af6ce2_Out_3;
Unity_Branch_float4(_And_01fa23b3b0054ee285a642ea984c79bd_Out_2, _Lerp_5b84de47bc154d2eab428508120ea672_Out_3, _SampleTexture2DLOD_91d8eb10f6014791b31ca62331d89a27_RGBA_0, _Branch_a6360ef37f69476dad27377056af6ce2_Out_3);
float _Multiply_da3254ad20e34a8b9507097f01d91a2c_Out_2;
Unity_Multiply_float_float(_Divide_569c994b2ab34847bd4a297c59a7ca80_Out_2, _OneMinus_9b87aca1ae574fd289bcfc7b1beb7820_Out_1, _Multiply_da3254ad20e34a8b9507097f01d91a2c_Out_2);
float _Multiply_951a39edc04e42edb94eec3de2616641_Out_2;
Unity_Multiply_float_float(_Divide_569c994b2ab34847bd4a297c59a7ca80_Out_2, _OneMinus_fe03f4b292834b7991037367f130cefa_Out_1, _Multiply_951a39edc04e42edb94eec3de2616641_Out_2);
Out_Position_1 = _Branch_ba93d84f34e744b6a0798505c9ceae34_Out_3;
Out_Normal_2 = _Normalize_6ff0bb5959824712b3c1a9d455332917_Out_1;
Out_Tangent_3 = _Branch_937bb7ab707947f3939fbece2363d768_Out_3;
Out_ColorRGB_4 = _Combine_4377c6dcc5d345eca19f49e271a380a1_RGB_5;
Out_ColorAlpha_6 = _Split_c5593124f90046678b7f159106c72a73_A_4;
Out_SpareColorRGBA_5 = _Branch_a6360ef37f69476dad27377056af6ce2_Out_3;
Out_SamplingVThisFrame_8 = _Add_1fc73c4ac8ed420895dc22580cd38980_Out_2;
Out_SamplingVNextFrame_9 = _Add_ec5f1cbe56ae4bc3adc07cab0b3cada0_Out_2;
Out_PieceLocalPositionThisFrame_10 = _Branch_4f4f2009002c4eafa0b38571d20172b2_Out_3;
Out_PieceLocalPositionNextFrame_11 = _Branch_6abcc2317e104339a2decf93e9aee587_Out_3;
Out_DataInPositionAlphaThisFrame_12 = _Multiply_da3254ad20e34a8b9507097f01d91a2c_Out_2;
Out_DataInPositionAlphaNextFrame_13 = _Multiply_951a39edc04e42edb94eec3de2616641_Out_2;
Out_ColorRGBAThisFrame_17 = _LoadColorTexture_f0d31671e10846148e10ff6f6ddcce87_Out_0;
Out_ColorRGBANextFrame_14 = _LoadColorTexture_cc743dddac284c769882b4847ff7576b_Out_0;
Out_SpareColorRGBAThisFrame_18 = _SampleTexture2DLOD_91d8eb10f6014791b31ca62331d89a27_RGBA_0;
Out_SpareColorRGBANextFrame_15 = _SampleTexture2DLOD_25f85af0492d4a22a920ab930ef4024f_RGBA_0;
Out_InterframeInterpolationAlpha_16 = _Fraction_c62e039143ec48078706377fd40a9b87_Out_1;
Out_AnimationProgressThisFrame_21 = _Multiply_8ecd22e403084ffeac4fda6da39b7880_Out_2;
Out_AnimationProgressNextFrame_22 = _Multiply_cfb7fa4be2094158a058e2c60bbf86e0_Out_2;
Out_PieceRestFrameLocalPosition_19 = _Combine_c5b8f60c79034bba86a0dcdd200aaf52_RGB_5;
Out_PieceLocalPositionFinal_20 = _Branch_a95062aee478445eb238301f4077b46b_Out_3;
}

    /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */

    // Graph Vertex
    // GraphVertex: <None>

    /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreSurface' */

    // Graph Pixel
    struct SurfaceDescription
{
float4 Out;
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
SurfaceDescription surface = (SurfaceDescription)0;
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
float _Property_dec4506e248341b28fe2c8d49642655e_Out_0 = _B_autoPlayback;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
float _Property_8de81ae99c9e42f382ca2d64a5320c32_Out_0 = _gameTimeAtFirstFrame;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
float _Property_f1e2cf2c77614076b44609bb6248b3b0_Out_0 = _displayFrame;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
float _Property_9dd3f3a8aa7f4b8b98c245671a0ccc3c_Out_0 = _playbackSpeed;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
float _Property_c8cf047780ab45ee8b7c46338cb1f1f6_Out_0 = _houdiniFPS;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
float _Property_bdf605ae51274295b6717cdea5f990ee_Out_0 = _B_interpolate;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
float _Property_ac8fa91ddd734a51805b060cfb9ef252_Out_0 = _B_interpolateCol;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
float _Property_91fe97fdf36b4ad29e3a17ebdf13896b_Out_0 = _B_interpolateSpareCol;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
float _Property_59c97c43621b48e7a7113ee8e093093c_Out_0 = _B_surfaceNormals;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
UnityTexture2D _Property_9236a60294a44b11b05129feaf44221a_Out_0 = UnityBuildTexture2DStructNoScale(_posTexture);
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
UnityTexture2D _Property_46fd3449bf4c4e63808c67b6b43ce73c_Out_0 = UnityBuildTexture2DStructNoScale(_posTexture2);
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
UnityTexture2D _Property_99e50fce137f41ea8d5f8d6945e24521_Out_0 = UnityBuildTexture2DStructNoScale(_rotTexture);
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
UnityTexture2D _Property_2771991b04124530b56cab74d03b1ad5_Out_0 = UnityBuildTexture2DStructNoScale(_colTexture);
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
UnityTexture2D _Property_0623e61d7a4d4dc6a62bbeeb3270e8c3_Out_0 = UnityBuildTexture2DStructNoScale(_spareColTexture);
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
float _Property_a7ede65d63e14d2fa5a1eb7143dce481_Out_0 = _B_pscaleAreInPosA;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
float _Property_6da2c24bb03f491e9a4ae9288edbff79_Out_0 = _globalPscaleMul;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
float _Property_675cdf2bcc6547d3a874e8bb64e3dece_Out_0 = _B_stretchByVel;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
float _Property_a2bb588e1d04422ba775a61c0594d3be_Out_0 = _stretchByVelAmount;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
float _Property_bf5e30ae3d894b1a849c38ea8958e3f0_Out_0 = _B_animateFirstFrame;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
float _Property_b86981125884455da91bed13413bbbbf_Out_0 = _frameCount;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
float _Property_52c5873f926b4b9f854070d9c8d2886f_Out_0 = _boundMaxX;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
float _Property_611d6cf54f734f89bd499a23712ca0df_Out_0 = _boundMaxY;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
float _Property_6b6a2245b06b46399254eb74e17a261f_Out_0 = _boundMaxZ;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
float _Property_d17bb64f97e34bdea2e7af2405dc0686_Out_0 = _boundMinX;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
float _Property_153b5f703dc1482f9da91cf90eca30f5_Out_0 = _boundMinY;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
float _Property_e3f21ed56bb74dcdb3cf4a5ac378ca77_Out_0 = _boundMinZ;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
Bindings_VATRigidBodyDynamicsSSG_a4f0f42d0478d0747b2f528d548fb71b_float _VATRigidBodyDynamicsSSG_149e7d4dc5704ffcb4bb1119a20f54aa;
_VATRigidBodyDynamicsSSG_149e7d4dc5704ffcb4bb1119a20f54aa.ObjectSpaceNormal = IN.ObjectSpaceNormal;
_VATRigidBodyDynamicsSSG_149e7d4dc5704ffcb4bb1119a20f54aa.ObjectSpaceTangent = IN.ObjectSpaceTangent;
_VATRigidBodyDynamicsSSG_149e7d4dc5704ffcb4bb1119a20f54aa.ObjectSpacePosition = IN.ObjectSpacePosition;
_VATRigidBodyDynamicsSSG_149e7d4dc5704ffcb4bb1119a20f54aa.uv1 = IN.uv1;
_VATRigidBodyDynamicsSSG_149e7d4dc5704ffcb4bb1119a20f54aa.uv2 = IN.uv2;
_VATRigidBodyDynamicsSSG_149e7d4dc5704ffcb4bb1119a20f54aa.uv3 = IN.uv3;
float3 _VATRigidBodyDynamicsSSG_149e7d4dc5704ffcb4bb1119a20f54aa_OutPosition_1;
float3 _VATRigidBodyDynamicsSSG_149e7d4dc5704ffcb4bb1119a20f54aa_OutNormal_2;
float3 _VATRigidBodyDynamicsSSG_149e7d4dc5704ffcb4bb1119a20f54aa_OutTangent_3;
float3 _VATRigidBodyDynamicsSSG_149e7d4dc5704ffcb4bb1119a20f54aa_OutColorRGB_4;
float _VATRigidBodyDynamicsSSG_149e7d4dc5704ffcb4bb1119a20f54aa_OutColorAlpha_6;
float4 _VATRigidBodyDynamicsSSG_149e7d4dc5704ffcb4bb1119a20f54aa_OutSpareColorRGBA_5;
float _VATRigidBodyDynamicsSSG_149e7d4dc5704ffcb4bb1119a20f54aa_OutSamplingVThisFrame_8;
float _VATRigidBodyDynamicsSSG_149e7d4dc5704ffcb4bb1119a20f54aa_OutSamplingVNextFrame_9;
float3 _VATRigidBodyDynamicsSSG_149e7d4dc5704ffcb4bb1119a20f54aa_OutPieceLocalPositionThisFrame_10;
float3 _VATRigidBodyDynamicsSSG_149e7d4dc5704ffcb4bb1119a20f54aa_OutPieceLocalPositionNextFrame_11;
float _VATRigidBodyDynamicsSSG_149e7d4dc5704ffcb4bb1119a20f54aa_OutDataInPositionAlphaThisFrame_12;
float _VATRigidBodyDynamicsSSG_149e7d4dc5704ffcb4bb1119a20f54aa_OutDataInPositionAlphaNextFrame_13;
float4 _VATRigidBodyDynamicsSSG_149e7d4dc5704ffcb4bb1119a20f54aa_OutColorRGBAThisFrame_17;
float4 _VATRigidBodyDynamicsSSG_149e7d4dc5704ffcb4bb1119a20f54aa_OutColorRGBANextFrame_14;
float4 _VATRigidBodyDynamicsSSG_149e7d4dc5704ffcb4bb1119a20f54aa_OutSpareColorRGBAThisFrame_18;
float4 _VATRigidBodyDynamicsSSG_149e7d4dc5704ffcb4bb1119a20f54aa_OutSpareColorRGBANextFrame_15;
float _VATRigidBodyDynamicsSSG_149e7d4dc5704ffcb4bb1119a20f54aa_OutInterframeInterpolationAlpha_16;
float _VATRigidBodyDynamicsSSG_149e7d4dc5704ffcb4bb1119a20f54aa_OutAnimationProgressThisFrame_21;
float _VATRigidBodyDynamicsSSG_149e7d4dc5704ffcb4bb1119a20f54aa_OutAnimationProgressNextFrame_22;
float3 _VATRigidBodyDynamicsSSG_149e7d4dc5704ffcb4bb1119a20f54aa_OutPieceRestFrameLocalPosition_19;
float3 _VATRigidBodyDynamicsSSG_149e7d4dc5704ffcb4bb1119a20f54aa_OutPieceLocalPositionFinal_20;
SG_VATRigidBodyDynamicsSSG_a4f0f42d0478d0747b2f528d548fb71b_float(_Property_dec4506e248341b28fe2c8d49642655e_Out_0, _Property_8de81ae99c9e42f382ca2d64a5320c32_Out_0, _Property_f1e2cf2c77614076b44609bb6248b3b0_Out_0, _Property_9dd3f3a8aa7f4b8b98c245671a0ccc3c_Out_0, _Property_c8cf047780ab45ee8b7c46338cb1f1f6_Out_0, _Property_bdf605ae51274295b6717cdea5f990ee_Out_0, _Property_ac8fa91ddd734a51805b060cfb9ef252_Out_0, _Property_91fe97fdf36b4ad29e3a17ebdf13896b_Out_0, _Property_59c97c43621b48e7a7113ee8e093093c_Out_0, _Property_9236a60294a44b11b05129feaf44221a_Out_0, _Property_46fd3449bf4c4e63808c67b6b43ce73c_Out_0, _Property_99e50fce137f41ea8d5f8d6945e24521_Out_0, _Property_2771991b04124530b56cab74d03b1ad5_Out_0, _Property_0623e61d7a4d4dc6a62bbeeb3270e8c3_Out_0, _Property_a7ede65d63e14d2fa5a1eb7143dce481_Out_0, _Property_6da2c24bb03f491e9a4ae9288edbff79_Out_0, _Property_675cdf2bcc6547d3a874e8bb64e3dece_Out_0, _Property_a2bb588e1d04422ba775a61c0594d3be_Out_0, _Property_bf5e30ae3d894b1a849c38ea8958e3f0_Out_0, _Property_b86981125884455da91bed13413bbbbf_Out_0, _Property_52c5873f926b4b9f854070d9c8d2886f_Out_0, _Property_611d6cf54f734f89bd499a23712ca0df_Out_0, _Property_6b6a2245b06b46399254eb74e17a261f_Out_0, _Property_d17bb64f97e34bdea2e7af2405dc0686_Out_0, _Property_153b5f703dc1482f9da91cf90eca30f5_Out_0, _Property_e3f21ed56bb74dcdb3cf4a5ac378ca77_Out_0, IN.TimeParameters.x, float3 (0, 0, 0), _VATRigidBodyDynamicsSSG_149e7d4dc5704ffcb4bb1119a20f54aa, _VATRigidBodyDynamicsSSG_149e7d4dc5704ffcb4bb1119a20f54aa_OutPosition_1, _VATRigidBodyDynamicsSSG_149e7d4dc5704ffcb4bb1119a20f54aa_OutNormal_2, _VATRigidBodyDynamicsSSG_149e7d4dc5704ffcb4bb1119a20f54aa_OutTangent_3, _VATRigidBodyDynamicsSSG_149e7d4dc5704ffcb4bb1119a20f54aa_OutColorRGB_4, _VATRigidBodyDynamicsSSG_149e7d4dc5704ffcb4bb1119a20f54aa_OutColorAlpha_6, _VATRigidBodyDynamicsSSG_149e7d4dc5704ffcb4bb1119a20f54aa_OutSpareColorRGBA_5, _VATRigidBodyDynamicsSSG_149e7d4dc5704ffcb4bb1119a20f54aa_OutSamplingVThisFrame_8, _VATRigidBodyDynamicsSSG_149e7d4dc5704ffcb4bb1119a20f54aa_OutSamplingVNextFrame_9, _VATRigidBodyDynamicsSSG_149e7d4dc5704ffcb4bb1119a20f54aa_OutPieceLocalPositionThisFrame_10, _VATRigidBodyDynamicsSSG_149e7d4dc5704ffcb4bb1119a20f54aa_OutPieceLocalPositionNextFrame_11, _VATRigidBodyDynamicsSSG_149e7d4dc5704ffcb4bb1119a20f54aa_OutDataInPositionAlphaThisFrame_12, _VATRigidBodyDynamicsSSG_149e7d4dc5704ffcb4bb1119a20f54aa_OutDataInPositionAlphaNextFrame_13, _VATRigidBodyDynamicsSSG_149e7d4dc5704ffcb4bb1119a20f54aa_OutColorRGBAThisFrame_17, _VATRigidBodyDynamicsSSG_149e7d4dc5704ffcb4bb1119a20f54aa_OutColorRGBANextFrame_14, _VATRigidBodyDynamicsSSG_149e7d4dc5704ffcb4bb1119a20f54aa_OutSpareColorRGBAThisFrame_18, _VATRigidBodyDynamicsSSG_149e7d4dc5704ffcb4bb1119a20f54aa_OutSpareColorRGBANextFrame_15, _VATRigidBodyDynamicsSSG_149e7d4dc5704ffcb4bb1119a20f54aa_OutInterframeInterpolationAlpha_16, _VATRigidBodyDynamicsSSG_149e7d4dc5704ffcb4bb1119a20f54aa_OutAnimationProgressThisFrame_21, _VATRigidBodyDynamicsSSG_149e7d4dc5704ffcb4bb1119a20f54aa_OutAnimationProgressNextFrame_22, _VATRigidBodyDynamicsSSG_149e7d4dc5704ffcb4bb1119a20f54aa_OutPieceRestFrameLocalPosition_19, _VATRigidBodyDynamicsSSG_149e7d4dc5704ffcb4bb1119a20f54aa_OutPieceLocalPositionFinal_20);
#endif
surface.Out = all(isfinite(_VATRigidBodyDynamicsSSG_149e7d4dc5704ffcb4bb1119a20f54aa_OutPosition_1)) ? half4(_VATRigidBodyDynamicsSSG_149e7d4dc5704ffcb4bb1119a20f54aa_OutPosition_1.x, _VATRigidBodyDynamicsSSG_149e7d4dc5704ffcb4bb1119a20f54aa_OutPosition_1.y, _VATRigidBodyDynamicsSSG_149e7d4dc5704ffcb4bb1119a20f54aa_OutPosition_1.z, 1.0) : float4(1.0f, 0.0f, 1.0f, 1.0f);
return surface;
}

    // --------------------------------------------------
    // Build Graph Inputs

    SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
    SurfaceDescriptionInputs output;
    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);

    /* WARNING: $splice Could not find named fragment 'CustomInterpolatorCopyToSDI' */

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
// must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
float3 unnormalizedNormalWS =                       input.normalWS;
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
const float renormFactor =                          1.0 / length(unnormalizedNormalWS);
#endif



#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
output.WorldSpaceNormal =                           renormFactor*input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
output.ObjectSpaceNormal =                          normalize(mul(output.WorldSpaceNormal, (float3x3) UNITY_MATRIX_M));           // transposed multiplication by inverse matrix to handle normal scale
#endif


#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
// to preserve mikktspace compliance we use same scale renormFactor as was used on the normal.
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
// This is explained in section 2.2 in "surface gradient based bump mapping framework"
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
output.WorldSpaceTangent =                          renormFactor*input.tangentWS.xyz;
#endif


#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
output.ObjectSpaceTangent =                         TransformWorldToObjectDir(output.WorldSpaceTangent);
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
output.ObjectSpacePosition =                        TransformWorldToObject(input.positionWS);
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
output.uv1 =                                        input.texCoord1;
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
output.uv2 =                                        input.texCoord2;
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
output.uv3 =                                        input.texCoord3;
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
output.TimeParameters =                             _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
#endif

#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN                output.FaceSign =                                   IS_FRONT_VFACE(input.cullFace, true, false);
#else
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
#endif
#undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

    return output;
}

    // --------------------------------------------------
    // Main

    #include "Packages/com.unity.shadergraph/ShaderGraphLibrary/PreviewVaryings.hlsl"
#include "Packages/com.unity.shadergraph/ShaderGraphLibrary/PreviewPass.hlsl"

    ENDHLSL
}
}
CustomEditor "UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI"
FallBack "Hidden/Shader Graph/FallbackError"
}