
// TODO: Make the sphere deform into different triangulations during the song
//
class TriangulatedSphere {
  float radius = 500;
  float longSteps = PI/12;
  float latSteps  = PI/12; 
  
  float angleY, angleZ;
  
  TriangulatedSphere() {
    this.angleY              = random(128)*PI/128;
    this.angleZ              = random(243)*PI/243;    
  }
  
  void draw() {
    float soundLevel = currentLevel();
//    println("Sound level is " + soundLevel*10000/log(soundLevel*10000));
    radius = soundLevel*500;
    
    pushMatrix();
    beginShape(TRIANGLES);     
    
    stroke(0, 0, 255);
    fill(0);

    for (float i = 0; i <= 2*PI; i += latSteps) {
      for (float j = 0; j <= PI; j += longSteps/2) {
        drawTopTriangle(radius*cos(i), radius*cos(i+latSteps), radius*sin(i), radius*sin(i+latSteps), j);        
        j += longSteps/2;
        drawBottomTriangle(radius*cos(i), radius*cos(i+latSteps), radius*sin(i), radius*sin(i+latSteps), j);
      }
      
      i += latSteps;

      for (float j = longSteps/2; j <= PI + longSteps/2; j += longSteps/2) {
        drawTopTriangle(radius*cos(i), radius*cos(i+latSteps), radius*sin(i), radius*sin(i+latSteps), j);        
        j += longSteps/2;
        drawBottomTriangle(radius*cos(i), radius*cos(i+latSteps), radius*sin(i), radius*sin(i+latSteps), j);
      }
    }
    
    /*
    angleY += PI/128;
    rotateY(angleY);
    angleZ += PI/243;
    rotateZ(angleZ);    
    */

    endShape(CLOSE);
    popMatrix();
  }
  
  void drawTopTriangle(float s0, float s1, float top, float bottom, float j) {
    vertex(top,    s0*cos(j),             s0*sin(j));
    vertex(top,    s0*cos(j+longSteps),   s0*sin(j+longSteps)); 
    vertex(bottom, s1*cos(j+longSteps/2), s1*sin(j+longSteps/2));
  }
  
  void drawBottomTriangle(float s0, float s1, float top, float bottom, float j) {
    vertex(bottom, s1*cos(j),             s1*sin(j));
    vertex(bottom, s1*cos(j+longSteps),   s1*sin(j+longSteps));      
    vertex(top,    s0*cos(j+longSteps/2), s0*sin(j+longSteps/2));
  }
  
}
