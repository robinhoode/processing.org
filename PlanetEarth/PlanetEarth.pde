import processing.opengl.*;
import javax.media.opengl.*;
import peasy.*;

PeasyCam cam;
TessellatedSphere sphere;

void setup() {
  size(800, 600, OPENGL);
  cam = new PeasyCam(this, width);
  initGl(g);

  sphere = new TessellatedSphere(loadImage("world32k.jpg"));
}

void draw() {
  background(0);
  // Stuff here..
  sphere.draw();
}


class TessellatedSphere {
  float radius = 100;
  float R;
  float latStep  = 5;
  float longStep = PI/12;  
  PImage sphereTexture;
  
  TessellatedSphere(PImage texture) {
    R             = radius;  
    sphereTexture = texture;
  }
  
  void radialVertex(float t, float i) {
    float rad = sqrt(R*R - i*i);
    
    // Fix suggested by http://dev.processing.org/bugs/show_bug.cgi?id=602#c0
    float u = map(t/(2*PI),    0, 1, 0.001, 0.999);
    float v = map((i+R)/(2*R), 0, 1, 0.001, 0.999);
    
    vertex(rad*cos(t), rad*sin(t), i, u, v);
  }
    
  void draw() {    
    noStroke();
    noFill();
    textureMode(NORMALIZED);

    for (float i = -R; i < R; i += latStep) {      
      beginShape(QUAD_STRIP);
      texture(sphereTexture);
      for (float t = 0; t <= 2*PI; t += longStep) {
        radialVertex(t, i);
        radialVertex(t, i+latStep);
      }
      endShape();                  
    }
  }
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
