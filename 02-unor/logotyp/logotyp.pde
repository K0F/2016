
int DIA = 400;
String SEED = "test";
int NUM_LINES = 42; 
int THICK = 6;
float ALPHA = 255;

void setup(){
  size(420,420);
  noiseSeed(stringToSeed(SEED));

  textFont(createFont("Tahoma"),8);
}


void draw(){

  background(255);
  fill(0);

  text("SEED: "+SEED,10,20);  
  text("DIAMETER: "+DIA+"x"+DIA+"px",10,30);
  text("NUM OF LINES: "+NUM_LINES,10,40);  
  text("THICKNESS: "+THICK,10,50);  
  text("ALPHA: "+ALPHA,10,60);  

  stroke(0,ALPHA);
  strokeWeight(THICK);
  
  pushMatrix();
  translate(width/2,height/2);
  for(int i = 0 ; i < NUM_LINES;i++){
    float x1 = cos(i/42.0*TWO_PI+noise(i))*DIA/2.0;
    float y1 = sin(i/42.0*TWO_PI+noise(i))*DIA/2.0;
    float x2 = noise(i,0);
    float y2 = noise(0,i);

    int z = 0;
    while(dist(x2,y2,width/2,height/2)>DIA/2){
      x2 = noise(i+z,0)*width;
      y2 = noise(0,i+z)*height;
      z++;
    }

    line(x1,y1,x2-width/2,y2-height/2);
  }

  popMatrix();
}

void keyPressed(){
  if(key>' '&&key<'~'){
    SEED+=(char)key;
  }

  if(keyCode==BACKSPACE){
    if(SEED.length()>0)
      SEED = SEED.substring(0,SEED.length()-1);
  }
  noiseSeed(stringToSeed(SEED));
}


int stringToSeed(String input){
  int result = 1;
  for(int i = 0 ; i < input.length();i++){
    result += (int)(input.charAt(i)*i/(input.length()+1.0));
  }
  return result;
}
