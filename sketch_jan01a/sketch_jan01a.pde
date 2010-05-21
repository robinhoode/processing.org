 	
import processing.opengl.*;
import processing.video.*;

MovieMaker mm;  // Declare MovieMaker object

void setup() {

//  hint(ENABLE_OPENGL_4X_SMOOTH);
  // Create MovieMaker object with size, filename,
  // compression codec and quality, framerate
  size(320, 240, OPENGL);
//  hint(ENABLE_OPENGL_4X_SMOOTH);  
  mm = new MovieMaker(this, 320, 240, "drawing.mov",
                       120, MovieMaker.H263, MovieMaker.HIGH);
}

void draw() {
  background(0);   
  ellipse(mouseX, mouseY, 20, 20);  
  mm.addFrame();  // Add window's pixels to movie
}

void keyPressed() {
  if (key == ' ') {
    mm.finish();  // Finish the movie if space bar is pressed!
  }
}
