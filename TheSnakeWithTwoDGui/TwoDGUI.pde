class TwoDGUI {
  boolean  collapsed;
  PeasyCam cam;
  PApplet  applet;
  
  TwoDGUI(PApplet applet, PeasyCam cam) {
    this.applet    = applet;
    this.cam       = cam;
    this.collapsed = true;
  }
  
  void draw() {
    // Add Lanes here..
    if (collapsed) {
      cam.setMouseControlled(true);
      drawCollapsed();
    } else {
      cam.setMouseControlled(false);
      drawExpanded();
    }
  }
  
  void drawCollapsed() {
    fill(50, 125);
    rect(0, height-24, width, height);
    fill(80);
    text("Snake Control Panel", 6, height-10);
  }
  
  void drawExpanded() {
    fill(50, 250);      
    rect(0, height/2, width, height);
    fill(255);    
    text("Snake Control Panel", 6, height/2+14);
    drawControls();
  }
  
  void drawControls() {
    Line line = new Line(applet);
    line.add(new PVector(160, height/2 + 10));
    line.add(new PVector(200, height/2 + 60));
    line.draw();
  }
    
  void keyPressed(char key, int keyCode) {
    if (keyCode == KeyEvent.VK_PAGE_UP) {
      collapsed = false;
    }
    
    if (keyCode == KeyEvent.VK_PAGE_DOWN) {
      collapsed = true;
    }
  }
}

