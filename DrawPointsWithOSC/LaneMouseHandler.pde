class LaneMouseHandler {
  Lane lane;
  Line line;
  Rect selectorRect;
  GlobalMouseHandler g;
  
  int selectMode;

  LaneMouseHandler(Lane lane) {
    this.lane         = lane;
    this.line         = lane.line;
    this.selectorRect = new Rect(new PVector(0, 0), new PVector(0, 0));
    this.g            = GlobalMouseHandler.getInstance();
    this.selectMode   = NO_SELECT_MODE;
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
    if (linePoint != null && !lane.selectedPoints.contains(linePoint)) {
      // That becomes the only selected
      GlobalLanesHandler.deselectAllPoints();
      lane.selectOnly(linePoint);        
    } 

    // If we land on one and we have at least one already selected    
    else if (!lane.isNoneSelected() && linePoint != null) {
      // Go into drag mode
      selectMode = DRAG_GRIP_MODE;
    } 

    // If we don't land on a grip and there are no selected points          
    else if (linePoint == null) {
      // Go into selector rect mode
      GlobalLanesHandler.deselectAllPoints();
      selectorRect.point1 = selectorRect.point2 = mouseVector;
      selectMode = CREATE_SELECTOR_MODE;
    }
  }

  void mousePressed(PVector mouseVector) {
    if (lane.boundary.contains(mouseVector)) {
      switch (g.mouseMode) {
      case ADD_POINTS_MODE:
        addPoints(mouseVector); 
        break;
      case SELECT_POINTS_MODE:
        selectPoints(mouseVector); 
        break;
      }
    }
  }

  void mouseReleased(PVector mouseVector) {
    selectMode = NO_SELECT_MODE;
  }

  LinePoint findCurrentlySelected(PVector mouseVector) {
    LinePoint linePoint;
    for (int i = 0; i < line.points.size(); i++) {
      linePoint = line.get(i);
      if (linePoint.mouseWithinGrip(mouseVector)) {
        return linePoint;
      }
    }
    return null;    
  }  

  void mouseDragged(PVector mouseVector, PVector mouseDelta) {
//    println("Mouse delta is " + mouseDelta);

    if (lane.boundary.contains(mouseVector)) {
      switch (g.mouseMode) {
      case SELECT_POINTS_MODE:
        if (selectMode == CREATE_SELECTOR_MODE) {
          updateSelectorRect(mouseDelta);
        } 
        else if (!lane.isNoneSelected()) {
          lane.dragSelected(mouseVector, mouseDelta);
          selectMode = DRAG_GRIP_MODE;
        }          
        break;
      case ADD_POINTS_MODE:
        break;
      }
    }
  }

  void updateSelectorRect(PVector mouseDelta) {
    selectorRect.point2 = PVector.add(selectorRect.point2, mouseDelta);
    selectMode = CREATE_SELECTOR_MODE;
    lane.deselectAllPoints();
    for (int i = 0; i < line.points.size(); i++) {
      LinePoint point = line.get(i);
      if (selectorRect.contains(point.point)) 
        lane.select(point);
    }
  }
  
  void drawSelector() {
    if (selectMode == CREATE_SELECTOR_MODE) {
      selectorRect.draw(125);
    }
  }


}

