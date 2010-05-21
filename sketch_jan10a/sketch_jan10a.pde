import processing.opengl.*;
import javax.media.opengl.*;
import peasy.*;

// I want import chaosmeme.*
// Instead of PeasyCam, and setting up OpenGL
// The first I would do automatically.
// The second I might not remember..

PeasyCam cam;

void setup() {
  size(800, 600, OPENGL);
  
  GL gl = ((PGraphicsOpenGL)g).gl;
  
  hint(ENABLE_OPENGL_4X_SMOOTH);
  gl.glHint (gl.GL_LINE_SMOOTH_HINT, gl.GL_NICEST);
  gl.glEnable (gl.GL_LINE_SMOOTH);  
  
  cam = new PeasyCam(this, width);  
}

void draw() {
  background(0);
  PVector first  = new PVector(0,   0,   0);
  PVector second = new PVector(0,   0, 100);  
  PVector third  = new PVector(0, 100, 100);
  
  fill(0);
  stroke(0, 0, 255);
  beginShape(TRIANGLES);
  for (float i = 0; i < 100; i += 10) {
    drawVertex(first);
    drawVertex(between(second, third, i/100));
    drawVertex(between(second, third, (i+5)/100));
  }
  endShape();
}

PVector between(PVector start, PVector end, float percent) {
  return PVector.add(PVector.mult(PVector.sub(end, start), percent), start);
}

void drawVertex(PVector vect) {
  vertex(vect.x, vect.y, vect.z);  
}
