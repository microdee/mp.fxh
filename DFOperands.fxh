#define DFOPERANDS_FXH

// simple operations
float U(float a, float b) {return min(a,b);}
float S(float a, float b) {return max(a,-b);}
float I(float a, float b) {return max(a,b);}

// smooth operations
float sU( float a, float b, float k )
{
    float h = clamp( 0.5+0.5*(b-a)/k, 0.0, 1.0 );
    return lerp( b, a, h ) - k*h*(1.0-h);
}
float sS( float a, float b, float k )
{
    return log( exp(a/k) + exp(-b/k) ) * k;
}
float sI( float a, float b, float k )
{
    return log( exp(a/k) + exp(b/k) ) * k;
}

float blend(float a, float b, uint s, float mass)
{
	float res = b;
	if(s==1) res = U(a,b);
	if(s==2) res = S(a,b);
	if(s==3) res = I(a,b);
	if(s==4) res = sU(a,b,mass);
	if(s==5) res = sS(a,b,mass/4);
	if(s==6) res = sI(a,b,mass/4);
	if(s==7) res = a;
	return res;
}
