
class Matrix3D {
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
    return new Matrix3D(
    1,          0,           0,
    0, cos(angle), -sin(angle),
    0, sin(angle),  cos(angle));
  }

  static Matrix3D rotationY(float angle) {
    return new Matrix3D(
    cos(angle),  0, sin(angle),
             0,  1,          0,
    -sin(angle), 0, cos(angle));
  }

  static Matrix3D rotationZ(float angle) {
    return new Matrix3D(
    cos(angle), -sin(angle), 0,
    sin(angle),  cos(angle), 0,
             0,           0, 1);
  }

  Matrix3D mult(Matrix3D other) {
    float[][] newMatrix = new float[3][3];

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

  PVector mult(PVector vector) {
    return new PVector(matrix[0][0] * vector.x + matrix[0][1] * vector.y + matrix[0][2] * vector.z,
    matrix[1][0] * vector.x + matrix[1][1] * vector.y + matrix[1][2] * vector.z,
    matrix[2][0] * vector.x + matrix[2][1] * vector.y + matrix[2][2] * vector.z);
  }
  
  String toString() {
    return "[" + matrix[0][0] + "," + matrix[0][1] + "," + matrix[0][2] + "]," +
           "[" + matrix[1][0] + "," + matrix[1][1] + "," + matrix[1][2] + "]," +
           "[" + matrix[2][0] + "," + matrix[2][1] + "," + matrix[2][2] + "]";
  }
}

