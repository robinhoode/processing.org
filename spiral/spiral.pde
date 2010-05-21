import processing.opengl.*;
import pitaru.sonia_v2_9.*;
import SoniaHelper.*;
import javax.media.opengl.*; 


int spectrumLength=2048; // Needs to be power of 2
int bandsteps;
float maxdist,damperval;
SoniaHelper ffthelper;


float      time;

int gridX = 40, gridY = 40;
vector3[]  grid;

PImage  g_Texture;
PImage  g_TextureMask;


GL opengl;
//GLU glu;


void keyPressed()
{
  saveFrame( "frame.jpg" );
}


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

  // steps per band of freqs
  //  bandsteps=spectrumLength/ffthelper.band.length;

  // Get the maximum distance the max value will travel.
  // Note that the max, maxMaximum and maxMinimum fields are
  // doubles. We need to cast them to float to use them here.
  //  maxdist=ffthelper.maxMaximum-ffthelper.maxMinimum;



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

  g_Texture = loadImage( "test.jpg" );
//  g_Texture = loadImage( "fire2.jpg" );//env4.jpg" );
  g_TextureMask = loadImage( "a4.jpg" );
  g_Texture.mask( g_TextureMask );
  
//  colorMode( HSB, 255 );

  // set perspective mode
  perspective( PI*0.3, 4.0/3.0, 0.1, 1000 );  

}


void draw()
{
  time = millis() * 0.001;

  // get spectrum data  and pass it to helper
  LiveInput.getSpectrum();
  ffthelper.update(LiveInput.spectrum);

  float lowfreq = ffthelper.band[12] * 100;
  float snare = ffthelper.band[24] * 100;


  background( 0 );

  camera( sin(time*.1)*2, cos(time*.1)*2, 100+5*cos(time*0.1),
//  camera( 0, 0, 100, //sin(time*.1)*200, 50, cos(time*.1)*200,
  0, 0, 0,
  0, 1, 0 );


  /*
  /////////////////////////////////////////////////////////////////////////////////
   // draw 3d tunnel
   /////////////////////////////////////////////////////////////////////////////////
   
   strokeWeight( 4 );
   stroke( 255, lowfreq*1.85 );
   //  noStroke();
   
   //
   // distort grid
   //
   for( int y=0; y<gridY; y++ )
   for( int x=0; x<gridX; x++ )
   {
   grid[x+y*gridX].x = ((sin(x*(2*PI/gridX))) * 50) + sin((2*time+2.0*y)/4.0f) + cos((time+2.0f*y)/8.0f) - sin(time) *2;// - cos(fTime/8);
   grid[x+y*gridX].y = ((cos(x*(2*PI/gridX))) * 50) + cos((time+2.0*y)/8.0f) + sin((2*time+2.0f*y)/4.0f) - cos(time) * 4;// - sin(fTime/15);
   
   grid[x+y*gridX].x += sin(time+x*0.2+y*0.15) * .05 * snare * 30.973;
   //      grid[x+y*gridX].x += sin(time*1.1+x*0.2+y*0.05) * .05;
   grid[x+y*gridX].y += cos(time*1.2+x*0.037-y*0.095) * sin(time*1.1+y*0.137) * lowfreq * .21;
   grid[x+y*gridX].z += cos(time*.2+x*0.137-y*0.05) * 0.03 * 3.31;// * cos(time*.01+y*0.137)* .021;
   }  
   
   //
   // draw tunnel grid
   //
   textureMode( NORMALIZED );
   beginShape( QUADS );
   for( int y=0; y<gridY; y++ )
   for( int x=0; x<gridX; x+=2 )
   {
   int p1 = x + y * gridX;
   int p2 = (x+1) + y * gridX;
   int p3 = x + (y+1) * gridX;
   int p4 = (x+1) + (y+1) * gridX;
   
   float t = y / float(gridY);
   //      float i = 0 + ((128+128*sin(-2*time+y*0.03+lowfreq)) * t );
   float i = 0 + ((64+64*sin(-2*time+x*0.5)) * t );
   fill( i*0.825, i*0.134, i*0.125, random(x)+255-lowfreq*3 );//255-x*10, y*10, 255-x*5, 255 );//255-lowfreq*6 );
   
   vertex( grid[p1].x, grid[p1].y, grid[p1].z );//, (x/float(gridX)), (y/float(gridY)) );
   vertex( grid[p2].x, grid[p2].y, grid[p2].z );// , ((x+1)/float(gridX)), (y/float(gridY)) );
   vertex( grid[p4].x, grid[p4].y, grid[p4].z );// , ((x+1)/float(gridX)), ((y+1)/float(gridY)) );
   vertex( grid[p3].x, grid[p3].y, grid[p3].z );// , (x/float(gridX)), ((y+1)/float(gridY)) );
   }
   endShape();
   */


  /////////////////////////////////////////////////////////////////////////////////
  // draw spiral images
  /////////////////////////////////////////////////////////////////////////////////

  opengl.glDisable( GL.GL_DEPTH_TEST );
//  opengl.glEnable( GL.GL_BLEND );
  opengl.glBlendFunc( GL.GL_SRC_ALPHA, GL.GL_ONE );
 
//  noStroke();
//   stroke( 255, lowfreq*.25 );

  textureMode( NORMALIZED );
  float s = 10.0;
//  for( int i=63; i>=0; i-- )
  for( int i=0; i<64; i++ )
  {
    float band = ffthelper.band[i];// * ffthelper.band[i];
    //    fill( 255-(i*8), 118+(64-i)+ffthelper.band[i]*555, 118+(64-i)+ffthelper.band[i]*555, 242-(i*4+band*128) );
    //    fill( 255-(i*8), 18+i+ffthelper.band[i]*555, 18+i+ffthelper.band[i]*555, (32-i)*4+band*255 );
    fill( 255-(i*8), (i*6*ffthelper.band[4]*128) );
//    fill( 255, (i*0.5)+ffthelper.band[i*2]*255 );

    pushMatrix();
    translate( cos(-time*0.72+i*.1)*2, sin(time*0.5+i*.2)*2, -1 );//sin(time+i*.1) );
    rotateZ( 2*sin(time*.125+(32-i)*.15+ffthelper.band[4]) );
//    rotateZ( 2*sin(time*.25+(32-i)*.15+ffthelper.band[64-i]) );
    beginShape( QUADS );
    texture( g_Texture );
    vertex( -s,  s, i*2, 0, 0 );
    vertex(  s,  s, i*2, 1, 0 );
    vertex(  s, -s, i*2, 1, 1 );
    vertex( -s, -s, i*2, 0, 1 );
    endShape();  
    popMatrix();
  }

}
