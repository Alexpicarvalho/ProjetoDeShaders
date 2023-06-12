Shader "custom/Olhos"
{
	Properties
	{
		_MainTex ("Main Tex", 2D) = "default texture" {}
		_PupilTex ("Pupil Tex", 2D) = "InsideTex" {}
		_PupilSize ("Pupil Size", Range(0.01, 0.5)) = 0.1
		 _RotationSpeed ("Rotation Speed", Range(0.1, 10)) = 1
	}

	SubShader
	{
		CGPROGRAM

		#pragma surface surf Lambert 

		struct Input
		{
			float3 localPos;
			float3 worldPos;
			float3 viewDir;
			float2 uv_MainTex;
			float2 uv_PupilTex;
		};
		sampler2D _MainTex;
		sampler2D _PupilTex;
		float _RotationSpeed;
		float _PupilSize;

		void surf(Input IN, inout SurfaceOutput o)
		{
			//float dotP = dot(IN.viewDir, IN.uv_MainTex);
			
			//float2 uv = UnityObjectToClip
			//float2 uv = IN.uv_MainTex - float2(0.5,0.5);
			half2 viewDir = normalize(UnityObjectToClipPos(IN.viewDir))	;




			normalize(IN.viewDir);
			o.Albedo = tex2D(_MainTex, viewDir + IN.uv_MainTex);
			

		}

		ENDCG
	}

	FallBack "Diffuse"
}
