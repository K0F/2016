/*
Magic pix fill by Kof
Copyright (C) 2016 Krystof Pesek

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.




   ,dPYb,                  ,dPYb,
   IP'`Yb                  IP'`Yb
   I8  8I                  I8  8I
   I8  8bgg,               I8  8'
   I8 dP" "8    ,ggggg,    I8 dP
   I8d8bggP"   dP"  "Y8ggg I8dP
   I8P' "Yb,  i8'    ,8I   I8P
  ,d8    `Yb,,d8,   ,d8'  ,d8b,_
  88P      Y8P"Y8888P"    PI8"8888
                           I8 `8,
                           I8  `8,
                           I8   8I
                           I8   8I
                           I8, ,8'
                            "Y8P'

*/

Map map;


////////////////////////////////////////////////////////
float MAGIC_NUMBER = 0.05293339301;
int FLICKER_CADENCE = 7;
float SHAPE_FILL_AMMOUNT = 80;
float SHAPE_MOVEMENT_SPEED = 3.333;
float RADIUS = 100.0;
int UNIVERSE_SETUP;
float POWPOW;
boolean white = true;
////////////////////////////////////////////////////////
////////////////////////////////////////////////////////
int patternX[] = {1,16,32,30,64,120,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1};
int patternY[] = {1,2,3,4,5,6,7,8,9,10,160,32,31,15};
////////////////////////////////////////////////////////
////////////////////////////////////////////////////////


/////////////
//   !!!   //
/////////////

float META_POW = 10.333;
////////////////////////////////////////////////////////

void setup(){
  size(1280,720,P2D);

  //radical variant
  //UNIVERSE_SETUP=year()+month()+day()+hour()+minute()+second();

  //conservative variant
  UNIVERSE_SETUP=year();

  noiseSeed(UNIVERSE_SETUP);
  map = new Map(width,height);
}


void MAGIC(){
  POWPOW = noise(frameCount/100000.1)*META_POW;
  MAGIC_NUMBER = pow(noise(frameCount/10.0)*0.9293339301+0.001,noise(frameCount/10.001)*POWPOW);      
  FLICKER_CADENCE = (int)(noise(frameCount/333.1)*23.0+1.0);
  SHAPE_FILL_AMMOUNT = noise(frameCount/100.2)*180.0;
  SHAPE_MOVEMENT_SPEED = noise(frameCount/1000.201)*30.333+1.0;
}


////////////////////////////////////////////////////////
void draw(){

  MAGIC();

  map.draw();
  if(frameCount%FLICKER_CADENCE==0)
    white=!white;

  fill(white?255:0,SHAPE_FILL_AMMOUNT);
  noStroke();
  float theta = frameCount/SHAPE_MOVEMENT_SPEED;
  ellipse(width/2+(cos(theta)*(height/PI-RADIUS/2.0)),height/2+(sin(theta)*(height/PI-RADIUS/2.0)),RADIUS,RADIUS);


}
////////////////////////////////////////////////////////

class Map{
  boolean [][] pix;
  int w,h;
  int counterX = 0;
  int counterY = 0;

  int modX = 1;
  int modY = 1;

  Map(int _w,int _h){
    w = _w;
    h = _h;
    pix = new boolean[w][h];

    seed(50);

  }

  void seed(int perc){
    for(int y = 0 ; y < h; y++){
      for(int x = 0 ; x < w; x++){
        if(random(100)<perc)
          pix[x][y] = true;
        else
          pix[x][y] = false;

      }
    }
  }

  void update(){
    loadPixels();
    for(int y = 0 ; y < h; y++){
      for(int x = 0 ; x < w; x++){
        if(brightness(pixels[y*w+x])>127)
          pix[x][y] = true;
        else
          pix[x][y] = false;

      }
    }
  }

  void draw(){
    loadPixels();

    color c1 = color(255);
    color c2 = color(0);
    for(int y = 0 ; y < h; y++){
      for(int x = 0 ; x < w; x++){
        color c = pixels[y*w+x];
        if(pix[((x+w)-(patternX[counterX]*modX))%w][y] ^ pix[x][((y+h)-(patternY[counterY]*modY))%h])
          set(x,y,lerpColor(c,c1,MAGIC_NUMBER));
        else
          set(x,y,lerpColor(c,c2,MAGIC_NUMBER));

      } 
    }
    update();

    counterX++;
    counterY++;

    if(counterX>=patternX.length){
      counterX=0;
      modX*=-1;
    }

    if(counterY>=patternY.length){
      counterY=0;
      modY*=-1;
    }
  }
}
////////////////////////////////////////////////////////
