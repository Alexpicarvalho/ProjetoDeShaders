Shader "Unlit/FlashLight"
{
    Properties
    {
        _Color("Color", Color) = (1, 1, 1, 1)
        _VectorGlovalPosition("PositioInTheWorld", Vector) = (0, 0, 0, 0)
        _Slide("Slidetest", Range(0, 10)) = 0
        _MainTex("display name", 2D) = "defaulttexture" {}
    }

        SubShader
    {
        Tags { "RenderType" = "Transparent" 
                "Queue" = "Transparent"}
        LOD 100

        Pass
        {
            // SrcAlpha alfa da cor do resultado final
            // OneMinus... é 1 - alpha do sharde
            Blend SrcAlpha OneMinusSrcAlpha
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
                float4 worldSpacePositionShaders : TEXCOORD1;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _Color;
            float4 _VectorGlovalPosition;
            float _Slide;
            

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.worldSpacePositionShaders = mul(unity_ObjectToWorld, v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col;

            // apply flashlight effect
            if (IsInsideCircle(_VectorGlovalPosition.xy, i.worldSpacePositionShaders.xy, _Slide))
            {
                fixed4 texColor = tex2D(_MainTex, i.uv);
                col.rgb = texColor.rgb;
                col.a = texColor.a;
            }
            else col = fixed4(0, 0, 0, 0);

            

            return col;
        }
        ENDCG
    }
    }
}
