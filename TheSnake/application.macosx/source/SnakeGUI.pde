
class SnakeGUI {
  PeasyCam cam;
  float[] rotations = new float[3];
  
  PGraphics3D g3;
  
  GPanel panel;
  GHorzSlider angleXSlider, angleYSlider, angleZSlider;
  GHorzSlider nudgeXSlider, nudgeYSlider, nudgeZSlider;
  GHorzSlider shiftXSlider, shiftYSlider, shiftZSlider;
  
  SnakeGUI(PeasyCam cam, PGraphics3D g3){
    this.cam   = cam;
    this.g3    = g3;
    this.panel = panel;
  }
  
  void setup(PApplet applet) {
    GComponent.globalColor = GCScheme.getColor(applet,  GCScheme.GREY_SCHEME);
    GComponent.globalFont = GFont.getFont(applet, "Serif", 11);
  
    panel = new GPanel(applet, "Boxes Control Panel", 30, 30, 500, 180);
    panel.setAlpha(192);
  
    panel.add(new GLabel(applet, "X Angle", 2, 0, 120));
    angleXSlider = new GHorzSlider(applet, 125, 0, 325, 10);
    angleXSlider.setLimits(180,0,360);
    angleXSlider.setInertia(0);
    panel.add(angleXSlider);
    
    panel.add(new GLabel(applet, "Y Angle", 2, 16, 120));
    angleYSlider = new GHorzSlider(applet, 125, 16, 325, 10);
    angleYSlider.setLimits(180,0,360);
    angleYSlider.setInertia(0);
    panel.add(angleYSlider);
    
    panel.add(new GLabel(applet, "Z Angle", 2, 32, 120));
    angleZSlider = new GHorzSlider(applet, 125, 32, 325, 10);
    angleZSlider.setLimits(180,0,360);
    angleZSlider.setInertia(0);
    panel.add(angleZSlider);
  
    panel.add(new GLabel(applet, "X Nudge", 2, 48, 120));
    nudgeXSlider = new GHorzSlider(applet, 125, 48, 325, 10);
    nudgeXSlider.setLimits(0,-100,100);
    nudgeXSlider.setInertia(0);
    panel.add(nudgeXSlider);
  
    panel.add(new GLabel(applet, "Y Nudge", 2, 64, 120));
    nudgeYSlider = new GHorzSlider(applet, 125, 64, 325, 10);
    nudgeYSlider.setLimits(0,-100,100);
    nudgeYSlider.setInertia(0);
    panel.add(nudgeYSlider);
  
    panel.add(new GLabel(applet, "Z Nudge", 2, 80, 120));
    nudgeZSlider = new GHorzSlider(applet, 125, 80, 325, 10);
    nudgeZSlider.setLimits(0,-100,100);
    nudgeZSlider.setInertia(0);
    panel.add(nudgeZSlider);
    
    panel.add(new GLabel(applet, "X Shift", 2, 96, 120));
    shiftXSlider = new GHorzSlider(applet, 125, 96, 325, 10);
    shiftXSlider.setLimits(0,-100,100);
    shiftXSlider.setInertia(0);
    panel.add(shiftXSlider);
  
    panel.add(new GLabel(applet, "Y Shift", 2, 112, 120));
    shiftYSlider = new GHorzSlider(applet, 125, 112, 325, 10);
    shiftYSlider.setLimits(0,-100,100);
    shiftYSlider.setInertia(0);
    panel.add(shiftYSlider);
  
    panel.add(new GLabel(applet, "Z Shift", 2, 128, 120));
    shiftZSlider = new GHorzSlider(applet, 125, 128, 325, 10);
    shiftZSlider.setLimits(0,-100,100);
    shiftZSlider.setInertia(0);
    panel.add(shiftZSlider);
  }
  
  void draw() {
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

  Vector3D nudgeVector() {
    return new Vector3D(nudgeXSlider.getValue(), nudgeYSlider.getValue(), nudgeZSlider.getValue());
  }
  
  Vector3D shiftVector() {
    return new Vector3D(shiftXSlider.getValue(), shiftYSlider.getValue(), shiftZSlider.getValue());
  }
  
  Vector3D angleVector() {
    float angleX, angleY, angleZ;
    angleX = angleXSlider.getValue()*PI/360;
    angleY = angleYSlider.getValue()*PI/360;
    angleZ = angleZSlider.getValue()*PI/360;
    
    return new Vector3D(angleX, angleY, angleZ);
  }
}
