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
    this.selectorRect = new Rect(new PVector(0, 0), new PVector(0, 0));
  }

  void addOnlyPoint(PVector mouseVector) {
    line.add(mouseVector);
  }

  boolean rightOfLastPoint(PVector mouseVector) {
    return (mouseVector.x > line.lastPoint().point.x + line.gripSize);
  }

  boolean leftOfFirstPoint(PVector mouseVector) {
    return (mouseVector.x < line.firstPoint().point.x - line.gripSize);
  }

  void addFirstPoint(PVector mouseVector) {
    line.add(0, mouseVector);
  }

  void addLastPoint(PVector mouseVector) {
    line.add(mouseVector);
  }  

  void addPoints(PVector mouseVector) {
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

  void selectPoints(PVector mouseVector) {    
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

  void mousePressed(PVector mouseVector) {
    switch (mouseMode) {
    case ADD_POINTS_MODE:
      addPoints(mouseVector); 
      break;
    case SELECT_POINTS_MODE:
      selectPoints(mouseVector); 
      break;
    }
  }

  void mouseReleased(PVector mouseVector) {
    selectMode = NO_SELECT_MODE;
  }

  LinePoint findCurrentlySelected(PVector mouseVector) {
    LinePoint linePoint;
    for (int i = 0; i < line.linePoints.size(); i++) {
      linePoint = line.get(i);
      if (linePoint.mouseWithinGrip(mouseVector)) {
        return linePoint;
      }
    }
    return null;    
  }  

  void mouseDragged(PVector mouseVector, PVector mouseDelta) {
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

  void updateSelectorRect(PVector mouseDelta) {
    selectorRect.point2 = PVector.add(selectorRect.point2, mouseDelta);
    selectMode = CREATE_SELECTOR_MODE;
    line.selectNone();
    for (int i = 0; i < line.linePoints.size(); i++) {
      LinePoint point = line.get(i);
      if (selectorRect.contains(point.point)) 
        line.select(point);
    }
  }

  void drawSelector() {
    if (selectMode == CREATE_SELECTOR_MODE) {
      stroke(125);
      selectorRect.draw();
    }
  }

  void drawMode() {
    fill(30, 125);
    noStroke();
    rect(0, 0, width, 24);
    fill(255, 125);
    switch (mouseMode) {
    case ADD_POINTS_MODE:
      text("Mouse Mode: Add Points (Hit tab to switch)", 6, 16); 
      break;
    case SELECT_POINTS_MODE:
      text("Mouse Mode: Select Points (Hit tab to switch)", 6, 16); 
      break;
    }
  }

  void switchToAddMode() {
    line.selectNone();
    mouseMode = ADD_POINTS_MODE;
  }

  void switchMode() {
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

