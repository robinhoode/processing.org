import processing.opengl.*;
import peasy.*;
PeasyCam cam;

void setup() {
  size(800, 600, OPENGL);
  
  cam = new PeasyCam(this, width);
}

void draw() {
  float scalar = 55;
  int step   = 5;
  
  background(0);
  stroke(0, 125);
  fill(0, 0, 255);
  beginShape(TRIANGLES);
  for (int i = 0; i < 90; i++) {
    vertex(0, scalar*cos(i), scalar*sin(i));
    vertex(-scalar, scalar*cos(i+step), scalar*sin(i+step));
    vertex(-scalar, scalar*cos(i+2*step), scalar*sin(i+2*step));
  }
  rotateY(PI/2);
  endShape(CLOSE);
}
