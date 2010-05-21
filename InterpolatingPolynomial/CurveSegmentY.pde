
class CurveSegmentY {
  GMatrix matrix;
  GVector coeff;
  ArrayList points;
    
  CurveSegmentY(ArrayList points) {
    this.points = points;
    
    computeCoeffs();        
  }
  
  PVector getFirst() {
    return (PVector) points.get(0);
  }
  
  PVector getLast() {
    return (PVector) points.get(points.size()-1);
  }  
  
  GMatrix constructMatrix() {
    matrix = new GMatrix(points.size(), points.size());
    
    for (int i = 0; i < points.size(); i++) {
      double[] row = new double[points.size()];
      for (int j = 0; j < points.size(); j++) {
        PVector vector = (PVector) points.get(i);
        row[j] = pow(vector.y, j);
      }
      matrix.setRow(i, row);
    }
    
    println("Matrix is " + matrix);
    
    return matrix;
  }

  GVector constructVector() {
    GVector vector = new GVector(points.size());
    
    double[] row = new double[points.size()];
    
    for (int i = 0; i < points.size(); i++) {
      PVector point = (PVector) points.get(i);
      row[i] = point.x;
    }
    
    vector.set(row);
    return vector;
  }  

  void computeCoeffs() {
    GMatrix inverse = constructMatrix();
    inverse.invert();
    coeff = new GVector(points.size());
    coeff.mul(inverse, constructVector());
  }

  float eval(double y) {
    float sum = 0;
    for (int i = 0; i < coeff.getSize(); i++) {
      sum += coeff.getElement(i)*pow((float) y, i);
    }
    return sum;
  }

  void draw() {
    stroke(255);
    int step = 1;
    for (float i = getFirst().y; i < getLast().y; i += step) {
      line(eval(i), i, eval(i+step), i+step  );
    }
  }
}

