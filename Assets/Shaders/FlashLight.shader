Shader "Unlit/FlashLight"
{
    Properties
    {
        _Color("Color", Color) = (1, 1, 1, 1)
        _VectorGlovalPosition("PositioInTheWorld", Vector) = (0, 0, 0, 0)
        _Slide("Slidetest", Range(0, 10)) = 0
        _TexureSeta("display name", 2D) = "defaulttexture" {}
    }

        SubShader
    {
        Tags { "RenderType" = "Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work

            #include "UnityCG.cginc"
        #include "Assets\Shaders\Biblieoteca\MyLibary.cginc"

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
            float4 _Color;
            float4 _VectorGlovalPosition;
            float _Slide;
            sampler2D _TexureSeta;

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);

            // apply flashlight effect
            if (IsInsideCircle(_VectorGlovalPosition.xy, i.vertex.xy, _Slide))
            {
                fixed4 texColor = tex2D(_TexureSeta, i.uv);
                col.rgb = texColor.rgb;
                col.a = texColor.a;
            }

            // apply fog

            return col;
        }
        ENDCG
    }
    }
}
