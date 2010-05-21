import peasy.*; 
import processing.opengl.*;

PeasyCam cam;

void setup() { 
  size(800, 600, OPENGL);
  
  noStroke();
  cam = new PeasyCam(this, width);
}

class CircleXY extends Circle {  
  CircleXY(float radius, float iters, float angle, float displace) {
    super(radius, iters, angle, displace);    
  }
  
  float x(float t) {
    return radius*cos(t) + displace;    
  }
  
  float y(float t) {
    return (radius*sin(t) + displace)*cos(angle);    
  }
  
  float z(float t) {
    return (radius*sin(t) + displace)*sin(angle);    
  }
}

class CircleYZ extends Circle {
  CircleYZ(float radius, float iters, float angle, float displace) {
    super(radius, iters, angle, displace);    
  }
  
  float x(float t) {
    return displace + radius*sin(angle);
  }
  
  float y(float t) {
    float r = displace + radius*(-cos(angle));
    return r*cos(t);
  }
  
  float z(float t) {
    float r = displace + radius*(-cos(angle));
    return r*sin(t);    
  }
}

void draw() {
  background(15, 15, 15);   
  
  float radius = 6;
  float displacement = 20;
  float circleIterations = 360;
  
  CircleXY circle;
  float iters = 36;
  for (int i = 0; i < iters; i++) {
    circle = new CircleXY(radius, circleIterations, TWO_PI*(i/iters), displacement);
    circle.drawShape();
    circle.drawPoints();
  }  
  
  CircleYZ circle2;
  for (int i = 0; i < iters; i++) {
    circle2 = new CircleYZ(radius, circleIterations, TWO_PI*(i/iters), displacement);
    circle2.drawShape();
  }
}



