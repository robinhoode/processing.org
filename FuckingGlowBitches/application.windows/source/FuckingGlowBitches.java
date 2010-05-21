import processing.core.*; 
import processing.xml.*; 

import processing.opengl.*; 
import javax.media.opengl.*; 
import peasy.*; 

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

public class FuckingGlowBitches extends PApplet {





PeasyCam cam;
PGraphics3D g3;

OuterGrid outerGrid;

public void setup() {
  size(800, 600, OPENGL);
  cam = new PeasyCam(this, width);
  g3 = (PGraphics3D) g;    
  initGl(g);
  FPS.register(this);
  outerGrid = new OuterGrid();
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

public void draw3D() {
  background(0);
  // Stuff here..
  outerGrid.draw(); 

}

public void draw2D() {
  FPS.draw(this);  
}

public void draw() {
  draw3D();
  
  PMatrix3D currCameraMatrix = new PMatrix3D(g3.camera);
  camera();
  draw2D();  
  g3.camera = currCameraMatrix;  

  glow(4, 3);  
}


/*****************************************/

public void initGl(PGraphics g) {
  GL gl = ((PGraphicsOpenGL)g).gl;

  hint(ENABLE_OPENGL_4X_SMOOTH);
  gl.glEnable(gl.GL_LINE_SMOOTH);  
  gl.glEnable(gl.GL_BLEND);
  gl.glBlendFunc (gl.GL_SRC_ALPHA, gl.GL_ONE_MINUS_SRC_ALPHA);  
  gl.glHint(gl.GL_LINE_SMOOTH_HINT, gl.GL_NICEST);
  gl.glLineWidth(1.5f);
  gl.glClearColor(0,0,0,0);
}
// The framerate counter
// To use this you must first do FPS.register(this) in your setup()
static public class FPS {
  static private int frames = 0;
  static private long startTime = 0;
  static private int fps = 0;
  static private PApplet p;
  static private PFont font;
 
  static FPS instance;
 
  public static void register(PApplet p){    
    instance = new FPS();
    FPS.p = p;
    FPS.font = p.createFont("Arial-Bold", 12);
    p.textFont(FPS.font, 12);
    p.registerPost(instance);
  }
 
  public static void frame() {
    if (startTime==0)
      startTime = p.millis();
    frames++;
    long t = p.millis() - startTime;
    if (t>1000) {
      fps = (int)(1000*frames/t);
      startTime += t;
      frames = 0;
    }
  }
 
  static public int frameRate(){
    return fps;
  }
 
  public void post(){
    FPS.frame();
  }   
 
  static public void draw(PApplet applet) {
    p.fill(255);    
    p.text("fps: " + frameRate(), 6, 14);    
  }
}

 
// GLOWING 
 
// Martin Schneider 
// October 14th, 2009 
// k2g2.org 
 
 
// use the glow function to add radiosity to your animation :) 
 
// r (blur radius) : 1 (1px)  2 (3px) 3 (7px) 4 (15px) ... 8  (255px) 
// b (blur amount) : 1 (100%) 2 (75%) 3 (62.5%)        ... 8  (50%) 
   
public void glow(int r, int b) { 
  loadPixels(); 
  blur(1); // just adding a little smoothness ... 
  int[] px = new int[pixels.length]; 
  arrayCopy(pixels, px); 
  blur(r); 
  mix(px, b); 
  updatePixels(); 
} 
 
public void blur(int dd) { 
   int[] px = new int[pixels.length];  
   for(int d=1<<--dd; d>0; d>>=1) {   
      for(int x=0;x<width;x++) for(int y=0;y<height;y++) { 
        int p = y*width + x; 
        int e = x >= width-d ? 0 : d; 
        int w = x >= d ? -d : 0; 
        int n = y >= d ? -width*d : 0; 
        int s = y >= (height-d) ? 0 : width*d; 
        int r = ( r(pixels[p+w]) + r(pixels[p+e]) + r(pixels[p+n]) + r(pixels[p+s]) ) >> 2; 
        int g = ( g(pixels[p+w]) + g(pixels[p+e]) + g(pixels[p+n]) + g(pixels[p+s]) ) >> 2; 
        int b = ( b(pixels[p+w]) + b(pixels[p+e]) + b(pixels[p+n]) + b(pixels[p+s]) ) >> 2; 
        px[p] = 0xff000000 + (r<<16) | (g<<8) | b; 
      } 
      arrayCopy(px,pixels);  
   } 
} 
 
public void mix(int[] px, int n) { 
  for(int i=0; i< pixels.length; i++) { 
    int r = (r(pixels[i]) >> 1)  + (r(px[i]) >> 1) + (r(pixels[i]) >> n)  - (r(px[i]) >> n) ; 
    int g = (g(pixels[i]) >> 1)  + (g(px[i]) >> 1) + (g(pixels[i]) >> n)  - (g(px[i]) >> n) ; 
    int b = (b(pixels[i]) >> 1)  + (b(px[i]) >> 1) + (b(pixels[i]) >> n)  - (b(px[i]) >> n) ; 
    pixels[i] =  0xff000000 | (r<<16) | (g<<8) | b; 
  } 
} 
 
public int r(int c) {return (c >> 16) & 255; } 
public int g(int c) {return (c >> 8) & 255;} 
public int b(int c) {return c & 255; } 
 


  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#E2E2E2", "FuckingGlowBitches" });
  }
}
