import processing.core.*; 
import processing.xml.*; 

import peasy.*; 
import guicomponents.*; 
import processing.opengl.*; 
import javax.media.opengl.*; 
import oscP5.*; 
import netP5.*; 

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

public class TheSnake extends PApplet {






PeasyCam cam;
CubeArray cubes;

// Used to remember PGraphics3D transformation matrix
PGraphics3D g3;
// SnakeGUI snakeGui;
Snake snake;

public void setup() { 
  size(800, 600, OPENGL);
  noStroke();  

  cam = new PeasyCam(this, width);  
  snake = new Snake((PGraphics3D) g, this);
  FPS.register(this);
  
  g3 = (PGraphics3D) g;
}

public void draw() {
  snake.draw();  
  PMatrix3D currCameraMatrix = new PMatrix3D(g3.camera);
  camera();
  FPS.draw(this);  
  g3.camera = currCameraMatrix;
}



class Cube {
  Vector3D[] vertices = new Vector3D[24]; 
  Vector3D location, dimensions, angleFacing = new Vector3D();
  Matrix3D rotationMatrix;

  // Constructor 2
  Cube(Vector3D location, Vector3D dimensions, Vector3D angleFacing) { 
    this.location    = location;
    this.dimensions  = dimensions;
    buildVertices();
    rotateTo(angleFacing);
  } 

  public void buildVertices() {
    double w = this.dimensions.x;
    double h = this.dimensions.y;
    double d = this.dimensions.z;
    // cube composed of 6 quads 
    //front 
    vertices[0] = new Vector3D(-w/2,-h/2,d/2); 
    vertices[1] = new Vector3D(w/2,-h/2,d/2); 
    vertices[2] = new Vector3D(w/2,h/2,d/2); 
    vertices[3] = new Vector3D(-w/2,h/2,d/2); 
    //left 
    vertices[4] = new Vector3D(-w/2,-h/2,d/2); 
    vertices[5] = new Vector3D(-w/2,-h/2,-d/2); 
    vertices[6] = new Vector3D(-w/2,h/2,-d/2); 
    vertices[7] = new Vector3D(-w/2,h/2,d/2); 
    //right 
    vertices[8] = new Vector3D(w/2,-h/2,d/2); 
    vertices[9] = new Vector3D(w/2,-h/2,-d/2); 
    vertices[10] = new Vector3D(w/2,h/2,-d/2); 
    vertices[11] = new Vector3D(w/2,h/2,d/2); 
    //back 
    vertices[12] = new Vector3D(-w/2,-h/2,-d/2);  
    vertices[13] = new Vector3D(w/2,-h/2,-d/2); 
    vertices[14] = new Vector3D(w/2,h/2,-d/2); 
    vertices[15] = new Vector3D(-w/2,h/2,-d/2); 
    //top 
    vertices[16] = new Vector3D(-w/2,-h/2,d/2); 
    vertices[17] = new Vector3D(-w/2,-h/2,-d/2); 
    vertices[18] = new Vector3D(w/2,-h/2,-d/2); 
    vertices[19] = new Vector3D(w/2,-h/2,d/2); 
    //bottom 
    vertices[20] = new Vector3D(-w/2,h/2,d/2); 
    vertices[21] = new Vector3D(-w/2,h/2,-d/2); 
    vertices[22] = new Vector3D(w/2,h/2,-d/2); 
    vertices[23] = new Vector3D(w/2,h/2,d/2);    
  }

  public void draw(){
    Vector3D vert;
    // Draw cube
    stroke(0);
    fill(150);
    for (int i = 0; i < 6; i++) {
      beginShape(QUADS);
      for (int j=0; j<4; j++) {
        drawVertex(Vector3D.add(location, vertices[j+4*i]));
      }
      endShape();
    }
  }

  public void drawVertex(Vector3D vector) {
    vertex((float) vector.x, (float) vector.y, (float) vector.z);
  }

  public void moveTo(Vector3D location) {
    this.location = location;
  }

