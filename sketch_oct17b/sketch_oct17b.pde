import processing.opengl.*;
import peasy.*; 
PeasyCam cam;

void setup() { 
  size(800, 600, OPENGL);
  
  noStroke();
  cam = new PeasyCam(this, width);
//  populateBoxes();
}


class Box {
  float dx;
  float dy;
  float dz;
  
  Box(float dx, float dy, float dz) {
    this.dx = dx;
    this.dy = dy;
    this.dz = dz;
  }
  
  void draw() {
    noFill();          
    stroke(0,255,0);    
    translate(dx, dy, dz);
    box(boxSize, boxSize, boxSize);
  }
}


float boxSize = 20;
float randomRange = 10;
int iterations = 100;
int boxCount = 100;

ArrayList boxes = new ArrayList();

Box newRandomBox() {
  int direction = (int)random(6);
  
  if (direction == 0)
    return new Box(boxSize, 0.0, 0.0);
  else if (direction == 1)
    return new Box(-boxSize, 0.0, 0.0);
  else if (direction == 2)
    return new Box(0.0, boxSize, 0.0);
  else if (direction == 3)
    return new Box(0.0, -boxSize, 0.0);
  else if (direction == 4)
    return new Box(0.0, 0.0, boxSize);
  else if (direction == 3)
    return new Box(0.0, 0.0, -boxSize);
  else
    return new Box(0.0, 0.0, 0.0);
}

/*
void populateBoxes() {
  for (int i = 0; i < boxCount; i++) {    
    boxes[i] = newRandomBox();
  }
}
*/


void draw() {
  background(15, 15, 15); 
  
  pushMatrix();  
  
  for (int i = 0; i < boxes.size(); i++) {
    Box currentBox = (Box)boxes.get(i);
    currentBox.draw(); 
  }
  
  popMatrix();
}

void keyPressed() {
  boxes.add(newRandomBox());
}


