class Line {
  int pointBuffer = 7;  
  int gripSize = GRIP_SIZE;
  
  PApplet          applet;
  ArrayList        points;
  Lane             lane;
  
  Line (PApplet applet, Lane lane) {
    this.applet    = applet;
    this.lane      = lane;
    points         = new ArrayList();
  }
   
  void add(PVector point) {
    points.add(new LinePoint(point, this));
  }
  
  void add(int i, PVector point) {
    points.add(i, new LinePoint(point, this));    
  }
  
  LinePoint get(int i) {
    return (LinePoint) points.get(i); 
  }
  
  boolean noPoints() {
    return points.isEmpty();
  }
  
  LinePoint prevPoint(LinePoint point) {
    return get(points.indexOf(point)-1);
  }
  
  LinePoint nextPoint(LinePoint point) {
    return get(points.indexOf(point)+1);
  }
    
  float findLowerLimit(LinePoint point) {
    if (point != firstPoint()) {
      // Dont come within pointBuffer pixels from the previous point
      return prevPoint(point).point.x+pointBuffer;
    } else {
      return 0;
    }
  }

  float findUpperLimit(LinePoint point) {
    if (point != lastPoint()) {
      // Dont come within pointBuffer pixels from the next point      
      return nextPoint(point).point.x-pointBuffer;
    } else {
      return width;
    }
  }
  
  LinePoint lastPoint() {
    return (LinePoint) points.get(points.size()-1);
  }
  
  LinePoint firstPoint() {
    return (LinePoint) points.get(0);
  }
  
  void drawLine(LinePoint first, LinePoint second) {   
    line((float) first.point.x,  (float) first.point.y,
         (float) second.point.x, (float) second.point.y); 
  }
  
  void drawLineSegments() {
    stroke(255);
    for (int i = 1; i < points.size(); i++) {
      drawLine(get(i-1), get(i));
    }
  }
  
  void drawGrips() {
    for (int i = 0; i < points.size(); i++) {
      get(i).drawGrip();
    }
  }
}
