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
  
  /*
  // Start Sonia engine.
  Sonia.start(this); 
   
  // Start LiveInput and return 256 FFT frequency bands.
  LiveInput.start(256); 
  LiveInput.useEqualizer(true);  
  */
  
  cylinder  = new TriangulatedCylinder(1500, 2, 150);
  cylinder2 = new TriangulatedCylinder(2000, 3, 250);
  sphere    = new TriangulatedSphere();
  outerGrid = new OuterGrid();
  
  minim = new Minim(this);  
//  FileChooser chooser = new FileChooser();
  drop = new SDrop(this);
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
  PGraphicsOpenGL pgl;
  GL gl; 
  pgl = (PGraphicsOpenGL) g;
  
  gl = pgl.beginGL();

  // This fixes the overlap issue
//  gl.glDisable(GL.GL_DEPTH_TEST);

  // Turn on the blend mode
  gl.glEnable(GL.GL_BLEND);

  // Define the blend mode
//  gl.glBlendFunc(GL.GL_SRC_ALPHA,GL.GL_ONE);
  gl.glBlendFunc(GL.GL_SRC_ALPHA,GL.GL_ONE);

  pgl.endGL();   

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


