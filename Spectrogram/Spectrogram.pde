import ddf.minim.analysis.*; 
import ddf.minim.*; 
 
Minim minim; 
//AudioPlayer song; 
AudioPlayer song; 
//AudioInput song;
FFT fftLog; 
float step; 
 
void setup() 
{ 
  size(1280, 512, P2D); 
  smooth(); 
  minim = new Minim(this); 
//  song = minim.getLineIn(Minim.STEREO, 1024);
  FileChooser chooser = new FileChooser();
  //String filePath = chooser.choose(this);
  String filePath = "L:\\root\\artists\\AFX\\afx - analord 08\\0801 - pwsteal.ldpinch.d.mp3";
  song = minim.loadFile(filePath, (int)pow(2, 11));
  song.play();
//  song = minim.getLineIn(Minim.STEREO, 1024); 

  //song=minim.loadFile("02 Tetragrammaton.mp3",1024); 
  fftLog = new FFT(song.bufferSize(), song.sampleRate()); 
  rectMode(CORNERS); 
  background(0); 
  //step=float(width)/(song.length()/16.7); 
  step=1; 
} 
 
void draw() 
{ 
  //background(0); 
  fftLog.forward(song.mix); 
  //println(fftLog.specSize()); 
  // draw the full spectrum 
  println("The FFT Log spec size is " + fftLog.specSize());
  for(int i = 0; i < fftLog.specSize(); i++) 
  { 
    stroke(fftLog.getBand(i)); 
    line(i, height, i, height - fftLog.getBand(i) * 4);

    //strokeWeight(1.5); 
//    colorMode(HSB,100,100,100,100); 
//    stroke((100-fftLog.getBand(i)),100,100,fftLog.getBand(i)); 
   
    //kinda chromatic notes 
    //point(frameCount,i); 
//    point((frameCount*step)%width,height-i); 
    //ahí está tratando de que sea escala Log haciendole raíz cuadrada a las malas :P 
    //point(frameCount*step,(height-i)); 
 
    //color myColor=color((i*16)%fftLog.specSize(),fftLog.specSize()-(2*i),100); 
    //fill(myColor,8); 
  } 
  
} 
 
void keyPressed(){ 
 
 // if(key=='p')song.play(); 
  if(key=='s'){ 
    println("saving..."); 
    saveFrame("thinguies-####.png"); 
    println("saved."); 
  } 
 
} 
 
void stop() 
{ 
  // always close Minim audio classes when you are done with them 
  song.close(); 
  // always stop Minim before exiting 
  minim.stop(); 
 
  super.stop(); 
} 

