import processing.pdf.*;

void setup(){

  size(2480,520);
  noLoop();
  background(255);
  beginRecord(PDF,"screen.pdf");
  smooth();
}


void draw(){


  stroke(0,130);
  noFill();

  for(float z = 1.0 ; z < 10.0;z+=0.2){
    beginShape();
    for(int i = 0 ; i < width;i++){
      float y = sin(i/3.0/z-z)*3;
      vertex(i,y+(z*52));
    }
    endShape();

  }
  endRecord();
    save("bck.png");
}
