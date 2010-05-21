/**
 * PeasyCam with GUI control
 *
 * Extends PeasyCam example to use with GUI4processing by
 * providing sliders to control the angles.
 *
 * When the panel is open you can drag the sliders to rotate
 * the cube. When the panel is closed then dragging the mouse
 * over the display will rotate the cube as per PeaseyCam
 * example.
 *
 * The control code is quite complex because PeasyCam does 
 * not provide methods to set the rotation angles abso;utely
 * only relatively.
 *
 * Click on the panel tab to open/close the panel.
 * 
 * by Peter Lager
 */

import processing.opengl.*;
import guicomponents.*;
import peasy.*;

PeasyCam cam;

GPanel pnl;
GHorzSlider sx,sy, sz;
int ax, ay, az;

// These are needed to remember PeasyCam offset and distance
float[] offsets = new float[3];
float[] rotations = new float[3];
double distance = 0.0f;

// Remember last slider values
// PeasyCam does not provide methods to set the absolute
// rotation angles, rotateX(ang) rotates about the X axis
// by ang radians
int lastSx, lastSy, lastSz;
int currSx, currSy, currSz;

// Used to remember PGraphics3D transformation matrix
PGraphics3D g3;

void setup() {
  // Change OPENGL to P3D to use Java 3D both work but OpenGL
  // gives a better font display while Java 3D is probably
  // better for applets - smaller file size but needs  larger 
  // font size.
  size(400,400,OPENGL);
  // Create a PeasyCam object
  cam = new PeasyCam(this, 100);
  cam.setMinimumDistance(50);
  cam.setMaximumDistance(500);

  // Sets the colour scheme for the GUI components 
  // Schemes available are 
  // BLUE_SCHEME, GREEN_SCHEME, RED_SCHEME, GREY_SCHEME
  // YELLOW_SCHEME, CYAN_SCHEME, PURPLE_SCHEME
  // Defaults to BLUE_SCHEME 
  GComponent.globalColor = GCScheme.getColor(this,  GCScheme.RED_SCHEME);

  /* GFont.getFont() - parameters
   * 1) this (always)
   * 2) font name (see below)
   * 3) font size
   *
   * The font name will depend on the OS used and fonts installed. It should be the same
   * as those listed in the 'Create Font' tool in processing. Alternatively use
   * println(PFont.list());
   * in a Processing sketch
   */
  GComponent.globalFont = GFont.getFont(this, "Georgia", 12);

  // Create a collapsible panel
  // (this, tab title, x, y, width, height)
  pnl = new GPanel(this, "PeasyCam Control", 10,300,300,72);

  // Create a horizontal slider
  // (this, x, y, width, height)
  // default value limits 0-100 and initial value 50
  sx = new GHorzSlider(this, 10, 8, 280, 16);
  // set slider value limits (initial value, min, max)
  sx.setLimits(0,-180,180);
  // Set thumb inertia for nice visual effect - acceptable
  // values 1 to 100 (default = 1  i.e. no inertia)
  sx.setInertia(20);

  sy = new GHorzSlider(this, 10, 28, 280, 16);
  sy.setLimits(0,-180,180);
  sy.setInertia(20);

  sz = new GHorzSlider(this, 10, 48, 280, 16);
  sz.setLimits(0,-180,180);
  sz.setInertia(20);

  // Add the sliders to the panel x,y coordinates are now 
  // relative to the top left of the panel open area below
  // the tab
  pnl.add(sx);
  pnl.add(sy);
  pnl.add(sz);

  // Remember PGraphics3D transformation matrix
  g3 = (PGraphics3D)g;
}

void draw() {
  // Switch off PeasyCam mouse control if the panel is being
  // dragged else turn it on
  if(pnl.isCollapsed()){
    // Panel is collapsed
    cam.setMouseControlled(!pnl.isDragging());
  }
  else {
    // panel open must be using sliders
    cam.setMouseControlled(false);  
  }
  pushMatrix();
  rotateX(-.5);
  rotateY(-.5);
  background(0);
  strokeWeight(2);
  stroke(255,255,0);
  fill(255,0,0);
  box(30);
  translate(0,0,20);
  fill(0,0,255);
  box(5);
  popMatrix();
  Gui2D();
}


/*
This function displays how we can create a HUD with PeasyCam.
 */
void Gui2D(){
  // Get the current PeasyCam details to restore later
  //  offsets = cam.getLookAt();
  rotations = cam.getRotations();
  //  distance = cam.getDistance();

  // Get a handle on the current PGraphics?D transformation matrix
  PMatrix3D currCameraMatrix = new PMatrix3D(g3.camera);

  // This statement resets the camera in PGraphics3D, this effectively 
  // sets the display to behave as 2D with the origin 0,0 at the top-left
  // of the display
  camera();

  // Draw the HUD using PApplet graphics commands and GUI for Processing
  // 2D gui components
  G4P.draw();

  // Reset the PGraphics3D transformation matrix
  g3.camera = currCameraMatrix;


  // Since this code will modify the PeasyCam object it must be
  // done after we have set the g3.camera back to its original
  // 3D state.

  // If neccessary update slider positions
  if(pnl.isCollapsed() == true){
    // Update slider positions
    currSx = lastSx = (int)Math.toDegrees(rotations[0]);
    currSy = lastSy = (int)Math.toDegrees(rotations[1]);
    currSz = lastSz = (int)Math.toDegrees(rotations[2]);

    // There are 2 methods to set the value of the slider
    // setValue(value); it takes into account any inertia
    // setValue(value, ignore); where ignore is a boolean value
    // which if true will set the value and move the thumb
    // immediatetly ignoring any inertia value
    sx.setValue((int)Math.toDegrees(rotations[0]), true);
    sy.setValue((int)Math.toDegrees(rotations[1]), true);
    sz.setValue((int)Math.toDegrees(rotations[2]), true);
  }
  else {
    // Use sliders to control rotation
    if(currSx != lastSx){
      cam.rotateX(Math.toRadians(currSx - lastSx));
      lastSx = currSx;
    }
    if(currSy != lastSy){
      cam.rotateY(Math.toRadians(currSy - lastSy));
      lastSy = currSy;
    }
    if(currSz != lastSz){
      cam.rotateZ(Math.toRadians(currSz - lastSz));
      lastSz = currSz;
    }
  }
}

// Handle panels events i.e. when a panel is opened or
// collapsed
void handlePanelEvents(GPanel panel){
  // Intended to detect panel events but ended up not
  // needing it. Left the following code as an example
  if(pnl.isCollapsed())
    println("Panel has collapsed");
  else
    println("Panel has opened");

}

// Handles slider events for both horizontal and
// vertical sliders
void handleSliderEvents(GSlider slider){
  if(slider == sx){
    currSx = slider.getValue();
  }
  if(slider == sy){
    currSy = slider.getValue(); 
  }
  if(slider == sz){
    currSz = slider.getValue(); 
  }
}
