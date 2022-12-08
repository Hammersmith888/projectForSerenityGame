// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "DawnShader/SkinShader"
{
	Properties
	{
		_Dirt("Dirt", 2D) = "white" {}
		_DirtBoots("Dirt Boots", Range( 0 , 2)) = 0
		[Header(Translucency)]
		_Translucency("Strength", Range( 0 , 50)) = 1
		_TransNormalDistortion("Normal Distortion", Range( 0 , 1)) = 0.1
		_TransScattering("Scaterring Falloff", Range( 1 , 50)) = 2
		_TransDirect("Direct", Range( 0 , 1)) = 1
		_TransAmbient("Ambient", Range( 0 , 1)) = 0.2
		_TransShadow("Shadow", Range( 0 , 1)) = 0.9
		_AO("AO", 2D) = "white" {}
		_SkinNormal("Skin Normal", 2D) = "bump" {}
		_SSSMask("SSS Mask", 2D) = "white" {}
		_SSSColor("SSS Color", Color) = (1,0.8184171,0.7122642,1)
		_Mask("Mask", 2D) = "white" {}
		_SkinRoughness("Skin Roughness", 2D) = "white" {}
		_RoughnessMod_R("RoughnessMod_R", 2D) = "white" {}
		_SkinRounghnessBoots("Skin Rounghness Boots", Range( 0 , 1)) = 0
		_SkinColor("Skin Color", 2D) = "white" {}
		_Tint("Tint", Color) = (1,0.8288271,0.7311321,0)
		_BaseColorMul("BaseColorMul", Color) = (0.745283,0.4324048,0.4324048,0)
		_ColorPow("Color Pow", Range( 0 , 1)) = 1
		_BlendColor01("Blend Color 01", Color) = (0.5686275,0.5686275,0.5686275,0)
		_BlendColor02("Blend Color 02", Color) = (1,1,1,0)
		_BlendColor03("Blend Color 03", Color) = (1,1,1,0)
		_BlendColor04("Blend Color 04", Color) = (1,1,1,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "UnityPBSLighting.cginc"
		#pragma target 3.0
		#pragma surface surf StandardCustom keepalpha addshadow fullforwardshadows exclude_path:deferred 
		struct Input
		{
			float2 uv_texcoord;
		};

		struct SurfaceOutputStandardCustom
		{
			half3 Albedo;
			half3 Normal;
			half3 Emission;
			half Metallic;
			half Smoothness;
			half Occlusion;
			half Alpha;
			half3 Translucency;
		};

		uniform sampler2D _SkinNormal;
		uniform float4 _SkinNormal_ST;
		uniform sampler2D _SkinColor;
		uniform float4 _SkinColor_ST;
		uniform float4 _BlendColor01;
		uniform sampler2D _Mask;
		uniform float4 _Mask_ST;
		uniform float4 _BlendColor02;
		uniform float4 _BlendColor03;
		uniform float4 _BlendColor04;
		uniform float4 _BaseColorMul;
		uniform float _ColorPow;
		uniform float4 _Tint;
		uniform sampler2D _Dirt;
		uniform float4 _Dirt_ST;
		uniform float _DirtBoots;
		uniform sampler2D _SkinRoughness;
		uniform float4 _SkinRoughness_ST;
		uniform float _SkinRounghnessBoots;
		uniform sampler2D _RoughnessMod_R;
		uniform float4 _RoughnessMod_R_ST;
		uniform sampler2D _AO;
		uniform float4 _AO_ST;
		uniform half _Translucency;
		uniform half _TransNormalDistortion;
		uniform half _TransScattering;
		uniform half _TransDirect;
		uniform half _TransAmbient;
		uniform half _TransShadow;
		uniform float4 _SSSColor;
		uniform sampler2D _SSSMask;
		uniform float4 _SSSMask_ST;

		inline half4 LightingStandardCustom(SurfaceOutputStandardCustom s, half3 viewDir, UnityGI gi )
		{
			#if !DIRECTIONAL
			float3 lightAtten = gi.light.color;
			#else
			float3 lightAtten = lerp( _LightColor0.rgb, gi.light.color, _TransShadow );
			#endif
			half3 lightDir = gi.light.dir + s.Normal * _TransNormalDistortion;
			half transVdotL = pow( saturate( dot( viewDir, -lightDir ) ), _TransScattering );
			half3 translucency = lightAtten * (transVdotL * _TransDirect + gi.indirect.diffuse * _TransAmbient) * s.Translucency;
			half4 c = half4( s.Albedo * translucency * _Translucency, 0 );

			SurfaceOutputStandard r;
			r.Albedo = s.Albedo;
			r.Normal = s.Normal;
			r.Emission = s.Emission;
			r.Metallic = s.Metallic;
			r.Smoothness = s.Smoothness;
			r.Occlusion = s.Occlusion;
			r.Alpha = s.Alpha;
			return LightingStandard (r, viewDir, gi) + c;
		}

		inline void LightingStandardCustom_GI(SurfaceOutputStandardCustom s, UnityGIInput data, inout UnityGI gi )
		{
			#if defined(UNITY_PASS_DEFERRED) && UNITY_ENABLE_REFLECTION_BUFFERS
				gi = UnityGlobalIllumination(data, s.Occlusion, s.Normal);
			#else
				UNITY_GLOSSY_ENV_FROM_SURFACE( g, s, data );
				gi = UnityGlobalIllumination( data, s.Occlusion, s.Normal, g );
			#endif
		}

		void surf( Input i , inout SurfaceOutputStandardCustom o )
		{
			float2 uv_SkinNormal = i.uv_texcoord * _SkinNormal_ST.xy + _SkinNormal_ST.zw;
			o.Normal = UnpackNormal( tex2D( _SkinNormal, uv_SkinNormal ) );
			float2 uv_SkinColor = i.uv_texcoord * _SkinColor_ST.xy + _SkinColor_ST.zw;
			float4 tex2DNode4 = tex2D( _SkinColor, uv_SkinColor );
			float2 uv_Mask = i.uv_texcoord * _Mask_ST.xy + _Mask_ST.zw;
			float4 tex2DNode11 = tex2D( _Mask, uv_Mask );
			float4 lerpResult59 = lerp( tex2DNode4 , ( tex2DNode4 * ( ( ( _BlendColor01 * tex2DNode11.r ) + ( _BlendColor02 * tex2DNode11.g ) ) + ( ( _BlendColor03 * tex2DNode11.b ) + ( _BlendColor04 * tex2DNode11.a ) ) ) ) , ( ( tex2DNode11.r + tex2DNode11.g ) + ( tex2DNode11.b + tex2DNode11.a ) ));
			float4 temp_cast_0 = (_ColorPow).xxxx;
			float2 uv_Dirt = i.uv_texcoord * _Dirt_ST.xy + _Dirt_ST.zw;
			float4 tex2DNode63 = tex2D( _Dirt, uv_Dirt );
			float4 lerpResult70 = lerp( ( lerpResult59 + ( ( _BaseColorMul * pow( tex2DNode4 , temp_cast_0 ) ) * _Tint ) ) , ( tex2DNode63 * _DirtBoots ) , ( _DirtBoots * tex2DNode63.a ));
			o.Albedo = lerpResult70.rgb;
			float2 uv_SkinRoughness = i.uv_texcoord * _SkinRoughness_ST.xy + _SkinRoughness_ST.zw;
			float2 uv_RoughnessMod_R = i.uv_texcoord * _RoughnessMod_R_ST.xy + _RoughnessMod_R_ST.zw;
			float4 temp_cast_2 = (( 1.0 * _DirtBoots )).xxxx;
			float4 lerpResult71 = lerp( ( tex2D( _SkinRoughness, uv_SkinRoughness ) * ( _SkinRounghnessBoots * tex2D( _RoughnessMod_R, uv_RoughnessMod_R ).a ) ) , temp_cast_2 , ( _DirtBoots * tex2DNode63.a ));
			o.Smoothness = lerpResult71.r;
			float2 uv_AO = i.uv_texcoord * _AO_ST.xy + _AO_ST.zw;
			o.Occlusion = tex2D( _AO, uv_AO ).r;
			float2 uv_SSSMask = i.uv_texcoord * _SSSMask_ST.xy + _SSSMask_ST.zw;
			o.Translucency = ( _SSSColor * tex2D( _SSSMask, uv_SSSMask ).g ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16400
7;23;2546;1050;4895.43;2780.497;2.951426;True;True
Node;AmplifyShaderEditor.ColorNode;20;-928.8261,-1231.057;Float;False;Property;_BlendColor02;Blend Color 02;22;0;Create;True;0;0;False;0;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;12;-1394.003,-1222.533;Float;False;Property;_BlendColor01;Blend Color 01;21;0;Create;True;0;0;False;0;0.5686275,0.5686275,0.5686275,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;22;-426.8227,-1229.299;Float;False;Property;_BlendColor04;Blend Color 04;24;0;Create;True;0;0;False;0;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;21;-668.8802,-1227.952;Float;False;Property;_BlendColor03;Blend Color 03;23;0;Create;True;0;0;False;0;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;11;-1456.844,-962.1219;Float;True;Property;_Mask;Mask;13;0;Create;True;0;0;False;0;08bef8bdfb981434bb8b739b8d34a588;08bef8bdfb981434bb8b739b8d34a588;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;54;-423.0063,-1050.944;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;53;-661.6342,-1051.532;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;51;-1095.295,-1058.552;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;52;-887.1647,-1051.217;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-1407.582,-202.3145;Float;False;Property;_ColorPow;Color Pow;20;0;Create;True;0;0;False;0;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;55;-520.2012,-919.9565;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;4;-1431.925,-404.8359;Float;True;Property;_SkinColor;Skin Color;17;0;Create;True;0;0;False;0;6e53a163b96e3d94a98d29194f6a4d63;6e53a163b96e3d94a98d29194f6a4d63;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;56;-790.5305,-920.6831;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;57;-650.0494,-819.539;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;8;-1120.536,-220.4266;Float;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;61;-1076.165,-789.5539;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;7;-1348.19,-600.9757;Float;False;Property;_BaseColorMul;BaseColorMul;19;0;Create;True;0;0;False;0;0.745283,0.4324048,0.4324048,0;0.003921569,0.003921569,0.003921569,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;62;-1077.273,-893.6233;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;3;-1420.305,247.2969;Float;True;Property;_RoughnessMod_R;RoughnessMod_R;15;0;Create;True;0;0;False;0;c0b7b18616e3d4c4d9f007d6681e9331;c0b7b18616e3d4c4d9f007d6681e9331;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;26;-1403.547,-63.60631;Float;False;Property;_SkinRounghnessBoots;Skin Rounghness Boots;16;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-977.7782,-369.261;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;33;-857.7969,-232.529;Float;False;Property;_Tint;Tint;18;0;Create;True;0;0;False;0;1,0.8288271,0.7311321,0;1,0.8288271,0.7311321,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;60;-944.4194,-819.4459;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;58;-479.5711,-756.8867;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;63;-1276.916,-1681.338;Float;True;Property;_Dirt;Dirt;0;0;Create;True;0;0;False;0;baaa21e922f419e4497dd7f311c685f7;baaa21e922f419e4497dd7f311c685f7;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;65;-1256.622,-1791.901;Float;False;Property;_DirtBoots;Dirt Boots;1;0;Create;True;0;0;False;0;0;0;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;64;-1130.401,-1457.628;Float;False;Constant;_Float0;Float 0;22;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;44;-1101.422,-69.58938;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;25;-1427.203,43.70723;Float;True;Property;_SkinRoughness;Skin Roughness;14;0;Create;True;0;0;False;0;1df5a1941431ac04483ca62aeb4e16eb;1df5a1941431ac04483ca62aeb4e16eb;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;-617.485,-350.551;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;59;-305.0912,-572.9854;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;69;-864.1537,-1542.7;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;36;-562.103,480.0817;Float;True;Property;_SSSMask;SSS Mask;11;0;Create;True;0;0;False;0;33d79758a5b303945a6a9a60e499b29d;33d79758a5b303945a6a9a60e499b29d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;24;-336.6446,-369.4753;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;67;-867.3045,-1667.159;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;49;-558.4207,676.9701;Float;False;Property;_SSSColor;SSS Color;12;0;Create;True;0;0;False;0;1,0.8184171,0.7122642,1;1,0.8288271,0.7311321,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;43;-973.1713,55.39404;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;68;-864.1538,-1793.193;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;66;-864.1537,-1413.515;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;70;-475.3391,-1760.756;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;71;-484.2004,-1533.033;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;38;-1405.436,652.8618;Float;True;Property;_SkinNormal;Skin Normal;10;0;Create;True;0;0;False;0;5920de4d143c58743969dfac7ec8365c;5920de4d143c58743969dfac7ec8365c;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;37;-361.3509,847.9471;Float;True;Property;_AO;AO;9;0;Create;True;0;0;False;0;83ba82314cd89af46bdab3663afb9aa4;83ba82314cd89af46bdab3663afb9aa4;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;50;-246.4187,679.5697;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;76.37568,-40.6022;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;DawnShader/SkinShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;ForwardOnly;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;2;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;54;0;22;0
WireConnection;54;1;11;4
WireConnection;53;0;21;0
WireConnection;53;1;11;3
WireConnection;51;0;12;0
WireConnection;51;1;11;1
WireConnection;52;0;20;0
WireConnection;52;1;11;2
WireConnection;55;0;53;0
WireConnection;55;1;54;0
WireConnection;56;0;51;0
WireConnection;56;1;52;0
WireConnection;57;0;56;0
WireConnection;57;1;55;0
WireConnection;8;0;4;0
WireConnection;8;1;9;0
WireConnection;61;0;11;3
WireConnection;61;1;11;4
WireConnection;62;0;11;1
WireConnection;62;1;11;2
WireConnection;10;0;7;0
WireConnection;10;1;8;0
WireConnection;60;0;62;0
WireConnection;60;1;61;0
WireConnection;58;0;4;0
WireConnection;58;1;57;0
WireConnection;44;0;26;0
WireConnection;44;1;3;4
WireConnection;35;0;10;0
WireConnection;35;1;33;0
WireConnection;59;0;4;0
WireConnection;59;1;58;0
WireConnection;59;2;60;0
WireConnection;69;0;64;0
WireConnection;69;1;65;0
WireConnection;24;0;59;0
WireConnection;24;1;35;0
WireConnection;67;0;65;0
WireConnection;67;1;63;4
WireConnection;43;0;25;0
WireConnection;43;1;44;0
WireConnection;68;0;63;0
WireConnection;68;1;65;0
WireConnection;66;0;65;0
WireConnection;66;1;63;4
WireConnection;70;0;24;0
WireConnection;70;1;68;0
WireConnection;70;2;67;0
WireConnection;71;0;43;0
WireConnection;71;1;69;0
WireConnection;71;2;66;0
WireConnection;50;0;49;0
WireConnection;50;1;36;2
WireConnection;0;0;70;0
WireConnection;0;1;38;0
WireConnection;0;4;71;0
WireConnection;0;5;37;0
WireConnection;0;7;50;0
ASEEND*/
//CHKSM=E30675D809CDDC3C76486932A1C4AD498E5F2558