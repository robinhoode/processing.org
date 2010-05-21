import processing.opengl.*;
import javax.media.opengl.*;
import javax.media.opengl.glu.*;
import peasy.*;

PeasyCam cam;
OpenGL openGl;

void setup() {
  size(800, 600, OPENGL);
  cam = new PeasyCam(this, width);
  openGl = new OpenGL(this);
}

void draw() {
  openGl.draw();
}



