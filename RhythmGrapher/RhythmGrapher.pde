// Show a scrolling view of the music, trying to 
// line up where the rhythm/beat is

// Mouse X, Y shows up in the corner of the screen
// Level of the track hitting the line is shown also

// Press SPACE to pause

import processing.opengl.*;
import pitaru.sonia_v2_9.*;

PFont font;

int HISTORY_LENGTH = 800;
float[] history = new float[HISTORY_LENGTH];

void setup() {
   size(HISTORY_LENGTH, 600, OPENGL);
      
   // Start Sonia engine.
   Sonia.start(this); 
   
   // Start LiveInput and return 256 FFT frequency bands.
   LiveInput.start(); 
   LiveInput.useEqualizer(true);
   font = createFont("Arial-Bold", 12);  
}

boolean playing = true;

void keyPressed() {
  if (key == ' ')
    playing = !playing;
}

void draw() {
  background(0);

  stroke(255, 0, 0);
  

  recordHistory();
  
  stroke(255);
  line(mouseX, 0, mouseX, height);
  
  showMessage();
}

void recordHistory() {
  for (int i = 1; i < HISTORY_LENGTH; i++) {
    rect(i, height-history[i], 1, history[i]);
    if (playing)
      history[i-1] = history[i];
  }

  if (playing) {
    float level = getLevel();
    if (level > height)
      level = height-10;
    
    history[HISTORY_LENGTH-1] = level;  
  }
}

float getLevel() {
//  return pow(LiveInput.getLevel()*100, 7)/100;
//  return pow(LiveInput.getLevel()*100, 6);
  return cutNoise(LiveInput.getLevel());
}

float cutNoise(float value) {
  return pow(3, value*100);  
}

void showMessage() {
  textFont(font, 12);
  String message = "mouse: " + mouseX + "," + mouseY + 
                   " level: " + String.format("%.2f", history[mouseX]);
                     
  text(message, 6, 14);  
}
