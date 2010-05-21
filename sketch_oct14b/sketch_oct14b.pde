float radiusCenter = 100;
float radiusTube = 50;
float iterations = 100;

void setup() {
  size(800, 600, P3D);
}

void draw() {
//  background(0);

  float r = radiusCenter;
  float h = 100; // x-offset
  float k = 100; // y-offset

  // A circle
  circle(h, k, r, -100, iterations);
}

void circle(float h, float k, float r, float z, float iterations) {
  beginShape();  
  for (int i = 1; i < iterations; i++) {
    float t = 2*PI*(i/iterations);
    float x = r*cos(t) + h;
    float y = r*sin(t) + k;
    vertex(x, y, z);
  }
  endShape(CLOSE);
  
}


void torus() {
  beginShape(LINES);
  
  for (int i = 1; i < iterations; i++) {
    float u = 2*PI * (i/iterations);
    for (int j = 1; j < iterations; j++) {
      float v = 2* PI * (j/iterations);
      
      float x = (radiusCenter + radiusTube*cos(v))*cos(u);
      float y = (radiusCenter + radiusTube*cos(v))*sin(u);
      float z = radiusTube*sin(v);
      vertex(x, y, z);
    }
  }
  endShape(CLOSE);
  
}

