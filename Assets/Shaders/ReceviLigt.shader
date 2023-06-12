Shader "Custom/ReceviLigt"
{
    Properties
    {
        _Color("Color", Color) = (1,1,1,1)
        _VectorGlovalPosition ("PositioInTheWorld", Vector) = (0,0,0,0)
        _Slide("Slidetest",Range(0,10)) =0
        _TexureSeta ("display name", 2D) = "defaulttexture" {}
    }

    SubShader
    {
     Cull off
        CGPROGRAM
            #pragma surface surf Lambert alpha
            #include "Assets\Shaders\Biblieoteca\MyLibary.cginc"

        struct Input {
        float2 uv_TexureSeta;
        float3 worldPos;
        };

       float4 _Color;
       float4 _VectorGlovalPosition;
       float _Slide;
       sampler2D _TexureSeta;

       void surf(Input IN, inout SurfaceOutput o)
       {
           if (IsInsideCircle(_VectorGlovalPosition.xy, IN.worldPos.xy, _Slide))
           {
               fixed4 texColor = tex2D(_TexureSeta, IN.uv_TexureSeta);
               o.Emission = texColor.rgb;
               o.Alpha = texColor.a;
           }

           
           

          // o.Albedo = _Color.rgb;
           //o.Alpha *= _Color.a;
       }
       ENDCG
    }

        FallBack "Diffuse"
}
