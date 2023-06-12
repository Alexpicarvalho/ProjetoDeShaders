Shader "Custom/ReceviLigt"
{
    Properties
    {
        _Color("Color", Color) = (1,1,1,1)
        _VectorGlovalPosition ("display name", Vector) = (0,0,0,0)
        _Slide("Slidetest",Range(0,3)) =0
        _TexureSeta ("display name", 2D) = "defaulttexture" {}
    }

    SubShader
    {
     Cull off
        CGPROGRAM
            #pragma surface surf Lambert 
            #include "Assets\Script\Shardes\Biblieoteca\MyLibary.cginc"

        struct Input {
        float2 uv_TexureSeta;
        float3 worldPos;
        };

       float4 _Color;
       float4 _VectorGlovalPosition;
       float _Slide;
       sampler2D _TexureSeta;

        void surf(Input IN, inout SurfaceOutput o) {
       if( IsInsideCircle(_VectorGlovalPosition.xy,IN.worldPos.xy,_Slide)) o.Emission= tex2D(_TexureSeta,IN.uv_TexureSeta);
      // o.Albedo = Black();
        }
        
        ENDCG
    }
        FallBack "Diffuse"
}