  public void moveTowards(Vector3D init, Vector3D nudgeVector) {
    this.location = init;
    nudge(nudgeVector);
  }

  public void nudge(Vector3D offset) {
    shift(rotationMatrix.mult(offset));
  }
  
  public void shift(Vector3D offset) {
    this.location = Vector3D.add(this.location, offset);
  }

  public void buildRotationMatrix() {
    this.rotationMatrix = Matrix3D.rotationX(angleFacing.x);
    this.rotationMatrix = Matrix3D.rotationY(angleFacing.y).mult(this.rotationMatrix);
    this.rotationMatrix = Matrix3D.rotationZ(angleFacing.z).mult(this.rotationMatrix);    
  }

  public void rotateTo(Vector3D angleFacing) {
    this.angleFacing = angleFacing;
    rebuildVerticesFromRotation();
  }
  
  public void spin(Vector3D rotation) {
    this.angleFacing = Vector3D.add(this.angleFacing, rotation);
    rebuildVerticesFromRotation();
  }
  
  public void rebuildVerticesFromRotation() {
    buildRotationMatrix();    
    buildVertices();    
    for (int i = 0; i < vertices.length; i++) {
      vertices[i] = rotationMatrix.mult(vertices[i]);
    }        
  }
  
  public Cube clone() {
    return new Cube(this.location, this.dimensions, this.angleFacing);
  }
}

class CubeArray {
  Cube[] cubes;
  
  CubeArray(int count, Vector3D location, Vector3D dimensions, Vector3D angleFacing) {
    cubes = new Cube[count];
    cubes[0] = new Cube(location, dimensions, angleFacing);
  }
  
  public void iterate(Vector3D nudge, Vector3D shift, Vector3D spin) {
    for (int i = 1; i < cubes.length; i++) {
      cubes[i] = cubes[i-1].clone();
      cubes[i].nudge(nudge);
      cubes[i].shift(shift);
      cubes[i].spin(spin);
    }
  }
  
  public void iterateNudge(float x, float y, float z) {
    for (int i = 1; i < cubes.length; i++) {
      cubes[i] = cubes[i-1].clone();
      cubes[i].nudge(new Vector3D(x, y, z));
    }    
  }
  
  public void draw() {
    for (int i = 0; i < cubes.length; i++)
      if (cubes[i] != null)
        cubes[i].draw();
    }
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
    p.textFont(p.createFont("Arial-Bold", 12), 12);
    p.text("fps: " + frameRate(), 6, 14);    
  }
}




class Snake {
  OscP5 oscP5;
  
  Snake(PGraphics3D g, PApplet applet) {
    cubes = new CubeArray(100, new Vector3D(0, 0, 0), new Vector3D(50, 50, 50), new Vector3D(0, 0, 0));
    // Remember PGraphics3D transformation matrix
    
//    snakeGui = new SnakeGUI(cam, (PGraphics3D) g);
//    snakeGui.setup(applet);
    
    oscP5 = new OscP5(applet, 12000);
    oscP5.plug(cubes, "iterateNudge", "/nudge");
  }
  
  public void draw() {  
    background(0);
    lights();

//    cubes.iterate(snakeGui.nudgeVector(), snakeGui.shiftVector(), snakeGui.angleVector()); 

    cubes.draw();
//    snakeGui.draw();
  }
}

class SnakeGUI {
  PeasyCam cam;
  float[] rotations = new float[3];
  
  PGraphics3D g3;
  
  GPanel panel;
  GHorzSlider angleXSlider, angleYSlider, angleZSlider;
  GHorzSlider nudgeXSlider, nudgeYSlider, nudgeZSlider;
  GHorzSlider shiftXSlider, shiftYSlider, shiftZSlider;
  
  SnakeGUI(PeasyCam cam, PGraphics3D g3){
    this.cam   = cam;
    this.g3    = g3;
    this.panel = panel;
  }
  
