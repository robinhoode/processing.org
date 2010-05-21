// Show a scrolling view of the music, trying to 
// line up where the rhythm/beat is

import processing.opengl.*;
import pitaru.sonia_v2_9.*;

PFont font;

int FREQS = 8;
int LANE_HEIGHT = 50;
int HISTORY_LENGTH = 512;
float[][] history = new float[FREQS][HISTORY_LENGTH];

void setup() {
   size(HISTORY_LENGTH, FREQS*LANE_HEIGHT, OPENGL);
      
   // Start Sonia engine.
   Sonia.start(this);
   
   LiveInput.start(FREQS); 
   LiveInput.useEqualizer(true);
   font = createFont("Arial-Bold", 12);  
}

void draw() {
  background(0);
  stroke(255);
  LiveInput.getSpectrum();
  
  for (int f = 0; f < FREQS; f++) {
    for (int i = 1; i < HISTORY_LENGTH; i++) {
      float y = LANE_HEIGHT - history[f][i] + LANE_HEIGHT*f;
      rect(i, y, 1, history[f][i]);
      history[f][i-1] = history[f][i];
    }
  }

  for (int f = 0; f < FREQS; f++) {
    history[f][HISTORY_LENGTH-1] = getLevel(f, LANE_HEIGHT);
  }
}

float getLevel(int freq, int limit) {  
  float level = LiveInput.spectrum[freq]*2.5;
  if (level > limit)
    level = limit;
//  println("Level is " + level);
  return level;
}

