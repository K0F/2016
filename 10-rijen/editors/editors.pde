
ArrayList editors;

void setup(){
  size(800,600);

  textFont(createFont("Monospace",9,false));

  editors = new ArrayList();
  editors.add(new Editor());
}



void draw(){


  background(24);

  for(int i = 0 ; i < editors.size();i++){
    Editor tmp = (Editor)editors.get(i);
    tmp.draw();
  }


}




class Editor{
  String code;
  PVector pos;
  PVector dim;
  int id;
  int b = 10;

  Editor(){
    id = editors.size()-1;
    code = "abcdefgh";
    pos = new PVector(mouseX,mouseY);
    dim = new PVector(320,240);
  }

  void draw(){

    stroke(127);
    fill(12);
    rect(pos.x,pos.y,dim.x,dim.y);

    fill(250);
    text(code,pos.x+b,pos.y+b,dim.x-b*2,dim.y-b*2);

  }


}
