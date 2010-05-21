import processing.opengl.*;
import javax.media.opengl.*;
import peasy.*; 
PeasyCam cam;

Icosahedron icosa;

// A mathematical constant
float phi = (1 + sqrt(5))/2.0;

void setup() { 
  size(800, 600, OPENGL);
  
  GL gl = ((PGraphicsOpenGL)g).gl;
  
  hint(ENABLE_OPENGL_4X_SMOOTH);
  gl.glHint (gl.GL_LINE_SMOOTH_HINT, gl.GL_NICEST);
  gl.glEnable (gl.GL_LINE_SMOOTH);
  
  cam   = new PeasyCam(this, width);
  icosa = new Icosahedron(100);  
}


void draw() {
  background(15);
  noFill();
  
  directionalLight(255, 255, 255, -10, -10, -10);
  icosa.draw();
}

PVector between(PVector start, PVector end, float percent) {
  return PVector.add(PVector.mult(PVector.sub(end, start), percent), start);
}
