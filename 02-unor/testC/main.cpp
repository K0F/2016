#include <cprocessing.hpp>
#include <stdio.h>

using namespace cprocessing;

void setup(){
  size(400,400);
}

void draw(){
  float r,g,b;
  r = (sin(frameCount/100.0)+1)*127;
  g = (sin(frameCount/100.001)+1)*127;
  b = (sin(frameCount/100.002)+1)*127;
  background(r,g,b);
  fill(255-r,255-g,255-b);
  noStroke();
  ellipse(width/2,height/2,400,400);

  //printf << (frameRate)tostring << "\n";
}
