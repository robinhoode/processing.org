import processing.opengl.*;
import peasy.*;
PeasyCam cam;

void setup() { 
  size(800, 600, OPENGL);
  
  noStroke();
  cam = new PeasyCam(this, width);
}

class Sphere {
  float radius;
  
  Sphere(float radius) {
    this.radius = radius;
  }
  
  void drawPoints() {
    int iters = 100;
    pushMatrix();
    for (int i = 0; i < iters; i++) {
      float theta = TWO_PI*(i/float(iters));
      for (int j = 0; j < iters; j++) {
        float phi = TWO_PI*(j/float(iters));
        stroke(0, 255, 0, 255);
        point(x(theta, phi), y(theta, phi), z(theta, phi));
      }
    }
    popMatrix();
  }
  
  void drawLines() {
    int iters = 100;
    beginShape();
    for (int i = 0; i < iters; i++) {
      float theta = TWO_PI*(i/float(iters));
      for (int j = 0; j < iters; j++) {
        float phi = TWO_PI*(j/float(iters));
        stroke(0, 255, 0, 255);
        vertex(x(theta, phi), y(theta, phi), z(theta, phi));
      }
    }
    endShape();    
  }
  
  float r(float phi) {
     return radius*cos(phi); 
  }
  
  float x(float theta, float phi) {
    return r(phi)*cos(theta);
  }
  
  float y(float theta, float phi) {
    return r(phi)*sin(theta);
  }
  
  float z(float theta, float phi) {
    return sin(phi)*radius;
  }
}


class GradientSphere extends Sphere {
  float radius;
  float alph;
  
  GradientSphere(float radius, float alph) {
    super(radius);
    this.alph   = alph;
  }
  
  void drawPoints() {
    
    int iters = 100;
    pushMatrix();
    for (int i = 0; i < iters; i++) {
      float theta = TWO_PI*(i/float(iters));
      for (int j = 0; j < iters; j++) {
        float phi = TWO_PI*(j/float(iters));
        stroke(0, alph, 0, alph);        
        point(x(theta, phi), y(theta, phi), z(theta, phi));
      }
    }
    popMatrix();
    
  }  
}

class Cylinder {
  float radius;
  float maxHeight;
  float currHeight;
  
  Cylinder(float radius, float maxHeight) {
    this.radius    = radius;
    this.maxHeight = maxHeight;
  }
    
  void drawPoints() {
    int iters = 100;
    pushMatrix();
    for (int i = 0; i < iters; i++) {
      this.currHeight = maxHeight*(i/float(iters));
      for (int j = 0; j < iters; j++) {
        float t = TWO_PI*(j/float(iters));
        stroke(0, 255, 0, 255);
        point(x(t),y(t),z(t));
      }
    }
    popMatrix();
  }
  
  float x(float t) {  
    return radius*cos(t);
  }
  
  float y(float t) {
    return radius*sin(t);
  }
  
  float z(float t) {
    return currHeight;
  }  
}


void draw() {
  background(15, 15, 15);   

//  Cylinder cylinder = new Cylinder(20, 100);
//  cylinder.drawPoints();

  GradientSphere mySphere;

  int maxRadius = 20;
  int maxAlpha  = 255;
  float iters = 5;
  for (int i = 0; i < iters; i++) {
    float r = maxRadius*(i/iters);
    float a = maxAlpha*(i/iters);
    mySphere = new GradientSphere(r, a);
    mySphere.drawPoints();
  }
  
  /*
  point(0,0,0);
  stroke(0, 255, 0, 250);
  point(1,0,0);  
  point(0,1,0);
  */
}
