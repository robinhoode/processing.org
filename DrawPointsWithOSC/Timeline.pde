
import oscP5.*;
import netP5.*;

class Timeline {
  int        xLocation;
  boolean    playing;
  Lane       lane;
  Line       line;
  OscP5      osc;
  NetAddress oscLocation;
  
  Timeline(Lane lane, int xLocation, boolean playing) {    
    this.lane        = lane;
    this.line        = lane.line;
    this.xLocation   = xLocation;
    this.playing     = playing;
    this.osc         = new OscP5(line.applet, 12001);
    this.oscLocation = new NetAddress("127.0.0.1", 12000);
  }
  
  void draw() {
    drawLine();
    drawText();
    
    if (playing) {
      sendMessages();
      if (xLocation < width)
        update();
    }    
  }
  
  void sendMessages() {
    OscMessage message = new OscMessage("/shift");
    
    float xMessage = valueAt(xLocation) - (line.applet.height/2);
    println("xMessage is " + xMessage);
    
    message.add((float) xMessage);
    message.add((float) 0);
    message.add((float) 0);
    
    osc.send(message, oscLocation);
  }
  
  void drawLine() {
    stroke(0, 0, 255);
    line(xLocation, 0, xLocation, height);    
  }
  
  void drawText() {
    fill(30, 125);
    noStroke();
    rect(0, height-INFO_BAR_HEIGHT, width, INFO_BAR_HEIGHT);
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
    for (int i = 1; i < line.points.size(); i++) {
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
