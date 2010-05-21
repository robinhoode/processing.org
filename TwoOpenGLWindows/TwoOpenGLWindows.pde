
import processing.opengl.*;
import javax.media.opengl.*;
import com.sun.opengl.util.FPSAnimator;

void setup() {
  size(400, 300, OPENGL);
  
  Frame f = new Frame("OPENGL frame");
  GLCanvas canvas = new GLCanvas();
  canvas.addGLEventListener(new GLRenderer());
  f.add(canvas);
  f.setSize(300, 300);
  f.setLocation(0,0);
  f.setUndecorated(true);
  f.show();
//  FPSAnimator animator = new FPSAnimator(canvas, 60);
//  animator.start();
}

void draw() {
  background(0);
  fill(255);
  rect(10,10,frameCount%100,10);
}

class GLRenderer implements GLEventListener {
  GL gl;
  
  public void init(GLAutoDrawable drawable) {
    this.gl = drawable.getGL();
  }
  
  public void display(GLAutoDrawable drawable) {
    background(0);
    stroke(255);
    line(0, 0, height, width);
  }
  
  public void reshape(GLAutoDrawable drawable, int x, int y, int width, int height) {
  }
  
  public void displayChanged(GLAutoDrawable drawable, boolean modeChanged, boolean deviceChanged) {
  }
}
