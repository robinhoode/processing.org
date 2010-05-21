import processing.opengl.*;
import javax.media.opengl.*; 

import peasy.*;
import ddf.minim.*;
import sojamo.drop.*;

SDrop drop;

Minim minim;
AudioPlayer groove;

PeasyCam cam;

TriangulatedCylinder cylinder, cylinder2;
TriangulatedSphere   sphere;
OuterGrid outerGrid;

void setup() {
  size(800, 600, OPENGL);
  
  cam = new PeasyCam(this, width);
  
  initGl(g);
  
  cylinder  = new TriangulatedCylinder(1500, 2, 150);
  cylinder2 = new TriangulatedCylinder(2000, 3, 250);
  sphere    = new TriangulatedSphere();
  outerGrid = new OuterGrid();
  
  minim = new Minim(this);  
//  FileChooser chooser = new FileChooser();
  drop = new SDrop(this);
}

void initGl(PGraphics g) {
  GL gl = ((PGraphicsOpenGL)g).gl;
  
  hint(ENABLE_OPENGL_4X_SMOOTH);
  gl.glHint (gl.GL_LINE_SMOOTH_HINT, gl.GL_NICEST);
  gl.glEnable (gl.GL_LINE_SMOOTH);    
}

void dropEvent(DropEvent dropEvent) {
  if (groove != null && groove.isPlaying())
    groove.pause();
  
  if (dropEvent.isFile()) {
    groove = minim.loadFile(dropEvent.file().getPath(), 2048);
    groove.play();
  }  
}

void draw() {
  background(0);

  sphere.draw();
  cylinder.draw();
  cylinder2.draw();
  
  outerGrid.draw();   
}

float currentLevel() {
  if (groove != null)
    return groove.left.level();
  else
    return 0;
}

