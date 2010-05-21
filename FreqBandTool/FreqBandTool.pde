import processing.opengl.*;
import pitaru.sonia_v2_9.*;

PFont font;
int FREQ_BANDS = 1024;

void setup(){
   size(FREQ_BANDS, 400, OPENGL);
      
   // Start Sonia engine.
   Sonia.start(this); 
   
   LiveInput.start(FREQ_BANDS); 
   LiveInput.useEqualizer(true);
   font = createFont("Arial-Bold", 12);
}

float level;

int lastUpdate = 0;

// Don't update the spectrum too fast. Otherwise it just
// looks ike noise

void updateSpectrum() {
  int now = millis();
  if (now - lastUpdate > 1) {
    LiveInput.getSpectrum();
    lastUpdate = now;
  }
}

void draw() {
  background(0);
  
  updateSpectrum();
  
  noStroke();
  fill(255,0,0);

  for(int i=0; i < FREQ_BANDS; i++) {
    level = LiveInput.spectrum[i];
    rect(i,height-(level),1,level);    
  }
  
  stroke(255);
  line(mouseX, 0, mouseX, height);
  
  showMessage();
}

void showMessage() {
  textFont(font, 12);
  String message = "mouse: " + mouseX + "," + mouseY + 
                   " level: " + LiveInput.spectrum[mouseX];
                     
  text(message, 6, 14);  
}
