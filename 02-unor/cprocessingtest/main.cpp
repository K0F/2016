#include <cprocessing.hpp>
#include <iostream>

using namespace cprocessing;

class Test{
  public:
    PVector pos;

    Test(){
      pos = PVector(0,0);
    }

    void draw(){
      noStroke();
      fill(0);
      pos.x = cos(frameCount/100.0)*height/4+width/2;
      pos.y = sin(frameCount/100.0)*height/4+height/2;
      ellipse(pos.x,pos.y,100,100);
    }
};


Test test;

void setup(){
  size(800,400,"test");
  test = Test();
}

void draw(){
  background(0);

  int s = 10;
  strokeWeight(1);
  stroke(255);

  float xx,yy;
  xx = yy = 0;
  for(int y = -height*2; y < height*4 ;y += s){
    for(int x = -width ; x < width*2 ;x += s){
      if(dist(x,y,xx,yy)<20){
        float deform = pow(dist(test.pos.x,test.pos.y,x,y),0.9);
        float shift = pow(deform/10.0,1.15)*cos(frameCount/40.0+x/50.0);
        line(x+deform,y+shift,xx+deform,yy+shift);
      }
      xx=x;
      yy=y;
    }
  }

//  test.draw();
  stroke(0);
  noFill();
  strokeWeight(2);
  rect(0,0,width,height);
}
