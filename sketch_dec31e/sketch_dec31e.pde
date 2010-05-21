import peasy.*;
import guicomponents.*;
import processing.opengl.*;

PeasyCam cam;
CubeArray cubes;

GPanel panel;
GHorzSlider angleXSlider, angleYSlider, angleZSlider;
GHorzSlider nudgeXSlider, nudgeYSlider, nudgeZSlider;
GHorzSlider shiftXSlider, shiftYSlider, shiftZSlider;

// Used to remember PGraphics3D transformation matrix
PGraphics3D g3;

float[] rotations = new float[3];

void setupGUI() {
  GComponent.globalColor = GCScheme.getColor(this,  GCScheme.GREY_SCHEME);
  GComponent.globalFont = GFont.getFont(this, "Serif", 11);

  panel = new GPanel(this, "Boxes Control Panel", 30, 30, 500, 180);
  panel.setAlpha(192);

  panel.add(new GLabel(this, "X Angle", 2, 0, 120));
  angleXSlider = new GHorzSlider(this, 125, 0, 325, 10);
  angleXSlider.setLimits(0,-180,180);
  angleXSlider.setInertia(0);
  panel.add(angleXSlider);
  
  panel.add(new GLabel(this, "Y Angle", 2, 16, 120));
  angleYSlider = new GHorzSlider(this, 125, 16, 325, 10);
  angleYSlider.setLimits(0,-180,180);
  angleYSlider.setInertia(0);
  panel.add(angleYSlider);
  
  panel.add(new GLabel(this, "Z Angle", 2, 32, 120));
  angleZSlider = new GHorzSlider(this, 125, 32, 325, 10);
  angleZSlider.setLimits(0,-180,180);
  angleZSlider.setInertia(0);
  panel.add(angleZSlider);

  panel.add(new GLabel(this, "X Nudge", 2, 48, 120));
  nudgeXSlider = new GHorzSlider(this, 125, 48, 325, 10);
  nudgeXSlider.setLimits(0,-100,100);
  nudgeXSlider.setInertia(0);
  panel.add(nudgeXSlider);

  panel.add(new GLabel(this, "Y Nudge", 2, 64, 120));
  nudgeYSlider = new GHorzSlider(this, 125, 64, 325, 10);
  nudgeYSlider.setLimits(0,-100,100);
  nudgeYSlider.setInertia(0);
  panel.add(nudgeYSlider);

  panel.add(new GLabel(this, "Z Nudge", 2, 80, 120));
  nudgeZSlider = new GHorzSlider(this, 125, 80, 325, 10);
  nudgeZSlider.setLimits(0,-100,100);
  nudgeZSlider.setInertia(0);
  panel.add(nudgeZSlider);
  
  panel.add(new GLabel(this, "X Shift", 2, 96, 120));
  shiftXSlider = new GHorzSlider(this, 125, 96, 325, 10);
  shiftXSlider.setLimits(0,-100,100);
  shiftXSlider.setInertia(0);
  panel.add(shiftXSlider);

  panel.add(new GLabel(this, "Y Nudge", 2, 112, 120));
  shiftYSlider = new GHorzSlider(this, 125, 112, 325, 10);
  shiftYSlider.setLimits(0,-100,100);
  shiftYSlider.setInertia(0);
  panel.add(shiftYSlider);

  panel.add(new GLabel(this, "Z Nudge", 2, 128, 120));
  shiftZSlider = new GHorzSlider(this, 125, 128, 325, 10);
  shiftZSlider.setLimits(0,-100,100);
  shiftZSlider.setInertia(0);
  panel.add(shiftZSlider);

  g3 = (PGraphics3D) g;
}


void setup() { 
  size(800, 600, OPENGL);
  noStroke();  

  cam = new PeasyCam(this, width);
  cubes = new CubeArray(100, new Vector3D(0, 0, 0), new Vector3D(50, 50, 50), new Vector3D(0, 0, 0));
  // Remember PGraphics3D transformation matrix
  setupGUI();
}

void draw() {  
  background(0);
  lights();

  updateCubes();  
  drawGUI();
}

void updateCubes() {
  Vector3D nudge = new Vector3D(nudgeXSlider.getValue(), nudgeYSlider.getValue(), nudgeZSlider.getValue());
  Vector3D shift = new Vector3D(shiftXSlider.getValue(), shiftYSlider.getValue(), shiftZSlider.getValue());
  
  float angleX, angleY, angleZ;

  if (angleXSlider.getValue() == 0)
    angleX = PI;
  else
    angleX = PI/angleXSlider.getValue();
    
  if (angleYSlider.getValue() == 0)
    angleY = PI;
  else
    angleY = PI/angleYSlider.getValue();
    
  if (angleZSlider.getValue() == 0)
    angleZ = PI;
  else
    angleZ = PI/angleZSlider.getValue();

  cubes.iterate(nudge, shift, new Vector3D(angleX, angleY, angleZ));  
  cubes.draw();
}

void drawGUI() {
  if (panel.isCollapsed()) {
    cam.setMouseControlled(!panel.isDragging());
  } 
  else {
    cam.setMouseControlled(false);  
  }  

  rotations = cam.getRotations();
  PMatrix3D currCameraMatrix = new PMatrix3D(g3.camera);
  camera();
  G4P.draw();
  g3.camera = currCameraMatrix;
}

