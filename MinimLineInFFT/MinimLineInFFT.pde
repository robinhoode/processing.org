/**
 * This sketch demonstrates how to use an FFT to analyze an
 * AudioBuffer and draw the resulting spectrum. <br />
 * It also allows you to turn windowing on and off,
 * but you will see there is not much difference in the spectrum.<br />
 * Press 'w' to turn on windowing, press 'e' to turn it off.
 */

import ddf.minim.analysis.*;
import ddf.minim.*;
import processing.opengl.*;

Minim minim;
// AudioPlayer jingle;
AudioInput in;
FFT fft;
String windowName;

void setup() {
  size(512, 600, P2D);
  textMode(SCREEN);

  minim = new Minim(this);
  in = minim.getLineIn(Minim.STEREO, width*2);

  // create an FFT object that has a time-domain buffer 
  // the same size as jingle's sample buffer
  // note that this needs to be a power of two 
  // and that it means the size of the spectrum
  // will be 512. see the online tutorial for more info.
  fft = new FFT(in.bufferSize(), in.sampleRate());
  textFont(createFont("Arial", 12));
  windowName = "None";
  
  range = new FreqRange(20, 150);
}

FreqRange range; 

void draw()
{
  background(0);
  stroke(255);
  // perform a forward FFT on the samples in jingle's left buffer
  // note that if jingle were a MONO file, 
  // this would be the same as using jingle.right or jingle.left
  fft.forward(in.left);
 
  for(int i = 0; i < fft.specSize(); i++) {
    // draw the line for frequency band i, scaling it by 4 so we can see it a bit better
    line(i, height, i, height - fft.getBand(i)*4);
  }
  
  range.sumOver(fft);  
  range.draw();
  
  fill(255);
  // keep us informed about the window being used
  text("Window: " + windowName, 5, 10);
  text("MouseX: " + mouseX, 5, 24);  
}

void keyReleased()
{
  if ( key == 'w' )  {
    // a Hamming window can be used to shape the sample buffer that is passed to the FFT
    // this can reduce the amount of noise in the spectrum
    fft.window(FFT.HAMMING);
    windowName = "Hamming";
  }

  if ( key == 'e' ) {
    fft.window(FFT.NONE);
    windowName = "None";
  }
}

void stop() {
  // always close Minim audio classes when you finish with them
  in.close();
  minim.stop();

  super.stop();
}

class FreqRange {
  int start, end;
  int sampleIndex;
  float[] samples;
  float average, max;
  
  FreqRange(int start, int end) {
    this.start       = start;
    this.end         = end;
    this.sampleIndex = 0;
    this.samples     = new float[16];
  }
  
  float sumOver(FFT fft) {
    incrementSampleIndex();
    
    float sum = 0;
    for (int i = start; i <= end; i++)
      sum += fft.getBand(i);
          
    samples[sampleIndex] = sum;        
    return sum;
  }
  
  void incrementSampleIndex() {
    sampleIndex += 1;
    if (sampleIndex > samples.length-1)
      sampleIndex = 0;    
  }
  
  void analyzeSamples() {
    float sum = 0;
    for (int i = 0; i < samples.length; i++) {
      sum += samples[i];
      if (max < samples[i])
        max = samples[i];
    }
    average = sum/(float)(6*samples.length);
  }
  
  void draw() {
    analyzeSamples();
    stroke(0, 0, 255);
    line(start, height-average, end, height-average);    
  }
}
