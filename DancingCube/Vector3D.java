
class Vector3D {
  double x, y, z;
  
  Vector3D() {
    this.x = this.y = this.z = 0;
  }
  
  Vector3D(double x, double y, double z) {
    this.x = x; this.y = y; this.z = z;
  }
  
  static Vector3D add(Vector3D self, Vector3D other) {
    return new Vector3D(self.x + other.x, self.y + other.y, self.z + other.z);
  }

  static Vector3D sub(Vector3D self, Vector3D other) {
    return new Vector3D(self.x - other.x, self.y - other.y, self.z - other.z);
  }
  
  static Vector3D mult(Vector3D self, float scalar) {
    return new Vector3D(self.x * scalar, self.y * scalar, self.y * scalar);
  }
}
