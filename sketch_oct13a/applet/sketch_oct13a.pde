float boxSize = 120;
float margin = boxSize*2;
float distance = 1000;
color boxFill;

float latitude = 5000;
float longitude = 5000;

void setup() {
  size(800, 600, P3D);
  noStroke();
  beginCamera();
//  rotateZ(PI/8);
//  rotate(-PI/3);
  rotateX(-PI/4);
  endCamera(); 
}

void draw() {
  background(0);
  
  translate(longitude/2, latitude/2, -distance);
  // Center and spin grid
  
  beginCamera();
  camera(0.0, mouseY, 220.0, // eyeX, eyeY, eyeZ
         0.0, 0.0, 0.0, // centerX, centerY, centerZ
         0.0, 1.0, 0.0); // upX, upY, upZ

//  rotateX(-PI/4 - (mouseY/height));
  endCamera();

  // Build grid using multiple translations 
  for (float j =- latitude+margin; j <= latitude-margin; j += boxSize){
    for (float k =- longitude+margin; k <= longitude-margin; k += boxSize){
      // Base fill color on counter values, abs function 
      // ensures values stay within legal range
      boxFill = color(0, 255, 0, 50);
      pushMatrix();
      translate(k, j, 1);
      stroke(boxFill);
      fill(boxFill);
      box(boxSize, boxSize, 1);
      popMatrix();
    }
  }
}

