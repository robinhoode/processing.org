import processing.opengl.*;
import ddf.minim.analysis.*; 
import ddf.minim.*; 
 
Minim minim; 
//AudioPlayer song; 
//AudioPlayer song; 
AudioInput song;
FFT fftLog; 
float step; 
 
void setup() 
{ 
  size(1280, 512, OPENGL); 
  smooth(); 
  minim = new Minim(this); 
//  song = minim.getLineIn(Minim.STEREO, 1024);
  FileChooser chooser = new FileChooser();
  //String filePath = chooser.choose(this);
  String filePath = "L:\\root\\artists\\AFX\\afx - analord 08\\0801 - pwsteal.ldpinch.d.mp3";
  //song = minim.loadFile(filePath, (int)pow(2, 11));
  //song.play();
  song = minim.getLineIn(Minim.STEREO, 1024); 
  //song=minim.loadFile("02 Tetragrammaton.mp3",1024); 
  fftLog = new FFT(song.bufferSize(), song.sampleRate()); 
  rectMode(CORNERS); 
  background(0);
  //step=float(width)/(song.length()/16.7); 
  step=1; 
} 
 
int i = 0;
void draw() 
{
  background(0);
  if (i > width) {
    background(0);
    i = 0;
  }
  
  //background(0); 
  fftLog.forward(song.mix); 

  float density = 0;
  int start = 166, stop = 328;
  
  for (int i = start; i <= stop; i++)
    density += fftLog.getFreq(i);
    
  density = cutNoise(density);
  println("Density is " + density);
  stroke(density);
  i += 1;
  line(i, 0, i, height);
}

float cutNoise(float value) {
  return pow(value, 3)/pow(10, 8);
}

void stop() 
{ 
  // always close Minim audio classes when you are done with them 
  song.close(); 
  // always stop Minim before exiting 
  minim.stop(); 
 
  super.stop(); 
} 

