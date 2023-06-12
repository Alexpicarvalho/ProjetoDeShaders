Shader "Olhos2" {
   Properties {
      _MainTex ("Texture Image", 2D) = "white" {}
      _ScaleX ("Scale X", Float) = 1.0
      _ScaleY ("Scale Y", Float) = 1.0
   }
   SubShader {
      Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
      ZWrite Off
      Blend SrcAlpha OneMinusSrcAlpha

      Pass {   
         CGPROGRAM

         #pragma vertex vert  
         #pragma fragment frag
         #include "UnityCG.cginc"
         // User-specified uniforms            
         uniform sampler2D _MainTex;        
         uniform float _ScaleX;
         uniform float _ScaleY;

         struct vertexInput {
            float4 vertex : POSITION;
            float3 normal : NORMAL;
            float4 tangent : TANGENT;
            float2 tex : TEXCOORD0;
         };

         struct vertexOutput {
            float4 pos : SV_POSITION;
            float2 tex : TEXCOORD0;
            float3 viewDir : TEXCOORD1;
         };

         vertexOutput vert(vertexInput input) 
         {
            vertexOutput output;

            float3 normalWS = UnityObjectToWorldNormal(input.normal);
            float3 tangentWS = UnityObjectToWorldDir(input.tangent);
            float tangentSign = input.tangent.w * unity_WorldTransformParams.w;
            float3 viewDir = normalize(_WorldSpaceCameraPos.xyz - mul(unity_ObjectToWorld, input.vertex).xyz);


            float3 bitangentWS = cross(normalWS, tangentWS) * tangentSign;
            output.viewDir = float3(
                dot(viewDir, tangentWS),
                dot(viewDir, bitangentWS),
                dot(viewDir, normalWS)
            );

             output.tex = input.tex;
            output.pos = UnityObjectToClipPos(input.vertex);
     
            return output;
         }

         float4 frag(vertexOutput input) : SV_TARGET
         {       
            return tex2D(_MainTex, input.tex / 2 - input.viewDir.xy);   

         }

         ENDCG
      }
   }
}