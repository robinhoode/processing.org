import processing.opengl.*;
import javax.media.opengl.*;
import peasy.*;

PeasyCam cam;

void setup() {
  size(800, 600, OPENGL);
  cam = new PeasyCam(this, width);
  initGl(g);
}

float r1(float phi) {
  float a = 1; // a = random(10);
  float b = 1; // b = random(10);
  float m = 6.0; // m = random(10);
  
  float n1 = 1.0; // n1 = random(100);
  float n2 = 1.0; // n2 = random(100);
  float n3 = 1.0; // n3 = random(100);
  return pow(pow(abs(cos(m*phi/4)/a), n2) + pow(abs(sin(m*phi/4)/b), n3), -1/n1);
}

float r2(float phi) {
  float a = 1; // a = random(10);
  float b = 1; // b = random(10);
  float m = 3; // m = random(10);
  
  float n1 = 1.0; // n1 = random(100);
  float n2 = 1.0; // n2 = random(100);
  float n3 = 1.0; // n3 = random(100);
  return pow(pow(abs(cos(m*phi/4)/a), n2) + pow(abs(sin(m*phi/4)/b), n3), -1/n1);  
}

/* 
  http://local.wasp.uwa.edu.au/~pbourke/geometry/supershape3d/ 
*/

void superShapeVertex(float shapeSize, float phi, float theta) {
  float x = r1(theta)*cos(theta)*r2(phi)*cos(phi);
  float y = r1(theta)*sin(theta)*r2(phi)*cos(phi);
  float z = r2(phi)*sin(phi);
  vertex(shapeSize*x, shapeSize*y, shapeSize*z);
}

void draw() {
  background(0);

  noFill();
  stroke(0, 0, 255);
  
  float shapeSize = 50;
  float stepSize = PI/24;

  beginShape(QUADS);
  
  for (float u = -PI/2; u <= PI/2; u += stepSize) {
    for (float v = -PI; v <= PI; v += stepSize) {
      superShapeVertex(shapeSize, u, v);
      superShapeVertex(shapeSize, u, v+stepSize);      
      superShapeVertex(shapeSize, u+stepSize, v+stepSize);      
      superShapeVertex(shapeSize, u+stepSize, v);
    }
  }
  
  endShape();

  // Stuff here..
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
