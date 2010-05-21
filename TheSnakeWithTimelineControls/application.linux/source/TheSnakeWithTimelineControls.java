import processing.core.*; 
import processing.xml.*; 

import processing.opengl.*; 

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

public class TheSnakeWithTimelineControls extends PApplet {



PFrame f;
TimelineApplet s;

public void setup() {
  size(320, 240, OPENGL);
  PFrame f = new PFrame();

}

public void draw() {
  background(255,0,0);
  fill(255);
  rect(10,10,frameCount%100,10);
  s.redraw();
}

public class PFrame extends Frame {
  public PFrame() {
    setBounds(100,100,800,600);
    s = new TimelineApplet();
    add(s);
    s.init();
    show();
  }
}

int GRIP_SIZE = 3;

public class TimelineApplet extends PApplet {
  Line line;
  PFont font;
  int lastMouseX, lastMouseY;
  
  public void setup() {
    size(800, 600, OPENGL);
    noLoop();
    
    String fontPath = "C:\\Documents and Settings\\Owner\\dev\\processing\\TheSnakeWithTimelineControls\\data\\CourierNewPSMT-12.vlw";
    this.font = loadFont(fontPath);
    
    line = new Line(this);
  }

  public void draw() {
    background(0);
    line.draw();
  }
    
  public void mousePressed() {
    line.mouseHandler.mousePressed(new PVector(mouseX, mouseY));
    lastMouseX = mouseX;
    lastMouseY = mouseY;    
  }
}
class Line {
  ArrayList linePoints, selectedPoints;
  int pointBuffer = 7;  
  int gripSize = GRIP_SIZE;
  
  LineMouseHandler mouseHandler;
  Timeline timeline;
  TimelineApplet applet;
  
  Line (TimelineApplet applet) {   
    linePoints     = new ArrayList();
    selectedPoints = new ArrayList();
    mouseHandler   = new LineMouseHandler(this);
    timeline       = new Timeline(this, 0, false);
    this.applet    = applet;
  }
  
  public void select(LinePoint point) {
    if (!selectedPoints.contains(point))
      selectedPoints.add(point);
  }
  
  public void selectOnly(LinePoint point) {
    selectedPoints = new ArrayList();
    selectedPoints.add(point);
  }
  
  public void selectNone() {
    selectedPoints = new ArrayList();
  }
  
  public void add(PVector point) {
    linePoints.add(new LinePoint(point, this));
  }
  
  public void add(int i, PVector point) {
    linePoints.add(i, new LinePoint(point, this));    
  }
  
  public LinePoint get(int i) {
    return (LinePoint) linePoints.get(i); 
  }
  
  public boolean noPoints() {
    return linePoints.isEmpty();
  }
  
  public LinePoint prevPoint(LinePoint point) {
    return get(linePoints.indexOf(point)-1);
  }
  
  public LinePoint nextPoint(LinePoint point) {
    return get(linePoints.indexOf(point)+1);
  }
    
  public float findLowerLimit(LinePoint point) {
    if (point != firstPoint()) {
      // Dont come within pointBuffer pixels from the previous point
      return prevPoint(point).point.x+pointBuffer;
    } else {
      return 0;
    }
  }

  public float findUpperLimit(LinePoint point) {
    if (point != lastPoint()) {
      // Dont come within pointBuffer pixels from the next point      
      return nextPoint(point).point.x-pointBuffer;
    } else {
      return applet.width;
    }
  }
  
  public LinePoint lastPoint() {
    return (LinePoint) linePoints.get(linePoints.size()-1);
  }
  
  public LinePoint firstPoint() {
    return (LinePoint) linePoints.get(0);
  }
  
  public void drawLine(LinePoint first, LinePoint second) {
    stroke(255);
    applet.line((float) first.point.x,  (float) first.point.y,
                (float) second.point.x, (float) second.point.y); 
  }
  
  public void draw() {
    drawLineSegments();
    drawGrips();
    timeline.draw();    
    mouseHandler.drawMode();
    mouseHandler.drawSelector();
  }

  public void drawLineSegments() {
    stroke(255);
    for (int i = 1; i < linePoints.size(); i++) {
      drawLine(get(i-1), get(i));
    }
  }
  
  public void drawGrips() {
    for (int i = 0; i < linePoints.size(); i++) {
      get(i).drawGrip();
    }
  }

  public void keyPressed(char key, int keyCode) {
    if (!selectedPoints.isEmpty()) {
      nudgeSelected(keyCode);
    }
    
    if (keyCode == TAB) {
      mouseHandler.switchMode();
    }
    
    timeline.keyPressed(key, keyCode);
  }

  public void nudgeSelected(int keyCode) {  
    if (keyCode == UP)
      nudgeSelected(new PVector( 0, -1));
    if (keyCode == DOWN)
      nudgeSelected(new PVector( 0,  1));
    if (keyCode == LEFT)
      nudgeSelected(new PVector(-1,  0));
    if (keyCode == RIGHT)
      nudgeSelected(new PVector( 1,  0));
  }

  public LinePoint getSelected(int i) {
    return (LinePoint) selectedPoints.get(i);
  }
  
