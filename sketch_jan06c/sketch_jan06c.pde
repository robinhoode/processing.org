import processing.opengl.*;
import peasy.*;
import pitaru.sonia_v2_9.*;

PeasyCam cam;

TriangulatedCylinder cylinder, cylinder2;
TriangulatedSphere   sphere;
OuterGrid outerGrid;

void setup() {
  size(1200, 700, OPENGL);
  
  cam = new PeasyCam(this, width);
  
  // Start Sonia engine.
  Sonia.start(this); 
   
  // Start LiveInput and return 256 FFT frequency bands.
  LiveInput.start(256); 
  LiveInput.useEqualizer(true);  
  cylinder  = new TriangulatedCylinder(1500, 2, 150);
  cylinder2 = new TriangulatedCylinder(2000, 3, 250);
  sphere    = new TriangulatedSphere();
  outerGrid = new OuterGrid();
}


void draw() {
  background(0);
  
  sphere.draw();
  cylinder.draw();
  cylinder2.draw();
  
  outerGrid.draw();   
}

class OuterGrid {
  float angleY, angleZ;
  int boxSize = 1200;
  
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

class TriangulatedCylinder {
  float angleY = 0;
  float angleZ = 0;


  float angleStep = PI/12,        scalar, 
        standardShapeHeight = 20, shapeHeight, 
        levelScale,               iterationSize,
        strokeColor;
  
  TriangulatedCylinder(float levelScale, float iterationSize, float strokeColor) {
    this.angleY              = random(128)*PI/128;
    this.angleZ              = random(243)*PI/243;
    this.levelScale          = levelScale;
    this.iterationSize       = iterationSize;
    this.standardShapeHeight = standardShapeHeight;
    this.strokeColor         = strokeColor;
  }
  
  void draw() {
    float soundLevel = LiveInput.getLevel();
//    println("Sound level is " + soundLevel*10000/log(soundLevel*10000));
    scalar = soundLevel*levelScale;
    
    shapeHeight = standardShapeHeight*soundLevel*100; //*(scalar);
    
    stroke(0, 0, strokeColor);
    fill(0, 100);
    
    pushMatrix();
    beginShape(TRIANGLES); 

    for (float i = 0; i < 2*PI; i += angleStep*iterationSize) {
      vertex(shapeHeight,  scalar*cos(i),             scalar*sin(i));
      vertex(shapeHeight,  scalar*cos(i+angleStep),   scalar*sin(i+angleStep));
      vertex(-shapeHeight, scalar*cos(i+angleStep/2), scalar*sin(i+angleStep/2));
      
      i += angleStep*iterationSize;
      vertex(-shapeHeight,  scalar*cos(i),             scalar*sin(i));
      vertex(-shapeHeight,  scalar*cos(i+angleStep),   scalar*sin(i+angleStep));
      vertex(shapeHeight,   scalar*cos(i+angleStep/2), scalar*sin(i+angleStep/2));
    }
    
    angleY += PI/128;
    rotateY(angleY);
    angleZ += PI/243;
    rotateZ(angleZ);    
    
    endShape(CLOSE);
    popMatrix();
  }  
}

// TODO: Make the sphere deform into different triangulations during the song
//
class TriangulatedSphere {
  float scalar = 500;
  float longSteps = PI/12;
  float latSteps  = PI/12; 
  
  float angleY, angleZ;
  
  TriangulatedSphere() {
    this.angleY              = random(128)*PI/128;
    this.angleZ              = random(243)*PI/243;    
  }
  
  void draw() {
    float soundLevel = LiveInput.getLevel();
//    println("Sound level is " + soundLevel*10000/log(soundLevel*10000));
    scalar = soundLevel*1000;
    
    pushMatrix();
    beginShape(TRIANGLES);     
    
    stroke(0, 0, 255);
    fill(0);

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
    
    angleY += PI/128;
    rotateY(angleY);
    angleZ += PI/243;
    rotateZ(angleZ);    


    endShape(CLOSE);
    popMatrix();
  }
  
  void drawTopTriangle(float s0, float s1, float top, float bottom, float j) {
    vertex(top,    s0*cos(j),             s0*sin(j));
    vertex(top,    s0*cos(j+longSteps),   s0*sin(j+longSteps)); 
    vertex(bottom, s1*cos(j+longSteps/2), s1*sin(j+longSteps/2));
  }
  
  void drawBottomTriangle(float s0, float s1, float top, float bottom, float j) {
    vertex(bottom, s1*cos(j),             s1*sin(j));
    vertex(bottom, s1*cos(j+longSteps),   s1*sin(j+longSteps));      
    vertex(top,    s0*cos(j+longSteps/2), s0*sin(j+longSteps/2));
  }
  
}


