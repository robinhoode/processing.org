class Rect {
  PVector point1, point2;
  
  Rect(float x1, float y1, float x2, float y2) {
    this(new PVector(x1, y1), new PVector(x2, y2));
  }

  Rect(PVector point1, PVector point2) {
    if (point1.x < point2.x) {
      this.point1 = point1;  
      this.point2 = point2;
    } else {
      this.point1 = point2;  
      this.point2 = point1;      
    }
  }
  
  boolean contains(PVector point) {
    boolean containsX = (point1.x <= point.x && point.x <= point2.x) || 
                        (point2.x <= point.x && point.x <= point1.x);
    boolean containsY = (point1.y <= point.y && point.y <= point2.y) || 
                        (point2.y <= point.y && point.y <= point1.y);
    return containsX && containsY;
  }
  
  void draw(int grayScale) {
    stroke(grayScale);
    noFill();
    rect(point1.x, point1.y, point2.x - point1.x, point2.y - point1.y);
  }
}

