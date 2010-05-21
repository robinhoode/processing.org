
// Refactor some shit.. 

class Waveform {
  AudioPlayer groove;
  Minim minim;
  
  float stepSize;
  float power = 0, offset = 0; 
  
  float[] channel;
  float samplesPerMillisecond;
  
  Waveform(String filePath, Minim minim) {
    this.minim = minim;
    this.groove = minim.loadFile(filePath, 2048);
    this.channel = minim.loadSample(filePath).getChannel(BufferedAudio.LEFT);

    println("Channel length is " + channel.length);
    println("Groove length " + groove.length());  
  
    this.samplesPerMillisecond = this.channel.length / (float)this.groove.length();
  }
  
  void draw() {
    background(0);
    stroke(255);
    
    updateStepSize();
    for (float i = 0; i < width; i++) {
      float y = (height/2) + (height/2) * channel[getLocation(i)];
      line(i, height/2, i, y);
    }    
  }
  
  int getLocation(float i) {
    return (int)((i + offset)*stepSize);
  }
  
  void updateOffset(float offsetD) {
    offset = constrain(offset + offsetD, 0, (channel.length/stepSize) - width);  
  }
  
  void keyPressed() {
    if (keyCode == RIGHT)
      updateOffset(1);
    
    if (key == ' ') {
      if (groove.isPlaying())
        groove.pause();
      else
        groove.play();
    }
  }
  
  void mouseWheel(int delta) {
    power = constrain(power-delta, 0, power-delta);
  
    updateStepSize();
  
    println("Step size is " + stepSize);
    println("Scale is " + zoomScale());
    println("Scale/2 is " + zoomScale()/2);
  
    if (delta < 0) {
  //    float offsetD = (getLocation(mouseX))*(pow(2, power-1));    
      float offsetD = (mouseX)*pow(1.5, power-1);
  //    offset = (offset + mouseX) * pow(2, power-1);
  //    println("MouseX is " + mouseX + " and offsetD is " + offsetD);
  //    offset = offset*pow(2, power);
      updateOffset(offsetD);
  //    updateOffset(0);
    } else {
  //    float offsetD = -(getLocation(mouseX))*(pow(2, power));
      float offsetD = -(mouseX)*pow(1.5, power);
  //    offset = 2*offset - mouseX;
  //    println("MouseX is " + mouseX + " and offsetD is " + offsetD);
      updateOffset(offsetD);
  //    offset = offset/pow(2, power);
  //    updateOffset(0);    
    }
    
    println("mouse wheel delta " + delta);
    println("power is now " + power);
    println("offset is now " + offset);      
  }
    
  float zoomScale() {
    return zoomScale(0);
  }
  
  float zoomScale(float delta) {
    return pow(1.5, power+delta);  
  }
  
  float updateStepSize() {
    return (stepSize = channel.length/(float)(width*zoomScale()));
  }

  void stop() {
    groove.close();
    minim.stop();    
  }

  void drawInfo() {
    int loc = constrain(getLocation((int)mouseX), 0, channel.length);
    text("Scale: " + zoomScale() + 
         " Location: " + loc + 
         " Amplitude: " + channel[loc] +
         " Step size: " + stepSize, 6, 16);
  }
  
  void mouseDragged(int lastMouseX) {
    float mouseDW = (mouseX - lastMouseX);
    lastMouseX = mouseX;
    
    println("Mouse delta width is " + mouseDW);
    
    float offsetD = -(mouseDW);
    println("OffsetD is " + offsetD);
    
    updateOffset(offsetD);
    println("Offset is now " + offset);
  }
  
  void drawSongPos() {
    float pos = (width*relativeGroovePosition() + offset)*zoomScale();
    
  //  println("Current position is " + pos);
    stroke(255, 0, 0);
    line(pos, 0, pos, height);  
  }
  
  float relativeGroovePosition() {
    return groove.position()/ (float)groove.length();
  }
}
