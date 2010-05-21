
class Sphere {
  float radius;
  PVector pos;
  
  Sphere(float radius, PVector pos) {
    this.radius = radius;
    this.pos    = pos;
  }
  
  void drawLines() {
    int iters = 20;

    for (int i = 0; i < iters; i++) {
      float theta = TWO_PI*(i/float(iters));
      beginShape();      
      for (int j = 0; j < iters; j++) {        
        float phi = TWO_PI*(j/float(iters));
        stroke(0, 255, 0, 255);
        vertex(x(theta, phi), y(theta, phi), z(theta, phi));
      }
      endShape(CLOSE);          
    }
  }
  
  float r(float phi) {
     return radius*cos(phi);
  }
  
  float x(float theta, float phi) {
    return r(phi)*cos(theta) + this.pos.x;
  }
  
  float y(float theta, float phi) {
    return r(phi)*sin(theta) + this.pos.y;
  }
  
  float z(float theta, float phi) {
    return sin(phi)*radius + this.pos.z;
  }
}


