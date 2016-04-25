import netP5.*;
import oscP5.*;


Editor editor;
Interpret interpret;

void setup() {
  size(800, 900); 

  interpret = new Interpret(this);
  editor = new Editor();
}


void draw() {
  background(0); 


  editor.draw();
}

class Editor {
  ArrayList code;
  PFont font;
  int ln;
  int carret;
  int fontSize;
  float glyphW;
  PVector pos;

  Editor() {
    fontSize = 11;
    font = loadFont("DroidSansMono-11.vlw");

    textFont(font, fontSize);
    textAlign(LEFT);


    pos = new PVector(100, 100);
    carret = 0;
    ln=0;
    String test = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ~!@#$%^&*()_+-=1234567890:";
    glyphW = textWidth(test)/(test.length()+0.0);

    code = new ArrayList();
    code.add("");
    add("hello world");
  }

  void draw() {
    pushMatrix();
    translate(pos.x, pos.y);
    fill(255);
    for (int i = 0; i < code.size(); i++) {
      String line = (String)code.get(i);
      text(line, 0, i*fontSize);
    }
    String current = (String)code.get(ln);
    float w = textWidth(current);
    carret = constrain(carret,0,carret);

    noStroke();
    fill((sin(frameCount/3.0)+1.0)*255);
    rect(carret*glyphW+1, ln*fontSize+1, glyphW, -fontSize);
    popMatrix();
  }

  void add(String _input) {
    String line = (String)code.get(ln);

    code.set(ln, line+_input+"");
    carret = (line+_input+"").length();

    if(code.size()>0)
      interpret.send((String)code.get(ln),ln);
  }

  void newLine() {
    code.add("");
    carret=0;
    ln++;
  }

  void backspace() {
    String line = (String)code.get(ln);
    if (line.length()>=1) {  
      line = line.substring(0, line.length()-1);
      code.set(ln, line);
      carret--;
    }else{
      if(editor.code.size()>1){
        editor.code.remove(ln);
        ln--;
        carret=((String)editor.code.get(ln)).length();
      }
    }
  }
}

void keyPressed() {

  if ((int)key>=20 && (int)key<=126) {
    editor.add(key+"");
  }
  switch(keyCode) {
    case ENTER:
      editor.newLine();
      break;
    case BACKSPACE:
      editor.backspace();
      break;
  }
}


class Interpret{
  String body;
  String input;
  int id;
  PApplet parent;
  OscP5 osc;
  NetAddress address;


  Interpret(PApplet _parent){
    parent = _parent;
    address = new NetAddress("127.0.0.1", 57120);
    osc = new OscP5(parent,10000);
  }

  void send(String _input,int _id){
    input = _input;
    id = _id;
    body = "("+
      "~s"+id+".quant=1;"+
      "~s"+id+".fadeTime=3;"+
      "~s"+id+".play;"+
      "~s"+id+"={var notes,code,sig,freq,speed,mod;"+
      "code=\""+input+"\";"+
      "code=code.ascii;"+
      "notes = (code).linexp(20,127,50,16000);"+
      "speed = 1/16;"+
      "mod = 1.25;"+
      "freq = Duty.ar(speed,0,Dseq(notes,inf)).lag(speed/2*mod);"+
      "sig = SinOsc.ar(freq!2,mul:0.2) + LFNoise2.ar(freq*2,freq.linlin(50,10000,1,0));"+
      "sig = sig + Formant.ar(freq!2,freq.lag(0.2*speed*mod),freq.lag(0.1*speed*mod)*2,0.09);"+
      "Splay.ar(sig,0.7,0.25,SinOsc.ar(4)/3);"+
      "};"+
      ")";

    send();
  }

  void send(){
    OscMessage message = new OscMessage("/oo_i");
    message.add(body);
    osc.send(message,address);
  }



}
