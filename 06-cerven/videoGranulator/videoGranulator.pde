

import processing.video.*;
Movie myMovie;

float dur = 0;

void setup() {
  size(800,600,P2D);
  myMovie = new Movie(this, "/home/kof/videos/FM.mpg");
  myMovie.loop();
  dur = myMovie.duration();
}

void draw() {
  tint(255, 20);
  image(myMovie, noise(frameCount/10.0)*(width-myMovie.width), noise(frameCount/3.0)*(height-myMovie.height));
}

// Called every time a new frame is available to read
void movieEvent(Movie m) {
  m.read();
}


