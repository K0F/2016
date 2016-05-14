

import processing.video.*;

int W = 1600;
int H = 720;

int cw = 1280 ;
int ch = 720;
int depth = 255;

int qua = 0;
int cntr = 0;
int no =0;


Capture cam;

byte tresh = 30;

boolean rec = false;
boolean printout = false;

void setup(){
  size(1280,720,OPENGL);
  frameRate(30);
  String[] cameras = Capture.list();
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(i+":"+cameras[i]);
    }
    cam = new Capture(this, cameras[13]);
    cam.start();     
  }      
  background(0);
}


class Saver implements Runnable {
  int num = 0;
  PApplet parent;
  PGraphics tmp;

  Saver(PApplet _parent, int _num){
    parent = _parent;
    num=_num;
  }
  // This method is called when the thread runs
  public void run() {
  tmp = createGraphics(1280,720);
  tmp.beginDraw();
  tmp.image(g,0,0);
  tmp.endDraw();

    tmp.save("/tmp/strip"+nf(num,4)+".png");
  }
}
void captureEvent(Capture c) {
  c.read();
  cam.loadPixels();
}

void draw(){
  loadPixels();
  if(cam.pixels!=null){

    /*
       int x = cw/2;
       for(int y = 0;y<height;y++){
       pixels[y*width+(0)] = color(brightness(cam.pixels[y*cw+x]));
       }
     */
    for(int x = 0;x<width;x++){
      pixels[(height-1)*width+(x)] = color(brightness(cam.pixels[720/2*width+(1280-x)]));
    }


  }
  cntr++;
  if(cntr%height==0){
    cntr=0;
    Saver saver = new Saver(this,no);
    Thread thread = new Thread(saver);
    thread.start();
    no++;
  }


  updatePixels();
  image(g,0,-1);
}
