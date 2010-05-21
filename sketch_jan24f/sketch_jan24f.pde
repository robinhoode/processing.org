import processing.opengl.*;
import javax.media.opengl.*;
import peasy.*;

PeasyCam cam;
PGraphics3D g3;

void setup() {
  size(800, 600, OPENGL);
  cam = new PeasyCam(this, width);
  initGl(g);
  g3 = (PGraphics3D) g;    
  FPS.register(this);

  // Any other initialization here..
}

void draw3D() {
  background(0);
  noStroke();
  fill(0, 0, 255, 10);  
  tint(0, 0, 255, 10);
  sphere(100);

  stroke(0, 0, 255);
  fill(0, 0, 255, 255);
  sphere(90);

  // Cool stuff here..	
}

void draw2D() {
  // Draw 2D Stuff on top of the 3D interface

  FPS.draw(this);
}




/*****************************************
 * draw 2D on top of 3D using PeasyCam   *
 *****************************************/

void draw() {
  draw3D();

  PMatrix3D currCameraMatrix = new PMatrix3D(g3.camera);
  camera();
  draw2D();  
  g3.camera = currCameraMatrix;  
}


/*****************************************
 * Initialize GL                         *
 *****************************************/

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


/*****************************************
 * FPS                                   *
 *****************************************/


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
    p.text("FPS: " + frameRate(), 6, 14);    
  }
}


