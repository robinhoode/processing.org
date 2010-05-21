
class LinePoint {
  PVector point;
  Line parentLine;
  int gripSize = GRIP_SIZE;
  
  LinePoint(PVector point, Line parentLine) {
    this.point      = point;
    this.parentLine = parentLine;
  }
  
  boolean mouseWithinGrip(PVector mouse) {
    if (point.x - gripSize <= mouse.x && 
        mouse.x <= point.x + gripSize && 
        point.y - gripSize <= mouse.y && 
        mouse.y <= point.y + gripSize) {
      return true;
    } else {
      return false;
    }
  }  
  
  void drawGrip() {    
    if (line.selectedPoints.contains(this)) {
      fill(255);
    } else {
      noFill();
    }
       
    stroke(255);
    rect((float) (point.x - gripSize), 
         (float) (point.y - gripSize),
         (float) gripSize*2,
         (float) gripSize*2);
  }
  
  void drag(PVector mouseVector, PVector mouseDelta) {
//    if (insideXLimit(mouseVector))
      nudge(mouseDelta);
  }
  
  void nudge(PVector nudge) {
//    println("Nuding by " + nudge);
    moveTo(new PVector(point.x + nudge.x, point.y + nudge.y));
  }
  
  boolean insideXLimit(PVector point) {
    return (line.findLowerLimit(this) <= point.x &&
            point.x <= line.findUpperLimit(this));
  }
  
  void moveTo(PVector loc) {
    float upperLimitX = line.findUpperLimit(this),
          lowerLimitX = line.findLowerLimit(this);
//    println("Moving from " + point);
    point = new PVector(constrain(loc.x, lowerLimitX, upperLimitX), constrain(loc.y, 0, height));
//    println(".. to " + point);
  }

}

