
//////////////////////////////////////////////

boolean render = false; // false, true

float alfakanal = 100; // 0 .. 255
float rychlost = 1.0; // 0.1 .. 10.0
float sum = 10.0;

/////////////////////////////////////////////

PImage img;

void setup(){

  size(640,480,P2D);
  frameRate(24);
  background(255);
  img = loadImage("mraky.jpg");

}


void draw(){
  
  fill(255,alfakanal);
  rect(0,0,width,height);
  
     for(int y = 0 ; y < height;y+=2){
     for(int x = 0 ; x < width;x+=2){
     noStroke();
     fill(noise((x/10.0)+frameCount/4.0,y,frameCount/100.0)*255,sum);
     rect(x,y,4,4);
     }
     }
   

  tint(255,alfakanal);
  image(img,-frameCount*rychlost,0);

  loadPixels();
  /*
     for(int i = 0 ; i < 200000;i++){
     pixels[(int)random(pixels.length)] = pixels[(int)random(pixels.length)];
     }
   */

  updatePixels();

  if(render)
  saveFrame("frame#####.jpg");
}
