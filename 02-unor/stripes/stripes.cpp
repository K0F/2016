#include <cprocessing.hpp>
#include <stdio.h>
using namespace cprocessing;


void setup(){
  size(800,450,"stripes");
}



void draw(){

  background(0);
  stroke(255);

  int c = 0;
  int res = (sin(frameCount/100.0)+1.0)*127+1;
  for(int i = 0 ; i < height;i+=res){
    line(0,i,width,i);
    c++;
  }

} 
