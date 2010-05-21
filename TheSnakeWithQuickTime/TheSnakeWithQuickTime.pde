import peasy.*;
import guicomponents.*;
import processing.opengl.*;
import processing.video.*;

PeasyCam cam;
CubeArray cubes;
MovieMaker movieMaker;

// Used to remember PGraphics3D transformation matrix
PGraphics3D g3;

float[] rotations = new float[3];

GUI gui;

void setup() { 
  size(800, 600, OPENGL);
  noStroke();

  cam = new PeasyCam(this, width);
  
  movieMaker = new MovieMaker(this, width, height, "cubes.mov", 60, MovieMaker.JPEG, MovieMaker.HIGH);
  
  cubes = new CubeArray(100, new Vector3D(0, 0, 0), new Vector3D(50, 50, 50), new Vector3D(0, 0, 0));
  // Remember PGraphics3D transformation matrix
  
  gui = new GUI(this);
  
  g3 = (PGraphics3D) g;  
}

void draw() {  
  background(0);
  lights();

  cubes.iterate(gui.nudgeVector(), gui.shiftVector(), gui.angleVector());  
  cubes.draw();  
  gui.draw();
  
  movieMaker.addFrame();
}
  
  

