
int w = 428*2;
int h = 287*2;

int res = 5;

color col[] = {color(#ffcc00),color(#111111)};

void setup(){
  size(w,h,OPENGL);
  noiseSeed(2016);
  ortho();

}

int b = 100;
float f = 0;
void draw(){
  background(col[1]);

  noFill();
  stroke(#ffcc00);
  int lin = 0;
  float cnt = 0;

  pushMatrix();
  translate(width/2,height/2,0);

  rotateX(PI/4+(frameCount/1000.0));
  rotateZ(PI/3+(frameCount/1001.0));

  for(int z = -b*4;z<b*4;z+=res*16){
    for(int y = -b ; y < b; y+=res){
      beginShape();
      for(int x = -b ; x < b ; x+=res){
        float d = pow(noise(x/80.0,y/80.0,z/400.0+f)+1,8);
        vertex(x,y,z+d);

        lin++;
      }
      endShape();
    }
  }

  popMatrix();
  f+=0.01;
}

