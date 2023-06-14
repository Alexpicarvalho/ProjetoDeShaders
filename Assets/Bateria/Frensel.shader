Shader "Custom/Ex2"
{
    Properties
    {
       
        _VerticalLimite("Outline tickness", Range(-1,1)) = 0
        _MainTex("Main Texture", 2D) = "Default texture" {}
        // Base color used where Rim effect is not strong
		 _BaseColor ("Color", Color) = (1,1,1,1)
		// Color used where Rim effect is stronger
		_RimColor ("Rim Color", Color) = (0.0, 0.0, 0.0, 1.0)
		// Expoent used to make Rim effect sharper and thinner
		_RimColorPower ("Rim Color Power", Range(0,1)) = 0.1


        _CaosAmount("CaosAmount",Range(0,1)) = 0




    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200
        Blend SrcAlpha OneMinusSrcAlpha

        Pass {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
    

            #include "UnityCG.cginc"

            struct InputVertex {
                float4 pos    : POSITION;
                float2 uv    : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct OutputVertex { 
                float4 pos : SV_POSITION ;
                float2 uv : TEXCOORD0;
                float4 localPosition : TEXCOORD1;
                float3 normal : NORMAL;
                float4 Color : COLOR;
                float4 worldPos : TEXCOORD2;
            };  
            
            half4 _BaseColor;
            half4 _RimColor;
            float _RimColorPower;
            float _VerticalLimite;
            float _CaosAmount;
            sampler2D _MainTex;

            OutputVertex vert(InputVertex i) {
                OutputVertex o;
               
                float3 pos = i.pos.xyz;
                o.localPosition = i.pos ;
                o.uv = i.uv;
                o.normal = i.normal;
                o.Color = _BaseColor;
                o.pos = UnityObjectToClipPos(pos);
                o.worldPos = mul(unity_ObjectToWorld, pos);


                return o;
            
            }

             fixed4 frag(OutputVertex o) : SV_TARGET0 {
             
               
                    float3 viewDir = normalize(ObjSpaceViewDir ( o.localPosition));
                    float dotP = dot(viewDir, o.normal);
                    if (dotP < _VerticalLimite || dotP < _VerticalLimite) {
                        return _RimColor;
                    }
                    return tex2D(_MainTex, o.uv);
            }
            ENDCG      
        }      
    }
}