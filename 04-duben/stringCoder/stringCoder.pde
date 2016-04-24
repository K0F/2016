import netP5.*;
import oscP5.*;


Editor editor;


void setup() {
  size(800, 900); 

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
    fontSize = 14;
    font = createFont("Monospaced", fontSize, false);
    
    textFont(font, fontSize);
    textAlign(LEFT);


    pos = new PVector(100, 100);
    carret = 0;
    ln=0;
    String test = "hello +_+_ world!";
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