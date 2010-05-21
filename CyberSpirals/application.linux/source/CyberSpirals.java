import processing.core.*; 
import processing.xml.*; 

import processing.opengl.*; 
import javax.media.opengl.*; 
import peasy.*; 
import java.lang.*; 
import java.lang.reflect.*; 
import ddf.minim.*; 
import sojamo.drop.*; 

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

public class CyberSpirals extends PApplet {


 







PeasyCam cam;

ArrayList boxes;
final static int BOX_COUNT = 35;

Tunnel tunnel;

SDrop drop;

Minim minim;
AudioPlayer groove;

PGraphics3D g3;

public void setup() {
  size(800, 600, OPENGL);
  
  g3 = (PGraphics3D) g;    
  cam = new PeasyCam(this, width);

  FPS.register(this);
  
  tunnel = new Tunnel();
  
  boxes = new ArrayList();
  for (int i = 0; i < BOX_COUNT; i++)
    boxes.add(new Box());
    
  minim = new Minim(this);  
//  FileChooser chooser = new FileChooser();
  drop = new SDrop(this);
}

public void draw() {
  background(0);
  tunnel.draw();
  Box box;
  for (int i = 0; i < boxes.size(); i++) {
    box = (Box) boxes.get(i);
    box.draw();
    if (box.location.z > 1000) {
      boxes.remove(box);
      boxes.add(new Box());
    }
  }
  
  PMatrix3D currCameraMatrix = new PMatrix3D(g3.camera);
  camera();
  FPS.draw(this); 
  g3.camera = currCameraMatrix;
}


public float currentLevel() {
  if (groove != null)
    return groove.left.level();
  else
    return 0;
}

public void dropEvent(DropEvent dropEvent) {
  if (groove != null && groove.isPlaying())
    groove.pause();
  
  if (dropEvent.isFile()) {
    groove = minim.loadFile(dropEvent.file().getPath(), 2048);
    groove.play();
  }  
}

class Box {
  Vector3D location;
  float speed = 10;
  int boxColor;
  float angle, distance;
  
  Box() {
    this.location = new Vector3D(randomX(), randomY(), -1200);
    this.boxColor = randomColor();
    this.speed    = randomSpeed();
    this.angle    = atan2((float) location.y, (float) location.x);
    this.distance = sqrt(pow((float) location.x, 2) + pow((float) location.y, 2));
  }
  
  public float randomX() {
    float value = random(-200, 200);    
    if (value > 0)
      return value + 10;
    else if (value < 0)
      return value - 10;    
    else 
      return randomX();
  }
  
  public float randomY() {
    float value = random(-200, 200);    
    if (value > 0)
      return value + 10;
    else if (value < 0)
      return value - 10;    
    else 
      return randomY();
  }
  
  public int randomColor() {
    return color(random(0, 255), random(0, 255), random(0, 255));
  }
  
  public float randomSpeed() {
    return random(10, 25);
  }
  
  public Matrix3D orientationMatrix() {
    double angle = (double) atan2((float) location.x, (float) location.y);
    return Matrix3D.rotateX(angle).mult(Matrix3D.rotateY(angle));
  }
  
  public void vertexAt(float x, float y, float z) {
//    Vector3D offset = orientationMatrix().mult(new Vector3D(x, y, z)).add(location);    
//    Vector3D offset = new Vector3D(x, y, z).add(location);
//    vertex((float) offset.x, (float) offset.y, (float) offset.z);
    vertex(x, y, z);
  }
  
  public float boxSize() {
    return currentLevel()*80;
//    return 40;
  }
  
  public void drawLeftWall() {
    // Left wall        
    vertexAt(-boxSize(), boxSize(), boxSize());
    vertexAt(-boxSize(), boxSize(), -boxSize());
    vertexAt(-boxSize(), -boxSize(), -boxSize());
    vertexAt(-boxSize(), -boxSize(), boxSize());    
  }
  
  public void drawRightWall() {
    // Right wall
    vertexAt(boxSize(), boxSize(), boxSize());
    vertexAt(boxSize(), boxSize(), -boxSize());
    vertexAt(boxSize(), -boxSize(), -boxSize());
    vertexAt(boxSize(), -boxSize(), boxSize());
  }
  
