

void setup(){
  size(320,240);

}

void draw(){
  background(0);
  stroke(255);
  float d = frameCount/10.0;
  line(d,0,d,height);

}
