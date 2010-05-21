float depth = 400;  

import peasy.*; 
PeasyCam cam;


void setup(){ 
  size(800, 600, P3D); 
  
  noStroke();
  cam = new PeasyCam(this, width);
} 
 
void draw(){ 
  background(15, 15, 15); 
 
 
  for(int i=0; i<1; i++) {
  
    for (int y = -2; y < 2; y++) { 
      for (int x = -2; x < 2; x++) { 
        for (int z = -2; z < 2; z++) {  
          pushMatrix();
          noFill();          
          stroke(0,255,0);
          translate(50*x, 50*y, 50*z); 
          box(50, 50, 50); 
          popMatrix(); 
        } 
      } 
    } 
  } 
  
} 
 

