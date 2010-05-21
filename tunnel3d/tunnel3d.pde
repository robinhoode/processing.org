import processing.opengl.*;
import pitaru.sonia_v2_9.*;
import SoniaHelper.*;
import javax.media.opengl.*;


int spectrumLength=2048; // Needs to be power of 2
int bandsteps;
float maxdist,damperval;
SoniaHelper ffthelper;

GL opengl;
//GLU glu; 

float      time;

int gridX = 40, gridY = 40;
vector3[]  grid;

PImage  g_Texture;


void setup()
{
  size( 640, 480, OPENGL );

  opengl = ((PGraphicsOpenGL)g).gl;

  frameRate( 60 );

  //
  // start sonia object
  //
  Sonia.start(this);

  // line input set up
  LiveInput.start(spectrumLength);
  LiveInput.useEnvelope( true, 2.4f );
  //  LiveInput.useEqualizer( true );  

  // SoniaHelper( int _n, int _nbands,boolean doAvg )
  ffthelper=new SoniaHelper( spectrumLength, 256, false );
  ffthelper.setMaxLimits(200, 2000);
  damperval=0.1f;
  ffthelper.setDamper(damperval);  



  grid = new vector3[(gridX+1)*(gridY+1)];
  float scalX = 4.0;
  float scalY = 3.0;
  for( int y=0; y<gridY+1; y++ )
    for( int x=0; x<gridX+1; x++ )
    {
//      grid[x + y * gridX] = new vector3( x*scalX-((gridX/2)*scalX), y*scalY-((gridY/2)*scalY), 0 );
        grid[x + y * gridX] = new vector3( 0, 0, 0 );
        grid[x + y * gridX].x = sin(x * (2.0*PI/float(gridX))) * 50.0;
        grid[x + y * gridX].y = cos(x * (2.0*PI/float(gridX))) * 50.0;
        grid[x + y * gridX].z = -600 + (y * 18);
    }

  g_Texture = loadImage( "vain.jpg" );


  // set perspective mode
  perspective( PI*0.25, 4.0/3.0, 1, 1000 );  
}


void draw()
{
  time = millis() * 0.001;

  // get spectrum data  and pass it to helper
  LiveInput.getSpectrum();
  ffthelper.update(LiveInput.spectrum);


  background( 0 );

  camera( 0, 0, 80, //sin(time*.1)*200, 50, cos(time*.1)*200,
  0, 0, 0,
  0, 1, 0 );


  float lowfreq = ffthelper.band[12] * 100;
  float snare = ffthelper.band[24] * 100;

  strokeWeight( 4 );
  stroke( 255, lowfreq*1.85 );
//  noStroke();


  // distort grid
  for( int y=0; y<gridY; y++ )
    for( int x=0; x<gridX; x++ )
    {
      grid[x+y*gridX].x = ((sin(x*(2*PI/gridX))) * 50) + sin((2*time+2.0*y)/4.0f) + cos((time+2.0f*y)/8.0f) - sin(time) *2;// - cos(fTime/8);
      grid[x+y*gridX].y = ((cos(x*(2*PI/gridX))) * 50) + cos((time+2.0*y)/8.0f) + sin((2*time+2.0f*y)/4.0f) - cos(time) * 4;// - sin(fTime/15);
      
      grid[x+y*gridX].x += sin(time+x*0.2+y*0.15) * .05 * snare * 30.973;
//      grid[x+y*gridX].x += sin(time*1.1+x*0.2+y*0.05) * .05;
      grid[x+y*gridX].y += cos(time*1.2+x*0.037-y*0.095) * sin(time*1.1+y*0.137) * lowfreq * 2.21;
      grid[x+y*gridX].z += cos(time*.2+x*0.137-y*0.05) * 0.03 * 3.31;// * cos(time*.01+y*0.137)* .021;
    }  

  
  opengl.glDisable( GL.GL_DEPTH_TEST );
  opengl.glEnable( GL.GL_BLEND );
  opengl.glBlendFunc( GL.GL_SRC_ALPHA, GL.GL_ONE );

  opengl.glTexParameterf( GL.GL_TEXTURE_2D, GL.GL_TEXTURE_WRAP_S, GL.GL_REPEAT );
  opengl.glTexParameterf( GL.GL_TEXTURE_2D, GL.GL_TEXTURE_WRAP_T, GL.GL_REPEAT );
  opengl.glTexParameterf( GL.GL_TEXTURE_2D, GL.GL_TEXTURE_MAG_FILTER, GL.GL_LINEAR );
  opengl.glTexParameterf( GL.GL_TEXTURE_2D, GL.GL_TEXTURE_MIN_FILTER, GL.GL_LINEAR );
  opengl.glTexEnvf( GL.GL_TEXTURE_ENV, GL.GL_TEXTURE_ENV_MODE, GL.GL_MODULATE );


  textureMode( NORMALIZED );
//  texture( g_Texture );
  for( int y=0; y<gridY; y+=2 )
  {
  beginShape( QUADS );
    for( int x=0; x<gridX; x+=1 )
    {
      int p1 = x + y * gridX;
      int p2 = (x+1) + y * gridX;
      int p3 = x + (y+1) * gridX;
      int p4 = (x+1) + (y+1) * gridX;

      float t = y / float(gridY);
//      float i = 0 + ((128+128*sin(-2*time+y*0.03+lowfreq)) * t );
      float i = y;//0 + ((64+64*sin(-2*time+x*0.5)) / t );
      fill( i*2.825, i*2.134, i*0.125, random(x)+255-lowfreq*3 );//255-x*10, y*10, 255-x*5, 255 );//255-lowfreq*6 );
//noFill();
      vertex( grid[p1].x, grid[p1].y, grid[p1].z );//, (x/float(gridX)), (y/float(gridY)) );
      vertex( grid[p2].x, grid[p2].y, grid[p2].z );// , ((x+1)/float(gridX)), (y/float(gridY)) );
      vertex( grid[p4].x, grid[p4].y, grid[p4].z );// , ((x+1)/float(gridX)), ((y+1)/float(gridY)) );
      vertex( grid[p3].x, grid[p3].y, grid[p3].z );// , (x/float(gridX)), ((y+1)/float(gridY)) );
    }
  endShape();
  }
}
