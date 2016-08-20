



String filename = "/home/kof/recordings/Sat_Jul__2_13_16_59_CEST_2016.flac";
//String filename = "/tmp/test.wav";
byte raw[];
int offset = 0;


void setup(){
  size(1280,720);
  raw = loadBytes(filename);
  println("File loaded, got. "+raw.length+" bytes");
  frameRate(14.98); 
}


void draw(){
  background(0);
  loadPixels();
  offset+=width*height;
  for(int i = 0 ; i < width*height;i++){
    pixels[i] = color(raw[(i+offset)%raw.length]);
  }
  updatePixels();
}
