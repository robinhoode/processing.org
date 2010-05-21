import processing.opengl.*;
import javax.media.opengl.*;
import peasy.*;

PeasyCam cam;
PGraphics3D g3;

float r11, r12, r21, r22;
float n1, n2, n3;

PFont font;

void setup() {
  size(800, 600, OPENGL);
  cam = new PeasyCam(this, width);
  initGl(g);
  g3 = (PGraphics3D) g;  
  
  font = loadFont("ArabicTransparent-16.vlw");
  textFont(font, 16);
  
  loadNewValues();
}

void loadNewValues() {

  /*
  r11 = random(100);
  r12 = random(100);
  r21 = random(100);
  r22 = random(100);
  */
  
  r11 = random(100);
  r12 = random(100);
  r21 = random(100);
  r22 = random(100);
  
  n1 = random(100);
  n3 = random(100);
  n2 = random(100);
}

float r1(float phi) {
  float a = 1; // a = random(10);
  float b = 1; // b = random(10);

/*  
  float n1 = 1.0; // n1 = random(100);
  float n2 = 1.0; // n2 = random(100);
  float n3 = 1.0; // n3 = random(100);
*/

  return pow(pow(abs(cos(r11*phi/4)/a), n2) + pow(abs(sin(r12*phi/4)/b), n3), -1/n1);
}

float r2(float phi) {
  float a = 1; // a = random(10);
  float b = 1; // b = random(10);
  
  /*
  float n1 = 1.0; // n1 = random(100);
  float n2 = 1.0; // n2 = random(100);
  float n3 = 1.0; // n3 = random(100);
  */
  
  return pow(pow(abs(cos(r21*phi/4)/a), n2) + pow(abs(sin(r22*phi/4)/b), n3), -1/n1);  
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
  draw3D();

  PMatrix3D currCameraMatrix = new PMatrix3D(g3.camera);
  camera();
  draw2D();  
  g3.camera = currCameraMatrix;  
}

void draw2D() {
  fill(255);
  text("r11 = " + r11 + ", r21 = " + r21 + ", r12 = " + r12 + ", r22 = " + r22, 12, 16);  
  text("n1 = " + n1 + ", n2 = " + n2 + ", n3 = " + n3, 12, 32);    
}

void draw3D() {
  background(0);

  fill(0, 0, 255);
  //stroke(0, 0, 255);
  stroke(0);
  
  directionalLight(126, 126, 126, 0, 0, -1);
  ambientLight(102, 102, 102);
  
  float shapeSize = 50;
  float stepSize = PI/48;

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
}

void keyPressed() {
  if (keyCode == ENTER) 
    loadNewValues();
    
  if (key == 'q')
    r11 += 0.1;
  if (key == 'a')
    r11 -= 0.1;

  if (key == 'w')
    r12 += 0.1;
  if (key == 's')
    r12 -= 0.1;
    
  if (key == 'e')
    r21 += 0.1;
  if (key == 'd')
    r21 -= 0.1;    
    
  if (key == 'r')
    r22 += 0.1;
  if (key == 'f')
    r22 -= 0.1;
    
  if (key == '7')
    n1 += 0.1;
  if (key == '1')
    n1 -= 0.1;

  if (key == '8')
    n2 += 0.1;
  if (key == '2')
    n2 -= 0.1;    

  if (key == '9')
    n3 += 0.1;
  if (key == '3')
    n3 -= 0.1;        
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
