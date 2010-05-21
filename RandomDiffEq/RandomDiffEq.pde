
import processing.opengl.*;

void setup() {
  size(800, 600, OPENGL);
}


void draw() {
  background(0);
  int step = 2;
  
  for (int C = 0; C < ; C++) {
    stroke(255);
    for (int i = 0; i < width; i += step) {      
      line(i + width/2, f(i, C) + height/2, i+step + width/2, f(i+step, C) + height/2);
    }
  }
}

float f(float x, float C) {
//  return sin(log(x / C))*150;
  return x*x + C/x;
}
