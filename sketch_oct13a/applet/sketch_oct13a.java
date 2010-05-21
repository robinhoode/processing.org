import processing.core.*; 
import processing.xml.*; 

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

public class sketch_oct13a extends PApplet {

float boxSize = 120;
float margin = boxSize*2;
float distance = 1000;
int boxFill;

float latitude = 5000;
float longitude = 5000;

public void setup() {
  size(800, 600, P3D);
  noStroke();
  beginCamera();
//  rotateZ(PI/8);
//  rotate(-PI/3);
  rotateX(-PI/4);
  endCamera(); 
}

public void draw() {
  background(0);
  
  translate(longitude/2, latitude/2, -distance);
  // Center and spin grid
  
  beginCamera();
  camera(0.0f, mouseY, 220.0f, // eyeX, eyeY, eyeZ
         0.0f, 0.0f, 0.0f, // centerX, centerY, centerZ
         0.0f, 1.0f, 0.0f); // upX, upY, upZ

//  rotateX(-PI/4 - (mouseY/height));
  endCamera();

  // Build grid using multiple translations 
  for (float j =- latitude+margin; j <= latitude-margin; j += boxSize){
    for (float k =- longitude+margin; k <= longitude-margin; k += boxSize){
      // Base fill color on counter values, abs function 
      // ensures values stay within legal range
      boxFill = color(0, 255, 0, 50);
      pushMatrix();
      translate(k, j, 1);
      stroke(boxFill);
      fill(boxFill);
      box(boxSize, boxSize, 1);
      popMatrix();
    }
  }
}


  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#D4D0C8", "sketch_oct13a" });
  }
}
