class Timeline {
  int     xLocation;
  boolean playing;
  Line    line;
  
  Timeline(Line line, int xLocation, boolean playing) {
    this.line      = line;
    this.xLocation = xLocation;
    this.playing   = playing;
  }
  
  void draw() {
    drawLine();
    drawText();    
    
    if (xLocation < width && playing) {
      update();      
    }
  }
  
  void drawLine() {
    stroke(0, 0, 255);
    line(xLocation, 0, xLocation, height);    
  }
  
  void drawText() {
    fill(30, 125);
    noStroke();
    rect(0, height-24, width, 24);
    fill(255, 125);
    text("Timeline position : " + xLocation + " Value at position: " + valueAt(xLocation), 6, height-10);
  }
  
  void update() {
    xLocation += 1;
  }
  
  void play() {
    this.playing = true;
  }
  
  void pause() {
    this.playing = false;
  }
  
  void keyPressed(char key, int keyCode) {
    if (key == ' ') {
      if (playing)
        pause();
      else
        play();
    }
    
    if (keyCode == KeyEvent.VK_HOME)
      xLocation = 1;
    if (keyCode == KeyEvent.VK_END)
      xLocation = width;
  }
  
  // TODO: Refactor this somehow..?  
  float valueAt(int x) {
    LinePoint first, second;
    for (int i = 1; i < line.linePoints.size(); i++) {
      first  = line.get(i-1);
      second = line.get(i);
      
      float x0 = (float) first.point.x;      
      float x1 = (float) second.point.x;
      float y0 = (float) (height - first.point.y);
      float y1 = (float) (height - second.point.y);
      
      if (x0 == x) return y0;
      if (x1 == x) return y1;
        
      if (x0 <= x && x <= x1) {
        float m = (y1 - y0)/(x1 - x0);
        return m*(x - x0) + y0;
      }      
    }
    return 0;
  }  
}
