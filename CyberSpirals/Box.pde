class Box {
  Vector3D location;
  float speed = 10;
  color boxColor;
  float angle, distance;
  
  Box() {
    this.location = new Vector3D(randomX(), randomY(), -1200);
    this.boxColor = randomColor();
    this.speed    = randomSpeed();
    this.angle    = atan2((float) location.y, (float) location.x);
    this.distance = sqrt(pow((float) location.x, 2) + pow((float) location.y, 2));
  }
  
  float randomX() {
    float value = random(-200, 200);    
    if (value > 0)
      return value + 10;
    else if (value < 0)
      return value - 10;    
    else 
      return randomX();
  }
  
  float randomY() {
    float value = random(-200, 200);    
    if (value > 0)
      return value + 10;
    else if (value < 0)
      return value - 10;    
    else 
      return randomY();
  }
  
  color randomColor() {
    return color(random(0, 255), random(0, 255), random(0, 255));
  }
  
  float randomSpeed() {
    return random(10, 25);
  }
  
  Matrix3D orientationMatrix() {
    double angle = (double) atan2((float) location.x, (float) location.y);
    return Matrix3D.rotateX(angle).mult(Matrix3D.rotateY(angle));
  }
  
  void vertexAt(float x, float y, float z) {
//    Vector3D offset = orientationMatrix().mult(new Vector3D(x, y, z)).add(location);    
//    Vector3D offset = new Vector3D(x, y, z).add(location);
//    vertex((float) offset.x, (float) offset.y, (float) offset.z);
    vertex(x, y, z);
  }
  
  float boxSize() {
    return currentLevel()*80;
//    return 40;
  }
  
  void drawLeftWall() {
    // Left wall        
    vertexAt(-boxSize(), boxSize(), boxSize());
    vertexAt(-boxSize(), boxSize(), -boxSize());
    vertexAt(-boxSize(), -boxSize(), -boxSize());
    vertexAt(-boxSize(), -boxSize(), boxSize());    
  }
  
  void drawRightWall() {
    // Right wall
    vertexAt(boxSize(), boxSize(), boxSize());
    vertexAt(boxSize(), boxSize(), -boxSize());
    vertexAt(boxSize(), -boxSize(), -boxSize());
    vertexAt(boxSize(), -boxSize(), boxSize());
  }
  
  void drawFrontWall() {
    // Front wall
    vertexAt(boxSize(), boxSize(), boxSize());
    vertexAt(-boxSize(), boxSize(), boxSize());  
    vertexAt(-boxSize(), -boxSize(), boxSize());    
    vertexAt(boxSize(), -boxSize(), boxSize());     
  }
  
  void drawBackWall() {
    // Back wall
    vertexAt(boxSize(), boxSize(), -boxSize());
    vertexAt(-boxSize(), boxSize(), -boxSize());  
    vertexAt(-boxSize(), -boxSize(), -boxSize());    
    vertexAt(boxSize(), -boxSize(), -boxSize());     
  }
  
  void drawBottomAndTopWall() {
    // Bottom and top wall
    vertexAt(boxSize(), boxSize(), boxSize());
    vertexAt(boxSize(), boxSize(), -boxSize());  
    vertexAt(-boxSize(), boxSize(), -boxSize());    
    vertexAt(-boxSize(), boxSize(), boxSize());     
  }

  void computeAngle() {
    angle = atan2((float) location.y, (float) location.x) + PI/48;    
  }
  
  void updateLocation() {
    location.z += speed;
    
    computeAngle();
    location.x = distance*cos(angle);
    location.y = distance*sin(angle);
  }
  
  void vertices() {
    pushMatrix();       
    beginShape(QUADS);
        
    drawLeftWall();
    drawRightWall();
    drawFrontWall();
    drawBackWall();
    drawBottomAndTopWall();

    translate((float) location.x, (float) location.y, (float) location.z);
    rotateX(angle);
    rotateY(angle);
    
    endShape();
    popMatrix();
  }
  
  void draw() {
    updateLocation();
    stroke(boxColor);
    fill(0);
    vertices();    
  }
}

