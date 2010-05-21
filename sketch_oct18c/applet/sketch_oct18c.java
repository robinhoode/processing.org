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

public class sketch_oct18c extends PApplet {

 
PeasyCam cam;

ArrayList spheres = new ArrayList();

float sphereCount = 200;

public void setup() { 
  size(800, 600, P3D);
  
  noStroke();
  cam = new PeasyCam(this, width);

  for (int i = 0; i < sphereCount; i++)
    spheres.add(new GravSphere(10, new PVector(random(100), random(100), random(100)), 1));
}

public void draw() {
  background(15, 15, 15);
  noFill();  
  
  GravSphere mySphere;
  
  for (int i = 0; i < spheres.size(); i++) {  
    mySphere = (GravSphere) spheres.get(i);
    mySphere.drawLines();
    mySphere.gravitateTowards(new PVector(1, 1, 1), 1000);
    mySphere.update();  
  }
}
float maxAccel = 100;

class GravSphere extends Sphere {
  PVector last_pos;
  PVector vel;
  PVector accel;
  float mass;
  
  GravSphere(float radius, PVector initPos, float mass) {
    super(radius, initPos);
//    this.pos   = initPos;
    this.accel = new PVector(0, 0, 0);    
    this.mass  = mass;
  }
  
  public void gravitateTowards(PVector location, float mass) {    
    float delta_x = location.x - this.pos.x;
    float delta_y = location.y - this.pos.y;
    float delta_z = location.z - this.pos.z;
    
    float dist_sq = sq(delta_x) + sq(delta_y) + sq(delta_z);    
   
    float magAccel   = mass/sqrt(dist_sq);
    if (magAccel > maxAccel) magAccel = maxAccel;
    
    // r-hat is better than angle projection!
    this.accel.x += magAccel*(delta_x/sqrt(dist_sq));
    this.accel.y += magAccel*(delta_y/sqrt(dist_sq));
    this.accel.z += magAccel*(delta_z/sqrt(dist_sq));
  }
    
  public void update() {
    this.last_pos = new PVector(this.pos.x, this.pos.y, this.pos.z);
    this.pos = PVector.add(this.pos, this.accel);
    
    // WTF is this in terms of Physics? Maybe a drag coefficient?
    this.accel = PVector.mult(this.accel, 0.9f);
  }
}

class Sphere {
  float radius;
  PVector pos;
  
  Sphere(float radius, PVector pos) {
    this.radius = radius;
    this.pos    = pos;
  }
  
  public void drawLines() {
    int iters = 20;

    for (int i = 0; i < iters; i++) {
      float theta = TWO_PI*(i/PApplet.parseFloat(iters));
      beginShape();      
      for (int j = 0; j < iters; j++) {        
        float phi = TWO_PI*(j/PApplet.parseFloat(iters));
        stroke(0, 255, 0, 255);
        vertex(x(theta, phi), y(theta, phi), z(theta, phi));
      }
      endShape(CLOSE);          
    }
  }
  
  public float r(float phi) {
     return radius*cos(phi);
  }
  
  public float x(float theta, float phi) {
    return r(phi)*cos(theta) + this.pos.x;
  }
  
  public float y(float theta, float phi) {
    return r(phi)*sin(theta) + this.pos.y;
  }
  
  public float z(float theta, float phi) {
    return sin(phi)*radius + this.pos.z;
  }
}



  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#D4D0C8", "sketch_oct18c" });
  }
}
