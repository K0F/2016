
Map map;


/////////////////////////////////////////
float MAGIC_NUMBER = 0.1293339301;      //
int FLICKER_CADENCE = 7;
float SHAPE_FILL_AMMOUNT = 80;
float SHAPE_MOVEMENT_SPEED = 3.333;
float RADIUS = 100.0;
int patternX[] = {1,1,1,1,1,1,1,1,1,1,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,16};
int patternY[] = {1,2,3,4,5,6,7,8,9,10};
/////////////////////////////////////////

boolean white = true;

void setup(){
  size(640/2,480/2,P2D);
  map = new Map(width,height);
}

void draw(){
  map.draw();


  if(frameCount%FLICKER_CADENCE==0)
  white=!white;


  fill(white?255:0,SHAPE_FILL_AMMOUNT);
  noStroke();
  float theta = frameCount/SHAPE_MOVEMENT_SPEED;
  ellipse(width/2+(cos(theta)*(height/PI-RADIUS/2.0)),height/2+(sin(theta)*(height/PI-RADIUS/2.0)),RADIUS,RADIUS);

}


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
        if(pix[((x+w)-(patternX[counterX]*modX))%w][y] ^ pix[x][((y+h)-(patternX[counterX]*modY))%h])
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
