
class Curve {
  GMatrix matrix;
  GVector coeff;
  ArrayList points;
  
  Curve(ArrayList points) {
    this.points = points;
    
    computeCoeffs();    
  }
  
  Curve(double[] data) {
    this.coeff = new GVector(data);
  }
  
  GMatrix constructMatrix() {
    matrix = new GMatrix(points.size(), points.size());
    
    for (int i = 0; i < points.size(); i++) {
      double[] row = new double[points.size()];
      for (int j = 0; j < points.size(); j++) {
        PVector vector = (PVector) points.get(i);
        row[j] = pow(vector.x, j);
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
      row[i] = point.y;
    }
    
    vector.set(row);    
    println("Vector is " + vector);
    return vector;
  }  
  
  void computeCoeffs() {
    GMatrix inverse = constructMatrix();
    inverse.invert();
    println("Inverse is " + inverse);
    coeff = new GVector(points.size());
    coeff.mul(inverse, constructVector());
    println("Coeffients are " + coeff);
    for (int i = 0; i < width; i += 10) {
      println("Point is x = " + i + ", y = " + eval(i));
    }
  }
  
  float eval(double x) {
    float sum = 0;
    for (int i = 0; i < coeff.getSize(); i++) {
      sum += coeff.getElement(i)*pow((float) x, i);
    }
    return sum;
  }
  
  void draw() {
    stroke(255);
    int step = 1;
    for (int i = 0; i < width; i += step) {
      line(i, eval(i), i+step, eval(i+step));
    }
  }
}
