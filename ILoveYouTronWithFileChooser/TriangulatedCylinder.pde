
class TriangulatedCylinder {
  float angleY = 0;
  float angleZ = 0;


  float angleStep = PI/12,        scalar, 
        standardShapeHeight = 20, shapeHeight, 
        levelScale,               iterationSize,
        strokeColor;
  
  TriangulatedCylinder(float levelScale, float iterationSize, float strokeColor) {
    this.angleY              = random(128)*PI/128;
    this.angleZ              = random(243)*PI/243;
    this.levelScale          = levelScale;
    this.iterationSize       = iterationSize;
    this.standardShapeHeight = standardShapeHeight;
    this.strokeColor         = strokeColor;
  }
  
  void draw() {
//    float soundLevel = LiveInput.getLevel();
    float soundLevel = currentLevel();
//    println("Sound level is " + soundLevel*10000/log(soundLevel*10000));
    scalar = soundLevel*levelScale;
    
    shapeHeight = standardShapeHeight*soundLevel*20; //*(scalar);
    
    stroke(0, 0, strokeColor);
    fill(0, 100);
    
    pushMatrix();
    beginShape(TRIANGLES); 

    for (float i = 0; i < 2*PI; i += angleStep*iterationSize) {
      vertex(shapeHeight,  scalar*cos(i),             scalar*sin(i));
      vertex(shapeHeight,  scalar*cos(i+angleStep),   scalar*sin(i+angleStep));
      vertex(-shapeHeight, scalar*cos(i+angleStep/2), scalar*sin(i+angleStep/2));
      
      i += angleStep*iterationSize;
      vertex(-shapeHeight,  scalar*cos(i),             scalar*sin(i));
      vertex(-shapeHeight,  scalar*cos(i+angleStep),   scalar*sin(i+angleStep));
      vertex(shapeHeight,   scalar*cos(i+angleStep/2), scalar*sin(i+angleStep/2));
    }
    
    angleY += PI/128;
    rotateY(angleY);
    angleZ += PI/243;
    rotateZ(angleZ);    
    
    endShape(CLOSE);
    popMatrix();
  }  
}

