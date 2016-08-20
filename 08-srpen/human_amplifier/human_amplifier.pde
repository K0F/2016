


void setup(){
  size(1280,720);

  background(0);
  noStroke();
  fill(255);

}



void draw(){

  fill(frameCount%10==0?255:0,90);
  ellipse(width/2,height/2,200,200);

  loadPixels();
  int i = 0;
  for(int y = 0; y<height; y++){
    for(int x = 0; x<width; x++){
      pixels[i] = pixels[((int)(i+noise(i/100000.0+frameCount)*4.0))%pixels.length];

      i = y * width + x;
    }
  }
  updatePixels();


}
