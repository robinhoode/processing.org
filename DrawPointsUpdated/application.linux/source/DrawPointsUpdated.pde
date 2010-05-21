/*
 * Current functionality:
 *  - Drag grips
 *  - Create new grips on left and right sides
 *  - If there are no points, first click adds
 *    a new point
 *  - Clicking on a grip selects, clicking anywhere
 *    else deselects
 *  - After selecting a grip, the arrow keys "nudge"
 *    the grip to a specific point
 *  - Select and drag multiple grips
 *    (Still somewhat buggy, but not that bad)
 *
 * TODO:
 *  - Scaling mechanism
 *  - 
 */


Line line;
HelpMenu helpMenu;
import processing.opengl.*;
int GRIP_SIZE = 3;

int lastMouseX, lastMouseY;

void setup() {
  size(1300, 400, OPENGL);
//  frame.setResizable(true);
  line = new Line();

  String[] helpText = {
    "Script Name : Points Timeline",
    "",
    "Description: This processing.org script lets you create a timeline for values. It is mainly for timing the locations of objects,",
    "specifically for syncing the behavior of objects with music.",
    "",
    "Add mode : When in 'Add mode', you click the mouse to create points from left to right. You cannot select points in this mode.",
    "",
    "Select mode : Move the points by dragging them, or selecting multiple points and dragging them simultaneously. Use the arrow keys to nudge them into place.",    
    "",
    "Play mode: A blue cursor will show up. This cursor will scroll from left to right and will change the values at the bottom, which can then be hooked up to",
    "your script.",
    "",
    "Controls",
    " * Space Bar  - Move the blue cursor from left to right. Hit space again to pause it.",
    " * Home Key   - Move the blue cursor back to start",
    " * End  Key   - Move the blue cursor back to the end",
    " * Arrow Keys - If you have points selected, the arrow keys will nudge them into place.",
  };

  helpMenu = new HelpMenu(helpText);
  
  textFont(loadFont("CourierNewPSMT-12.vlw"), 12);
}

void draw() {
  background(0);
  if (helpMenu.showing)
    helpMenu.draw();
  else
    line.draw();
}

void mousePressed() {
  helpMenu.showing = false;  
  line.mouseHandler.mousePressed(new PVector(mouseX, mouseY));
  lastMouseX = mouseX;
  lastMouseY = mouseY;    
}

void mouseReleased() {
  line.mouseHandler.mouseReleased(new PVector(mouseX, mouseY));
}

void mouseDragged() {
  line.mouseHandler.mouseDragged(new PVector(mouseX, mouseY),
                                 new PVector(mouseX - lastMouseX, mouseY - lastMouseY));
  lastMouseX = mouseX;
  lastMouseY = mouseY;  
}

void keyPressed() {
  line.keyPressed(key, keyCode);
}
