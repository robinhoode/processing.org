import processing.opengl.*;
import javax.media.opengl.*;
import peasy.*;

void setup() {
  size(800, 600, OPENGL);
  cam = new PeasyCame(this, width);
  
  initGl(g);
}

void initGl(PGraphics g) {
  GL gl = ((PGraphicsOpenGL)g).gl;

  hint(ENABLE_OPENGL_4X_SMOOTH);
  gl.glEnable(gl.GL_LINE_SMOOTH);  
  gl.glEnable(gl.GL_BLEND);
  gl.glBlendFunc (gl.GL_SRC_ALPHA, gl.GL_ONE_MINUS_SRC_ALPHA);  
  gl.glHint(gl.GL_LINE_SMOOTH_HINT, gl.GL_NICEST);
  gl.glLineWidth(1.5);
  gl.glClearColor(0,0,0,0);
}

void draw() {
  // HERE!!
}
