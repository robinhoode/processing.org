import processing.opengl.*;
import javax.media.opengl.*;
import peasy.*;

PeasyCam cam;

void setup() {
  size(800, 600, OPENGL);
  cam = new PeasyCam(this, width);
  initGl(g);
}

/* Shape equations from http://local.wasp.uwa.edu.au/~pbourke/geometry/ */

void shapeVertex2(float shapeSize, float u, float v) {
  float x = 2*sin(3*u) / (2 + cos(v));
  float y = 2*(sin(u) + 2*sin(2*u)) / (2 + cos(v + 2*PI / 3));
  float z = (cos(u) - 2*cos(2*u))*(2 + cos(v))*(2 + cos(v + 2*PI / 3)) / 4;
  vertex(shapeSize*x, shapeSize*y, shapeSize*z);  
}

void shapeVertex(float shapeSize, float u, float v) {
  float x = sin(u)*(1 + cos(v));
  float y = sin(u + 2*PI/3)*(1 + cos(v + 2*PI/3));
  float z = sin(u + 4*PI/3)*(1 + cos(v + 4*PI/3));
  vertex(shapeSize*x, shapeSize*y, shapeSize*z);
}

void draw() {
  background(0);
  // Stuff here..

  noFill();
  stroke(0, 0, 255);
  
  float shapeSize = 50;
  float stepSize = PI/36;
  
  beginShape(QUADS);
  
  for (float u = -PI; u <= PI; u += stepSize) {
    for (float v = -PI; v <= PI; v += stepSize) {
      shapeVertex(shapeSize, u, v);
      shapeVertex(shapeSize, u, v+stepSize);      
      shapeVertex(shapeSize, u+stepSize, v+stepSize);      
      shapeVertex(shapeSize, u+stepSize, v);
    }
  }
  
  endShape();
}


/*****************************************/

void initGl(PGraphics g) {
  GL gl = ((PGraphicsOpenGL)g).gl;

  hint(ENABLE_OPENGL_4X_SMOOTH);
  gl.glEnable(gl.GL_LINE_SMOOTH);  
  gl.glEnable(gl.GL_BLEND);
  gl.glBlendFunc (gl.GL_SRC_ALPHA, gl.GL_ONE_MINUS_SRC_ALPHA);  
  gl.glHint(gl.GL_LINE_SMOOTH_HINT, gl.GL_NICEST);
  gl.glLineWidth(1.5);
  gl.glClearColor(0,0,0,0);
}
