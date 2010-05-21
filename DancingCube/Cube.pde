class Cube {
  Vector3D[] vertices = new Vector3D[24]; 
  Vector3D location, dimensions, angleFacing = new Vector3D();
  Matrix3D rotationMatrix;

  // Constructor 2
  Cube(Vector3D location, Vector3D dimensions, Vector3D angleFacing) { 
    this.location    = location;
    this.dimensions  = dimensions;
    buildVertices();
    rotateTo(angleFacing);
  } 

  void buildVertices() {
    double w = this.dimensions.x;
    double h = this.dimensions.y;
    double d = this.dimensions.z;
    // cube composed of 6 quads 
    //front 
    vertices[0] = new Vector3D(-w/2,-h/2,d/2); 
    vertices[1] = new Vector3D(w/2,-h/2,d/2); 
    vertices[2] = new Vector3D(w/2,h/2,d/2); 
    vertices[3] = new Vector3D(-w/2,h/2,d/2); 
    //left 
    vertices[4] = new Vector3D(-w/2,-h/2,d/2); 
    vertices[5] = new Vector3D(-w/2,-h/2,-d/2); 
    vertices[6] = new Vector3D(-w/2,h/2,-d/2); 
    vertices[7] = new Vector3D(-w/2,h/2,d/2); 
    //right 
    vertices[8] = new Vector3D(w/2,-h/2,d/2); 
    vertices[9] = new Vector3D(w/2,-h/2,-d/2); 
    vertices[10] = new Vector3D(w/2,h/2,-d/2); 
    vertices[11] = new Vector3D(w/2,h/2,d/2); 
    //back 
    vertices[12] = new Vector3D(-w/2,-h/2,-d/2);  
    vertices[13] = new Vector3D(w/2,-h/2,-d/2); 
    vertices[14] = new Vector3D(w/2,h/2,-d/2); 
    vertices[15] = new Vector3D(-w/2,h/2,-d/2); 
    //top 
    vertices[16] = new Vector3D(-w/2,-h/2,d/2); 
    vertices[17] = new Vector3D(-w/2,-h/2,-d/2); 
    vertices[18] = new Vector3D(w/2,-h/2,-d/2); 
    vertices[19] = new Vector3D(w/2,-h/2,d/2); 
    //bottom 
    vertices[20] = new Vector3D(-w/2,h/2,d/2); 
    vertices[21] = new Vector3D(-w/2,h/2,-d/2); 
    vertices[22] = new Vector3D(w/2,h/2,-d/2); 
    vertices[23] = new Vector3D(w/2,h/2,d/2);    
  }

  void draw(){
    // Draw cube
    stroke(0);
    fill(150);
    for (int i = 0; i < 6; i++) {
      beginShape(QUADS);
      for (int j=0; j<4; j++) {
        drawVertex(Vector3D.add(location, vertices[j+4*i]));
      }
      endShape();
    }
  }

  void drawVertex(Vector3D vector) {
    vertex((float) vector.x, (float) vector.y, (float) vector.z);
  }

  void moveTo(Vector3D location) {
    this.location = location;
  }

  void moveTowards(Vector3D init, Vector3D nudgeVector) {
    this.location = init;
    nudge(nudgeVector);
  }

  void nudge(Vector3D offset) {
    shift(rotationMatrix.mult(offset));
  }
  
  void shift(Vector3D offset) {
    this.location = Vector3D.add(this.location, offset);
  }
  
  void scale(float scalar) {
    this.dimensions = Vector3D.mult(this.dimensions, scalar);
    buildVertices();
  }

  void buildRotationMatrix() {
    this.rotationMatrix = Matrix3D.rotationX(angleFacing.x);
    this.rotationMatrix = Matrix3D.rotationY(angleFacing.y).mult(this.rotationMatrix);
    this.rotationMatrix = Matrix3D.rotationZ(angleFacing.z).mult(this.rotationMatrix);    
  }

  void rotateTo(Vector3D angleFacing) {
    this.angleFacing = angleFacing;
    rebuildVerticesFromRotation();
  }
  
  void spin(Vector3D rotation) {
    this.angleFacing = Vector3D.add(this.angleFacing, rotation);
    rebuildVerticesFromRotation();
  }
  
  void rebuildVerticesFromRotation() {
    buildRotationMatrix();    
    buildVertices();    
    for (int i = 0; i < vertices.length; i++) {
      vertices[i] = rotationMatrix.mult(vertices[i]);
    }        
  }
  
  Cube clone() {
    return new Cube(this.location, this.dimensions, this.angleFacing);
  }
}