  public void setup(PApplet applet) {
    GComponent.globalColor = GCScheme.getColor(applet,  GCScheme.GREY_SCHEME);
    GComponent.globalFont = GFont.getFont(applet, "Serif", 11);
  
    panel = new GPanel(applet, "Boxes Control Panel", 30, 30, 500, 180);
    panel.setAlpha(192);
  
    panel.add(new GLabel(applet, "X Angle", 2, 0, 120));
    angleXSlider = new GHorzSlider(applet, 125, 0, 325, 10);
    angleXSlider.setLimits(180,0,360);
    angleXSlider.setInertia(0);
    panel.add(angleXSlider);
    
    panel.add(new GLabel(applet, "Y Angle", 2, 16, 120));
    angleYSlider = new GHorzSlider(applet, 125, 16, 325, 10);
    angleYSlider.setLimits(180,0,360);
    angleYSlider.setInertia(0);
    panel.add(angleYSlider);
    
    panel.add(new GLabel(applet, "Z Angle", 2, 32, 120));
    angleZSlider = new GHorzSlider(applet, 125, 32, 325, 10);
    angleZSlider.setLimits(180,0,360);
    angleZSlider.setInertia(0);
    panel.add(angleZSlider);
  
    panel.add(new GLabel(applet, "X Nudge", 2, 48, 120));
    nudgeXSlider = new GHorzSlider(applet, 125, 48, 325, 10);
    nudgeXSlider.setLimits(0,-100,100);
    nudgeXSlider.setInertia(0);
    panel.add(nudgeXSlider);
  
    panel.add(new GLabel(applet, "Y Nudge", 2, 64, 120));
    nudgeYSlider = new GHorzSlider(applet, 125, 64, 325, 10);
    nudgeYSlider.setLimits(0,-100,100);
    nudgeYSlider.setInertia(0);
    panel.add(nudgeYSlider);
  
    panel.add(new GLabel(applet, "Z Nudge", 2, 80, 120));
    nudgeZSlider = new GHorzSlider(applet, 125, 80, 325, 10);
    nudgeZSlider.setLimits(0,-100,100);
    nudgeZSlider.setInertia(0);
    panel.add(nudgeZSlider);
    
    panel.add(new GLabel(applet, "X Shift", 2, 96, 120));
    shiftXSlider = new GHorzSlider(applet, 125, 96, 325, 10);
    shiftXSlider.setLimits(0,-100,100);
    shiftXSlider.setInertia(0);
    panel.add(shiftXSlider);
  
    panel.add(new GLabel(applet, "Y Shift", 2, 112, 120));
    shiftYSlider = new GHorzSlider(applet, 125, 112, 325, 10);
    shiftYSlider.setLimits(0,-100,100);
    shiftYSlider.setInertia(0);
    panel.add(shiftYSlider);
  
    panel.add(new GLabel(applet, "Z Shift", 2, 128, 120));
    shiftZSlider = new GHorzSlider(applet, 125, 128, 325, 10);
    shiftZSlider.setLimits(0,-100,100);
    shiftZSlider.setInertia(0);
    panel.add(shiftZSlider);
  }
  
  public void draw() {
    if (panel.isCollapsed()) {
      cam.setMouseControlled(!panel.isDragging());
    } 
    else {
      cam.setMouseControlled(false);  
    }  
  
    rotations = cam.getRotations();
    PMatrix3D currCameraMatrix = new PMatrix3D(g3.camera);
    camera();
    G4P.draw();
    g3.camera = currCameraMatrix;
  }

  public Vector3D nudgeVector() {
    return new Vector3D(nudgeXSlider.getValue(), nudgeYSlider.getValue(), nudgeZSlider.getValue());
  }
  
  public Vector3D shiftVector() {
    return new Vector3D(shiftXSlider.getValue(), shiftYSlider.getValue(), shiftZSlider.getValue());
  }
  
  public Vector3D angleVector() {
    float angleX, angleY, angleZ;
    angleX = angleXSlider.getValue()*PI/360;
    angleY = angleYSlider.getValue()*PI/360;
    angleZ = angleZSlider.getValue()*PI/360;
    
    return new Vector3D(angleX, angleY, angleZ);
  }
}

  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#E2E2E2", "TheSnake" });
  }
}
