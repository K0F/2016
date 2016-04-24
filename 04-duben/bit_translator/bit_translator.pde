

Message m;

///////////////////////////////////////////////////////////////////////

void setup(){

  size(640,640,P2D);
  m = new Message("Test message, sending.....",width/2,height/2);

  textFont(createFont("Semplice Regular",8));
}
///////////////////////////////////////////////////////////////////////

void draw(){
  background(0);
  fill(255);
  m.draw();
}

///////////////////////////////////////////////////////////////////////
class Message{
  PVector pos;
  String string;
  String bits;
  boolean signal[];
  int curr;
  ArrayList emitter;

  Message(String _input,int _x,int _y){
    pos = new PVector(_x,_y);
    curr=0;
    emitter = new ArrayList();
    generate(_input);
  }

  void generate(String _input){
    string = _input+"";
    bits = "";
    for(int i = 0; i < string.length();i++){
      bits += binary( (byte)string.charAt(i));
    }
    signal = new boolean[bits.length()];
  }

  void plot(){
    for(int i = 0; i < bits.length();i++){
      boolean one =  bits.charAt(i) == '1' ? true : false;

      fill( (i==curr)? #ff0000 : (one ? 255 : 50));
      noStroke();
      rect(i+10,20,1,-5);
      signal[i] = one;
    }
  }

  void read(){
  noStroke();
  fill(signal[curr]?255:50);
  emitter.add(signal[curr]);
  if(emitter.size()>width)
  emitter.remove(0);
  
  rect(-3,-3,5,5);
  curr++;
  curr=curr%bits.length();
  }

  void draw(){
  pushMatrix();
  translate(pos.x,pos.y);
  sig();
    text(string,10,10);
    //text(bits,10,20);
    plot();
    read();
  popMatrix();
  }

  void sig(){
  stroke(255,30);
  noFill();
    for(int i = emitter.size()-1 ;i > 0;i--){
      boolean tmp = (Boolean)emitter.get(i);
      if(tmp){
        ellipse(0,0,emitter.size()-i,emitter.size()-i);
      }
    }
  }
}
