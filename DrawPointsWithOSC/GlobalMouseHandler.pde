static class GlobalMouseHandler {
  static int mouseMode;  

  static GlobalMouseHandler inst;
  static PImage selectorTool, additionTool;  
  static PApplet applet;

  static GlobalMouseHandler register(PApplet applet) {
    if (inst == null) {
      inst = new GlobalMouseHandler();
      inst.setup(applet);
    }
    return inst;
  }
  
  static GlobalMouseHandler getInstance() {
    return inst;
  }
  
  static void setup(PApplet applet) {
    inst.applet       = applet;
    inst.mouseMode    = ADD_POINTS_MODE;
    inst.selectorTool = applet.loadImage("selection.png");
    inst.additionTool = applet.loadImage("add.png"); 
  }

  // For drawing the mouse mode
  static void draw() {
    drawInfoBar();
    drawTools();        
  }
  
  static void drawInfoBar() {
    inst.applet.fill(30, 125);
    inst.applet.noStroke();
    inst.applet.rect(0, 0, inst.applet.width, INFO_BAR_HEIGHT);    
  }
  
  static void drawTools() {
    PApplet a = inst.applet;
    
    if (inst.mouseMode == SELECT_POINTS_MODE)
      a.fill(MOUSE_MODE_HIGHLIGHT, MOUSE_MODE_ALPHA);
    else
      a.fill(MOUSE_MODE_DIM, MOUSE_MODE_ALPHA);
    a.rect(a.width-ICON_SIZE, 0, ICON_SIZE, INFO_BAR_HEIGHT);
    a.image(inst.selectorTool, a.width-ICON_SIZE, -4);

    if (inst.mouseMode == ADD_POINTS_MODE)
      a.fill(MOUSE_MODE_HIGHLIGHT, MOUSE_MODE_ALPHA);
    else
      a.fill(MOUSE_MODE_DIM, MOUSE_MODE_ALPHA);
    a.rect(a.width-ICON_SIZE*2, 0, ICON_SIZE, INFO_BAR_HEIGHT);
    a.image(inst.additionTool, a.width-ICON_SIZE*2, -4);    
  }
  
  static void addPointsMode() {
    GlobalLanesHandler.deselectAllPoints();
    inst.mouseMode = ADD_POINTS_MODE;
  }
  
  static void selectPointsMode() {
    inst.mouseMode = SELECT_POINTS_MODE;     
  }
  
  static void switchMode() {
    switch (inst.mouseMode) {
    case ADD_POINTS_MODE:
      inst.selectPointsMode();
      break;
    case SELECT_POINTS_MODE:
      inst.addPointsMode(); 
      break;
    }
  }
}
