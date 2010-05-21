import saito.objloader.*;
import peasy.*; 

class Virus {
  OBJModel model;
  PVector  velocity;
  
  Virus(PApplet env, PVector velocity) {
    this.model    = new OBJModel(env);
    this.model.disableMaterial();
    this.model.disableTexture();
    this.model.load("simplified_virus.obj");
    this.velocity = velocity;
  }
  
  void draw() {
    this.model.draw();
  }
  
  void update() {
    this.move(this.velocity);
  }
  
  void move(PVector translation) {
    for (int i = 0; i < this.model.getVertexSize(); i++) {
      PVector vert = this.model.getVertex(i);
      vert.add(translation);
      this.model.setVertex(i, vert);
    }
  }
}

int VIRUS_COUNT   = 5;
ArrayList viruses = new ArrayList();
PeasyCam cam;

void setup() {
  size(600, 600, P3D);

  for (int i = 0; i < VIRUS_COUNT; i++) {
    float x = random(-20, 20);
    float y = random(-20, 20);
    float z = random(-20, 20);
    viruses.add(new Virus(this, new PVector(x, y, z)));
  }

  cam   = new PeasyCam(this, width);
}

void draw() {
  background(255);
  lights();
  pushMatrix();
  
  for (int i = 0; i < VIRUS_COUNT; i++) {
    Virus virus = (Virus) viruses.get(i);
    virus.draw();
    virus.update();
  }
  
  popMatrix();
}
