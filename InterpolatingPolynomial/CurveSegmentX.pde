
class CurveSegmentX {
  GMatrix matrix;
  GVector coeff;
  ArrayList points;
    
  CurveSegmentX(ArrayList points) {
    this.points = points;
    
    computeCoeffs();        
  }
  
  PVector get(int i) {
    return (PVector) points.get(i);    
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
        row[j] = pow(valueAt(i), j);
      }
      matrix.setRow(i, row);
    }
    
    println("Matrix is " + matrix);
    
    return matrix;
  }

  float valueAt(int i) {
    return get(i).x;
    /*
    if (i == 0)
      return getFirst().x;
    else
      return abs(get(i) - get(i-1));
      */
  }

  GVector constructVector() {
    GVector vector = new GVector(points.size());
    
    double[] row = new double[points.size()];
   
    for (int i = 0; i < points.size(); i++) {
      PVector point = (PVector) points.get(i);
      row[i] = point.y;
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

  float eval(float x) {
    float sum = 0;
    for (int i = 0; i < coeff.getSize(); i++) {
      sum += coeff.getElement(i)*pow(x, i);
    }
    return sum;
  }

  void draw() {
    stroke(255);
    int step = 1;
    for (float i = getFirst().x; i < getLast().x; i += step) {
      line(i, eval(i), i+step, eval(i+step));
    }
  }
}

