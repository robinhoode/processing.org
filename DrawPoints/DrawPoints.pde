import processing.opengl.*;

Line line;
int GRIP_SIZE = 3;

class LinePoint {
  PVector point;
  Line parentLine;
  int gripSize = GRIP_SIZE;
  
  LinePoint(PVector point, Line parentLine) {
    this.point      = point;
    this.parentLine = parentLine;
  }
  
  boolean mouseWithinGrip() {
    if (point.x - gripSize <= mouseX && 
        mouseX <= point.x + gripSize && 
        point.y - gripSize <= mouseY && 
        mouseY <= point.y + gripSize) {
      return true;
    } else {
      return false;
    }
  }  
  
  void drawGrip() {
    if (mousePressed && mouseWithinGrip()) {
      fill(255);
      line.currentlySelected = this;
    } else {
      noFill();
    }
      
    stroke(255);
    rect((float) (point.x - gripSize), 
         (float) (point.y - gripSize),
         (float) gripSize*2,
         (float) gripSize*2);
  }
  
  void drag(float lowerLimitX, float upperLimitX) {
    PVector newLocation = new PVector(mouseX, mouseY);
    
    if (newLocation.x <= lowerLimitX)
      newLocation.x = lowerLimitX;
    if (newLocation.x >= upperLimitX)
      newLocation.x = upperLimitX;
    
    this.point = newLocation;
  }  
}

class Line {  
  ArrayList linePoints, selectedPoints;
  LinePoint currentlySelected;
  int pointBuffer = 5;  
  int gripSize = GRIP_SIZE;
  
  Line () {
    linePoints     = new ArrayList();
    selectedPoints = new ArrayList();
  }
  
  void select(int i) {
    selectedPoints.add(i);
  }
  
  void add(PVector point) {
    linePoints.add(new LinePoint(point, this));
  }
  
  void add(int i, PVector point) {
    linePoints.add(i, new LinePoint(point, this));    
  }
  
  LinePoint get(int i) {
     return (LinePoint) linePoints.get(i); 
  }
  
  LinePoint prevPoint(LinePoint point) {
    return get(linePoints.indexOf(point)-1);
  }
  
  LinePoint nextPoint(LinePoint point) {
    return get(linePoints.indexOf(point)+1);
  }
    
  float findLowerLimit() {
    if (currentlySelected != firstPoint()) {
      // Dont come within pointBuffer pixels from the previous point
      return prevPoint(currentlySelected).point.x+pointBuffer;
    } else {
      return 0;
    }
  }

  float findUpperLimit() {
    if (currentlySelected != lastPoint()) {
      // Dont come within pointBuffer pixels from the next point      
      return nextPoint(currentlySelected).point.x-pointBuffer;
    } else {
      return width;
    }
  }
  
  void mouseDragged() {
    if (currentlySelected != null) {
      currentlySelected.drag(findLowerLimit(), findUpperLimit());
    }
  }
  
  LinePoint lastPoint() {
    return (LinePoint) linePoints.get(linePoints.size()-1);
  }
  
  LinePoint firstPoint() {
    return (LinePoint) linePoints.get(0);
  }

  void addLastPoint() {
    if (mouseX > lastPoint().point.x + gripSize)
      add(new PVector(mouseX, mouseY));
  }
  
  void addFirstPoint() {
    if (mouseX < firstPoint().point.x - gripSize) 
      add(0, new PVector(mouseX, mouseY));
  }

  void mousePressed() {
    currentlySelected = null;
    addLastPoint();
    addFirstPoint();
  }
  
  void drawLine(LinePoint first, LinePoint second) {   
    line((float) first.point.x,  (float) first.point.y,
         (float) second.point.x, (float) second.point.y); 
  }
  
  void draw() {
    drawLineSegments();
    drawGrips();
  }
  
  void drawLineSegments() {
    stroke(255);
    for (int i = 1; i < linePoints.size(); i++) {
      drawLine(get(i-1), get(i));
    }    
  }
  
  void drawGrips() {
    for (int i = 0; i < linePoints.size(); i++) {
      get(i).drawGrip();
    }
  }
}

void setup() {
  size(800, 600, OPENGL);
  line = new Line();
  line.add(new PVector(20, 20));
  line.add(new PVector(50, 50));
  line.add(new PVector(75, 50));
}

void draw() {
  background(0);
  line.draw();
}

void mousePressed() {
  line.mousePressed();
}

void mouseDragged() {
  line.mouseDragged();
}
