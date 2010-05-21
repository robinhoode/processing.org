import processing.opengl.*;
import javax.media.opengl.*;
import peasy.*;

PeasyCam cam;
TriangulatedSphere sphere;
PImage textureMap;

void setup() {
  size(800, 600, OPENGL);
  cam = new PeasyCam(this, width);
  initGl(g);  

  sphere     = new TriangulatedSphere();
  textureMap = loadImage("world32k.jpg"); 
}

void draw() {
  background(0);
  sphere.draw();
}

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

// TODO: Make the sphere deform into different triangulations during the song
//
class TriangulatedSphere {
  float scalar = 500;
  float longSteps = PI/12;
  float latSteps  = PI/12; 


  TriangulatedSphere() {

  }

  void draw() {    
    pushMatrix();
    beginShape(TRIANGLES);     

//    stroke(0, 0, 255);
//    fill(0);
    texture(textureMap);

    for (float i = 0; i <= 2*PI; i += latSteps) {
      for (float j = 0; j <= PI; j += longSteps/2) {
        drawTopTriangle(scalar*cos(i), scalar*cos(i+latSteps), scalar*sin(i), scalar*sin(i+latSteps), j);        
        j += longSteps/2;
        drawBottomTriangle(scalar*cos(i), scalar*cos(i+latSteps), scalar*sin(i), scalar*sin(i+latSteps), j);
      }

      i += latSteps;

      for (float j = longSteps/2; j <= PI + longSteps/2; j += longSteps/2) {
        drawTopTriangle(scalar*cos(i), scalar*cos(i+latSteps), scalar*sin(i), scalar*sin(i+latSteps), j);     
        j += longSteps/2;
        drawBottomTriangle(scalar*cos(i), scalar*cos(i+latSteps), scalar*sin(i), scalar*sin(i+latSteps), j);
      }
    }

    endShape(CLOSE);
    popMatrix();
  }

  void drawTopTriangle(float s0, float s1, float top, float bottom, float j) {
    vertex(top,    s0*cos(j),             s0*sin(j),               j);
    vertex(top,    s0*cos(j+longSteps),   s0*sin(j+longSteps),     j); 
    vertex(bottom, s1*cos(j+longSteps/2), s1*sin(j+longSteps/2),   j);
  }

  void drawBottomTriangle(float s0, float s1, float top, float bottom, float j) {
    vertex(bottom, s1*cos(j),             s1*sin(j),               j);
    vertex(bottom, s1*cos(j+longSteps),   s1*sin(j+longSteps),     j);      
    vertex(top,    s0*cos(j+longSteps/2), s0*sin(j+longSteps/2),   j);
  }

}

