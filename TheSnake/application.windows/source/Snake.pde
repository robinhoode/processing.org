import oscP5.*;
import netP5.*;

class Snake {
  OscP5 oscP5;
  
  Snake(PGraphics3D g, PApplet applet) {
    cubes = new CubeArray(100, new Vector3D(0, 0, 0), new Vector3D(50, 50, 50), new Vector3D(0, 0, 0));
    // Remember PGraphics3D transformation matrix
    
//    snakeGui = new SnakeGUI(cam, (PGraphics3D) g);
//    snakeGui.setup(applet);
    
    oscP5 = new OscP5(applet, 12000);
    oscP5.plug(cubes, "iterateNudge", "/nudge");
  }
  
  void draw() {  
    background(0);
    lights();

//    cubes.iterate(snakeGui.nudgeVector(), snakeGui.shiftVector(), snakeGui.angleVector()); 

    cubes.draw();
//    snakeGui.draw();
  }
}
