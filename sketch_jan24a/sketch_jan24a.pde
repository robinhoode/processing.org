import hipstersinc.sunflow.shape.*;
import hipstersinc.sunflow.*;
import hipstersinc.sunflow.shader.*;
import hipstersinc.sunflow.util.*;
import hipstersinc.*;
import hipstersinc.sunflow.light.*;

void setup() {
  size(400, 300, "hipstersinc.P5Sunflow");
  noLoop();
}

void draw() {
  background(255);

  int numSpheres = 4;
  float yStep = width/4;
  float y = 40;

  for(int i=0; i<numSpheres; i++) {
    pushMatrix();
    translate(y, height/2);

    fill( i*(255/numSpheres), random(100, 200), random(0, 100) );
    sphere(40);
    popMatrix();

    y += yStep;
  }
}
