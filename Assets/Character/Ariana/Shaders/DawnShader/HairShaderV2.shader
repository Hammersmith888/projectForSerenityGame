// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "DawnShader/HairShaderV2"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.635
		_TextNoise("TextNoise", 2D) = "white" {}
		_NoiseTilling("Noise Tilling", Float) = 24
		_Root("Root", 2D) = "white" {}
		_Alpha("Alpha", 2D) = "white" {}
		_ID("ID", 2D) = "white" {}
		_Depth("Depth", 2D) = "white" {}
		_TipColor("Tip Color", Color) = (0.1226415,0.06746172,0.03297437,0)
		_RootColor("Root Color", Color) = (0.3113208,0.184846,0.1072001,0)
		_OpacityBoots("Opacity Boots", Range( 0 , 4)) = 1
		_DitherBoost("Dither Boost", Range( 0 , 4)) = 1
		_Brightness("Brightness", Float) = 0.2
		_RoughnessRoot("Roughness Root", Range( 0 , 5)) = 0.06
		_RoughnessTip("Roughness Tip", Range( 0 , 5)) = 0.04
		_MetallicBoost("Metallic Boost", Range( 0 , 5)) = 0.7
		_MipBias("MipBias", Float) = -1
		_TangentA("TangentA", Color) = (0,0.1543091,0.5568628,0.003921569)
		_TangentB("TangentB", Color) = (1,0.7653513,0,0.003921569)
		_TangentC("TangentC", Color) = (0,0.1543091,0.5568628,0.003921569)
		_TangentD("TangentD", Color) = (1,0.7653513,0,0.003921569)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Grass"  "Queue" = "Transparent+0" }
		Cull Off
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows exclude_path:deferred 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float4 _TangentA;
		uniform float4 _TangentB;
		uniform sampler2D _ID;
		uniform float4 _ID_ST;
		uniform float _MipBias;
		uniform float4 _TangentD;
		uniform float4 _TangentC;
		uniform sampler2D _Depth;
		uniform float4 _Depth_ST;
		uniform float _Brightness;
		uniform float4 _RootColor;
		uniform float4 _TipColor;
		uniform sampler2D _Root;
		uniform float4 _Root_ST;
		uniform sampler2D _TextNoise;
		uniform float _NoiseTilling;
		uniform float _MetallicBoost;
		uniform float _RoughnessTip;
		uniform float _RoughnessRoot;
		uniform sampler2D _Alpha;
		uniform float4 _Alpha_ST;
		uniform float _DitherBoost;
		uniform float _OpacityBoots;
		uniform float _Cutoff = 0.635;


		inline float Dither4x4Bayer( int x, int y )
		{
			const float dither[ 16 ] = {
				 1,  9,  3, 11,
				13,  5, 15,  7,
				 4, 12,  2, 10,
				16,  8, 14,  6 };
			int r = y * 4 + x;
			return dither[r] / 16; // same # of instructions as pre-dividing due to compiler magic
		}


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_ID = i.uv_texcoord * _ID_ST.xy + _ID_ST.zw;
			float4 tex2DNode50 = tex2Dbias( _ID, float4( uv_ID, 0, _MipBias) );
			float4 lerpResult106 = lerp( _TangentA , _TangentB , tex2DNode50.r);
			float4 normalizeResult108 = normalize( lerpResult106 );
			float2 uv_Depth = i.uv_texcoord * _Depth_ST.xy + _Depth_ST.zw;
			float4 lerpResult130 = lerp( _TangentD , _TangentC , tex2Dbias( _Depth, float4( uv_Depth, 0, _MipBias) ).r);
			float4 normalizeResult131 = normalize( lerpResult130 );
			o.Normal = ( normalizeResult108 + normalizeResult131 ).rgb;
			float2 uv_Root = i.uv_texcoord * _Root_ST.xy + _Root_ST.zw;
			float4 tex2DNode48 = tex2D( _Root, uv_Root );
			float4 lerpResult83 = lerp( _RootColor , _TipColor , tex2DNode48.r);
			float4 tex2DNode85 = tex2D( _TextNoise, ( i.uv_texcoord * _NoiseTilling ) );
			o.Albedo = ( _Brightness * ( lerpResult83 * tex2DNode85.r ) ).rgb;
			o.Metallic = ( _MetallicBoost * tex2DNode50.r );
			float lerpResult100 = lerp( _RoughnessTip , _RoughnessRoot , tex2DNode48.r);
			o.Smoothness = lerpResult100;
			o.Alpha = 1;
			float4 temp_cast_2 = (tex2DNode85.r).xxxx;
			float4 ditherCustomScreenPos110 = temp_cast_2;
			float2 clipScreen110 = ditherCustomScreenPos110.xy * _ScreenParams.xy;
			float dither110 = Dither4x4Bayer( fmod(clipScreen110.x, 4), fmod(clipScreen110.y, 4) );
			float2 uv_Alpha = i.uv_texcoord * _Alpha_ST.xy + _Alpha_ST.zw;
			float4 tex2DNode49 = tex2Dbias( _Alpha, float4( uv_Alpha, 0, _MipBias) );
			dither110 = step( dither110, ( tex2DNode49.a * _DitherBoost ) );
			clip( ( (0.0 + (dither110 - 0.0) * (1.0 - 0.0) / (1.0 - 0.0)) + (0.0 + (( _OpacityBoots * tex2DNode49.a ) - 0.0) * (1.0 - 0.0) / (1.0 - 0.0)) ) - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17000
753;1;1598;1010;1272.193;-317.9171;1.336637;True;True
Node;AmplifyShaderEditor.CommentaryNode;137;-1495.323,-369.5633;Float;False;1184.027;869.6328;Base Color;11;86;48;88;82;81;83;85;89;90;91;87;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;87;-1416.772,-175.7238;Float;False;Property;_NoiseTilling;Noise Tilling;2;0;Create;True;0;0;False;0;24;24;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;86;-1445.323,-316.1729;Float;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;103;-1698.661,1312.42;Float;False;Property;_MipBias;MipBias;15;0;Create;True;0;0;False;0;-1;-1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;134;-1434.186,1843.211;Float;False;1146.538;473.4188;Opacity;9;111;49;115;112;114;110;120;116;117;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;49;-1384.186,1893.211;Float;True;Property;_Alpha;Alpha;4;0;Create;True;0;0;False;0;112ffde36680b1840a2368c6b0f4f4cf;9bfa309fd2398d949b5c9f2671eb3e9b;True;0;False;white;Auto;False;Object;-1;MipBias;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;88;-1220.323,-264.1728;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;133;-1301.023,994.0795;Float;False;1005.005;800.842;Normal;11;105;104;51;50;106;130;108;129;128;131;132;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;111;-1373.957,2090.302;Float;False;Property;_DitherBoost;Dither Boost;10;0;Create;True;0;0;False;0;1;1.25;0;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;48;-1087.862,270.0696;Float;True;Property;_Root;Root;3;0;Create;True;0;0;False;0;2bd9c35bd4696f14789f4ca3244be798;347bee86d8ff03845bfdb6e6cac93870;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;81;-1033.546,-106.9795;Float;False;Property;_RootColor;Root Color;8;0;Create;True;0;0;False;0;0.3113208,0.184846,0.1072001,0;0.1886792,0.09171906,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;82;-1036.786,80.71716;Float;False;Property;_TipColor;Tip Color;7;0;Create;True;0;0;False;0;0.1226415,0.06746172,0.03297437,0;0.2924528,0.1421646,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;129;-937.9242,1406.093;Float;False;Property;_TangentC;TangentC;18;0;Create;True;0;0;False;0;0,0.1543091,0.5568628,0.003921569;0,0.1543091,0.5568628,0.003921569;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;85;-1036.854,-319.5632;Float;True;Property;_TextNoise;TextNoise;1;0;Create;True;0;0;False;0;460e2ff8ae929eb4da259f14ca11619f;460e2ff8ae929eb4da259f14ca11619f;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;51;-1244.706,1237.74;Float;True;Property;_Depth;Depth;6;0;Create;True;0;0;False;0;61e19dfc52912b84eab5daecc79d38c2;9bfa309fd2398d949b5c9f2671eb3e9b;True;0;False;white;Auto;False;Object;-1;MipBias;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;128;-926.8635,1587.922;Float;False;Property;_TangentD;TangentD;19;0;Create;True;0;0;False;0;1,0.7653513,0,0.003921569;1,0.7653513,0,0.003921569;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;112;-1070.851,1975.465;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;50;-1251.023,1044.079;Float;True;Property;_ID;ID;5;0;Create;True;0;0;False;0;2387ab402e3322e41a09384f85e872bc;9bfa309fd2398d949b5c9f2671eb3e9b;True;0;False;white;Auto;False;Object;-1;MipBias;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;104;-934.2133,1046.429;Float;False;Property;_TangentA;TangentA;16;0;Create;True;0;0;False;0;0,0.1543091,0.5568628,0.003921569;0,0.1543091,0.5568628,0.003921569;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;115;-1373.007,2170.657;Float;False;Property;_OpacityBoots;Opacity Boots;9;0;Create;True;0;0;False;0;1;1.09;0;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;105;-933.2133,1220.429;Float;False;Property;_TangentB;TangentB;17;0;Create;True;0;0;False;0;1,0.7653513,0,0.003921569;1,0.7653513,0,0.003921569;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;102;-1103.515,665.3661;Float;False;800.4378;294.6938;Roughness;3;100;99;98;;1,1,1,1;0;0
Node;AmplifyShaderEditor.LerpOp;106;-643.213,1162.429;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.DitheringNode;110;-910.4832,1931.1;Float;False;0;True;3;0;FLOAT;0;False;1;SAMPLER2D;;False;2;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;130;-668.2486,1540.677;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;114;-1042.431,2137.013;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;83;-757.9107,-18.98618;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;90;-719.992,-305.698;Float;False;Property;_Brightness;Brightness;11;0;Create;True;0;0;False;0;0.2;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;98;-764.048,748.4676;Float;False;Property;_RoughnessTip;Roughness Tip;13;0;Create;True;0;0;False;0;0.04;0.12;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;131;-648.5831,1435.409;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.NormalizeNode;108;-655.7672,1302.227;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCRemapNode;120;-665.9995,1948.89;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;117;-666.7361,2114.629;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;99;-762.0765,849.0599;Float;False;Property;_RoughnessRoot;Roughness Root;12;0;Create;True;0;0;False;0;0.06;0.76;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;89;-655.543,-218.4358;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;135;-735.5278,544.6165;Float;False;Property;_MetallicBoost;Metallic Boost;14;0;Create;True;0;0;False;0;0.7;0.94;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;132;-450.0181,1364.529;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;100;-487.0766,750.0601;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;91;-490.7108,-275.2152;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;116;-441.6482,1981.734;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;136;-434.4582,555.4799;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;127;-13.49403,405.2581;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;DawnShader/HairShaderV2;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.635;True;True;0;True;Grass;;Transparent;ForwardOnly;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;49;2;103;0
WireConnection;88;0;86;0
WireConnection;88;1;87;0
WireConnection;85;1;88;0
WireConnection;51;2;103;0
WireConnection;112;0;49;4
WireConnection;112;1;111;0
WireConnection;50;2;103;0
WireConnection;106;0;104;0
WireConnection;106;1;105;0
WireConnection;106;2;50;1
WireConnection;110;0;112;0
WireConnection;110;2;85;1
WireConnection;130;0;128;0
WireConnection;130;1;129;0
WireConnection;130;2;51;1
WireConnection;114;0;115;0
WireConnection;114;1;49;4
WireConnection;83;0;81;0
WireConnection;83;1;82;0
WireConnection;83;2;48;1
WireConnection;131;0;130;0
WireConnection;108;0;106;0
WireConnection;120;0;110;0
WireConnection;117;0;114;0
WireConnection;89;0;83;0
WireConnection;89;1;85;1
WireConnection;132;0;108;0
WireConnection;132;1;131;0
WireConnection;100;0;98;0
WireConnection;100;1;99;0
WireConnection;100;2;48;1
WireConnection;91;0;90;0
WireConnection;91;1;89;0
WireConnection;116;0;120;0
WireConnection;116;1;117;0
WireConnection;136;0;135;0
WireConnection;136;1;50;1
WireConnection;127;0;91;0
WireConnection;127;1;132;0
WireConnection;127;3;136;0
WireConnection;127;4;100;0
WireConnection;127;10;116;0
ASEEND*/
//CHKSM=1574E49696BD318E0F0404E2432EAF02DA121BF6