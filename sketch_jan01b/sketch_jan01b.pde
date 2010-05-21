import processing.opengl.*;

Line line;
int  mouseDragging;

class Line {
  ArrayList points;
  int gripSize = 4;
  
  Line () {
    points = new ArrayList();
  }
  
  void add(PVector point) {
    points.add(point);
  }

  void drawGripBox(PVector point) {
    stroke(255);
    if (mousePressed)
      fill(255);
    else
      noFill();
    rect((float) (point.x - gripSize), 
         (float) (point.y - gripSize),
         (float) gripSize*2,
         (float) gripSize*2);
  }
  
  boolean withinGripSize(PVector point) {
    if (point.x - gripSize <= mouseX && 
        mouseX <= point.x + gripSize && 
        point.y - gripSize <= mouseY && 
        mouseY <= point.y + gripSize) {
      return true;
    } else {
      return false;
    }
  }
  
  int pointBuffer = 5;
  
  float findLowerLimit() {
    float lowerLimitX = 0;
    PVector otherPoint;
    
    if (mouseDragging != 0) {
      otherPoint  = (PVector) points.get(mouseDragging-1);
      lowerLimitX = otherPoint.x+pointBuffer;
    }
    
    return lowerLimitX;
  }
  
  float findUpperLimit() {
    PVector otherPoint;      
    float upperLimitX = width;      
    if (mouseDragging < points.size()-1) {
      otherPoint  = (PVector) points.get(mouseDragging+1);
      upperLimitX = otherPoint.x-pointBuffer;
    }
    return upperLimitX;
  }
  
  void mouseDragged() {
    if (mouseDragging >= 0) {
      PVector newLocation = new PVector(mouseX, mouseY);
      float lowerLimitX = findLowerLimit();
      float upperLimitX = findUpperLimit();
      
      if (newLocation.x <= lowerLimitX)
        newLocation.x = lowerLimitX;
      if (newLocation.x >= upperLimitX)
        newLocation.x = upperLimitX;
      
      points.set(mouseDragging, newLocation);
    }
  }  

  void mousePressed() {
    mouseDragging = -1;
  }
  
  void mouseMoved() {
    mousePressed();
  }

  void drawGrip(PVector point, int i) {
    if (line.withinGripSize(point)) {
      line.drawGripBox(point);
      if (mousePressed)
        mouseDragging = i;
    }    
  }
  
  void draw() {
    stroke(255);
    drawGrip((PVector) points.get(0), 0);
    PVector first, second;
    for (int i = 1; i < points.size(); i++) {      
      first  = (PVector) points.get(i-1);
      second = (PVector) points.get(i);      
      line((float) first.x, (float) first.y, (float) second.x, (float) second.y); 
      drawGrip(second, i);
    }
  }
  
  void drawGrips() {
    mousePressed();
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

void mouseMoved() {
  line.mouseMoved();
}

void mousePressed() {
  line.mousePressed();
}

void mouseDragged() {
  line.mouseDragged();
}
