
class OuterGrid {
  float angleY, angleZ;
  int boxSize = 800;
  
  OuterGrid() {
    this.angleY = 0;
    this.angleZ = 0;
  }
  
  void draw() {

    int spacing = boxSize/10;
    
    stroke(0, 128, 0);
    strokeWeight(2);
    fill(0, 128, 0);
    
    pushMatrix();
    beginShape(LINES);
    
    for (int i = -boxSize; i <= boxSize; i += spacing) {
      bottomWall(i); topWall(i);
      rightWall(i);  leftWall(i);
      backWall(i);   frontWall(i);
    }
  
    angleY += PI/pow(2, 10);
    rotateY(angleY);
    angleZ += PI/pow(3, 8);
    rotateZ(angleZ);

    endShape();    
    popMatrix();    
  }
  
  void bottomWall(int i) {
    // Bottom wall
    // (i, +, -) => (i, +, +)
    vertex(i, boxSize, -boxSize); vertex(i, boxSize, boxSize);    
    // (+, +, i) => (-, +, i)    
    vertex(boxSize,  boxSize, i); vertex(-boxSize, boxSize, i);  
  }
  
  void topWall(int i) {
    // Top wall
    // (i, -, -) => (i, -, +)
    vertex(i, -boxSize, -boxSize); vertex(i, -boxSize, boxSize);  
    // (+, -, i) => (-, -, i)
    vertex(boxSize, -boxSize, i); vertex(-boxSize, -boxSize, i); 
  }
  
  void rightWall(int i) {
    // Right wall    
    // (+, +, i) => (+, -, i)        
    vertex(boxSize,  boxSize, i); vertex(boxSize, -boxSize, i); 
    // (+, i, +) => (+, i, -)    
    vertex(boxSize,  i, boxSize); vertex(boxSize, i, -boxSize);   
  }
  
  void leftWall(int i) {
    // Left wall
    // (-, -, i) => (-, +, i)    
    vertex(-boxSize, -boxSize, i); vertex(-boxSize, boxSize, i); 
    // (-, i, -) => (-, i, +)    
    vertex(-boxSize, i, -boxSize); vertex(-boxSize, i, boxSize);  
  }
  
  void backWall(int i) {
    // Back wall
    // (i, +, +) => (i, -, +)    
    vertex(i, boxSize, boxSize); vertex(i, -boxSize, boxSize);
    // (+, i, +) => (-, i, +)    
    vertex(boxSize, i, boxSize); vertex(-boxSize, i, boxSize);    
  }
  
  void frontWall(int i) {
    // Front wall
    // (i, -, -) => (i, +, -)    
    vertex(i, -boxSize, -boxSize); vertex(i, boxSize, -boxSize);  
    // (-, i, -) => (+, i, -)            
    vertex(-boxSize, i, -boxSize); vertex(boxSize, i, -boxSize);  
  }
}
