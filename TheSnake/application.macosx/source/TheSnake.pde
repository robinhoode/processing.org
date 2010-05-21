import peasy.*;
import guicomponents.*;
import processing.opengl.*;
import javax.media.opengl.*;

PeasyCam cam;
CubeArray cubes;

// Used to remember PGraphics3D transformation matrix
PGraphics3D g3;
// SnakeGUI snakeGui;
Snake snake;

void setup() { 
  size(800, 600, OPENGL);
  noStroke();  

  cam = new PeasyCam(this, width);  
  snake = new Snake((PGraphics3D) g, this);
  FPS.register(this);
  
  g3 = (PGraphics3D) g;
}

void draw() {
  snake.draw();  
  PMatrix3D currCameraMatrix = new PMatrix3D(g3.camera);
  camera();
  FPS.draw(this);  
  g3.camera = currCameraMatrix;
}



