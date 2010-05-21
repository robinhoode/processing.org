class CubeArray {
  Cube[] cubes;
  
  CubeArray(int count, Vector3D location, Vector3D dimensions, Vector3D angleFacing) {
    cubes = new Cube[count];
    cubes[0] = new Cube(location, dimensions, angleFacing);
  }
  
  void iterate(Vector3D nudge, Vector3D shift, Vector3D spin) {
    for (int i = 1; i < cubes.length; i++) {
      cubes[i] = cubes[i-1].clone();
      cubes[i].nudge(nudge);
      cubes[i].shift(shift);
      cubes[i].spin(spin);
    }
  }
  
  void iterateNudge(float x, float y, float z) {
    for (int i = 1; i < cubes.length; i++) {
      cubes[i] = cubes[i-1].clone();
      cubes[i].nudge(new Vector3D(x, y, z));
    }    
  }
    
  void iterateShift(float x, float y, float z) {
    for (int i = 1; i < cubes.length; i++) {
      cubes[i] = cubes[i-1].clone();
      cubes[i].shift(new Vector3D(x, y, z));
    }    
  }
  
  void draw() {
    for (int i = 0; i < cubes.length; i++) {
      if (cubes[i] != null)
        cubes[i].draw();
    }
  }
}

