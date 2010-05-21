class Cursor {
  PVector location;
  
  Cursor(PVector location) {
    this.location = location;
  }
  
  void draw() {
    stroke(0, 0, 255);
    line(location.x, 0, location.x, height);
  }
  
}
