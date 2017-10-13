#if !defined(INTERSECTIONS_FXH)
#define INTERSECTIONS_FXH 1
#define EPSILON 0.0000001
bool Segment_TriangleMT(float3 sstart, float3 sstop, float3 tri0, float3 tri1, float3 tri2, out float3 intspoint)
{
	intspoint = 0;
    float3 rayOrigin =  sstart;
    float3 ray = (sstop - sstart); 
    float3 vertex0 = tri0;
    float3 vertex1 = tri1;  
    float3 vertex2 = tri2;
    float3 edge1, edge2, h, s, q;
    float a,f,u,v;
    edge1 = vertex1 - vertex0;
    edge2 = vertex2 - vertex0;
    h = cross(ray, edge2);
    a = dot(edge1,h);
    if (a > -EPSILON && a < EPSILON)
        return false;
    f = 1/a;
    s = rayOrigin - vertex0;
    u = f * (dot(s, h));
    if (u < 0.0 || u > 1.0)
        return false;
    q = cross(s, edge1);
    v = f * dot(ray, q);
    if (v < 0.0 || u + v > 1.0)
        return false;
    // At this stage we can compute t to find out where the intersection point is on the line.
    float t = f * dot(edge2, q);
    if (t > EPSILON) // ray intersection
    {
        intspoint = rayOrigin + (normalize(ray) * (t * length(ray)));
        return true;
    }
    else // This means that there is a line intersection but not a ray intersection.
        return false;
}
bool Segment_TriangleMP(float3 sstart, float3 sstop, float3 tri0, float3 tri1, float3 tri2, out float3 intspoint)
{
	float3 raypos=sstart;
	float3 raydir=normalize(sstop-sstart);
	float3 diff = raypos - tri0;
	float3 faceEdgeA = tri1 - tri0;
    float3 faceEdgeB = tri2 - tri0;
    
	float3 norm = cross(faceEdgeB, faceEdgeA);
	//norm = normalize(norm);
	
	//Ray/Triangle intersection, from 
	// www.geometrictools.com
	
	float DdN = dot(raydir,norm);
    float fsign;
	bool hit = true;
	
    if (DdN > EPSILON)
    {
        fsign = 1.0f;
    }
    else if (EPSILON)
    {
        fsign = -1.0;
        DdN = -DdN;
    }
    else
    {
        hit = false;
    }
	
	
	if (hit)
	{
		hit = false;
		float DdQxE2 = fsign*dot(raydir, cross(faceEdgeB,diff));
		if (DdQxE2 >= 0.0f)
	    {
	    	float DdE1xQ = fsign*dot(raydir,cross(diff,faceEdgeA)); 
	        if (DdE1xQ >= 0.0f)
	        {
	            if (DdQxE2 + DdE1xQ <= DdN)
	            {	
	            // Line intersects triangle, check if ray does.
	                float QdN = -fsign* dot(diff,norm);
	                if (QdN >= 0.0f)
	                {
	                    float inv = 1/DdN;
                    	float dickface = QdN*inv;
	                	intspoint = raypos + dickface * raydir;
	                	hit = true;
	                }
	            }
	        }
	    }
	}
	return hit;
}
//    Return: -1 = triangle is degenerate (a segment or point)
//             0 =  disjoint (no intersect)
//             1 =  intersect in unique point I1
//             2 =  are in the same plane
int Segment_TriangleSS(float3 sstart, float3 sstop, float3 tri0, float3 tri1, float3 tri2, out float3 intspoint)
{
    float3    u, v, n;              // triangle float3s
    float3    dir, w0, w;           // ray float3s
    float     r, a, b;              // params to calc ray-plane intersect

    // get triangle edge float3s and plane normal
    u = tri1 - tri0;
    v = tri2 - tri0;
    n = cross(u, v);              // cross product
    if (any(n == (float3)0))             // triangle is degenerate
        return -1;                  // do not deal with this case

    dir = sstop - sstart;              // ray direction float3
    w0 = sstart - tri0;
    a = -dot(n,w0);
    b = dot(n,dir);
    if (abs(b) < EPSILON) {     // ray is  parallel to triangle plane
        if (a == 0)                 // ray lies in triangle plane
            return 2;
        else return 0;              // ray disjoint from plane
    }

    // get intersect point of ray with triangle plane
    r = a / b;
    if (r < 0.0)                    // ray goes away from triangle
        return 0;                   // => no intersect
    // for a segment, also test if (r > 1.0) => no intersect

    intspoint = sstart + r * dir;            // intersect point of ray and plane

    // is I inside T?
    float    uu, uv, vv, wu, wv, D;
    uu = dot(u,u);
    uv = dot(u,v);
    vv = dot(v,v);
    w = intspoint - tri0;
    wu = dot(w,u);
    wv = dot(w,v);
    D = uv * uv - uu * vv;

    // get and test parametric coords
    float s, t;
    s = (uv * wv - vv * wu) / D;
    if (s < 0.0 || s > 1.0)         // I is outside T
        return 0;
    t = (uv * wu - uu * wv) / D;
    if (t < 0.0 || (s + t) > 1.0)  // I is outside T
        return 0;

    return 1;                       // I is in T
}

#endif