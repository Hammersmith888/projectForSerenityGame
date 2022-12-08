// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "DawnShader/Weapon_Emissive_PannerPanner"
{
	Properties
	{
		_Dirt("Dirt", 2D) = "white" {}
		_DirtBoots("Dirt Boots", Range( 0 , 2)) = 0
		_AO("AO", 2D) = "white" {}
		_Normal("Normal", 2D) = "bump" {}
		_Mask("Mask", 2D) = "white" {}
		_Metallic("Metallic", 2D) = "white" {}
		_MetallicBoots01("Metallic Boots 01", Range( 0 , 4)) = 0
		_MetallicBoots02("Metallic Boots 02", Range( 0 , 4)) = 0
		_MetallicBoots03("Metallic Boots 03", Range( 0 , 4)) = 0
		_MetallicBoots04("Metallic Boots 04", Range( 0 , 4)) = 0
		_Roughness("Roughness", 2D) = "white" {}
		_RoughnessBoost01("Roughness Boost 01", Range( 0 , 4)) = 0.5
		_RoughnessBoost02("Roughness Boost 02", Range( 0 , 4)) = 0.5
		_RoughnessBoost03("Roughness Boost 03", Range( 0 , 4)) = 0.5
		_RoughnessBoost04("Roughness Boost 04", Range( 0 , 4)) = 0.5
		_BaseColor("Base Color", 2D) = "white" {}
		[Toggle(_DARKMODE_ON)] _DarkMode("Dark Mode", Float) = 0
		_BlendColor01("Blend Color 01", Color) = (1,1,1,0)
		_BlendColor02("Blend Color 02", Color) = (1,1,1,0)
		_BlendColor03("Blend Color 03", Color) = (1,1,1,0)
		_BlendColor04("Blend Color 04", Color) = (1,1,1,0)
		[Toggle(_BLENDTEXTUREMODE_ON)] _BlendTextureMode("Blend Texture Mode", Float) = 0
		[Toggle(_BLENDTEXTURE01_ON)] _BlendTexture01("Blend Texture 01", Float) = 0
		[Toggle(_BLENDTEXTURE02_ON)] _BlendTexture02("Blend Texture 02", Float) = 0
		[Toggle(_BLENDTEXTURE03_ON)] _BlendTexture03("Blend Texture 03", Float) = 0
		[Toggle(_BLENDTEXTURE04_ON)] _BlendTexture04("Blend Texture 04", Float) = 0
		_Texture01("Texture 01", 2D) = "white" {}
		_Texture02("Texture 02", 2D) = "white" {}
		_Texture03("Texture 03", 2D) = "white" {}
		_Texture04("Texture 04", 2D) = "white" {}
		_EmissiveMask("Emissive Mask", 2D) = "white" {}
		_EmissiveColor01("Emissive Color 01", Color) = (0,0,0,0)
		_EmissiveBoots1("Emissive Boots 1", Float) = 0
		_EmissiveColor02("Emissive Color 02", Color) = (0,0,0,0)
		_EmissiveBoots2("Emissive Boots 2", Float) = 0
		_EmissiveColor03("Emissive Color 03", Color) = (0,0,0,0)
		_EmissiveBoots3("Emissive Boots 3", Float) = 0
		_EmissiveColor04("Emissive Color 04", Color) = (0,0,0,0)
		_EmissiveBoots4("Emissive Boots 4", Float) = 0
		_EmissivePannerMap("Emissive Panner Map", 2D) = "white" {}
		_PannerProperty("Panner Property", Vector) = (0,0,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma shader_feature _BLENDTEXTUREMODE_ON
		#pragma shader_feature _DARKMODE_ON
		#pragma shader_feature _BLENDTEXTURE01_ON
		#pragma shader_feature _BLENDTEXTURE02_ON
		#pragma shader_feature _BLENDTEXTURE03_ON
		#pragma shader_feature _BLENDTEXTURE04_ON
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _Normal;
		uniform float4 _Normal_ST;
		uniform sampler2D _BaseColor;
		uniform float4 _BaseColor_ST;
		uniform float4 _BlendColor01;
		uniform sampler2D _Mask;
		uniform float4 _Mask_ST;
		uniform float4 _BlendColor02;
		uniform float4 _BlendColor03;
		uniform float4 _BlendColor04;
		uniform sampler2D _Texture01;
		uniform float4 _Texture01_ST;
		uniform sampler2D _Texture02;
		uniform float4 _Texture02_ST;
		uniform sampler2D _Texture03;
		uniform float4 _Texture03_ST;
		uniform sampler2D _Texture04;
		uniform float4 _Texture04_ST;
		uniform sampler2D _Dirt;
		uniform float4 _Dirt_ST;
		uniform float _DirtBoots;
		uniform float4 _EmissiveColor01;
		uniform sampler2D _EmissiveMask;
		uniform float4 _EmissiveMask_ST;
		uniform sampler2D _EmissivePannerMap;
		uniform float2 _PannerProperty;
		uniform float _EmissiveBoots1;
		uniform float _EmissiveBoots2;
		uniform float4 _EmissiveColor02;
		uniform float4 _EmissiveColor03;
		uniform float _EmissiveBoots3;
		uniform float4 _EmissiveColor04;
		uniform float _EmissiveBoots4;
		uniform sampler2D _Metallic;
		uniform float4 _Metallic_ST;
		uniform float _MetallicBoots01;
		uniform float _MetallicBoots02;
		uniform float _MetallicBoots03;
		uniform float _MetallicBoots04;
		uniform sampler2D _Roughness;
		uniform float4 _Roughness_ST;
		uniform float _RoughnessBoost01;
		uniform float _RoughnessBoost02;
		uniform float _RoughnessBoost03;
		uniform float _RoughnessBoost04;
		uniform sampler2D _AO;
		uniform float4 _AO_ST;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Normal = i.uv_texcoord * _Normal_ST.xy + _Normal_ST.zw;
			o.Normal = UnpackNormal( tex2D( _Normal, uv_Normal ) );
			float2 uv_BaseColor = i.uv_texcoord * _BaseColor_ST.xy + _BaseColor_ST.zw;
			float4 tex2DNode1 = tex2D( _BaseColor, uv_BaseColor );
			float2 uv_Mask = i.uv_texcoord * _Mask_ST.xy + _Mask_ST.zw;
			float4 tex2DNode2 = tex2D( _Mask, uv_Mask );
			float temp_output_27_0 = ( ( tex2DNode2.r + tex2DNode2.g ) + ( tex2DNode2.b + tex2DNode2.a ) );
			float4 lerpResult20 = lerp( tex2DNode1 , ( tex2DNode1 * ( ( ( _BlendColor01 * tex2DNode2.r ) + ( _BlendColor02 * tex2DNode2.g ) ) + ( ( _BlendColor03 * tex2DNode2.b ) + ( _BlendColor04 * tex2DNode2.a ) ) ) ) , temp_output_27_0);
			float4 lerpResult29 = lerp( tex2DNode1 , _BlendColor02 , tex2DNode2.g);
			float4 lerpResult28 = lerp( tex2DNode1 , _BlendColor01 , tex2DNode2.r);
			float4 lerpResult31 = lerp( tex2DNode1 , _BlendColor04 , tex2DNode2.a);
			float4 lerpResult30 = lerp( tex2DNode1 , _BlendColor03 , tex2DNode2.b);
			float4 lerpResult147 = lerp( tex2DNode1 , ( ( lerpResult29 + lerpResult28 ) * ( lerpResult31 + lerpResult30 ) ) , temp_output_27_0);
			#ifdef _DARKMODE_ON
				float4 staticSwitch38 = lerpResult147;
			#else
				float4 staticSwitch38 = lerpResult20;
			#endif
			float2 uv_Texture01 = i.uv_texcoord * _Texture01_ST.xy + _Texture01_ST.zw;
			float4 lerpResult55 = lerp( float4( 0,0,0,0 ) , tex2D( _Texture01, uv_Texture01 ) , tex2DNode2.r);
			#ifdef _BLENDTEXTURE01_ON
				float4 staticSwitch60 = lerpResult55;
			#else
				float4 staticSwitch60 = tex2DNode1;
			#endif
			float2 uv_Texture02 = i.uv_texcoord * _Texture02_ST.xy + _Texture02_ST.zw;
			float4 lerpResult56 = lerp( float4( 0,0,0,0 ) , tex2D( _Texture02, uv_Texture02 ) , tex2DNode2.g);
			#ifdef _BLENDTEXTURE02_ON
				float4 staticSwitch61 = lerpResult56;
			#else
				float4 staticSwitch61 = tex2DNode1;
			#endif
			float2 uv_Texture03 = i.uv_texcoord * _Texture03_ST.xy + _Texture03_ST.zw;
			float4 lerpResult57 = lerp( float4( 0,0,0,0 ) , tex2D( _Texture03, uv_Texture03 ) , tex2DNode2.b);
			#ifdef _BLENDTEXTURE03_ON
				float4 staticSwitch62 = lerpResult57;
			#else
				float4 staticSwitch62 = tex2DNode1;
			#endif
			float2 uv_Texture04 = i.uv_texcoord * _Texture04_ST.xy + _Texture04_ST.zw;
			float4 lerpResult58 = lerp( float4( 0,0,0,0 ) , tex2D( _Texture04, uv_Texture04 ) , tex2DNode2.a);
			#ifdef _BLENDTEXTURE04_ON
				float4 staticSwitch63 = lerpResult58;
			#else
				float4 staticSwitch63 = tex2DNode1;
			#endif
			float4 lerpResult71 = lerp( tex2DNode1 , ( ( ( staticSwitch60 * tex2DNode2.r ) + ( staticSwitch61 * tex2DNode2.g ) ) + ( ( staticSwitch62 * tex2DNode2.b ) + ( staticSwitch63 * tex2DNode2.a ) ) ) , temp_output_27_0);
			#ifdef _BLENDTEXTUREMODE_ON
				float4 staticSwitch72 = lerpResult71;
			#else
				float4 staticSwitch72 = staticSwitch38;
			#endif
			float2 uv_Dirt = i.uv_texcoord * _Dirt_ST.xy + _Dirt_ST.zw;
			float4 tex2DNode80 = tex2D( _Dirt, uv_Dirt );
			float4 lerpResult87 = lerp( staticSwitch72 , ( tex2DNode80 * _DirtBoots ) , ( _DirtBoots * tex2DNode80.a ));
			o.Albedo = lerpResult87.rgb;
			float2 uv_EmissiveMask = i.uv_texcoord * _EmissiveMask_ST.xy + _EmissiveMask_ST.zw;
			float4 tex2DNode158 = tex2D( _EmissiveMask, uv_EmissiveMask );
			float2 panner132 = ( _Time.y * _PannerProperty + i.uv_texcoord);
			float4 tex2DNode133 = tex2D( _EmissivePannerMap, panner132 );
			o.Emission = ( ( ( _EmissiveColor01 * ( ( tex2DNode158.r * tex2DNode133 ) * _EmissiveBoots1 ) ) + ( ( ( tex2DNode158.g * tex2DNode133 ) * _EmissiveBoots2 ) * _EmissiveColor02 ) ) + ( ( _EmissiveColor03 * ( ( tex2DNode158.b * tex2DNode133 ) * _EmissiveBoots3 ) ) + ( _EmissiveColor04 * ( ( tex2DNode158.a * tex2DNode133 ) * _EmissiveBoots4 ) ) ) ).rgb;
			float2 uv_Metallic = i.uv_texcoord * _Metallic_ST.xy + _Metallic_ST.zw;
			float4 tex2DNode76 = tex2D( _Metallic, uv_Metallic );
			float4 lerpResult128 = lerp( tex2DNode76 , ( ( ( ( _MetallicBoots01 * tex2DNode2.r ) + ( _MetallicBoots02 * tex2DNode2.g ) ) + ( ( _MetallicBoots03 * tex2DNode2.b ) + ( _MetallicBoots04 * tex2DNode2.a ) ) ) * tex2DNode76 ) , temp_output_27_0);
			o.Metallic = lerpResult128.r;
			float2 uv_Roughness = i.uv_texcoord * _Roughness_ST.xy + _Roughness_ST.zw;
			float4 tex2DNode77 = tex2D( _Roughness, uv_Roughness );
			float4 lerpResult119 = lerp( tex2DNode77 , ( ( ( ( _RoughnessBoost01 * tex2DNode2.r ) + ( _RoughnessBoost02 * tex2DNode2.g ) ) + ( ( _RoughnessBoost03 * tex2DNode2.b ) + ( _RoughnessBoost04 * tex2DNode2.a ) ) ) * tex2DNode77 ) , temp_output_27_0);
			float4 temp_cast_3 = (( 1.0 * _DirtBoots )).xxxx;
			float4 lerpResult88 = lerp( lerpResult119 , temp_cast_3 , ( _DirtBoots * tex2DNode80.a ));
			o.Smoothness = lerpResult88.r;
			float2 uv_AO = i.uv_texcoord * _AO_ST.xy + _AO_ST.zw;
			o.Occlusion = tex2D( _AO, uv_AO ).r;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16400
2567;29;1586;842;2790.685;3061.303;2.976255;True;True
Node;AmplifyShaderEditor.SamplerNode;39;-2885.036,-281.1397;Float;True;Property;_Texture01;Texture 01;26;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;13;-2163.126,-1318.067;Float;False;Property;_BlendColor03;Blend Color 03;19;0;Create;True;0;0;False;0;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-3048.035,-1155.09;Float;True;Property;_Mask;Mask;4;0;Create;True;0;0;False;0;None;87b2e550462076c4aa65495e7a18f37d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;50;-2882.945,273.4547;Float;True;Property;_Texture03;Texture 03;28;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;10;-2538.948,-1332.005;Float;False;Property;_BlendColor02;Blend Color 02;18;0;Create;True;0;0;False;0;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;15;-1803.023,-1314.167;Float;False;Property;_BlendColor04;Blend Color 04;20;0;Create;True;0;0;False;0;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;43;-2881.104,4.529496;Float;True;Property;_Texture02;Texture 02;27;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;54;-2882.484,549.7479;Float;True;Property;_Texture04;Texture 04;29;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;8;-3049.554,-1337.109;Float;False;Property;_BlendColor01;Blend Color 01;17;0;Create;True;0;0;False;0;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;56;-2486.201,-16.73898;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;-2725.142,-1324.813;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;130;-2931.776,-2406.721;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;131;-2899.776,-2278.721;Float;False;Property;_PannerProperty;Panner Property;40;0;Create;True;0;0;False;0;0,0;0.1,0.1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TimeNode;129;-2915.776,-2118.722;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;57;-2468.646,256.5266;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;58;-2457.471,532.6592;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-1581.31,-1308.37;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1;-3038.166,-960.0521;Float;True;Property;_BaseColor;Base Color;15;0;Create;True;0;0;False;0;None;6dd8471e56a3be147a1c2877e14763db;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-2318.233,-1325.208;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-1941.412,-1312.271;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;55;-2491.789,-300.0495;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;91;-331.6754,-916.2148;Float;False;Property;_RoughnessBoost02;Roughness Boost 02;12;0;Create;True;0;0;False;0;0.5;0.5;0;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;79;-333.8505,-1052.04;Float;False;Property;_RoughnessBoost01;Roughness Boost 01;11;0;Create;True;0;0;False;0;0.5;0.5;0;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;62;-2210.348,-111.9511;Float;False;Property;_BlendTexture03;Blend Texture 03;24;0;Create;True;0;0;False;0;0;0;0;True;;Toggle;2;Key0;Key1;Create;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;23;-1924.766,-1117.749;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PannerNode;132;-2611.776,-2246.721;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;93;-336.6754,-792.2153;Float;False;Property;_RoughnessBoost03;Roughness Boost 03;13;0;Create;True;0;0;False;0;0.5;0.5;0;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;60;-2213.897,-327.3228;Float;False;Property;_BlendTexture01;Blend Texture 01;22;0;Create;True;0;0;False;0;0;0;0;True;;Toggle;2;Key0;Key1;Create;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;30;-2306.91,-1559.232;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;28;-2745.928,-1561.666;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;29;-2526.072,-1556.6;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;63;-2211.201,-1.129412;Float;False;Property;_BlendTexture04;Blend Texture 04;25;0;Create;True;0;0;False;0;0;0;0;True;;Toggle;2;Key0;Key1;Create;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;22;-2397.184,-1119.58;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;95;-334.4108,-656.923;Float;False;Property;_RoughnessBoost04;Roughness Boost 04;14;0;Create;True;0;0;False;0;0.5;0.5;0;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;31;-2112.354,-1556.063;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;61;-2210.348,-219.3009;Float;False;Property;_BlendTexture02;Blend Texture 02;23;0;Create;True;0;0;False;0;0;0;0;True;;Toggle;2;Key0;Key1;Create;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;25;-2707.12,-1159.883;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;26;-2706.012,-1055.814;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;112;-43.93866,-917.8286;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;102;516.2817,-902.0133;Float;False;Property;_MetallicBoots02;Metallic Boots 02;7;0;Create;True;0;0;False;0;0;0;0;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;158;-2485.406,-3001.666;Float;True;Property;_EmissiveMask;Emissive Mask;30;0;Create;True;0;0;False;0;None;87b2e550462076c4aa65495e7a18f37d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;101;514.1066,-1037.839;Float;False;Property;_MetallicBoots01;Metallic Boots 01;6;0;Create;True;0;0;False;0;0;0;0;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;107;513.5462,-642.7215;Float;False;Property;_MetallicBoots04;Metallic Boots 04;9;0;Create;True;0;0;False;0;0;0;0;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;65;-1854.932,-396.8809;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;24;-2157.315,-1031.688;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;145;-2401.958,-1721.717;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;66;-1853.199,-282.3062;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;64;-1853.199,-516.6637;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;114;-30.93866,-662.8286;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;67;-1851.464,-174.6741;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;111;-51.93866,-1049.829;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;113;-36.93866,-790.8286;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;144;-2696.958,-1721.717;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;104;511.2816,-778.0138;Float;False;Property;_MetallicBoots03;Metallic Boots 03;8;0;Create;True;0;0;False;0;0;0;0;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;133;-2339.776,-2246.721;Float;True;Property;_EmissivePannerMap;Emissive Panner Map;39;0;Create;True;0;0;False;0;None;693a417e10213314aa5c5fed3107c21b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;69;-1657.034,-237.1693;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;156;-1846.425,-2876.713;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;-2336.383,-948.1839;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;120;803.5206,-1036.779;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;136;-1854.955,-2995.649;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;161;-1967.366,-3405.81;Float;False;Property;_EmissiveBoots4;Emissive Boots 4;38;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;135;-1964.147,-3644.794;Float;False;Property;_EmissiveBoots1;Emissive Boots 1;32;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;159;-1966.293,-3560.128;Float;False;Property;_EmissiveBoots2;Emissive Boots 2;34;0;Create;True;0;0;False;0;0;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;160;-1966.561,-3481.089;Float;False;Property;_EmissiveBoots3;Emissive Boots 3;36;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;157;-1841.134,-2736.526;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;116;136.0613,-758.8286;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;27;-2574.265,-1085.706;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;146;-2524.958,-1827.717;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;123;824.5206,-649.7785;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;122;818.5206,-777.7785;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;68;-1655.298,-475.0006;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;134;-1860.246,-3135.836;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;121;811.5206,-904.7785;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;115;120.0613,-969.8286;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;154;-1642.211,-2734.164;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;139;-1661.323,-3133.474;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;137;-1890.676,-2468.381;Float;False;Property;_EmissiveColor01;Emissive Color 01;31;0;Create;True;0;0;False;0;0,0,0,0;0.4009434,0.8080564,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;155;-1647.502,-2874.351;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;148;-1877.097,-2134.921;Float;False;Property;_EmissiveColor03;Emissive Color 03;35;0;Create;True;0;0;False;0;0,0,0,0;0.4009434,0.8080564,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;140;-1656.032,-2993.287;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;124;975.5206,-956.7785;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;20;-2317.433,-793.9289;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;125;991.5206,-745.7785;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;70;-1467.807,-348.2731;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;147;-2182.063,-1811.029;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;138;-1883.312,-2299.382;Float;False;Property;_EmissiveColor02;Emissive Color 02;33;0;Create;True;0;0;False;0;0,0,0,0;0,0.6797385,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;149;-1867.003,-1964.557;Float;False;Property;_EmissiveColor04;Emissive Color 04;37;0;Create;True;0;0;False;0;0,0,0,0;0,0.6797385,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;77;-358.246,-485.5379;Float;True;Property;_Roughness;Roughness;10;0;Create;True;0;0;False;0;None;28c436a0bde88774c9ef6b4c9bf017e2;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;118;261.8468,-872.3459;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;71;-1243.507,-392.5125;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;76;468.94,-489.5361;Float;True;Property;_Metallic;Metallic;5;0;Create;True;0;0;False;0;None;73344647eed06664e955472408a6444f;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;38;-1108.321,-1280.887;Float;False;Property;_DarkMode;Dark Mode;16;0;Create;True;0;0;False;0;0;0;0;True;;Toggle;2;Key0;Key1;Create;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;85;-358.5976,-1291.623;Float;False;Constant;_Float0;Float 0;22;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;151;-1456.103,-2197.149;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;117;130.0613,-545.8286;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;150;-1456.103,-2310.148;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;80;-505.1128,-1515.332;Float;True;Property;_Dirt;Dirt;0;0;Create;True;0;0;False;0;None;cf797529cb3826943a3826e6354165b3;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;141;-1454.679,-2581.38;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;142;-1454.679,-2468.381;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;86;-484.8184,-1625.895;Float;False;Property;_DirtBoots;Dirt Boots;1;0;Create;True;0;0;False;0;0;0;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;127;1117.306,-859.2958;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;83;-95.50151,-1501.153;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;82;-92.35077,-1376.695;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;81;-92.35077,-1247.51;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;84;-92.35083,-1627.187;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;72;-765.7151,-832.885;Float;False;Property;_BlendTextureMode;Blend Texture Mode;21;0;Create;True;0;0;False;0;0;0;0;True;;Toggle;2;Key0;Key1;Create;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;119;139.2943,-431.5911;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;152;-1248.103,-2254.149;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;143;-1246.679,-2525.381;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;126;985.5206,-532.7785;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;75;-250.3056,-2160.307;Float;True;Property;_Normal;Normal;3;0;Create;True;0;0;False;0;None;16ce5fdde8d2bb642a2af9ce6a73418a;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;74;-251.6975,-1947.125;Float;True;Property;_AO;AO;2;0;Create;True;0;0;False;0;None;062cff9d4710e624a9e6d566e8efd4e7;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;153;-1086.454,-2393.051;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;87;296.463,-1594.75;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;128;994.7536,-418.541;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;88;287.6019,-1367.028;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1442.579,-1523.725;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;DawnShader/Weapon_Emissive_PannerPanner;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;56;1;43;0
WireConnection;56;2;2;2
WireConnection;3;0;8;0
WireConnection;3;1;2;1
WireConnection;57;1;50;0
WireConnection;57;2;2;3
WireConnection;58;1;54;0
WireConnection;58;2;2;4
WireConnection;14;0;15;0
WireConnection;14;1;2;4
WireConnection;11;0;10;0
WireConnection;11;1;2;2
WireConnection;12;0;13;0
WireConnection;12;1;2;3
WireConnection;55;1;39;0
WireConnection;55;2;2;1
WireConnection;62;1;1;0
WireConnection;62;0;57;0
WireConnection;23;0;12;0
WireConnection;23;1;14;0
WireConnection;132;0;130;0
WireConnection;132;2;131;0
WireConnection;132;1;129;2
WireConnection;60;1;1;0
WireConnection;60;0;55;0
WireConnection;30;0;1;0
WireConnection;30;1;13;0
WireConnection;30;2;2;3
WireConnection;28;0;1;0
WireConnection;28;1;8;0
WireConnection;28;2;2;1
WireConnection;29;0;1;0
WireConnection;29;1;10;0
WireConnection;29;2;2;2
WireConnection;63;1;1;0
WireConnection;63;0;58;0
WireConnection;22;0;3;0
WireConnection;22;1;11;0
WireConnection;31;0;1;0
WireConnection;31;1;15;0
WireConnection;31;2;2;4
WireConnection;61;1;1;0
WireConnection;61;0;56;0
WireConnection;25;0;2;1
WireConnection;25;1;2;2
WireConnection;26;0;2;3
WireConnection;26;1;2;4
WireConnection;112;0;91;0
WireConnection;112;1;2;2
WireConnection;65;0;61;0
WireConnection;65;1;2;2
WireConnection;24;0;22;0
WireConnection;24;1;23;0
WireConnection;145;0;31;0
WireConnection;145;1;30;0
WireConnection;66;0;62;0
WireConnection;66;1;2;3
WireConnection;64;0;60;0
WireConnection;64;1;2;1
WireConnection;114;0;95;0
WireConnection;114;1;2;4
WireConnection;67;0;63;0
WireConnection;67;1;2;4
WireConnection;111;0;79;0
WireConnection;111;1;2;1
WireConnection;113;0;93;0
WireConnection;113;1;2;3
WireConnection;144;0;29;0
WireConnection;144;1;28;0
WireConnection;133;1;132;0
WireConnection;69;0;66;0
WireConnection;69;1;67;0
WireConnection;156;0;158;3
WireConnection;156;1;133;0
WireConnection;19;0;1;0
WireConnection;19;1;24;0
WireConnection;120;0;101;0
WireConnection;120;1;2;1
WireConnection;136;0;158;2
WireConnection;136;1;133;0
WireConnection;157;0;158;4
WireConnection;157;1;133;0
WireConnection;116;0;113;0
WireConnection;116;1;114;0
WireConnection;27;0;25;0
WireConnection;27;1;26;0
WireConnection;146;0;144;0
WireConnection;146;1;145;0
WireConnection;123;0;107;0
WireConnection;123;1;2;4
WireConnection;122;0;104;0
WireConnection;122;1;2;3
WireConnection;68;0;64;0
WireConnection;68;1;65;0
WireConnection;134;0;158;1
WireConnection;134;1;133;0
WireConnection;121;0;102;0
WireConnection;121;1;2;2
WireConnection;115;0;111;0
WireConnection;115;1;112;0
WireConnection;154;0;157;0
WireConnection;154;1;161;0
WireConnection;139;0;134;0
WireConnection;139;1;135;0
WireConnection;155;0;156;0
WireConnection;155;1;160;0
WireConnection;140;0;136;0
WireConnection;140;1;159;0
WireConnection;124;0;120;0
WireConnection;124;1;121;0
WireConnection;20;0;1;0
WireConnection;20;1;19;0
WireConnection;20;2;27;0
WireConnection;125;0;122;0
WireConnection;125;1;123;0
WireConnection;70;0;68;0
WireConnection;70;1;69;0
WireConnection;147;0;1;0
WireConnection;147;1;146;0
WireConnection;147;2;27;0
WireConnection;118;0;115;0
WireConnection;118;1;116;0
WireConnection;71;0;1;0
WireConnection;71;1;70;0
WireConnection;71;2;27;0
WireConnection;38;1;20;0
WireConnection;38;0;147;0
WireConnection;151;0;149;0
WireConnection;151;1;154;0
WireConnection;117;0;118;0
WireConnection;117;1;77;0
WireConnection;150;0;148;0
WireConnection;150;1;155;0
WireConnection;141;0;137;0
WireConnection;141;1;139;0
WireConnection;142;0;140;0
WireConnection;142;1;138;0
WireConnection;127;0;124;0
WireConnection;127;1;125;0
WireConnection;83;0;86;0
WireConnection;83;1;80;4
WireConnection;82;0;85;0
WireConnection;82;1;86;0
WireConnection;81;0;86;0
WireConnection;81;1;80;4
WireConnection;84;0;80;0
WireConnection;84;1;86;0
WireConnection;72;1;38;0
WireConnection;72;0;71;0
WireConnection;119;0;77;0
WireConnection;119;1;117;0
WireConnection;119;2;27;0
WireConnection;152;0;150;0
WireConnection;152;1;151;0
WireConnection;143;0;141;0
WireConnection;143;1;142;0
WireConnection;126;0;127;0
WireConnection;126;1;76;0
WireConnection;153;0;143;0
WireConnection;153;1;152;0
WireConnection;87;0;72;0
WireConnection;87;1;84;0
WireConnection;87;2;83;0
WireConnection;128;0;76;0
WireConnection;128;1;126;0
WireConnection;128;2;27;0
WireConnection;88;0;119;0
WireConnection;88;1;82;0
WireConnection;88;2;81;0
WireConnection;0;0;87;0
WireConnection;0;1;75;0
WireConnection;0;2;153;0
WireConnection;0;3;128;0
WireConnection;0;4;88;0
WireConnection;0;5;74;0
ASEEND*/
//CHKSM=48116AD562D7A6BFB933F3BEDB6576B1AE55A02C