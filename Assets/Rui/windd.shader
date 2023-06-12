Shader "Custom/windd" {
    Properties
    {
        _MainTex("Main Texture", 2D) = "white" {}
        _WindStrength("Wind Strength", Range(0, 1)) = 0.5
        _WindSpeed("Wind Speed", Range(0, 10)) = 1
        _WindFrequency("Wind Frequency", Range(0, 10)) = 1
        _Cutoff("Alpha Cutoff", Range(0, 1)) = 0.5
    }
        SubShader{
            Tags { "Queue" = "Transparent" "RenderType" = "Transparent" }
            Blend SrcAlpha OneMinusSrcAlpha

            CGPROGRAM
            #pragma surface surf Lambert vertex:vert addshadow

            sampler2D _MainTex;
            float _WindStrength;
            float _WindSpeed;
            float _WindFrequency;
            float _Cutoff;

            struct Input {
                float2 uv_MainTex;
            };

            void vert(inout appdata_full v, out Input o) {
                float4 worldPos = mul(unity_ObjectToWorld, v.vertex);                                          //passa par ao sin para tornar um movimentoo "tras para a frente"
                float2 windOffset = sin(worldPos.xz * _WindFrequency + _Time.y * _WindSpeed) * _WindStrength; //multiplica pela força para controlar o quantoo se mexem os vertices
                v.vertex.xyz += float3(windOffset.x, windOffset.y, 0); //adiciona ooffset á posicao dos vertices e o winfrequency controola a frequencia da influencia do worldpos na variacao do offset
                o.uv_MainTex = v.texcoord;                              //windspeed controla oo quao rapido os vertices se movem
            }

            void surf(Input IN, inout SurfaceOutput o) {
                fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
                clip(c.a - _Cutoff); //adicionei oo cutoff para cortar ppartes das "folhas" ou ficava demasiado extendido
                o.Albedo = c.rgb;
                o.Alpha = c.a;
            }
            ENDCG
        }
            FallBack "Diffuse"
}
