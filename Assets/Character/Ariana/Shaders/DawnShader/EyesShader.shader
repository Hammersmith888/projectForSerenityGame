// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "DawnShader/EyesShader"
{
	Properties
	{
		_Normal("Normal", 2D) = "bump" {}
		_Mask("Mask", 2D) = "white" {}
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
		_EmissiveColor1("Emissive Color 1", Color) = (0,0,0,0)
		_EmissivePower1("Emissive Power 1", Range( 0 , 5)) = 0
		_EmissiveColor2("Emissive Color 2", Color) = (0,0,0,0)
		_EmissivePower2("Emissive Power 2", Range( 0 , 5)) = 0
		_EmissiveColor3("Emissive Color 3", Color) = (0,0,0,0)
		_EmissivePower3("Emissive Power 3", Range( 0 , 5)) = 0
		_EmissiveColor4("Emissive Color 4", Color) = (0,0,0,0)
		_EmissivePower4("Emissive Power 4", Range( 0 , 5)) = 0
		_CubeMap("CubeMap", CUBE) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Off
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#pragma shader_feature _DARKMODE_ON
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float2 uv_texcoord;
			float3 worldRefl;
			INTERNAL_DATA
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
		uniform float4 _EmissiveColor1;
		uniform float _EmissivePower1;
		uniform float4 _EmissiveColor2;
		uniform float _EmissivePower2;
		uniform float4 _EmissiveColor4;
		uniform float _EmissivePower4;
		uniform float4 _EmissiveColor3;
		uniform float _EmissivePower3;
		uniform samplerCUBE _CubeMap;
		uniform sampler2D _Roughness;
		uniform float4 _Roughness_ST;
		uniform float _RoughnessBoost01;
		uniform float _RoughnessBoost02;
		uniform float _RoughnessBoost03;
		uniform float _RoughnessBoost04;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Normal = i.uv_texcoord * _Normal_ST.xy + _Normal_ST.zw;
			float3 tex2DNode75 = UnpackNormal( tex2D( _Normal, uv_Normal ) );
			o.Normal = tex2DNode75;
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
			float4 lerpResult132 = lerp( tex2DNode1 , ( ( lerpResult29 + lerpResult28 ) * ( lerpResult31 + lerpResult30 ) ) , temp_output_27_0);
			#ifdef _DARKMODE_ON
				float4 staticSwitch38 = lerpResult132;
			#else
				float4 staticSwitch38 = lerpResult20;
			#endif
			o.Albedo = staticSwitch38.rgb;
			o.Emission = ( ( ( ( tex2DNode2.r * _EmissiveColor1 ) * _EmissivePower1 ) + ( ( tex2DNode2.g * _EmissiveColor2 ) * _EmissivePower2 ) ) + ( ( ( tex2DNode2.a * _EmissiveColor4 ) * _EmissivePower4 ) + ( ( tex2DNode2.b * _EmissiveColor3 ) * _EmissivePower3 ) ) ).rgb;
			o.Metallic = texCUBE( _CubeMap, WorldReflectionVector( i , tex2DNode75 ) ).r;
			float2 uv_Roughness = i.uv_texcoord * _Roughness_ST.xy + _Roughness_ST.zw;
			float4 tex2DNode77 = tex2D( _Roughness, uv_Roughness );
			float4 lerpResult119 = lerp( tex2DNode77 , ( ( ( ( _RoughnessBoost01 * tex2DNode2.r ) + ( _RoughnessBoost02 * tex2DNode2.g ) ) + ( ( _RoughnessBoost03 * tex2DNode2.b ) + ( _RoughnessBoost04 * tex2DNode2.a ) ) ) * tex2DNode77 ) , temp_output_27_0);
			o.Smoothness = lerpResult119.r;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldRefl = -worldViewDir;
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16400
2567;29;1586;864;-380.3098;1738.048;1.272434;True;True
Node;AmplifyShaderEditor.ColorNode;13;-1297.669,-2232.802;Float;False;Property;_BlendColor03;Blend Color 03;11;0;Create;True;0;0;False;0;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;15;-937.5658,-2228.902;Float;False;Property;_BlendColor04;Blend Color 04;12;0;Create;True;0;0;False;0;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;8;-2184.097,-2251.844;Float;False;Property;_BlendColor01;Blend Color 01;9;0;Create;True;0;0;False;0;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;10;-1673.49,-2246.74;Float;False;Property;_BlendColor02;Blend Color 02;10;0;Create;True;0;0;False;0;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-2182.578,-2069.825;Float;True;Property;_Mask;Mask;1;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;91;628.3931,-962.841;Float;False;Property;_RoughnessBoost02;Roughness Boost 02;4;0;Create;True;0;0;False;0;0.5;0;0;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;93;622.3931,-838.8415;Float;False;Property;_RoughnessBoost03;Roughness Boost 03;5;0;Create;True;0;0;False;0;0.5;0;0;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;95;625.6577,-703.5492;Float;False;Property;_RoughnessBoost04;Roughness Boost 04;6;0;Create;True;0;0;False;0;0.5;0;0;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;79;626.218,-1098.666;Float;False;Property;_RoughnessBoost01;Roughness Boost 01;3;0;Create;True;0;0;False;0;0.5;0;0;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-1452.776,-2239.944;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-715.853,-2223.105;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-1075.954,-2227.006;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;-1859.684,-2239.549;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1;-2172.709,-1874.788;Float;True;Property;_BaseColor;Base Color;7;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;112;916.13,-964.4548;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;139;-1996.311,-1260.009;Float;False;Property;_EmissiveColor2;Emissive Color 2;15;0;Create;True;0;0;False;0;0,0,0,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;114;929.13,-709.4548;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;113;923.13,-837.4548;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;111;908.13,-1096.455;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;30;-1441.453,-2473.968;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;22;-1531.726,-2034.316;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;150;-1996.466,-746.6957;Float;False;Property;_EmissiveColor4;Emissive Color 4;19;0;Create;True;0;0;False;0;0,0,0,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;134;-2000,-1520;Float;False;Property;_EmissiveColor1;Emissive Color 1;13;0;Create;True;0;0;False;0;0,0,0,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;29;-1660.614,-2471.336;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;23;-1059.308,-2032.485;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;28;-1880.47,-2476.402;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;31;-1246.897,-2470.799;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;145;-1996.465,-1004.939;Float;False;Property;_EmissiveColor3;Emissive Color 3;17;0;Create;True;0;0;False;0;0,0,0,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;25;-1841.662,-2074.619;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;135;-2066,-1348;Float;False;Property;_EmissivePower1;Emissive Power 1;14;0;Create;True;0;0;False;0;0;0;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;152;-1756.556,-820.5927;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;116;1096.13,-805.4548;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;115;1080.13,-1016.455;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;26;-1840.554,-1970.55;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;141;-1762.311,-1359.009;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;130;-1469.887,-2619.856;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;147;-1758.034,-1086.747;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;24;-1291.858,-1946.424;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;140;-2063.311,-1087.009;Float;False;Property;_EmissivePower2;Emissive Power 2;16;0;Create;True;0;0;False;0;0;0;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;129;-1776.886,-2624.856;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;146;-2068.349,-830.7182;Float;False;Property;_EmissivePower3;Emissive Power 3;18;0;Create;True;0;0;False;0;0;0;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;138;-1776,-1632;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;151;-2069.571,-572.4749;Float;False;Property;_EmissivePower4;Emissive Power 4;20;0;Create;True;0;0;False;0;0;0;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;131;-1604.886,-2730.856;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;148;-1582.034,-974.7482;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;118;1202.841,-940.1658;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;77;680.2396,-491.8961;Float;True;Property;_Roughness;Roughness;2;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;133;-1600,-1520;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;75;-250.3056,-2160.307;Float;True;Property;_Normal;Normal;0;0;Create;True;0;0;False;0;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;142;-1586.311,-1247.009;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;-1470.926,-1862.92;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;153;-1580.556,-708.5939;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;27;-1708.807,-2000.442;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;149;-1409.178,-1089.415;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;117;1204.651,-656.0776;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WorldReflectionVector;156;845.6591,-1343.431;Float;False;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;144;-1413.455,-1361.677;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;132;-1261.992,-2714.168;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;20;-1451.976,-1708.665;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;119;1330.949,-484.579;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;38;-679.1426,-1782.767;Float;False;Property;_DarkMode;Dark Mode;8;0;Create;True;0;0;False;0;0;0;0;True;;Toggle;2;Key0;Key1;Create;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;154;-1219.227,-1208.737;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;157;1049.476,-1367.438;Float;True;Property;_CubeMap;CubeMap;21;0;Create;True;0;0;False;0;56a68e301a0ff55469ae441c0112d256;56a68e301a0ff55469ae441c0112d256;True;0;False;white;Auto;False;Object;-1;Auto;Cube;6;0;SAMPLER2D;;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1442.579,-1523.725;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;DawnShader/EyesShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;11;0;10;0
WireConnection;11;1;2;2
WireConnection;14;0;15;0
WireConnection;14;1;2;4
WireConnection;12;0;13;0
WireConnection;12;1;2;3
WireConnection;3;0;8;0
WireConnection;3;1;2;1
WireConnection;112;0;91;0
WireConnection;112;1;2;2
WireConnection;114;0;95;0
WireConnection;114;1;2;4
WireConnection;113;0;93;0
WireConnection;113;1;2;3
WireConnection;111;0;79;0
WireConnection;111;1;2;1
WireConnection;30;0;1;0
WireConnection;30;1;13;0
WireConnection;30;2;2;3
WireConnection;22;0;3;0
WireConnection;22;1;11;0
WireConnection;29;0;1;0
WireConnection;29;1;10;0
WireConnection;29;2;2;2
WireConnection;23;0;12;0
WireConnection;23;1;14;0
WireConnection;28;0;1;0
WireConnection;28;1;8;0
WireConnection;28;2;2;1
WireConnection;31;0;1;0
WireConnection;31;1;15;0
WireConnection;31;2;2;4
WireConnection;25;0;2;1
WireConnection;25;1;2;2
WireConnection;152;0;2;4
WireConnection;152;1;150;0
WireConnection;116;0;113;0
WireConnection;116;1;114;0
WireConnection;115;0;111;0
WireConnection;115;1;112;0
WireConnection;26;0;2;3
WireConnection;26;1;2;4
WireConnection;141;0;2;2
WireConnection;141;1;139;0
WireConnection;130;0;31;0
WireConnection;130;1;30;0
WireConnection;147;0;2;3
WireConnection;147;1;145;0
WireConnection;24;0;22;0
WireConnection;24;1;23;0
WireConnection;129;0;29;0
WireConnection;129;1;28;0
WireConnection;138;0;2;1
WireConnection;138;1;134;0
WireConnection;131;0;129;0
WireConnection;131;1;130;0
WireConnection;148;0;147;0
WireConnection;148;1;146;0
WireConnection;118;0;115;0
WireConnection;118;1;116;0
WireConnection;133;0;138;0
WireConnection;133;1;135;0
WireConnection;142;0;141;0
WireConnection;142;1;140;0
WireConnection;19;0;1;0
WireConnection;19;1;24;0
WireConnection;153;0;152;0
WireConnection;153;1;151;0
WireConnection;27;0;25;0
WireConnection;27;1;26;0
WireConnection;149;0;153;0
WireConnection;149;1;148;0
WireConnection;117;0;118;0
WireConnection;117;1;77;0
WireConnection;156;0;75;0
WireConnection;144;0;133;0
WireConnection;144;1;142;0
WireConnection;132;0;1;0
WireConnection;132;1;131;0
WireConnection;132;2;27;0
WireConnection;20;0;1;0
WireConnection;20;1;19;0
WireConnection;20;2;27;0
WireConnection;119;0;77;0
WireConnection;119;1;117;0
WireConnection;119;2;27;0
WireConnection;38;1;20;0
WireConnection;38;0;132;0
WireConnection;154;0;144;0
WireConnection;154;1;149;0
WireConnection;157;1;156;0
WireConnection;0;0;38;0
WireConnection;0;1;75;0
WireConnection;0;2;154;0
WireConnection;0;3;157;0
WireConnection;0;4;119;0
ASEEND*/
//CHKSM=582B533196B3A411B75D75B5D7734F7EE4E04E38