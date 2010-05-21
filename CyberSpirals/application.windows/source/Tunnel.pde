
class Tunnel {
  float tunnelWidth, tunnelStart, 
        tunnelEnd,   tunnelDepth, 
        arcStep,     iterStep;
  float angle;
  
  Tunnel() {
    tunnelWidth = 300;
    tunnelStart = -1200;
    tunnelEnd   = 600;
    tunnelDepth = tunnelEnd - tunnelStart;
    arcStep     = PI/128;
    iterStep    = 50;
    angle       = 0;
  }
  
  void drawCircles() {
    for (float i = tunnelStart; i < tunnelEnd; i += 50) {
      stroke(0, 0, 255*(i - tunnelStart)/(float)tunnelDepth);
//      stroke(0, 0, 255);
      noFill();      
      beginShape();
      for (float a = 0; a < 2*PI; a += arcStep) {  
        vertex(tunnelWidth*cos(a), tunnelWidth*sin(a), i);
      }
      endShape(CLOSE);
    }    
  }
  
  void drawSpiral() {
    stroke(0, 0, 255);
    noFill();          
    beginShape();
    float a = 0;
    for (float i = tunnelStart; i < tunnelEnd; i += 0.25, a += PI/128) {
      vertex(tunnelWidth*cos(a), tunnelWidth*sin(a), i);
    }

    endShape();
  }
  
  void drawLengths() {
    stroke(0, 0, 255);
    beginShape(LINES);
    for (float a = 0; a < 2*PI; a += PI/12) {
      vertex(tunnelWidth*cos(a), tunnelWidth*sin(a), tunnelStart);
      vertex(tunnelWidth*cos(a), tunnelWidth*sin(a), tunnelEnd);
    }
    rotate();
    endShape();
  }
    
  void rotate() {
    angle += PI/256;
    rotateZ(angle);
  }
  
  void draw() {
//    drawCircles();
    pushMatrix();
    drawSpiral();
    drawLengths(); 
    rotate();
    popMatrix();
  }
}
