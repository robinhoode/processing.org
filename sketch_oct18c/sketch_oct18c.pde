import peasy.*; 
PeasyCam cam;

ArrayList spheres = new ArrayList();

float sphereCount = 200;

void setup() { 
  size(800, 600, P3D);
  
  noStroke();
  cam = new PeasyCam(this, width);

  for (int i = 0; i < sphereCount; i++)
    spheres.add(new GravSphere(10, new PVector(random(100), random(100), random(100)), 1));
}

void draw() {
  background(15, 15, 15);
  noFill();  
  
  GravSphere mySphere;
  
  for (int i = 0; i < spheres.size(); i++) {  
    mySphere = (GravSphere) spheres.get(i);
    mySphere.drawLines();
    mySphere.gravitateTowards(new PVector(1, 1, 1), 1000);
    mySphere.update();  
  }
}
