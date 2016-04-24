
var DIA = 400;
var SEED = "test";
var NUM_LINES = 42; 
var THICK = 6;
var ALPHA = 255;

void setup(){
  size(420,420);
  noiseSeed(244);

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
  translate(220,220);
  for(var i = 0 ; i < NUM_LINES;i++){
    var x1 = cos(i/42.0*TWO_PI+noise(i))*DIA/2.0;
    var y1 = sin(i/42.0*TWO_PI+noise(i))*DIA/2.0;
    var x2 = noise(i);
    var y2 = noise(i*10);

    var z = 0;
    while(dist(x2,y2,220,220)>DIA/2){
      x2 = noise(i+z)*400;
      y2 = noise(i+z)*400;
      z++;
    }

    line(x1,y1,x2-width/2,y2-height/2);
  }

  popMatrix();
}

void keyPressed(){
  if(key>' '&&key<'~'){
    SEED += key;
  }

  if(keyCode==BACKSPACE){
    if(SEED.length()>0)
      SEED = SEED.substring(0,SEED.length()-1);
  }
  noiseSeed(stringToSeed(SEED));
}


int stringToSeed(String input){
  var result = 1;
  for(var i = 0 ; i < input.length();i++){
    result += (var)(input.charAt(i)*i/(input.length()+1.0));
  }
  return result;
}