  public void drawFrontWall() {
    // Front wall
    vertexAt(boxSize(), boxSize(), boxSize());
    vertexAt(-boxSize(), boxSize(), boxSize());  
    vertexAt(-boxSize(), -boxSize(), boxSize());    
    vertexAt(boxSize(), -boxSize(), boxSize());     
  }
  
  public void drawBackWall() {
    // Back wall
    vertexAt(boxSize(), boxSize(), -boxSize());
    vertexAt(-boxSize(), boxSize(), -boxSize());  
    vertexAt(-boxSize(), -boxSize(), -boxSize());    
    vertexAt(boxSize(), -boxSize(), -boxSize());     
  }
  
  public void drawBottomAndTopWall() {
    // Bottom and top wall
    vertexAt(boxSize(), boxSize(), boxSize());
    vertexAt(boxSize(), boxSize(), -boxSize());  
    vertexAt(-boxSize(), boxSize(), -boxSize());    
    vertexAt(-boxSize(), boxSize(), boxSize());     
  }

  public void computeAngle() {
    angle = atan2((float) location.y, (float) location.x) + PI/48;    
  }
  
  public void updateLocation() {
    location.z += speed;
    
    computeAngle();
    location.x = distance*cos(angle);
    location.y = distance*sin(angle);
  }
  
  public void vertices() {
    pushMatrix();       
    beginShape(QUADS);
        
    drawLeftWall();
    drawRightWall();
    drawFrontWall();
    drawBackWall();
    drawBottomAndTopWall();

    translate((float) location.x, (float) location.y, (float) location.z);
    rotateX(angle);
    rotateY(angle);
    
    endShape();
    popMatrix();
  }
  
  public void draw() {
    updateLocation();
    stroke(boxColor);
    fill(0);
    vertices();    
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
    p.textFont(p.createFont("Arial-Bold", 12), 12);
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
    p.stroke(255);
    p.fill(255);
    p.textFont(FPS.font, 12);
    p.text("fps: " + frameRate(), 6, 14);    
  }  
}

class Tunnel {
  float tunnelWidth, tunnelStart, 
        tunnelEnd,   tunnelDepth, 
        arcStep,     iterStep;
  float angle;
  
  Tunnel() {
    tunnelWidth = 300;
    tunnelStart = -1200;
    tunnelEnd   = 600;
    tunnelDepth = tunnelEnd - tunnelStart;
    arcStep     = PI/128;
    iterStep    = 50;
    angle       = 0;
  }
  
  public void drawCircles() {
    for (float i = tunnelStart; i < tunnelEnd; i += 50) {
      stroke(0, 0, 255*(i - tunnelStart)/(float)tunnelDepth);
//      stroke(0, 0, 255);
      noFill();      
      beginShape();
      for (float a = 0; a < 2*PI; a += arcStep) {  
        vertex(tunnelWidth*cos(a), tunnelWidth*sin(a), i);
      }
      endShape(CLOSE);
    }    
  }
  
  public void drawSpiral() {
    stroke(0, 0, 255);
    noFill();          
    beginShape();
    float a = 0;
    for (float i = tunnelStart; i < tunnelEnd; i += 0.25f, a += PI/128) {
      vertex(tunnelWidth*cos(a), tunnelWidth*sin(a), i);
    }

    endShape();
  }
  
  public void drawLengths() {
    stroke(0, 0, 255);
    beginShape(LINES);
    for (float a = 0; a < 2*PI; a += PI/12) {
      vertex(tunnelWidth*cos(a), tunnelWidth*sin(a), tunnelStart);
      vertex(tunnelWidth*cos(a), tunnelWidth*sin(a), tunnelEnd);
    }
    rotate();
    endShape();
  }
    
  public void rotate() {
    angle += PI/256;
    rotateZ(angle);
  }
  
  public void draw() {
//    drawCircles();
    pushMatrix();
    drawSpiral();
    drawLengths(); 
    rotate();
    popMatrix();
  }
}

  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#E2E2E2", "CyberSpirals" });
  }
}
