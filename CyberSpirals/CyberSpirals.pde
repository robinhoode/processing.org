import processing.opengl.*;
import javax.media.opengl.*; 
import peasy.*;
import java.lang.*;
import java.lang.reflect.*;
import ddf.minim.*;
import sojamo.drop.*;


PeasyCam cam;

ArrayList boxes;
final static int BOX_COUNT = 35;

Tunnel tunnel;

SDrop drop;

Minim minim;
AudioPlayer groove;

PGraphics3D g3;

void setup() {
  size(800, 600, OPENGL);
  
  g3 = (PGraphics3D) g;    
  cam = new PeasyCam(this, width);

  FPS.register(this);
  
  tunnel = new Tunnel();
  
  boxes = new ArrayList();
  for (int i = 0; i < BOX_COUNT; i++)
    boxes.add(new Box());
    
  minim = new Minim(this);  
//  FileChooser chooser = new FileChooser();
  drop = new SDrop(this);
}

void draw() {
  background(0);
  tunnel.draw();
  Box box;
  for (int i = 0; i < boxes.size(); i++) {
    box = (Box) boxes.get(i);
    box.draw();
    if (box.location.z > 1000) {
      boxes.remove(box);
      boxes.add(new Box());
    }
  }
  
  PMatrix3D currCameraMatrix = new PMatrix3D(g3.camera);
  camera();
  FPS.draw(this); 
  g3.camera = currCameraMatrix;
}


float currentLevel() {
  if (groove != null)
    return groove.left.level();
  else
    return 0;
}

void dropEvent(DropEvent dropEvent) {
  if (groove != null && groove.isPlaying())
    groove.pause();
  
  if (dropEvent.isFile()) {
    groove = minim.loadFile(dropEvent.file().getPath(), 2048);
    groove.play();
  }  
}

