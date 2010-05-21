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
  
  void select(LinePoint point) {
    if (!selectedPoints.contains(point))
      selectedPoints.add(point);
  }
  
  void selectOnly(LinePoint point) {
    selectedPoints = new ArrayList();
    selectedPoints.add(point);
  }
  
  void selectNone() {
    selectedPoints = new ArrayList();
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
  
  boolean noPoints() {
    return linePoints.isEmpty();
  }
  
  LinePoint prevPoint(LinePoint point) {
    return get(linePoints.indexOf(point)-1);
  }
  
  LinePoint nextPoint(LinePoint point) {
    return get(linePoints.indexOf(point)+1);
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
      return applet.width;
    }
  }
  
  LinePoint lastPoint() {
    return (LinePoint) linePoints.get(linePoints.size()-1);
  }
  
  LinePoint firstPoint() {
    return (LinePoint) linePoints.get(0);
  }
  
  void drawLine(LinePoint first, LinePoint second) {
    stroke(255);
    applet.line((float) first.point.x,  (float) first.point.y,
                (float) second.point.x, (float) second.point.y); 
  }
  
  void draw() {
    drawLineSegments();
    drawGrips();
    timeline.draw();    
    mouseHandler.drawMode();
    mouseHandler.drawSelector();
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

  void keyPressed(char key, int keyCode) {
    if (!selectedPoints.isEmpty()) {
      nudgeSelected(keyCode);
    }
    
    if (keyCode == TAB) {
      mouseHandler.switchMode();
    }
    
    timeline.keyPressed(key, keyCode);
  }

  void nudgeSelected(int keyCode) {  
    if (keyCode == UP)
      nudgeSelected(new PVector( 0, -1));
    if (keyCode == DOWN)
      nudgeSelected(new PVector( 0,  1));
    if (keyCode == LEFT)
      nudgeSelected(new PVector(-1,  0));
    if (keyCode == RIGHT)
      nudgeSelected(new PVector( 1,  0));
  }

  LinePoint getSelected(int i) {
    return (LinePoint) selectedPoints.get(i);
  }
  
  void nudgeSelected(PVector nudge) {
    for (int i = 0; i < selectedPoints.size(); i++) {
      getSelected(i).nudge(nudge);
    }    
  }

  void dragSelected(PVector mouseVector, PVector nudge) {
    for (int i = 0; i < selectedPoints.size(); i++) {
      getSelected(i).drag(mouseVector, nudge);
    }
  }
}
