Shader "Unlit/HullOutlines"
{
    Properties
    {
        _OutlineColor ("Outline Color", Color) = (0, 0, 0, 1)
        _MainTex("Main texture", 2D) = "MainTexture" {}
        _OutlineThickness ("Outline thickness", Float) = 0.1

        [Toggle(_AnimateOutline)] _Animate ("Animate Outline", Float) = 0
    }

    SubShader
    {
        Tags
        {
            "RenderType" = "Opaque"
            "Queue" = "Geometry"
        }

        Pass
        {
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct Attributes
            {
                float4 positionOS : POSITION;
                float2 tex_uv : TEXCOORD0;

            };

            struct Varyings
            {
                float4 positionCS : SV_POSITION;
                 float2 tex_uv : TEXCOORD0;

            };

            sampler2D _MainTex;
            Varyings vert(Attributes i)
            {
                Varyings o ;
                o.tex_uv = i.tex_uv;
                o.positionCS = UnityObjectToClipPos(i.positionOS);

                return o;
            }

            half4 frag(Varyings i) : SV_TARGET
            {
                half4 col = tex2D(_MainTex, i.tex_uv);
                return col;
            }

            ENDCG
        }

        Pass 
        {
            Cull Front

            CGPROGRAM

            #pragma shader_feature _AnimateOutline

            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct Attributes
            {
                float4 positionOS : POSITION;
                float4 smoothNormalOS : NORMAL;
                float2 tex_uv : TEXCOORD0;
                float4 pos : TEXCOORD1;
            };

            struct Varyings
            {
                float4 positionStart : TEXCOORD1;
                float4 positionCS : SV_POSITION;
                 float2 tex_uv : TEXCOORD0;
            };

            half4 _OutlineColor;
            float _OutlineThickness;

            Varyings vert(Attributes i)
            {
                Varyings o;

                float3 smoothNormal = UnityObjectToWorldNormal(i.smoothNormalOS.xyz);

                float finalOutlineThickness;
                #if defined(_AnimateOutline)
                    finalOutlineThickness = _OutlineThickness * (1 + sin(_Time.y));
                #else
                    finalOutlineThickness = _OutlineThickness;
                #endif

                float3 pos = mul(unity_ObjectToWorld, i.positionOS).xyz + finalOutlineThickness * smoothNormal;
                float3 posStart = mul(unity_ObjectToWorld, i.positionOS).xyz * smoothNormal;
                o.positionStart = UnityWorldToClipPos(posStart);

                o.positionCS = UnityWorldToClipPos(pos);

                return o;
            }

            half4 frag(Varyings i) : SV_TARGET
            {
                //half4 col = tex2D(_MainTex, i.tex_uv);
                
                    return _OutlineColor;
              
                
            }

            ENDCG
        }
    }
}
