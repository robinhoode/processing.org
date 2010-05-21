
class Grav3DParticle {
  PVector pos;
  PVector last_pos;
  PVector vel;
  PVector accel;
  float mass;
  
  Grav3DParticle(float x_i, float y_i, float z_i, float mass) {
    this.pos   = new PVector(x_i, y_i, z_i);
    this.accel = new PVector(0, 0);    
    this.mass  = mass;
  }
    
  void gravitateTowards(Grav3DParticle other) {
    float delta_x = other.pos.x - this.pos.x;
    float delta_y = other.pos.y - this.pos.y;
    float delta_z = other.pos.z - this.pos.z;
    
    float dist_sq = sq(delta_x) + sq(delta_y) + sq(delta_z);    
   
    float magAccel   = other.mass/sqrt(dist_sq);
    if (magAccel > maxAccel) magAccel = maxAccel;
    
    // r-hat is better than angle projection!
    this.accel.x += magAccel*(delta_x/sqrt(dist_sq));
    this.accel.y += magAccel*(delta_y/sqrt(dist_sq));
    this.accel.z += magAccel*(delta_z/sqrt(dist_sq));
  }
  
  void update() {
    this.last_pos = new PVector(this.pos.x, this.pos.y, this.pos.z);
    this.pos.x += this.accel.x;
    this.pos.y += this.accel.y;
    this.pos.z += this.accel.z;
    
    // WTF is this in terms of Physics? Maybe a drag coefficient?
    this.accel.x *= 0.9;
    this.accel.y *= 0.9;
    this.accel.z *= 0.9;
  }
  
  void drawPoint() {
    float distance = sq(accel.x)+sq(accel.y);
    float myColor = 255*(distance/maxAccel) + 100;          
    
    stroke(0, myColor, 0);
    fill(0, myColor, 0);    
    
    point(this.pos.x, this.pos.y, this.pos.z); 
    // sphere(this.pos.x, this.pos.y, this.pos.z);
    // line(this.pos.x, this.pos.y, this.last_pos.x, this.last_pos.y);
    //ellipse(this.pos.x, this.pos.y, abs(this.pos.x - this.last_pos.x)+2, abs(this.pos.y - this.last_pos.y)+2);
  }
}


ArrayList particles = new ArrayList();

float framerate = 60; // frames per second
float initialBoundBox = 200;
float particleCount   = 10000;
float maxAccel        = 50;

import peasy.*; 
PeasyCam cam;


void setup() {
  frameRate(framerate);
  size(1000,800,P3D);
  cam = new PeasyCam(this, width);
  
  for (int i = 0; i < particleCount; i++) {
    Grav3DParticle particle = new Grav3DParticle(random(initialBoundBox), random(initialBoundBox), random(initialBoundBox), 1);
    particles.add(particle);
  }
}

void draw() {
  background(15,15,15);
  
  for (int i = 0; i < particles.size(); i++) {
    if (particles.get(i) != null) {
      Grav3DParticle currParticle = (Grav3DParticle) particles.get(i);
      
      //if (mousePressed) {
        
      Grav3DParticle particle = new Grav3DParticle(50, 50, 50, 100);        
        
//      GravParticle newParticle  = new GravParticle(mouseX, mouseY, 100);
      currParticle.gravitateTowards(particle);
      
      
//      }
//      */
      currParticle.update(); 
      currParticle.drawPoint();
    }
  }
}

