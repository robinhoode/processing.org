public class Lane {
  Line             line;
  LaneMouseHandler mouseHandler;
  Timeline         timeline;
  ArrayList        selectedPoints, directionals;
  Rect             boundary;
  
  Lane(PApplet applet, Rect boundary) {
    this.line      = new Line(applet, this);
    selectedPoints = new ArrayList();
    createDirectionals();
    
    this.boundary  = boundary;
    mouseHandler   = new LaneMouseHandler(this);
    timeline       = new Timeline(this, 1, false);
  }
  
  float upperLimitY() {
    return boundary.point2.y;
  }
  
  float lowerLimitY() {
    return boundary.point1.y;
  }
  
  void drawBorder() {
    boundary.draw(255);
  }
  
  void draw() {
    drawBorder();
    line.drawLineSegments();
    line.drawGrips();
    timeline.draw();    
    mouseHandler.drawSelector();
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
  
  void keyPressed(char key, int keyCode) {
    if (!selectedPoints.isEmpty()) {
      if (directionals.contains(keyCode));
        nudgeSelected(keyCode);
      if (keyCode == BACKSPACE || keyCode == DELETE)
        deleteSelected();
    }
      
    timeline.keyPressed(key, keyCode);
  }

  void createDirectionals() {  
    directionals = new ArrayList(); 
    directionals.add(UP);
    directionals.add(DOWN);
    directionals.add(LEFT);
    directionals.add(RIGHT); 
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
  
  void select(LinePoint point) {
    if (!selectedPoints.contains(point))
      selectedPoints.add(point);
  }
  
  void selectOnly(LinePoint point) {
    selectedPoints = new ArrayList();
    selectedPoints.add(point);
  }
  
  void deselectAllPoints() {
    selectedPoints = new ArrayList();
  }
  
  void deleteSelected() {
    for (int i = 0; i < selectedPoints.size(); i++) {
      line.points.remove(selectedPoints.get(i));
    }
    deselectAllPoints();
  } 
  
  boolean isNoneSelected() {
    return selectedPoints.isEmpty();
  }
}
