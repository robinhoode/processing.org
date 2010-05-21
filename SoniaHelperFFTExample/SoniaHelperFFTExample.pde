// Demonstrates sound input. Download and install Sonia
// from http://sonia.pitaru.com before running.

import processing.opengl.*;
import pitaru.sonia_v2_9.*;

float level;

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
    p.textFont(FPS.font, 12);
    p.text("fps: " + frameRate(), 6, 14);    
  }  
}

PVector backgroundColor;
PFont bigFont;

void setup(){
  size(512, 400, OPENGL);
  FPS.register(this);

  // Start Sonia engine.
  Sonia.start(this); 
   
  // Start LiveInput and return 256 FFT frequency bands.
  LiveInput.start(width); 
//  LiveInput.useEqualizer(true);
   
  backgroundColor = new PVector(255, 0, 0);
   
  bigFont = createFont("Arial-Bold", 48);  
  textFont(bigFont, 48);
}



void draw() {
  background(0);
  
  LiveInput.getSpectrum();
  
  noStroke();
  fill(backgroundColor.x, backgroundColor.y, backgroundColor.z);

  float totalLevel = 0;


  backgroundColor = new PVector(255, 0, 0);
  for(int i = 0; i < 512; i++) {
    level=LiveInput.spectrum[i]/10;
    rect(i,height-(level), 1,level);
    
    if (level > (height - mouseY)) {
      textFont(bigFont, 36);
      text("BEAT!", 40, 40);
      backgroundColor = new PVector(0, 0, 255);
    }    
    totalLevel += level;
  }

  
  stroke(0, 0, 255);
  line(0, mouseY, width, mouseY);

  FPS.draw(this);  
}
