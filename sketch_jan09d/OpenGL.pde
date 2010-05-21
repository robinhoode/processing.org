class OpenGL {
  PApplet applet;
  
  OpenGL(PApplet applet) {
    this.applet = applet;
    
    PGraphicsOpenGL pgl = (PGraphicsOpenGL) applet.g;
    GL gl = pgl.gl;
    GLU glu = pgl.glu;
    resizeGLScene(gl, glu);
    initGL(gl);        
  }
  
  void resizeGLScene(GL gl, GLU glu) {
    gl.glViewport(0, 0, width, height);
    gl.glMatrixMode(GL.GL_PROJECTION);
    gl.glLoadIdentity();
    glu.gluPerspective(45, (float)width/(float)height, 0.1, 100);
    gl.glMatrixMode(GL.GL_MODELVIEW);
    gl.glLoadIdentity();
  }
  
  void initGL(GL gl) {
    gl.glShadeModel(GL.GL_SMOOTH);
    gl.glClearColor(0, 0, 0, 0);
    gl.glClearDepth(1);
    gl.glEnable(GL.GL_DEPTH_TEST);
    gl.glDepthFunc(GL.GL_LEQUAL);
    gl.glHint(GL.GL_PERSPECTIVE_CORRECTION_HINT, GL.GL_NICEST);
  }
    
  void draw() {
    PGraphicsOpenGL pgl = (PGraphicsOpenGL) applet.g;
    GL gl = pgl.beginGL();
      gl.glClear(GL.GL_COLOR_BUFFER_BIT | GL.GL_DEPTH_BUFFER_BIT);
      gl.glBegin(GL.GL_TRIANGLES);
        gl.glVertex3f(0, 100, 0);
        gl.glVertex3f(-100, -100, 0);
        gl.glVertex3f(100, -100, 0);
      gl.glEnd();
    pgl.endGL();    
  }
}
