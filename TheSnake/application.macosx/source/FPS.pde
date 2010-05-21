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