  public void nudgeSelected(PVector nudge) {
    for (int i = 0; i < selectedPoints.size(); i++) {
      getSelected(i).nudge(nudge);
    }    
  }

  public void dragSelected(PVector mouseVector, PVector nudge) {
    for (int i = 0; i < selectedPoints.size(); i++) {
      getSelected(i).drag(mouseVector, nudge);
    }
  }
}
class LineMouseHandler {
  Line line;
  int mouseMode;
  int selectMode;

  final int ADD_POINTS_MODE = 0;
  final int SELECT_POINTS_MODE = 1;

  final int NO_SELECT_MODE = 0;
  final int DRAG_GRIP_MODE = 1;
  final int CREATE_SELECTOR_MODE = 2;

  Rect selectorRect;

  LineMouseHandler(Line line) {
    this.line         = line;
    this.selectorRect = new Rect(line, new PVector(0, 0), new PVector(0, 0));
  }

  public void addOnlyPoint(PVector mouseVector) {
    line.add(mouseVector);
  }

  public boolean rightOfLastPoint(PVector mouseVector) {
    return (mouseVector.x > line.lastPoint().point.x + line.gripSize);
  }

  public boolean leftOfFirstPoint(PVector mouseVector) {
    return (mouseVector.x < line.firstPoint().point.x - line.gripSize);
  }

  public void addFirstPoint(PVector mouseVector) {
    line.add(0, mouseVector);
  }

  public void addLastPoint(PVector mouseVector) {
    line.add(mouseVector);
  }  

  public void addPoints(PVector mouseVector) {
    if (line.noPoints()) {
      addOnlyPoint(mouseVector);
    } 
    else if (rightOfLastPoint(mouseVector)) {
      addLastPoint(mouseVector);
    } 
    else if (leftOfFirstPoint(mouseVector)) {
      addFirstPoint(mouseVector);
    }
  }

  public void selectPoints(PVector mouseVector) {    
    LinePoint linePoint = findCurrentlySelected(mouseVector);

    // If we land on a grip and it's not selected
    if (linePoint != null && !line.selectedPoints.contains(linePoint)) {
      // That becomes the only selected
      line.selectOnly(linePoint);
    } 

    // If we land on one and we have at least one already selected    
    else if (!line.selectedPoints.isEmpty() && linePoint != null) {
      // Go into drag mode
      selectMode = DRAG_GRIP_MODE;
    } 

    // If we don't land on a grip and there are no selected points          
    else if (linePoint == null) {
      // Go into selector rect mode
      line.selectNone();
      selectorRect.point1 = selectorRect.point2 = mouseVector;
      selectMode = CREATE_SELECTOR_MODE;
    }
  }

  public void mousePressed(PVector mouseVector) {
    switch (mouseMode) {
    case ADD_POINTS_MODE:
      addPoints(mouseVector); 
      break;
    case SELECT_POINTS_MODE:
      selectPoints(mouseVector); 
      break;
    }
  }

  public void mouseReleased(PVector mouseVector) {
    selectMode = NO_SELECT_MODE;
  }

  public LinePoint findCurrentlySelected(PVector mouseVector) {
    LinePoint linePoint;
    for (int i = 0; i < line.linePoints.size(); i++) {
      linePoint = line.get(i);
      if (linePoint.mouseWithinGrip(mouseVector)) {
        return linePoint;
      }
    }
    return null;    
  }  

  public void mouseDragged(PVector mouseVector, PVector mouseDelta) {
    println("Mouse delta is " + mouseDelta);

    switch (mouseMode) {
    case SELECT_POINTS_MODE:
      if (selectMode == CREATE_SELECTOR_MODE) {
        updateSelectorRect(mouseDelta);
      } 
      else if (!line.selectedPoints.isEmpty()) {
        line.dragSelected(mouseVector, mouseDelta);
        selectMode = DRAG_GRIP_MODE;
      }          
      break;
    case ADD_POINTS_MODE:
      break;
    }
  }

  public void updateSelectorRect(PVector mouseDelta) {
    selectorRect.point2 = PVector.add(selectorRect.point2, mouseDelta);
    selectMode = CREATE_SELECTOR_MODE;
    line.selectNone();
    for (int i = 0; i < line.linePoints.size(); i++) {
      LinePoint point = line.get(i);
      if (selectorRect.contains(point.point)) 
        line.select(point);
    }
  }

  public void drawSelector() {
    if (selectMode == CREATE_SELECTOR_MODE) {
      stroke(125);
      selectorRect.draw();
    }
  }

  public void drawMode() {
    line.applet.fill(30, 125);
    line.applet.noStroke();
    line.applet.rect(0, 0, width, 24);
    line.applet.fill(255, 125);
    line.applet.textFont(line.applet.font, 12);
    switch (mouseMode) {
    case ADD_POINTS_MODE:
      line.applet.text("Mouse Mode: Add Points (Hit tab to switch)", 6, 16); 
      break;
    case SELECT_POINTS_MODE:
      line.applet.text("Mouse Mode: Select Points (Hit tab to switch)", 6, 16); 
      break;
    }
  }

