import processing.opengl.*;
import pitaru.sonia_v2_9.*;

PFont font;
int FREQ_BANDS = 512;

void setup(){
   size(FREQ_BANDS, 400, OPENGL);
      
   // Start Sonia engine.
   Sonia.start(this); 
   
   // Start LiveInput and return 256 FFT frequency bands.
   LiveInput.start(FREQ_BANDS); 
   LiveInput.useEqualizer(true);
   font = createFont("Arial-Bold", 12);
}

float level;

void draw() {
  background(0);
  
  LiveInput.getSpectrum();
  
  noStroke();
  fill(255,0,0);

  box(0, 0, 0);
  
  for(int i=0; i < FREQ_BANDS; i++) {
    level = LiveInput.spectrum[i];
    rect(i*2,height-(level), 2,level);    
  }
  
  stroke(255);
  line(mouseX, 0, mouseX, height);
  
  textFont(font, 12);
  text("mouse: " + mouseX + "," + mouseY, 6, 14);
}

