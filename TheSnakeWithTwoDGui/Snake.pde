class Snake {
  Snake(PGraphics3D g, PApplet applet) {
    cubes = new CubeArray(50, new Vector3D(0, 0, 0), new Vector3D(50, 50, 50), new Vector3D(0, 0, 0));    
  }
  
  void draw() {  
    background(0);
    // lights();
    // Find a better way to do lighting
    cubes.draw();
  }  
}
