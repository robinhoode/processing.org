// Music Player

/**
  * This sketch demonstrates how to use the <code>play</code> method of a <code>Playable</code> class.
  * The class used here is <code>AudioPlayer</code>, but you can also play an <code>AudioSnippet</code>.
  * Playing a <code>Playable</code> causes it to begin playing from the current position. When it reaches
  * the end of the recording it will emit silence, it will not stop! In other words, if you play something and
  * it gets to the end of the file, it will not stop and rewind, it will continue to try to read the file, but get
  * nothing and send silence to the audio system. If you call <code>isPlaying()</code> at that point, it will return true,
  * because the player is still trying to read the file, think of a record player that gets to the end of a record.
  * It just goes around on the same groove. It's not making any sound (well, crackles maybe) but it is still playing.
  * Press 'p' to play the file.
  *
  */
 
import ddf.minim.*;
 
Minim minim;
AudioPlayer groove;
WaveformRenderer waveform;
 
void setup() {
  size(512, 200, P3D);
 
  minim = new Minim(this);
  FileChooser chooser = new FileChooser();
  groove = minim.loadFile(chooser.choose(this), 2048);
 
  waveform = new WaveformRenderer();
  // see the example Recordable >> addListener for more about this
  groove.addListener(waveform);
  groove.play();
}
 
void draw()
{
  background(0);
  // see waveform.pde for an explanation of how this works
  waveform.draw();
}
 
void stop()
{
  // always close Minim audio classes when you are done with them
  groove.close();
  // always stop Minim before exiting.
  minim.stop();
 
  super.stop();
}