  public void switchToAddMode() {
    line.selectNone();
    mouseMode = ADD_POINTS_MODE;
  }

  public void switchMode() {
    switch (mouseMode) {
    case ADD_POINTS_MODE:
      mouseMode = SELECT_POINTS_MODE; 
      break;
    case SELECT_POINTS_MODE:
      switchToAddMode(); 
      break;
    }
  }
}


class LinePoint {
  PVector point;
  Line line;
  int gripSize = GRIP_SIZE;
  
  LinePoint(PVector point, Line line) {
    this.point = point;
    this.line  = line;
  }
  
  public boolean mouseWithinGrip(PVector mouse) {
    if (point.x - gripSize <= mouse.x && 
        mouse.x <= point.x + gripSize && 
        point.y - gripSize <= mouse.y && 
        mouse.y <= point.y + gripSize) {
      return true;
    } else {
      return false;
    }
  }  
  
  public void drawGrip() {    
    if (line.selectedPoints.contains(this)) {
      line.applet.fill(255);
    } else {
      line.applet.noFill();
    }
       
    line.applet.stroke(255);
    line.applet.rect((float) (point.x - gripSize), 
                     (float) (point.y - gripSize),
                     (float) gripSize*2,
                     (float) gripSize*2);
  }
  
  public void drag(PVector mouseVector, PVector mouseDelta) {
//    if (insideXLimit(mouseVector))
      nudge(mouseDelta);
  }
  
  public void nudge(PVector nudge) {
    moveTo(new PVector(point.x + nudge.x, point.y + nudge.y));
  }
  
  public boolean insideXLimit(PVector point) {
    return (line.findLowerLimit(this) <= point.x &&
            point.x <= line.findUpperLimit(this));
  }
  
  public void moveTo(PVector loc) {
    float upperLimitX = line.findUpperLimit(this),
          lowerLimitX = line.findLowerLimit(this);
//    println("Moving from " + point);
    point = new PVector(constrain(loc.x, lowerLimitX, upperLimitX), constrain(loc.y, 0, line.applet.height));
//    println(".. to " + point);
  }

}

class Rect {
  PVector point1, point2;
  Line line;

  Rect(Line line, PVector point1, PVector point2) {
    if (point1.x < point2.x) {
      this.point1 = point1;  
      this.point2 = point2;
    } else {
      this.point1 = point2;  
      this.point2 = point1;      
    }
  }
  
  public boolean contains(PVector point) {
    boolean containsX = (point1.x <= point.x && point.x <= point2.x) || 
                        (point2.x <= point.x && point.x <= point1.x);
    boolean containsY = (point1.y <= point.y && point.y <= point2.y) || 
                        (point2.y <= point.y && point.y <= point1.y);
    return containsX && containsY;
  }
  
  public void draw() {
    line.applet.stroke(125);
    line.applet.noFill();
    line.applet.rect(point1.x, point1.y, point2.x - point1.x, point2.y - point1.y);
  }
}

class Timeline {
  int     xLocation;
  boolean playing;
  Line    line;
  PFont   font;
  
  Timeline(Line line, int xLocation, boolean playing) {
    this.font      = font;
    this.line      = line;
    this.xLocation = xLocation;
    this.playing   = playing;
  }
  
  public void draw() {
    drawLine();
    drawText();    
    
    if (xLocation < line.applet.width && playing) {
      update();      
    }
  }
  
  public void drawLine() {
    line.applet.stroke(0, 0, 255);
    line.applet.line(xLocation, 0, xLocation, line.applet.height);    
  }
  
  public void drawText() {
    line.applet.fill(30, 125);
    line.applet.noStroke();
    line.applet.rect(0, line.applet.height-24, line.applet.width, 24);
    line.applet.fill(255, 125);
    line.applet.textFont(line.applet.font, 12);
    line.applet.text("Timeline position : " + xLocation + " Value at position: " + valueAt(xLocation), 6, line.applet.height-10);
  }
  
  public void update() {
    xLocation += 1;
  }
  
  public void play() {
    this.playing = true;
  }
  
  public void pause() {
    this.playing = false;
  }
  
  public void keyPressed(char key, int keyCode) {
    if (key == ' ') {
      if (playing)
        pause();
      else
        play();
    }
    
    if (keyCode == KeyEvent.VK_HOME)
      xLocation = 1;
    if (keyCode == KeyEvent.VK_END)
      xLocation = width;
  }
  
  // TODO: Refactor this somehow..?  
  public float valueAt(int x) {
    LinePoint first, second;
    for (int i = 1; i < line.linePoints.size(); i++) {
      first  = line.get(i-1);
      second = line.get(i);
      
      float x0 = (float) first.point.x;      
      float x1 = (float) second.point.x;
      float y0 = (float) (line.applet.height - first.point.y);
      float y1 = (float) (line.applet.height - second.point.y);
      
      if (x0 == x) return y0;
      if (x1 == x) return y1;
        
      if (x0 <= x && x <= x1) {
        float m = (y1 - y0)/(x1 - x0);
        return m*(x - x0) + y0;
      }      
    }
    return 0;
  }  
}

  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#E2E2E2", "TheSnakeWithTimelineControls" });
  }
}
