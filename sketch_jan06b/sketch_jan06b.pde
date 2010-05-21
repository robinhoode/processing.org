import processing.opengl.*;
import peasy.*;
import pitaru.sonia_v2_9.*;

PeasyCam cam;

void setup() {
  size(800, 600, OPENGL);
  
  cam = new PeasyCam(this, width);
  
  // Start Sonia engine.
  Sonia.start(this); 
   
  // Start LiveInput and return 256 FFT frequency bands.
  LiveInput.start(256); 
  LiveInput.useEqualizer(true);  
}


void draw() {
  background(0);
  
  drawOuterGrid();
  drawWierdShape();
}

void drawOuterGrid() {
  int boxSize = 500;
  int spacing = boxSize/10;
  
  stroke(0, 128, 0);
  strokeWeight(2);
  fill(0, 128, 0);
  
  for (int i = -boxSize; i <= boxSize; i += spacing) {
    // Bottom wall    
    line(i, boxSize, -boxSize, i, boxSize, boxSize);    // (i, +, -) => (i, +, +)
    line(boxSize,  boxSize, i,  -boxSize, boxSize, i);  // (+, +, i) => (-, +, i)    
    
    // Top wall
    line(i, -boxSize, -boxSize, i, -boxSize, boxSize);  // (i, -, -) => (i, -, +)
    line(boxSize, -boxSize, i, -boxSize, -boxSize, i);  // (+, -, i) => (-, -, i)

    // Right wall    
    line(boxSize,  boxSize, i,  boxSize, -boxSize, i);  // (+, +, i) => (+, -, i)    
    line(boxSize,  i, boxSize, boxSize, i, -boxSize);   // (+, i, +) => (+, i, -)
    
    // Left wall
    line(-boxSize, -boxSize, i,  -boxSize, boxSize, i); // (-, -, i) => (-, +, i)
    line(-boxSize, i, -boxSize, -boxSize, i, boxSize);  // (-, i, -) => (-, i, +)

    // Back wall
    line(i, boxSize, boxSize, i, -boxSize, boxSize);    // (i, +, +) => (i, -, +)
    line(boxSize, i, boxSize, -boxSize, i, boxSize);    // (+, i, +) => (-, i, +)
    
    // Front wall
    line(i, -boxSize, -boxSize, i, boxSize, -boxSize);  // (i, -, -) => (i, +, -)
    line(-boxSize, i, -boxSize, boxSize, i, -boxSize);  // (-, i, -) => (+, i, -)    
  }
}

float angleY = 0;
float angleZ = 0;

void drawWierdShape() {
  int step   = 10;

  float scalar = LiveInput.getLevel()*500;
  
  stroke(0, 125);
  fill(0, 0, 255);
  beginShape(TRIANGLES);
  for (int i = 0; i < 90; i++) {
    vertex(0, 0, 0);
    vertex(scalar, scalar*cos(i),      scalar*sin(i));
    vertex(scalar, scalar*cos(i+step), scalar*sin(i+step));

    vertex(0, 0, 0);
    vertex(-scalar, scalar*cos(i),      scalar*sin(i));
    vertex(-scalar, scalar*cos(i+step), scalar*sin(i+step));    
  }
  
  angleY += PI/128;
  rotateY(angleY);
  angleZ += PI/243;
  rotateZ(angleZ);
  endShape(CLOSE);
  
}
