import processing.opengl.*;

PFrame f;
TimelineApplet s;

void setup() {
  size(320, 240, OPENGL);
  PFrame f = new PFrame();

}

void draw() {
  background(255,0,0);
  fill(255);
  rect(10,10,frameCount%100,10);
  s.redraw();
}

public class PFrame extends Frame {
  public PFrame() {
    setBounds(100,100,800,600);
    s = new TimelineApplet();
    add(s);
    s.init();
    show();
  }
}

int GRIP_SIZE = 3;

public class TimelineApplet extends PApplet {
  Line line;
  PFont font;
  int lastMouseX, lastMouseY;
  
  public void setup() {
    size(800, 600, OPENGL);
    noLoop();
    
    String fontPath = "C:\\Documents and Settings\\Owner\\dev\\processing\\TheSnakeWithTimelineControls\\data\\CourierNewPSMT-12.vlw";
    this.font = loadFont(fontPath);
    
    line = new Line(this);
  }

  public void draw() {
    background(0);
    line.draw();
  }
    
  void mousePressed() {
    line.mouseHandler.mousePressed(new PVector(mouseX, mouseY));
    lastMouseX = mouseX;
    lastMouseY = mouseY;    
  }
}
