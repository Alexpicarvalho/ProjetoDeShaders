Shader "Custom/rotationShader"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
        _SliderSpeed3("sliderSpeed", Range(0,5)) = 5
        _SliderEscalar("Escalar", Range(0,10)) = 5
    }
        SubShader
        {
            Blend SrcAlpha OneMinusSrcAlpha
            ZWrite off // sempre que usar blend 

           Tags { "RenderType" = "Transparent" "Queue" = "Transparent" }

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

                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _SliderSpeed3;
            float _SliderEscalar;
            fixed4 _Color3;


            float3 rodar3DZ(float3 pos, float angle)
            {
                float3x3 rot = {cos(angle), -sin(angle), 0,
                                sin(angle), cos(angle), 0,
                                0,         0,         1
                };

                return mul(rot , pos);
            }

            v2f vert(appdata v)
            {
                v2f o;
                v.vertex.xyz = rodar3DZ(v.vertex.xyz, _SliderSpeed3);
                o.vertex = UnityObjectToClipPos(v.vertex * _SliderEscalar);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
            fixed4 col = tex2D(_MainTex, i.uv);
            // apply fog
            return col;
            }
            ENDCG
        }

        }
}
