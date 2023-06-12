Shader "Custom/WhiteLight"
{
    Properties
    {
        _Color("Color", Color) = (1,1,1,1)
        _EmissionColor("Emission Color", Color) = (1,1,1,1)
    }

    SubShader
    {
     Cull off
        CGPROGRAM
            #pragma surface surf Lambert alpha


        struct Input {
        float2 uvMainTex;
        float3 worldForward;
        };

        float4 _Color;
        float4 _EmissionColor;

        void surf(Input IN, inout SurfaceOutput o) {
            o.Emission = _EmissionColor.rgb * dot(IN.worldForward, o.Normal);
            o.Alpha=1;
           // o.Alpha = _Color.a;
        }

        ENDCG
    }
        FallBack "Diffuse"
}
