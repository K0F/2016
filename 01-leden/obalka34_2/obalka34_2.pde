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
}


void draw(){
background(col[4]);
  int cnt = 0;
  for(int i = 0 ; i < width;i+=1){
  
  stroke(cnt%2==0?col[0]:col[4]);
  for(int y = 0 ;y < height;y+=10){
  float sh = y+(10*noise((y^i)/10.0));
    line(i,y,i,sh);
    }
    cnt++;
  }

}







