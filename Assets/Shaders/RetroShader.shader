Shader "Hidden/RetroShader"
{
	Properties
	{
		[HideInInspector] _MainTex("Texture", 2D) = "white" {}
		_Pixelated("Texture", 2D) = "white" {}
		_PixelationIntensity("Pixelation Strength", Float) = 0.0

		_VignetteIntensity("Vignette Intensity", Range(0,1)) = 0.6
		_SaturationReduction("Saturation Reduction", Range(0,1)) = 0.4


		_ScrollSpeed("Scroll Speed", Range(1, 1000)) = 10
		_SliceFrequency("Slice Frequency", Range(0, 500)) = 10

	}
		SubShader
		{
			// No culling or depth
			Cull Off ZWrite Off ZTest Always

			Pass
			{
				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag

				#include "UnityCG.cginc"

				struct appdata
				{
					float4 vertex : POSITION;
					float2 uv : TEXCOORD0;
				};

				struct v2f
				{
					float2 uv : TEXCOORD0;
					float2 uvImage : TEXCOORD2;
					float4 vertex : SV_POSITION;
					float2 screenPos : TEXCOORD1;
				};

				v2f vert(appdata v)
				{
					v2f o;
					o.vertex = UnityObjectToClipPos(v.vertex);
					o.uv = v.uv;
					o.uvImage = v.uv;
					o.screenPos = o.vertex.xy / o.vertex.w;
					return o;
				}

				sampler2D _MainTex;
				sampler2D _Pixelated;
				float _VignetteIntensity;
				float _SaturationReduction;
				float _ScrollSpeed;
				float _SliceFrequency;

				fixed4 frag(v2f i) : SV_Target
				{
					float2 vignetteRadius = float2(1, 0.5); // Adjust the X and Y components for oval shape
					float vignetteSoftness = 0.2; // Adjust for fade distance
					float vignetteIntensity = _VignetteIntensity;

					float2 screenCenter = float2(0.5, 0.5);
					float2 normalizedScreenPos = i.screenPos * _ScreenParams.xy;

					float2 delta = normalizedScreenPos - screenCenter;
					float2 distance = abs(delta) / (vignetteRadius * _ScreenParams.x);

					float vignette = saturate(1.0 - smoothstep(1.0 - vignetteSoftness, 1.0, max(distance.x, distance.y)));
					vignette = lerp(1.0 - vignetteIntensity, 1.0, vignette);

					fixed4 col = tex2D(_MainTex, i.uv);
					float3 gray = dot(col.rgb, float3(0.3, 0.6, 0.1));
					col.rgb = lerp(gray, col.rgb, _SaturationReduction);
					col += tex2D(_Pixelated, i.uv);

					float sliceValue = sin((i.uv.y + _Time.x * _ScrollSpeed) * _SliceFrequency);
					
					
					if (sliceValue > 0)
					{
						col += tex2D(_Pixelated, i.uvImage);
					}
					col.rgb *= vignette;

					return col;

				}
				ENDCG
			}
		}
}