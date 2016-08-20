


void setup(){
  size(1280,720);
  smooth();
}


void draw(){
  fill(0,0,15,15);
  rectMode(CORNER);
  rect(0,0,width,height);
  fill(255,50);
  noStroke();

  for(int i = 50;i<width+100;i+=10){
     ring(width/2,height/2,i/2,i,(sin((frameCount+i)/100.0)+1.5)*3,frameCount/(i*4.0+1.0)*4.0);
  }
}




void ring(float _x, float _y, float _steps,float _r,float _size,float _rot){
  rectMode(CENTER);
  float step = TWO_PI / _steps;
  for(float f = -PI; f < PI;f+=step){
    float r = atan(f+frameCount/100.0) * _r;
    float x = cos(f+_rot) * r + _x;
    float y = sin(f+_rot) * r + _y;
    float size = noise(sin(f+frameCount)*r) * _size;
    pushMatrix();
    translate(x,y);
    rotate(f+_rot);
    scale(noise(x/100.0,y/100.0,(frameCount)/100.0)*4.0); 
    rect(0,0,_size,_size);
    popMatrix();
  }
}
