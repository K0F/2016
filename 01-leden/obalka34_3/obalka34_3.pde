import processing.pdf.*;

int w = 428*2;
int h = 287*2;

int res = 5;

int rs[] = {255,255,0,0,73,40};
int gs[] = {255,72,176,57,64,52,40};
int bs[] = {0,176,57,191,115,40};

color col[];

//= {color(255,255,0),color(255,72,176),color(0,115,57),color(0,64,191),color(73,52,115),color(40,40,40)};

void setup(){
  size(w,h);
  noiseSeed(2016);

  col = new color[rs.length];
  for(int i = 0 ; i < rs.length;i++){
    col[i] = color(rs[i],gs[i],bs[i]);

  }

  noLoop();
  background(255);

  beginRecord(PDF, "out.pdf"); 

}


void draw(){
  //background(col[4]);
  int cnt = 0;

  stroke(col[1]);
  noFill();
  beginShape();

  float ly[] = new float[width];
  for(int y = 0 ;y < height;y+=20){
    for(int i = 0 ; i < width;i+=2){
      float sh = y+(sin(i/(((y+1)/10.0)) -width/2)*5.0);
      line(i,sh,i,ly[i]+4);
      ly[i] = sh;
    }
    cnt++;
  }

  endShape();

  endRecord();
}







