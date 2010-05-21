import processing.opengl.*;
import javax.vecmath.*;

ArrayList points;

void setup() {
  size(800, 600, OPENGL);
  points = new ArrayList();
}

ArrayList getSlice(int start, int end) {
  ArrayList slice = new ArrayList();
  
  for (int i = start; i < end; i++) {
    slice.add((PVector) points.get(i));
  }
  
  return slice;
}

void draw() {
  background(0);
  for (int i = 0; i < points.size(); i++) {
    PVector point = (PVector) points.get(i);
    drawPoint(point);
  }
  
  if (points.size() > 1) {
    CurveSegmentY curveSeg = new CurveSegmentY(getSlice(0, points.size()));
    curveSeg.draw();
  }  
  
  if (points.size() > 1) {
    CurveSegmentX curveSeg = new CurveSegmentX(getSlice(0, points.size()));
    curveSeg.draw();
  }  
  
}

void drawPoint(PVector vector) {
  fill(255);
  rect(vector.x - 5, vector.y - 5, 10, 10);
}

void mousePressed() {
  points.add(new PVector(mouseX, mouseY));
  println("Mouse is at " + mouseX + "," + mouseY);
}

