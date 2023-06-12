
float3 Black() {
	return float4 (0,0,0,0);
}

bool DrawSquare(float2 center,float lado,float2 ponto){
	if(ponto.x> center.x-lado && ponto.x<center.x+lado && ponto.y>center.y-lado && ponto.y<center.y+lado ) return true;

	return false;
}

bool IsInsideCircle(float2 pointTest,float2 center, float radius) {
	float distance = sqrt(pow(pointTest.x - center.x,2)+ pow(pointTest.y - center.y,2));
	return (distance <= radius);
}


