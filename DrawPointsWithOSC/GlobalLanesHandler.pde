static class GlobalLanesHandler {
  static Lane[] lanes;
  static PApplet applet;
  static GlobalLanesHandler inst;
  
  static void register(PApplet applet) {
    inst = new GlobalLanesHandler();
    inst.applet = applet;
  }
  
  static void setup(PApplet a) {
  }
  
  static void deselectAllPoints() {
    for (int i = 0; i < inst.lanes.length; i++)
      lanes[i].deselectAllPoints();
  }
  
  static void draw() {
    for (int i = 0; i < inst.lanes.length; i++)
      inst.lanes[i].draw();
  }

  static void mousePressed(PVector mouseVector) {
    for (int i = 0; i < inst.lanes.length; i++)
      inst.lanes[i].mouseHandler.mousePressed(mouseVector);    
  }
  
  static void mouseReleased(PVector mouseVector) {
    for (int i = 0; i < inst.lanes.length; i++)
      inst.lanes[i].mouseHandler.mouseReleased(mouseVector);    
  }
  
  static void mouseDragged(PVector mouseVector, PVector mouseDelta) {
    for (int i = 0; i < inst.lanes.length; i++)  
      inst.lanes[i].mouseHandler.mouseDragged(mouseVector, mouseDelta);    
  }
  
  static void keyPressed(char key, int keyCode) {
    for (int i = 0; i < inst.lanes.length; i++)
      inst.lanes[i].keyPressed(key, keyCode);    
  }
}
