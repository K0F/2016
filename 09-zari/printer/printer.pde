import processing.pdf.*;

void setup() {
  size(400, 400, PDF, "filename.pdf");
  noiseSeed(2016);
  background(255);
}

void draw() {
  // Draw something good here
  rectMode(CENTER);

  int res = 10;
  float cc = 0.0;
  int b = 20;

float sum = 0;

  for(int y = b ; y <= height-b;y+=res){
  for(int x = b ; x <= height-b;x+=res){
  sum += 1.0;
}
}

  for(int y = b ; y <= height-b;y+=res){
  for(int x = b ; x <= height-b;x+=res){

    pushMatrix();
    translate(x,y);
    rotate(radians(cc));
    cc+=90/sum;

    rect(0,0,res-2,res-2);
    popMatrix();

  }
  }


if(frameCount>10)
exit();

next();
}

void next(){
  PGraphicsPDF pdf = (PGraphicsPDF) g;  // Get the renderer
  pdf.nextPage();  // Tell it to go to the next page

}
