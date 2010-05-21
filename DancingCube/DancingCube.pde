import peasy.*;
import processing.opengl.*;
import pitaru.sonia_v2_9.*;

PeasyCam cam;
Cube cube;

void setup() {
  size(800, 600, OPENGL);
  noStroke();
  
  cam = new PeasyCam(this, width);

  cube = new Cube(new Vector3D(0, 0, 0), new Vector3D(20, 20, 20), new Vector3D(0, 0, 0));
  
  // Start Sonia engine.
  Sonia.start(this); 
   
  // Start LiveInput and return 256 FFT frequency bands.
  LiveInput.start(256); 
  LiveInput.useEqualizer(true);  
}

float level;

int lastUpdate = 0;

void updateSpectrum() {
  int now = millis();
  if (now - lastUpdate > 100) {
    LiveInput.getSpectrum();
    lastUpdate = now;
  }
}


void draw() {
  background(0);
    
  updateSpectrum();
  level = LiveInput.spectrum[104];
  println("Level is currently " + level);
  cube.draw();
  cube.dimensions = Vector3D.mult(new Vector3D(20, 20, 20), level/10);
  cube.buildVertices();
}
