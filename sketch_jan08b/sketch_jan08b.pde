import processing.opengl.*;
import javax.media.opengl.*; 
import peasy.*;

//PeasyCam cam;

void setup() {
  size(800, 600, OPENGL);
//  cam = new PeasyCam(this, width);
  location = new PVector(width/2+10, height/2+10, -100);
}

PVector rotateAbout(PVector location, PVector center) {
  float x = (float) (location.x - center.x);
  float y = (float) (location.y - center.y);
  
  float distance = sqrt(x*x + y*y);
  float angle    = atan2(y, x)+PI/256;
  println("angle is " + (angle*PI));
  
  return new PVector(distance*cos(angle) + center.x, distance*sin(angle) + center.y, location.z);  
}

PVector location;

void draw() {
  background(0);
  location.z += 0.1;
  location   = rotateAbout(location, new PVector(width/2, height/2, 0));
  println("location is now " + location);
  translate(location.x, location.y, location.z);
  box(50);
}
