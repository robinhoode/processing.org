class Timeline {
  int     xLocation;
  boolean playing;
  Line    line;
  PFont   font;
  
  Timeline(Line line, int xLocation, boolean playing) {
    this.font      = font;
    this.line      = line;
    this.xLocation = xLocation;
    this.playing   = playing;
  }
  
  void draw() {
    drawLine();
    drawText();    
    
    if (xLocation < line.applet.width && playing) {
      update();      
    }
  }
  
  void drawLine() {
    line.applet.stroke(0, 0, 255);
    line.applet.line(xLocation, 0, xLocation, line.applet.height);    
  }
  
  void drawText() {
    line.applet.fill(30, 125);
    line.applet.noStroke();
    line.applet.rect(0, line.applet.height-24, line.applet.width, 24);
    line.applet.fill(255, 125);
    line.applet.textFont(line.applet.font, 12);
    line.applet.text("Timeline position : " + xLocation + " Value at position: " + valueAt(xLocation), 6, line.applet.height-10);
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
      float y0 = (float) (line.applet.height - first.point.y);
      float y1 = (float) (line.applet.height - second.point.y);
      
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
