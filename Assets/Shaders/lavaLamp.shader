Shader "Custom/lavaLamp"
{
	Properties
	{
		//Glass
		 _GlassColor("Glass Color", Color) = (1, 1, 1, 0.5)
		_GlassThickness("Glass Thickness", Range(0.01, 0.35)) = 0.1


		//Esferas
		_DiffuseColor("Diffuse Color", Color) = (1, 1, 1)

		_SpecularColor("Specular Color", Color) = (1, 1, 1)
		_SpecularPow("Specular Power", Float) = 1

		_FresnelColor("Fresnel Color", Color) = (1, 1, 1)
		_FresnelPow("Fresnel Power", Float) = 1

		_BlendAmount("Blend Amount", Range(0.01, 1)) = 0.05

	}

		SubShader
	{
		//Vidro
		Pass
		{
			Tags
			{
				"RenderType" = "Opaque"
				"Queue" = "Geometry"
			}

			Cull Off

			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

		   struct Attributes
			{
			float4 positionOS : POSITION;
			float3 normalOS : NORMAL;
			};

			struct Varyings
{
	float4 positionCS : SV_POSITION;

	float3 normalWS : TEXCOORD0;
	float3 viewDirWS : TEXCOORD1;
	float3 positionNoTranslationWS : TEXCOORD2;
};
			
			float _GlassThickness;
			half4 _GlassColor;
			
			Varyings vert(Attributes i)
{
	Varyings o = (Varyings)0;

	// Vidro
	float3 pos = i.positionOS.xyz - _GlassThickness * i.normalOS;
	o.positionCS = UnityObjectToClipPos(pos);
	o.positionNoTranslationWS = mul((float3x3)unity_ObjectToWorld, pos);

	// Objeto transparente
	o.normalWS = UnityObjectToWorldNormal(i.normalOS);
	o.viewDirWS = normalize(WorldSpaceViewDir(i.positionOS));

	return o;
}
			
			half4 frag(Varyings i) : SV_TARGET
				{
	// Objeto transparente
	float fresnel = pow(1 - saturate(dot(i.normalWS, i.viewDirWS)), 3);
	float dotP = (dot(i.normalWS, _WorldSpaceLightPos0.xyz) + 1) * 0.5;
	half4 col = _GlassColor;
	col.rgb *= dotP;
	col *= 0.2 + fresnel * 0.8;

	return col;
}
			ENDCG
		}
		//Esferas
		Pass
		{
		Cull Front
		ZTest Always

		Blend SrcAlpha OneMinusSrcAlpha

		CGPROGRAM

		#include "UnityCG.cginc"

		#pragma vertex vert 
		#pragma fragment frag

		#define EPSILON 0.001

		struct Attributes
		{
			float4 positionOS : POSITION;
		};

		struct Varyings
		{
			float4 positionCS : SV_POSITION;

			float3 positionWS : TEXCOORD0;
			float4 positionSS : TEXCOORD1;
		};

		struct Ray
		{
			float3 orig;
			float3 dir;
		};

		uniform sampler _CameraDepthTexture;

		half3 _DiffuseColor;

		half3 _SpecularColor;
		float _SpecularPow;

		half3 _FresnelColor;
		float _FresnelPow;

		float _BlendAmount;

		float4 _Spheres[20];
		int _SphereCount;

		float SphereSDF(float3 p, float r)
		{
			return length(p) - r;
		}

		float SmoothMin(float a, float b, float k)
		{
			float h = max(k - abs(a - b), 0) / k;
			return min(a, b) - h * h * h * k * (1 / 6.0);
		}

		float SceneSDF(float3 p)
		{
			float d = SphereSDF(p - _Spheres[0].xyz, _Spheres[0].w);

			for (int i = 1; i < _SphereCount; i++)
			{
				d = SmoothMin(d, SphereSDF(p - _Spheres[i].xyz, _Spheres[i].w), _BlendAmount);
			}

			return d;
		}

		float3 EstimateNormal(float3 p)
		{
			float2 h = float2(EPSILON, 0);

			return normalize(float3(
				SceneSDF(p + h.xyy) - SceneSDF(p - h.xyy),
				SceneSDF(p + h.yxy) - SceneSDF(p - h.yxy),
				SceneSDF(p + h.yyx) - SceneSDF(p - h.yyx)
			));
		}

		half3 CalculateLighting(float3 p, float3 viewDir)
		{
			float3 lightDir = _WorldSpaceLightPos0;
			float3 normal = EstimateNormal(p);

			float3 halfDir = normalize(lightDir + viewDir);

			float diffuseAtten = saturate(dot(normal, lightDir));
			float specularAtten = pow(saturate(dot(normal, halfDir)), _SpecularPow);
			float fresnelStrength = pow(1 - saturate(dot(normal, viewDir)), _FresnelPow);

			half3 diffuse = diffuseAtten * _DiffuseColor;
			half3 specular = specularAtten * _SpecularColor;
			half3 fresnel = fresnelStrength * _FresnelColor;

			return saturate(diffuse + specular + fresnel);
		}

		half4 Raymarch(Ray r, float maxDist)
		{
			float length = 0;

			for (int i = 0; i < 150; i++)
			{
				float d = SceneSDF(r.orig + length * r.dir);

				if (d > maxDist) break;

				if (d < EPSILON)
				{
					return half4(CalculateLighting(r.orig + length * r.dir, -r.dir), 1);
				}

				length += d;
			}

			return 0;
		}

		Varyings vert(Attributes i)
		{
			Varyings o = (Varyings)0;

			o.positionCS = UnityObjectToClipPos(i.positionOS.xyz);
			o.positionWS = mul(unity_ObjectToWorld, i.positionOS).xyz;
			o.positionSS = ComputeScreenPos(o.positionCS);

			return o;
		}

		half4 frag(Varyings i) : SV_TARGET
		{
			Ray r;
			r.orig = _WorldSpaceCameraPos;
			r.dir = normalize(i.positionWS - _WorldSpaceCameraPos);

			float depth = tex2D(_CameraDepthTexture, i.positionSS.xy / i.positionSS.w).r;
			depth = LinearEyeDepth(depth);

			half4 col = Raymarch(r, depth);

			return col;
		}

		ENDCG
	}

	}
}


