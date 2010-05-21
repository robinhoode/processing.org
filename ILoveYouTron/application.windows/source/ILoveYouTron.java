import processing.core.*; 
import processing.xml.*; 

import processing.opengl.*; 
import javax.media.opengl.*; 
import peasy.*; 
import pitaru.sonia_v2_9.*; 

import java.applet.*; 
import java.awt.*; 
import java.awt.image.*; 
import java.awt.event.*; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class ILoveYouTron extends PApplet {


 




PeasyCam cam;

TriangulatedCylinder cylinder, cylinder2;
TriangulatedSphere   sphere;
OuterGrid outerGrid;

public void setup() {
  size(800, 600, OPENGL);
  
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


public void draw() {
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

class OuterGrid {
  float angleY, angleZ;
  int boxSize = 800;
  
  OuterGrid() {
    this.angleY = 0;
    this.angleZ = 0;
  }
  
  public void draw() {

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
  
  public void bottomWall(int i) {
    // Bottom wall
    // (i, +, -) => (i, +, +)
    vertex(i, boxSize, -boxSize); vertex(i, boxSize, boxSize);    
    // (+, +, i) => (-, +, i)    
    vertex(boxSize,  boxSize, i); vertex(-boxSize, boxSize, i);  
  }
  
  public void topWall(int i) {
    // Top wall
    // (i, -, -) => (i, -, +)
    vertex(i, -boxSize, -boxSize); vertex(i, -boxSize, boxSize);  
    // (+, -, i) => (-, -, i)
    vertex(boxSize, -boxSize, i); vertex(-boxSize, -boxSize, i); 
  }
  
  public void rightWall(int i) {
    // Right wall    
    // (+, +, i) => (+, -, i)        
    vertex(boxSize,  boxSize, i); vertex(boxSize, -boxSize, i); 
    // (+, i, +) => (+, i, -)    
    vertex(boxSize,  i, boxSize); vertex(boxSize, i, -boxSize);   
  }
  
  public void leftWall(int i) {
    // Left wall
    // (-, -, i) => (-, +, i)    
    vertex(-boxSize, -boxSize, i); vertex(-boxSize, boxSize, i); 
    // (-, i, -) => (-, i, +)    
    vertex(-boxSize, i, -boxSize); vertex(-boxSize, i, boxSize);  
  }
  
  public void backWall(int i) {
    // Back wall
    // (i, +, +) => (i, -, +)    
    vertex(i, boxSize, boxSize); vertex(i, -boxSize, boxSize);
    // (+, i, +) => (-, i, +)    
    vertex(boxSize, i, boxSize); vertex(-boxSize, i, boxSize);    
  }
  
  public void frontWall(int i) {
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
  
  public void draw() {
    float soundLevel = LiveInput.getLevel();
//    println("Sound level is " + soundLevel*10000/log(soundLevel*10000));
    scalar = soundLevel*levelScale;
    
    shapeHeight = standardShapeHeight*soundLevel*20; //*(scalar);
    
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
  
  public void draw() {
    float soundLevel = LiveInput.getLevel();
//    println("Sound level is " + soundLevel*10000/log(soundLevel*10000));
    scalar = soundLevel*500;
    
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
  
  public void drawTopTriangle(float s0, float s1, float top, float bottom, float j) {
    vertex(top,    s0*cos(j),             s0*sin(j));
    vertex(top,    s0*cos(j+longSteps),   s0*sin(j+longSteps)); 
    vertex(bottom, s1*cos(j+longSteps/2), s1*sin(j+longSteps/2));
  }
  
  public void drawBottomTriangle(float s0, float s1, float top, float bottom, float j) {
    vertex(bottom, s1*cos(j),             s1*sin(j));
    vertex(bottom, s1*cos(j+longSteps),   s1*sin(j+longSteps));      
    vertex(top,    s0*cos(j+longSteps/2), s0*sin(j+longSteps/2));
  }
  
}



  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#E2E2E2", "ILoveYouTron" });
  }
}
