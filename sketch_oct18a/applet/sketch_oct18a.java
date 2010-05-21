import processing.core.*; 
import processing.xml.*; 

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

public class sketch_oct18a extends PApplet {

// TODO: Make maxAccel configurable by GUI
// TODO: Make mouse click mass configurable by GUI

float maxAccel = 50;

class GravParticle {
  PVector pos;
  PVector last_pos;
  PVector vel;
  PVector accel;
  float mass;
  
  GravParticle(float x_i, float y_i, float mass) {
    this.pos   = new PVector(x_i, y_i);
    this.accel = new PVector(0, 0);    
    this.mass  = mass;
  }
    
  public void gravitateTowards(GravParticle other) {
    float delta_x = other.pos.x - this.pos.x;
    float delta_y = other.pos.y - this.pos.y;
    float dist_sq = sq(delta_x) + sq(delta_y);
    
   
    float magAccel   = other.mass/sqrt(dist_sq);
    if (magAccel > maxAccel) magAccel = maxAccel;
    
    float angleAccel = atan(delta_y / delta_x);
    

    this.accel.x += magAccel*(delta_x/sqrt(dist_sq));
    this.accel.y += magAccel*(delta_y/sqrt(dist_sq));      
  }
  
  public void update() {
    this.last_pos = new PVector(this.pos.x, this.pos.y);
    this.pos.x += this.accel.x;
    this.pos.y += this.accel.y;
    this.accel.x *= 0.9f;
    this.accel.y *= 0.9f;
  }
  
  public void drawPoint() {
    float distance = sq(accel.x)+sq(accel.y);
    float myColor = 255*(distance/maxAccel) + 100;
          
    
    stroke(0, myColor, 0);
    fill(0, myColor, 0);    
    
    //point(this.pos.x, this.pos.y); 
    line(this.pos.x, this.pos.y, this.last_pos.x, this.last_pos.y);
    //ellipse(this.pos.x, this.pos.y, abs(this.pos.x - this.last_pos.x)+2, abs(this.pos.y - this.last_pos.y)+2);
  }
}

ArrayList particles = new ArrayList();

float framerate = 60; // frames per second

public void setup() {
  frameRate(framerate);
  size(1000,800,P2D);
  
  for (int i = 0; i < 10000; i++) {
    GravParticle particle = new GravParticle(random(width), random(height), 1);
    particles.add(particle);
  }
}

public void draw() {
  background(15,15,15);
  
  for (int i = 0; i < particles.size(); i++) {
    if (particles.get(i) != null) {
      GravParticle currParticle = (GravParticle) particles.get(i);
      if (mousePressed) {
        GravParticle newParticle  = new GravParticle(mouseX, mouseY, 100);
        currParticle.gravitateTowards(newParticle);
      }
      currParticle.update(); 
      currParticle.drawPoint();
    }
  }
}


  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#D4D0C8", "sketch_oct18a" });
  }
}
