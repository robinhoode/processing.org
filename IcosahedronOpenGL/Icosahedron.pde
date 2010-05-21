
class Icosahedron {
  PVector[] points;
  int[][] lines;
  int[][] faces;
  int scalar;
  
  Icosahedron() {
    build();
    this.scalar = 1;
    scalePoints(scalar);
  }
  
  // Provide a scalar to resize the icosahedron
  Icosahedron(int scalar) {
    build();
    this.scalar = scalar;
    scalePoints(scalar);
  }
  
  void build() {
    buildPoints();
    buildLines();
    buildFaces();
  }
  
  void buildPoints() {
    points    = new PVector[12];
    
    points[0] = new PVector(0, 1, phi);
    points[1] = new PVector(0, -1, phi);
    
    points[2] = new PVector(0, 1, -phi);    
    points[3] = new PVector(0, -1, -phi);
    
    points[4] = new PVector(1, phi, 0);
    points[5] = new PVector(-1, phi, 0);
    
    points[6] = new PVector(1, -phi, 0);
    points[7] = new PVector(-1, -phi, 0);
    
    points[8]  = new PVector(phi, 0, 1);
    points[9]  = new PVector(phi, 0, -1);
    
    points[10] = new PVector(-phi, 0, -1);
    points[11] = new PVector(-phi, 0, 1);
  }
  
  void buildFaces() {
    faces = new int[20][3];
    
    // Initial 5
    faces[ 0] = new int[] {0, 8, 1};
    faces[ 1] = new int[] {0, 1, 11};
    faces[ 2] = new int[] {0, 11, 5};
    faces[ 3] = new int[] {0, 5, 4};
    faces[ 4] = new int[] {0, 4, 8};

    // Middle 10
    faces[ 5] = new int[] { 1,  6,  8};
    faces[ 6] = new int[] { 1,  6,  7};    
    faces[ 7] = new int[] { 1,  7, 11};

    faces[ 8] = new int[] { 2,  4,  5};
    faces[ 9] = new int[] { 2,  4,  9};        
    faces[10] = new int[] { 2,  5, 10};

    faces[11] = new int[] { 4,  8,  9};    
    faces[12] = new int[] { 5, 10, 11};
    faces[13] = new int[] { 6,  8,  9}; 
    faces[14] = new int[] { 7, 10, 11};    

    // Final 5
    faces[15] = new int[] {3, 2, 9};        
    faces[16] = new int[] {3, 2, 10};    
    faces[17] = new int[] {3, 6, 9};
    faces[18] = new int[] {3, 6, 7};    
    faces[19] = new int[] {3, 7, 10}; 
  }
  
  void buildLines() {
    lines = new int[30][2];
    
    // Flip "1" (the scalar)
    lines[ 0] = new int[] {0,1};
    lines[ 1] = new int[] {0,4};
    lines[ 2] = new int[] {0,5};
    lines[ 3] = new int[] {0,8};
    lines[ 4] = new int[] {0,11};

    lines[ 5] = new int[] {1,6};
    lines[ 6] = new int[] {1,7};
    lines[ 7] = new int[] {1,8};
    lines[ 8] = new int[] {1,11};
    
    lines[ 9] = new int[] {2,3};
    lines[10] = new int[] {2,4};
    lines[11] = new int[] {2,5};
    lines[12] = new int[] {2,9};
    lines[13] = new int[] {2,10};
    
    lines[14] = new int[] {3,6};
    lines[15] = new int[] {3,7};
    lines[16] = new int[] {3,9};
    lines[17] = new int[] {3,10};
    
    lines[18] = new int[] {4,5};
    lines[19] = new int[] {4,8};
    lines[20] = new int[] {4,9};
    
    lines[21] = new int[] {5,10};
    lines[22] = new int[] {5,11};
    
    lines[23] = new int[] {6,7};
    lines[24] = new int[] {6,8};
    lines[25] = new int[] {6,9};
    
    lines[26] = new int[] {7,10};
    lines[27] = new int[] {7,11};
    
    lines[28] = new int[] {8,9};
    
    lines[29] = new int[] {10,11};    
  }
    
  void scalePoints(int scalar) {
    for (int i = 0; i < points.length; i++) {
      points[i].mult(scalar);
    }
  }
  
  void plotVertex(PVector vector) {
    vertex(vector.x, vector.y, vector.z);
  }
    
  void draw() {
//    drawTriangles();
    drawIteratedTriangles();
  }
  
  void drawTriangles() {
    stroke(0, 0, 255);
    fill(0);
    beginShape(TRIANGLES);
    for (int i = 0; i < faces.length; i++) {
      plotVertex(points[faces[i][0]]);
      plotVertex(points[faces[i][1]]);
      plotVertex(points[faces[i][2]]);
    }
    endShape();
  }
  
  void drawIteratedTriangles() {
    stroke(0, 0, 255);
    fill(0);
    beginShape(TRIANGLES);
    for (int i = 0; i < faces.length; i++) {
      iterateFace(faces[i]);
    }
    endShape();    
  }
  
  void iterateFace(int[] face) {
    for (float j = 0; j < 10; j++) {
      plotVertex(points[face[0]]);
      plotVertex(between(points[face[1]], points[face[2]],   (j)/10));
      plotVertex(between(points[face[1]], points[face[2]], (j+1)/10));

      plotVertex(points[face[1]]);
      plotVertex(between(points[face[0]], points[face[2]],   (j)/10));
      plotVertex(between(points[face[0]], points[face[2]], (j+1)/10));
      
      plotVertex(points[face[2]]);
      plotVertex(between(points[face[0]], points[face[1]],   (j)/10));
      plotVertex(between(points[face[0]], points[face[1]], (j+1)/10));
    }
  }

  // Used for shape debugging. Probably not useful in a live setting
  // I also probably screwed it up by rearranging the points..
  void drawRectangles() {
    fill(0);
    
    beginShape();
    plotVertex(points[0]);
    plotVertex(points[1]);
    plotVertex(points[2]);
    plotVertex(points[3]);    
    endShape(CLOSE);
    
    beginShape();
    plotVertex(points[4]);
    plotVertex(points[5]);
    plotVertex(points[6]);
    plotVertex(points[7]);    
    endShape(CLOSE);
    
    beginShape();
    plotVertex(points[8]);
    plotVertex(points[9]);
    plotVertex(points[10]);
    plotVertex(points[11]);    
    endShape(CLOSE);    
  }  
}
