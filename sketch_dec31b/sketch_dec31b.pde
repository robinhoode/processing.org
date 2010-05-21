import peasy.*; 
PeasyCam cam;


static class Matrix3D {
  float matrix[][] = new float[3][3];

  Matrix3D(float x11, float x12, float x13, float x21, float x22, float x23, float x31, float x32, float x33) {
    matrix[0][0] = x11;
    matrix[0][1] = x12;
    matrix[0][2] = x13;
    matrix[1][0] = x21;
    matrix[1][1] = x22;
    matrix[1][2] = x23;
    matrix[2][0] = x31;
    matrix[2][1] = x32;
    matrix[2][2] = x33;
  }

  Matrix3D(float[][] matrix) {
    this.matrix = matrix;
  }

  static Matrix3D rotationX(float angle) {
    return new Matrix3D(1,          0,           0,
    0, cos(angle), -sin(angle),
    0, sin(angle),  cos(angle));
  }

  static Matrix3D rotationY(float angle) {
    return new Matrix3D(cos(angle),  0, sin(angle),
    0,  1,          0,
    -sin(angle), 0, cos(angle));
  }

  static Matrix3D rotationZ(float angle) {
    return new Matrix3D(cos(angle), -sin(angle), 0,
    sin(angle),  cos(angle), 0,
    0,           0, 1);
  }

  Matrix3D mult(Matrix3D other) {
    float[][] newMatrix = new float[3][3];

    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        for (int k = 0; k < 3; k++) {
          newMatrix[i][j] = matrix[i][k]*other.matrix[k][j];
        }
      }
    }

    return new Matrix3D(newMatrix);
  }

  PVector mult(PVector vector) {
    return new PVector(matrix[0][0] * vector.x + matrix[0][1] * vector.y + matrix[0][2] * vector.z,
    matrix[1][0] * vector.x + matrix[1][1] * vector.y + matrix[1][2] * vector.z,
    matrix[2][0] * vector.x + matrix[2][1] * vector.y + matrix[2][2] * vector.z);
  }
}

class Cube {
  PVector[] vertices = new PVector[24]; 
  PVector location, dimensions, angleFacing;

  // Constructor 2
  Cube(PVector location, PVector dimensions, PVector angleFacing) { 
    this.location    = location;
    this.dimensions  = dimensions;
    this.angleFacing = angleFacing;
    buildVertices();
  } 

  void buildVertices() {
    float w = this.dimensions.x;
    float h = this.dimensions.y;
    float d = this.dimensions.z;
    // cube composed of 6 quads 
    //front 
    vertices[0] = new PVector(-w/2,-h/2,d/2); 
    vertices[1] = new PVector(w/2,-h/2,d/2); 
    vertices[2] = new PVector(w/2,h/2,d/2); 
    vertices[3] = new PVector(-w/2,h/2,d/2); 
    //left 
    vertices[4] = new PVector(-w/2,-h/2,d/2); 
    vertices[5] = new PVector(-w/2,-h/2,-d/2); 
    vertices[6] = new PVector(-w/2,h/2,-d/2); 
    vertices[7] = new PVector(-w/2,h/2,d/2); 
    //right 
    vertices[8] = new PVector(w/2,-h/2,d/2); 
    vertices[9] = new PVector(w/2,-h/2,-d/2); 
    vertices[10] = new PVector(w/2,h/2,-d/2); 
    vertices[11] = new PVector(w/2,h/2,d/2); 
    //back 
    vertices[12] = new PVector(-w/2,-h/2,-d/2);  
    vertices[13] = new PVector(w/2,-h/2,-d/2); 
    vertices[14] = new PVector(w/2,h/2,-d/2); 
    vertices[15] = new PVector(-w/2,h/2,-d/2); 
    //top 
    vertices[16] = new PVector(-w/2,-h/2,d/2); 
    vertices[17] = new PVector(-w/2,-h/2,-d/2); 
    vertices[18] = new PVector(w/2,-h/2,-d/2); 
    vertices[19] = new PVector(w/2,-h/2,d/2); 
    //bottom 
    vertices[20] = new PVector(-w/2,h/2,d/2); 
    vertices[21] = new PVector(-w/2,h/2,-d/2); 
    vertices[22] = new PVector(w/2,h/2,-d/2); 
    vertices[23] = new PVector(w/2,h/2,d/2);    
  }

