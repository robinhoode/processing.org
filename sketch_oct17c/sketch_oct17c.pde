import peasy.*; 
PeasyCam cam;

void setup() { 
  size(800, 600, P3D);
  
  noStroke();
  cam = new PeasyCam(this, width);
}

int pointCount = 100;

/*
class Torus {
  float tubeRadius;
  float centerRadius;
  
  PVector[] points;
  
  Torus(float tubeRadius, centerRadius) {
    this.points       = new PVector[pointCount];
    this.tubeRadius   = tubeRadius; 
    this.centerRadius = centerRadius;
    build();
  }
  
  void build() {
    for (int i = 0; i < pointCount; i++) {
      for (int j = 0; j < pointCount; j++) {
        PVector[]
      }
    }
  }
}
*/

class Circle {
  float h;
  float k;
  float r;
  float z;
  float iters;  
  
  Circle(float h, float k, float r, float z, float iters) {
    this.h = h;
    this.k = k;
    this.r = r;
    this.z = z;
    this.iters = iters;
  }
  
  void draw() {
    noFill();          
    stroke(0,255,0);
    beginShape();  
    for (int i = 1; i < iters; i++) {
      float t = 2*PI*(i/iters);
      float x = r*cos(t);
      float y = r*sin(t);
      vertex(x, y, 0);
    }
    endShape(CLOSE);    
  }
}

class Sphere {
  float h;
  float k;
  float r;
  float z;
  float iters;
  float rings;
  
  Sphere(float h, float k, float r, float z, float iters, float rings) {
    this.h = h;
    this.k = k;
    this.r = r;
    this.z = z;
    this.iters = iters;
    this.rings = rings;    
  }
  
  void draw() {
    Circle circle = new Circle(h, k, r, z, iters);
    for (int i = 0; i < rings; i++) {
      circle.draw();
      rotateY(2*PI*(i/rings));
    }
  }
}


void draw() {
  background(15, 15, 15);   
  
  Sphere mySphere = new Sphere(30, 30, 5, 0, 100, 100);
  mySphere.draw();  
}
