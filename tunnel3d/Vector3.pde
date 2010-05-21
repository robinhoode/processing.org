//------------------------------------------------------------
// vector3
//------------------------------------------------------------

class vector3
{
  float x, y, z;
  
  vector3()
  {
    this.x = 0.0;
    this.y = 0.0;
    this.z = 0.0;
  }
  
   vector3( float _x, float _y, float _z )
  {
    x = _x;
    y = _y;
    z = _z;
  }

  void set(vector3 v)
  {
    x = v.x;
    y = v.y;
    z = v.z;
  }
      
 void norm()
  {
    float n = sqrt(x*x + y*y + z*z);
    this.x /= n;
    this.y /= n;
    this.z /= n;
  }
  
 void zero()
  {
    x = 0.0;
    y = 0.0;
    z = 0.0; 
  }
}

vector3 cross(vector3 a, vector3 b)
  {
        vector3 result = new vector3();
	result.x = a.y*b.z - a.z*b.y;
	result.y = a.z*b.x - a.x*b.z;
	result.z = a.x*b.y - a.y*b.x; 

      return result;
  }
