import peasy.*;
import guicomponents.*;
import processing.opengl.*;
import javax.media.opengl.*;

import oscP5.*;
import netP5.*;

Snake snake;

PeasyCam cam;
CubeArray cubes;

TwoDGUI twoDGui;

// Used to remember PGraphics3D transformation matrix
PGraphics3D g3;
Vector3D vector3d;


void setup() { 
  size(800, 500, OPENGL);
  noStroke();  
  g3 = (PGraphics3D) g;  

  cam = new PeasyCam(this, width);  
  snake = new Snake(g3, this);
  FPS.register(this);
  twoDGui = new TwoDGUI(this, cam);
}

void draw() {
  snake.draw();
  
  PMatrix3D currCameraMatrix = new PMatrix3D(g3.camera);
  camera();
  draw2D();  
  g3.camera = currCameraMatrix;
}

void draw2D() {
  FPS.draw(this);  
  twoDGui.draw();
}

void keyPressed() {
  twoDGui.keyPressed(key, keyCode);
}


