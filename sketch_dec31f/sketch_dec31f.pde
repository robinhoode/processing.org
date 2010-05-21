/**
 * Interative Toroid with GUI control
 * by Peter Lager
 * 
 * Modification of the example
 * Interactive Toroid by Ira Greenberg. 
 *
 * the toroid has been abstracted to its own class to separate form GUI code
 * for clarity
 * 
 * Illustrates the geometric relationship between Toroid, Sphere, and Helix
 * 3D primitives, as well as lathing principal.
 * 
 */

import processing.opengl.*;
import guicomponents.*;

GLabel lblSegs, lblERad, lblPts, lblLRad;
GSlider sdrSegs, sdrERad, sdrPts, sdrLRad;
GCheckbox cbxWire;
GOption optTorroid, optHelix;
GOptionGroup optShape;
GPanel p;

Toroid t1;

void setup(){
  size(640, 360, OPENGL);
  t1 = new Toroid();

  // Sets the colour scheme for the GUI components 
  // Schemes available are 
  // BLUE_SCHEME, GREEN_SCHEME, RED_SCHEME, GREY_SCHEME
  // YELLOW_SCHEME, CYAN_SCHEME, PURPLE_SCHEME
  // Defaults to BLUE_SCHEME 
  GComponent.globalColor = GCScheme.getColor(this,  GCScheme.BLUE_SCHEME);
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
  GComponent.globalFont = GFont.getFont(this, "Georgia", 11);
  
  // Create the various GUI components
  p = new GPanel(this, "Toroid Control Panel", 30, 30, 460, 90);
  p.setAlpha(192);
  lblSegs = new GLabel(this, "Segment detail", 2, 4, 120);
  lblPts = new GLabel(this, "Ellipse detail", 2, 18, 120);
  lblERad = new GLabel(this, "Ellipse Radius", 2, 32, 120);
  lblLRad = new GLabel(this, "Toroid Radius", 2, 46, 120);
  sdrSegs = new GHorzSlider(this, 125, 4, 325, 11);
  sdrPts = new GHorzSlider(this, 125, 18, 325, 11);
  sdrERad = new GHorzSlider(this, 125, 32, 325, 11);
  sdrLRad = new GHorzSlider(this, 125, 46, 325, 11);
  sdrSegs.setLimits(60, 3, 80);
  sdrPts.setLimits(40,3,40);
  sdrERad.setLimits(60,10,100);
  sdrLRad.setLimits(100,0,240);

  optTorroid = new GOption(this, "Toroid?", 2, 60, 80);
  optHelix = new GOption(this, "Helix?", 2, 74, 80);
  cbxWire = new GCheckbox(this, "Wire frame?", 102, 60, 100);


  p.add(lblSegs);
  p.add(lblPts);
  p.add(lblERad);
  p.add(lblLRad);
  p.add(sdrSegs);
  p.add(sdrPts);
  p.add(sdrERad);
  p.add(sdrLRad);
  optShape = new GOptionGroup(this);
  p.add(optHelix);
  p.add(optTorroid);
  p.add(cbxWire);
  optShape.addOption(optTorroid);
  optShape.addOption(optHelix);
  optTorroid.setSelected(true);
 
}

public void handleSliderEvents(GSlider slider){
  if(slider == sdrSegs)
    t1.setSegmentDetail(sdrSegs.getValue());
  if(slider == sdrPts)
    t1.setEllipseDetail(sdrPts.getValue());
  if(slider == sdrERad)
    t1.setEllipseRadius(sdrERad.getValue()); 
  if(slider == sdrLRad)
    t1.setLatheRadius(sdrLRad.getValue()); 
}

public void handleCheckboxEvents(GCheckbox cbox){
  if(cbox == cbxWire)
    t1.setIsWire(cbxWire.isSelected());
}

public void handleOptionEvents(GOption selected, GOption deselected){
  if(selected == optHelix)
    t1.setIsHelix(true);
  else
    t1.setIsHelix(false);     
}

void draw(){
  pushMatrix();
  background(192, 220, 192);
  // basic lighting setup
  lights();
  // 2 rendering styles
  //center and spin toroid
  translate(width/2, height/2, -200);

  rotateX(frameCount*PI/150);
  rotateY(frameCount*PI/170);
  rotateZ(frameCount*PI/90);

  // draw toroid
  t1.draw();
  popMatrix();
}
