class Snake {
  OscP5 oscP5;
  
  Snake(PGraphics3D g, PApplet applet) {
    cubes = new CubeArray(50, new Vector3D(0, 0, 0), new Vector3D(50, 50, 50), new Vector3D(0, 0, 0));
    
    oscP5 = new OscP5(applet, 12000);
    oscP5.plug(cubes, "iterateNudge", "/nudge");
    oscP5.plug(cubes, "iterateShift", "/shift");
  }
  
  void draw() {  
    background(0);
    lights();
    cubes.draw();
  }  
}
