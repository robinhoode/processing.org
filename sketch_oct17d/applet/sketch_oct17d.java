import processing.core.*; 
import processing.xml.*; 

import peasy.*; 

import java.applet.*; 
import java.awt.*; 
import java.awt.image.*; 
import java.awt.event.*; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class sketch_oct17d extends PApplet {

 
PeasyCam cam;

public void setup() { 
  size(800, 600, P3D);
  
  noStroke();
  cam = new PeasyCam(this, width);
}

class CircleXY extends Circle {  
  CircleXY(float radius, float iters, float angle, float displace) {
    super(radius, iters, angle, displace);    
  }
  
  public float x(float t) {
    return radius*cos(t) + displace;    
  }
  
  public float y(float t) {
    return (radius*sin(t) + displace)*cos(angle);    
  }
  
  public float z(float t) {
    return (radius*sin(t) + displace)*sin(angle);    
  }
}

class CircleYZ extends Circle {
  CircleYZ(float radius, float iters, float angle, float displace) {
    super(radius, iters, angle, displace);    
  }
  
  public float x(float t) {
    return displace + radius*sin(angle);
  }
  
  public float y(float t) {
    float r = displace + radius*(-cos(angle));
    return r*cos(t);
  }
  
  public float z(float t) {
    float r = displace + radius*(-cos(angle));
    return r*sin(t);    
  }
}

public void draw() {
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




class Circle {
  float radius;
  float iters;
  float angle;
  float displace;  
  
  Circle(float radius, float iters, float angle, float displace) {
    this.radius   = radius;
    this.iters    = iters;
    this.angle    = angle;
    this.displace = displace;
  }
  
  public float x(float t) { return 0; }
  public float y(float t) { return 0; }
  public float z(float t) { return 0; }  
  
  public void lineStroke(float t) {
//    if (i % 25 == 0) {
      stroke(0, 255, 0, 100);
//    } else {
//      stroke(0, 255, 0, 100);
//    }            
  }
    
  public void drawShape() {    
    noFill();    
    beginShape();
    PVector[] points = pointDecompose((int) iters);    
    for (int i = 0; i < points.length; i++) {
      lineStroke(i);
      vertex(points[i].x, points[i].y, points[i].z);
    }
    endShape(CLOSE);     
  }
  
  public void drawPoints() {
    PVector[] points = pointDecompose((int) iters);
    pushMatrix();
    for (int i = 0; i < points.length; i++) {
      if (i % 10 == 0) {
        stroke(0, 255, 0, 255);
        point(points[i].x, points[i].y, points[i].z);
      }
    }
    popMatrix();
  }
  
  public PVector[] pointDecompose(int count) {
    PVector[] points = new PVector[count];
    for (int i = 0; i < count; i++) {
      float t = TWO_PI*(i/PApplet.parseFloat(count));
      points[i] = new PVector(x(t), y(t), z(t));
    }
    return points;
  }
}

  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#D4D0C8", "sketch_oct17d" });
  }
}
