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


         
        float3 rotGeral(float3 pontoEntradaGeral, float yaw, float pitch, float roll){
            
            
        yaw = (yaw*3.14)/180;
        pitch = (pitch*3.14)/180;
        roll = (roll*3.14)/180;
        float3x3 matrizGeral = {cos(yaw) * cos(pitch), cos(yaw) * sin(pitch) * sin(roll) - sin(yaw) * cos(roll), cos(yaw) * sin(pitch) * cos(roll) + sin(yaw) * sin(roll),
                                sin(yaw) * cos(pitch), sin(yaw) * sin(pitch) * sin(roll) + cos(yaw) * cos(roll), sin(yaw) * sin(pitch) * cos(roll) - cos(yaw) * sin(roll),
                                -sin(pitch), cos(pitch) * sin(roll), cos(pitch) * cos(roll)
                            };
        return mul(matrizGeral, pontoEntradaGeral);
            
        }


        float4x4 lookAt(float3 eye, float3 at, float3 up)
        {
          float3 zaxis = normalize(at - eye);    
          float3 xaxis = normalize(cross(zaxis, up));
          float3 yaxis = cross(zaxis, xaxis);

          

          float4x4 viewMatrix = {
            float4(xaxis.x, xaxis.y, xaxis.z, dot(xaxis, eye)),
            float4(yaxis.x, yaxis.y, yaxis.z, dot(yaxis, eye)),
            float4(zaxis.x, zaxis.y, zaxis.z, dot(zaxis, eye)),
            float4(0, 0, 0, 1)
          };

          return viewMatrix;
        }



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

            output.pos = UnityObjectToClipPos(input.vertex);
     


             //output.pos = UnityObjectToClipPos(mul(lookAt(input.vertex.xyz, mul(unity_WorldToObject, _WorldSpaceCameraPos), float3(0,1,0)), input.vertex)) ;
             output.tex = input.tex;
            //output.pos = UnityObjectToClipPos(rotGeral(input.vertex.xyz, viewDir.z - input.vertex.x ,  viewDir.y- input.vertex.y ,  viewDir.z- input.vertex.z));
       

           
          

            return output;
         }

         float4 frag(vertexOutput input) : SV_TARGET
         {

            
            return tex2D(_MainTex, input.tex / 2 - input.viewDir.xy);   
            //return (1,1,1,1);

         }

         ENDCG
      }
   }
}