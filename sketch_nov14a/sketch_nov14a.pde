
float framerate = 60;

void setup() {
  frameRate(framerate);
  size(1000, 800, P2D);
}

class Particle {
  PVector pos;
  PVector accel;
  
  Particle(PVector pos, PVector accel) {
    this.pos   = pos;
    this.accel = accel;
  }
  
  void update() {
    this.pos.add(this.accel);
    this.accel.mult(0.95);    
  }
  
  void draw() {
    ellipse(this.pos.x, this.pos.y, 10, 10);
  }
  
  boolean isDead() {
    return (this.accel.mag() < 0.5);
  }
}

// Produce x angles that sum to 360
float[] anglesThatSumTo360(int x) {
  float[] angles = new float[x];
  int i = 0, sum = 0;
  
  while (angles.length < x-1) {    
    float currentAngle = random(0, 90);
    if (sum + currentAngle < 360) {
      sum += currentAngle;
      angles[i] = currentAngle;
      i += 1;
    }
  }
  
  angles[i] = 360 - sum;
  return angles;
}

ArrayList particles = new ArrayList();


int PARTICLE_COUNT = 8;

void createExplosion(int x, int y) {
  for (int i = 0; i < PARTICLE_COUNT; i++) {
    int magnitude = 30;
    float angle = random(0, 90);
    PVector accel = new PVector(magnitude*cos(angle), magnitude*sin(angle));
    PVector pos   = new PVector(mouseX, mouseY);
    particles.add(new Particle(pos, accel));
  }
}

void draw() {
  background(15,15,15); 
  
  if (mousePressed) {
    createExplosion(mouseX, mouseY);
  }
  
  for (int i = 0; i < particles.size(); i++) {
    Particle particle = (Particle) particles.get(i);
    particle.update();
    particle.draw();
    
    if (particle.isDead()) {
      particles.remove(particle);
    }
  }
}


