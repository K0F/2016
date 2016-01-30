


void setup(){

  size(512,512);




}





void draw(){


  background(0);
  stroke(255,127);
  strokeWeight(2);
  
  pushMatrix();
  translate(width/2,height/2);
  rotate(radians(frameCount/1.5));
  translate(-width/2,-height/2);
  float i = -width;
  while(i<width*2){
    i+=(sin((frameCount+i*4.0)/768.0)*30.0)+34.1;
    line(i,-height,i-height,height*2);
  }

  popMatrix();




}
