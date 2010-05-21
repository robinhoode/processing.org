import processing.opengl.*;
import javax.media.opengl.*;
import peasy.*;

PeasyCam cam;

OuterGrid outerGrid;

void setup() {
  size(800, 600, OPENGL);
  cam = new PeasyCam(this, width);
  initGl(g);
  
  outerGrid = new OuterGrid();
}


class OuterGrid {
  float angleY, angleZ;
  int boxSize = 800;
  
  OuterGrid() {
    this.angleY = 0;
    this.angleZ = 0;
  }
  
  void draw() {

    int spacing = boxSize/10;
    
    stroke(0, 128, 0);
    strokeWeight(2);
    fill(0, 128, 0);
    
    pushMatrix();
    beginShape(LINES);
    
    for (int i = -boxSize; i <= boxSize; i += spacing) {
      bottomWall(i); topWall(i);
      rightWall(i);  leftWall(i);
      backWall(i);   frontWall(i);
    }
  
    angleY += PI/pow(2, 10);
    rotateY(angleY);
    angleZ += PI/pow(3, 8);
    rotateZ(angleZ);

    endShape();    
    popMatrix();    
  }
  
  void bottomWall(int i) {
    // Bottom wall
    // (i, +, -) => (i, +, +)
    vertex(i, boxSize, -boxSize); vertex(i, boxSize, boxSize);    
    // (+, +, i) => (-, +, i)    
    vertex(boxSize,  boxSize, i); vertex(-boxSize, boxSize, i);  
  }
  
  void topWall(int i) {
    // Top wall
    // (i, -, -) => (i, -, +)
    vertex(i, -boxSize, -boxSize); vertex(i, -boxSize, boxSize);  
    // (+, -, i) => (-, -, i)
    vertex(boxSize, -boxSize, i); vertex(-boxSize, -boxSize, i); 
  }
  
  void rightWall(int i) {
    // Right wall    
    // (+, +, i) => (+, -, i)        
    vertex(boxSize,  boxSize, i); vertex(boxSize, -boxSize, i); 
    // (+, i, +) => (+, i, -)    
    vertex(boxSize,  i, boxSize); vertex(boxSize, i, -boxSize);   
  }
  
  void leftWall(int i) {
    // Left wall
    // (-, -, i) => (-, +, i)    
    vertex(-boxSize, -boxSize, i); vertex(-boxSize, boxSize, i); 
    // (-, i, -) => (-, i, +)    
    vertex(-boxSize, i, -boxSize); vertex(-boxSize, i, boxSize);  
  }
  
  void backWall(int i) {
    // Back wall
    // (i, +, +) => (i, -, +)    
    vertex(i, boxSize, boxSize); vertex(i, -boxSize, boxSize);
    // (+, i, +) => (-, i, +)    
    vertex(boxSize, i, boxSize); vertex(-boxSize, i, boxSize);    
  }
  
  void frontWall(int i) {
    // Front wall
    // (i, -, -) => (i, +, -)    
    vertex(i, -boxSize, -boxSize); vertex(i, boxSize, -boxSize);  
    // (-, i, -) => (+, i, -)            
    vertex(-boxSize, i, -boxSize); vertex(boxSize, i, -boxSize);  
  }
}

void draw() {
  background(0);
  // Stuff here..
  outerGrid.draw(); 
  
  glow(4, 3);
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
