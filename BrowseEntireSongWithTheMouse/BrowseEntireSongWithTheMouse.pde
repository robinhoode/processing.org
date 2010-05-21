/* Browse the song
 *
 * Functionality:
 *  - Should load AFX - Analord 08 - Track 01 
 *    (just for convenience, without picking each time)
 *  - Move left to right by dragging the window
 *  - Zoom in and out with the mouse wheel
 *
 *
 *
 * TODO:
 *  - If AFX track is not found, launch file chooser
 *    instead of crashing
 *  - Center the zoom better (i.e. the center of the screen)
 *  - Add scroll bar at the bottom to show where you
 *    are in the track.
 *  - Make said scrollbar draggable, a much faster way to
 *    scroll through the track 
 *
 * VERY MUCH LATER TODO:
 *  - Do primitive beat detection
 *  - Integrate with DrawPoints
 *  - Add save feature to save chosen beats.
 */


import processing.opengl.*;
import ddf.minim.*;
import java.awt.event.*;

Waveform waveform; 
Cursor cursor;

void setup() {
  size(800, 600, OPENGL);
  smooth();
 
  cursor = new Cursor(new PVector(0, 0));
 
  Minim minim = new Minim(this);
  FileChooser chooser = new FileChooser();
  
  String filePath = "L:\\root\\artists\\AFX\\afx - analord 08\\0801 - pwsteal.ldpinch.d.mp3";
  
  waveform = new Waveform(filePath, minim);
  
  addMouseWheelListener(new MouseWheelListener() { 
    public void mouseWheelMoved(MouseWheelEvent evt) { 
      mouseWheel(evt.getWheelRotation());
  }}); 

  waveform.draw();
  textFont(createFont("Arial-Bold", 12), 12);
}
 
void draw() {
  waveform.draw();
  cursor.draw();
  waveform.drawInfo();  
}

void mousePressed() {
  lastMouseX = mouseX;
  cursor = new Cursor(new PVector(mouseX, mouseY));
}

int lastMouseX = 0, lastMouseY = 0;
void mouseDragged() {    
  waveform.mouseDragged(lastMouseX);
  lastMouseX = mouseX;
}

void mouseWheel(int delta) {
  waveform.mouseWheel(delta);
}

void stop() {
  waveform.stop();
}
