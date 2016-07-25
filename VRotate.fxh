#define VROTATE_FXH

#if !defined(PI)
#define PI 3.14159265359
#endif

float4x4 VRotate(float rotX,
         float rotY,
         float rotZ)
  {
   rotX *= PI*2;
   rotY *= PI*2;
   rotZ *= PI*2;
   float sx = sin(rotX);
   float cx = cos(rotX);
   float sy = sin(rotY);
   float cy = cos(rotY);
   float sz = sin(rotZ);
   float cz = cos(rotZ);

   return float4x4( cz*cy+sz*sx*sy, sz*cx, cz*-sy+sz*sx*cy, 0,
                   -sz*cy+cz*sx*sy, cz*cx, sz*sy+cz*sx*cy , 0,
                    cx * sy       ,-sx   , cx * cy        , 0,
                    0             , 0    , 0              , 1);
  }