  void draw(){
    PVector vert;
    // Draw cube
    stroke(0);
    fill(150);
    for (int i=0; i<6; i++) {
      beginShape(QUADS);
      for (int j=0; j<4; j++) {
        vert = vertices[j+4*i];
        drawVertex(PVector.add(location, vert));
      }
      endShape();
    }
  }

  void drawVertex(PVector vector) {
    vertex(vector.x, vector.y, vector.z);
  }

  void moveTo(PVector location) {
    this.location = location;
  }

  void moveTowards(PVector init, PVector nudgeVector) {
    this.location = init;
    nudge(nudgeVector);
  }

  void nudge(PVector offset) {
    Matrix3D rotX = Matrix3D.rotationX(angleFacing.x);
    Matrix3D rotY = Matrix3D.rotationY(angleFacing.y);
    offset = rotX.mult(offset);
    offset = rotY.mult(offset);
    this.location = PVector.add(this.location, offset);
  }

  void rotateX(float angle) {
    this.angleFacing.x = angle;
    buildVertices();   
    for (int i = 0; i < vertices.length; i++) {
      vertices[i] = Matrix3D.rotationX(angle).mult(vertices[i]);
    }
  }

  void rotateY(float angle) {
    this.angleFacing.y = angle;
    buildVertices();
    for (int i = 0; i < vertices.length; i++) {
      vertices[i] = Matrix3D.rotationY(angle).mult(vertices[i]);
    }
  }

  void rotateZ(float angle) {
    this.angleFacing.z = angle;
    buildVertices();
    for (int i = 0; i < vertices.length; i++) {
      vertices[i] = Matrix3D.rotationZ(angle).mult(vertices[i]);
    }
  }
}

class CubeArray {
  Cube[] cubes;
  PVector nudge       = new PVector(0, 0, 0),
  angleFacing = new PVector(0, 0, 0);

  CubeArray(PVector loc, PVector dim, PVector angles, int count) {
    cubes = new Cube[count];
    for (int i = 0; i < cubes.length; i++) {
      cubes[i] = new Cube(loc, dim, angles);
    }
  }

  void draw() {
    for (int i = 0; i < cubes.length; i++) {
      cubes[i].draw();
    }
  }

  // Constant nudge takes actual offsets
  void constantNudge(float x, float y, float z) {
    for (int i = 0; i < cubes.length; i++) {
      cubes[i].nudge(new PVector(x, y, z));
    }
  }

  // Relative nudge takes percentage offsets i.e 50%, 25% of the width of the block
  void relativeNudge(float x, float y, float z) {
    for (int i = 0; i < cubes.length; i++) {
      cubes[i].nudge(new PVector(i*x*cubes[i].dimensions.x,
      i*y*cubes[i].dimensions.y,
      i*z*cubes[i].dimensions.z));
    }
  }

  void constantRotateX(float angle) {
    for (int i = 0; i < cubes.length; i++) {
      cubes[i].rotateX(angle);
    }
  }

  void constantRotateY(float angle) {
    for (int i = 0; i < cubes.length; i++) {
      cubes[i].rotateY(angle);
    }
  }

  void constantRotateZ(float angle) {
    for (int i = 0; i < cubes.length; i++) {
      cubes[i].rotateZ(angle);
    }
  }

  void relativeRotateXThenNudgeXY(float angle, float x) {
    PVector originalNudgeVector = new PVector(x, 0, 0), 
    currentNudgeVector  = new PVector(x, 0, 0);

    Matrix3D currentRotation = Matrix3D.rotationZ(angle);

    for (int i = 0; i < cubes.length; i++) {      
      currentNudgeVector = PVector.add(currentRotation.mult(currentNudgeVector), originalNudgeVector);
      cubes[i].nudge(currentNudgeVector);
    }
  }

