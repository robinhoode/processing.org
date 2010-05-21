import saito.objloader.*;
import peasy.*; 

Virus virus;
PeasyCam cam;

void setup() {
  size(600, 600, P3D);

  virus = new Virus(this);
  cam   = new PeasyCam(this, width);
}

class Virus {
  OBJModel model;
  
  Virus(PApplet env) {
    this.model = new OBJModel(env, "virus.obj");
    this.model.disableMaterial();
  }
  
  void draw() {
    this.model.draw();
  }
  
  void move(PVector translation) {
    for (int i = 0; i < this.model.getVertexSize(); i++) {
      PVector vert = this.model.getVertex(i);
      vert.add(translation);
      this.model.setVertex(i, vert);
    }
  }
}

void draw() {
  background(255);
  lights();
  pushMatrix();
  translate(width/2, height/2, 0);
//  scale(30.0);
  virus.draw();
  virus.move(new PVector(1, 1, 1));
  popMatrix();
}


