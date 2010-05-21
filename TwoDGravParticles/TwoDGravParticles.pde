// TODO: Make maxAccel configurable by GUI
// TODO: Make mouse click mass configurable by GUI

import processing.opengl.*;

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
    
  void gravitateTowards(GravParticle other) {
    PVector delta = PVector.sub(other.pos, this.pos);
    float dist_sq = sq(delta.x) + sq(delta.y);
   
//    float magAccel   = other.mass/sqrt(dist_sq);
    float magAccel   = other.mass/pow(dist_sq, 1/4);
    if (magAccel > maxAccel) magAccel = maxAccel;

    
    this.accel.x += magAccel*(delta.x/sqrt(dist_sq));
    this.accel.y += magAccel*(delta.y/sqrt(dist_sq));      
  }
  
  void update() {
    this.last_pos = new PVector(this.pos.x, this.pos.y);
    this.pos.add(this.accel);
    this.accel.mult(0.9);
  }
  
  void drawPoint() {
    // float distance = sq(accel.x)+sq(accel.y);
    
    float distance = PVector.sub(new PVector(mouseX, mouseY), this.pos).mag();
    
//  float myColor = 255*(25/distance);

    float myColor = 255/(25/distance+1);
    
    stroke(0, myColor, 0);
    fill(0, myColor, 0, 255);    
    
    //point(this.pos.x, this.pos.y); 
    line(this.pos.x, this.pos.y, this.last_pos.x, this.last_pos.y);
    //ellipse(this.pos.x, this.pos.y, abs(this.pos.x - this.last_pos.x)+2, abs(this.pos.y - this.last_pos.y)+2);
  }
}

ArrayList particles = new ArrayList();

float framerate = 60; // frames per second

void setup() {
  frameRate(framerate);
  size(800,600, OPENGL);
  
  for (int i = 0; i < 2000; i++) {
    GravParticle particle = new GravParticle(random(width), random(height), 1);
    particles.add(particle);
  }
}

void draw() {
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