  void moveRelativeToPrev(PVector nudge) {
    for (int i = 1; i < cubes.length; i++) {
      cubes[i].moveTo(new PVector(cubes[i-1].location.x+nudge.x,
                                  cubes[i-1].location.y+nudge.y,
                                  cubes[i-1].location.z+nudge.z));
    }
  }

  void nudgeArray(PVector nudge) {
    this.nudge = PVector.add(this.nudge, nudge);
    for (int i = 1; i < cubes.length; i++) {
      cubes[i].moveTowards(cubes[i-1].location, this.nudge);
    }
  }

  void nudgeRotateYAndMoveForward(float angle, float forward) {
    this.angleFacing.y += angle;    
    for (int i = 1; i < cubes.length; i++) {
      cubes[i].rotateY(cubes[i-1].angleFacing.y + angle);
      cubes[i].moveTowards(cubes[i-1].location, new PVector(forward, 0, 0));
    }        
  }

  void nudgeRotateArrayX(float angle) {
    this.angleFacing.x += angle;
    for (int i = 1; i < cubes.length; i++) {
      cubes[i].rotateX(cubes[i-1].angleFacing.x + angle);
    }    
  }

  void nudgeRotateArrayY(float angle) {
    this.angleFacing.y += angle;
    for (int i = 1; i < cubes.length; i++) {
      cubes[i].rotateY(cubes[i-1].angleFacing.y + angle);
    }    
  }
  
}

// Cube cube = new Cube(new PVector(20, 20, 20), new PVector(100, 100, 100));  
CubeArray cubes = new CubeArray(new PVector(20, 20, 20), new PVector(25, 25, 25), new PVector(0,0,0), 200);
int y = 0;

float speed = 1;
int speedLimit = 2;
int limitX, limitY, limitZ;



PVector nudge = new PVector(speed, speed, speed);

void adjustRotation() {
  if (limitX >= cubes.nudge.x && cubes.nudge.x >= -limitX)
    nudge.x = nudge.x;
  else if (cubes.nudge.x > limitX)
    nudge.x = -speed;
  else if (cubes.nudge.x < -limitX)
    nudge.x = speed;

  if (limitY >= cubes.nudge.y && cubes.nudge.y >= -limitY)
    nudge.y = nudge.y;
  else if (cubes.nudge.y > limitY)
    nudge.y = -speed;
  else if (cubes.nudge.y < -limitY)
    nudge.y = speed;
    
  if (limitZ >= cubes.nudge.z && cubes.nudge.z >= -limitZ)
    nudge.z = nudge.z;
  else if (cubes.nudge.z > limitZ)
    nudge.z = -speed;
  else if (cubes.nudge.z < -limitZ)
    nudge.z = speed;
    
  cubes.nudgeArray(nudge);
  println(cubes.nudge.z);
}


void setup() { 
  size(800, 600, P3D);

  noStroke();
  cam = new PeasyCam(this, width); 
  
  limitX = limitY = limitZ = 25;
}

void draw() {
  background(0);
  cubes.draw();
  //  cubes.relativeRotateXThenNudgeXY(PI/32, -0.5);
  //  cubes.nudgeArray(new PVector(0, 0.1, 0));
  //  cubes.nudgeRotateArrayY(PI/128);
  //  cubes.nudgeSecondMoveRest(new PVector(0, 5*i, 0));

//  cubes.nudgeRotateArrayY(PI/256);
  cubes.nudgeRotateYAndMoveForward(PI/72, 10);

//  adjustRotation();
  //  cubes.nudgeRotateArrayX(PI/128);
   
  if (speed <= speedLimit)
    speed += 0.1;
  else if (speed >= speedLimit)
    speed -= 0.1;
}

void keyPressed() {
  if (keyCode == UP) 
    speed += 1;

  if (keyCode == DOWN)
    speed -= 1;
}



