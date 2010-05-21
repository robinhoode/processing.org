import processing.opengl.*;

void setup() {
  size(800, 600, OPENGL);
}

void draw() {
  background(0);
  stroke(255);
  line(50, 50, mouseX, mouseY);
}
