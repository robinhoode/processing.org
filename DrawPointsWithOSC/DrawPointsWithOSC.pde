import processing.opengl.*;

final static int GRIP_SIZE       = 3;
final static int INFO_BAR_HEIGHT = 24;
final static int ICON_SIZE       = 32;

final static int NO_SELECT_MODE = 0;
final static int DRAG_GRIP_MODE = 1;
final static int CREATE_SELECTOR_MODE = 2;  

final static int ADD_POINTS_MODE    = 0;
final static int SELECT_POINTS_MODE = 1;

final static int MOUSE_MODE_HIGHLIGHT = 150;
final static int MOUSE_MODE_DIM       = 60;
final static int MOUSE_MODE_ALPHA     = 60;

int lastMouseX, lastMouseY;

HelpMenu helpMenu;

void setup() {  
  size(1350, 600, OPENGL);
//  frame.setResizable(true);


  String[] helpText = {
    "Points Timeline: This processing.org script lets you create a timeline for values. It is mainly for timing the locations of objects specifically for syncing the behavior",
    "of objects with music.",
    "",
    "Add mode    : When in 'Add mode', you click the mouse to create points from left to right. You cannot select points in this mode.",
    "Select mode : Move the points by dragging them, or selecting multiple points and dragging them simultaneously. Use the arrow keys to nudge them into place.",
    "Play mode   : A blue cursor will show up. This cursor will scroll from left to right and will change the values at the bottom, which can then be hooked up to your script.",
    "",
    "Read the README for more information"
  };
  
  println("width is " + width);

  helpMenu = new HelpMenu(helpText);  
  textFont(loadFont("CourierNewPSMT-12.vlw"), 12);
  
  GlobalMouseHandler.register(this);
  GlobalLanesHandler.register(this);
  
  GlobalLanesHandler inst = GlobalLanesHandler.inst;
  inst.lanes    = new Lane[4];
  
  for (int i = 0; i < inst.lanes.length; i++) {
    Rect boundary = new Rect(0, INFO_BAR_HEIGHT + i*height/4, width, INFO_BAR_HEIGHT + (i+1)*height/4);
    inst.lanes[i] = new Lane(this, boundary);
  }
}

void draw() {
  background(0);
  if (helpMenu.showing)
    helpMenu.draw();
  else {
    GlobalLanesHandler.draw();
    GlobalMouseHandler.draw();
  }
}

void mousePressed() {
  helpMenu.showing = false;
  
  GlobalLanesHandler.mousePressed(new PVector(mouseX, mouseY));
  
  lastMouseX = mouseX;
  lastMouseY = mouseY;    
}

void mouseReleased() {
  
  GlobalLanesHandler.mouseReleased(new PVector(mouseX, mouseY));
}

void mouseDragged() {
  PVector mouseVector = new PVector(mouseX, mouseY),
          mouseDelta  = new PVector(mouseX - lastMouseX, mouseY - lastMouseY);
  
  GlobalLanesHandler.mouseDragged(mouseVector, mouseDelta);
  
  lastMouseX = mouseX;
  lastMouseY = mouseY;  
}

void keyPressed() {
  GlobalLanesHandler.keyPressed(key, keyCode);
  
  if (key == '1')
    GlobalMouseHandler.addPointsMode();
  if (key == '2')
    GlobalMouseHandler.selectPointsMode();
}
