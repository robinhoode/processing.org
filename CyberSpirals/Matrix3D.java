
class Matrix3D {
  double matrix[][] = new double[3][3];

  Matrix3D(double x11, double x12, double x13, double x21, double x22, double x23, double x31, double x32, double x33) {
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

  Matrix3D(double[][] matrix) {
    this.matrix = matrix;
  }

  static Matrix3D rotationX(double angle) {
    return new Matrix3D(
    1,               0,                0,
    0, Math.cos(angle), -Math.sin(angle),
    0, Math.sin(angle),  Math.cos(angle));
  }

  static Matrix3D rotateX(double angle) {
    return rotationX(angle);
  }

  static Matrix3D rotationY(double angle) {
    return new Matrix3D(
    Math.cos(angle),  0, Math.sin(angle),
                  0,  1,               0,
    -Math.sin(angle), 0, Math.cos(angle));
  }
  
  static Matrix3D rotateY(double angle) {
    return rotationY(angle);
  }

  static Matrix3D rotationZ(double angle) {
    return new Matrix3D(
    Math.cos(angle), -Math.sin(angle), 0,
    Math.sin(angle),  Math.cos(angle), 0,
                   0,               0, 1);
  }
  
  static Matrix3D rotateZ(double angle) {
    return rotationZ(angle);
  }

  Matrix3D mult(Matrix3D other) {
    double[][] newMatrix = new double[3][3];

    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        newMatrix[i][j] = 0;
        for (int k = 0; k < 3; k++) {
          newMatrix[i][j] += matrix[i][k]*other.matrix[k][j];
        }
      }
    }

    return new Matrix3D(newMatrix);
  }

  Vector3D mult(Vector3D vector) {
    return new Vector3D(matrix[0][0] * vector.x + matrix[0][1] * vector.y + matrix[0][2] * vector.z,
    matrix[1][0] * vector.x + matrix[1][1] * vector.y + matrix[1][2] * vector.z,
    matrix[2][0] * vector.x + matrix[2][1] * vector.y + matrix[2][2] * vector.z);
  }
  
  public String toString() {
    return "[" + matrix[0][0] + "," + matrix[0][1] + "," + matrix[0][2] + "]," +
           "[" + matrix[1][0] + "," + matrix[1][1] + "," + matrix[1][2] + "]," +
           "[" + matrix[2][0] + "," + matrix[2][1] + "," + matrix[2][2] + "]";
  }
}


