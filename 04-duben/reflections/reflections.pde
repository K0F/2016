/**
Coded by Kof @ 
Sat Apr 30 14:49:57 CEST 2016



   ,dPYb,                  ,dPYb,
   IP'`Yb                  IP'`Yb
   I8  8I                  I8  8I
   I8  8bgg,               I8  8'
   I8 dP" "8    ,ggggg,    I8 dP
   I8d8bggP"   dP"  "Y8ggg I8dP
   I8P' "Yb,  i8'    ,8I   I8P
  ,d8    `Yb,,d8,   ,d8'  ,d8b,_
  88P      Y8P"Y8888P"    PI8"8888
                           I8 `8,
                           I8  `8,
                           I8   8I
                           I8   8I
                           I8, ,8'
                            "Y8P'

*/

boolean RENDER = false;

/////////////////////////////////////////////

int BORDER = 10;
float FORCE = 1;
int LASTING = 3800;
int NUM = 360;
int ALPHA = 50;

boolean DRAW_DOTS = false;
boolean DRAW_LINES = false;
boolean DRAW_INTER_LINES = false;
boolean DRAW_MAPS = true;

////////////////////////////////////////////

float dia = 0;
PImage mapa,title;
ArrayList waves;

void setup(){

  size(1280,720,OPENGL);

  title = loadImage("title.png");

  if(RENDER){
    smooth();
  }else{
    hint(DISABLE_DEPTH_TEST);
  }

  textureMode(NORMAL);
  mapa = loadImage("map.png");

  waves = new ArrayList();

}

void keyPressed(){
  if(key=='r')
    mapa = loadImage("map.png");

}

void mousePressed(){
  if(mouseButton==LEFT)
    waves.add(new Wave(mouseX,mouseY));
  else if(waves.size()>0)
    waves.remove(0);
}

void draw(){
  background(5);

  if(frameCount<255 && RENDER){
    image(title,0,0);
  }else{
  
    for(int i = 0 ; i < waves.size();i++){
      Wave tmp = (Wave)waves.get(i);
      tmp.move();

      if(DRAW_DOTS)
        tmp.dot();

      if(DRAW_LINES)
        tmp.draw();
    }

    if(waves.size()>1 && DRAW_INTER_LINES)
      for(int i = 0 ; i <= NUM;i++){
        for(int ii = 1 ; ii < waves.size();ii++){
          Wave tmp1 = (Wave)waves.get(ii-1);
          Wave tmp2 = (Wave)waves.get(ii);
          Node n1 = tmp1.sel(i);
          Node n2 = tmp2.sel(i);
          stroke(255,map(pow(tmp1.life,2.0),0,LASTING*LASTING,50,10));
          line(n1.pos.x,n1.pos.y,n2.pos.x,n2.pos.y);
        }
      }

    if(waves.size()>1 && DRAW_MAPS){
      for(int i = 1 ; i <= NUM;i++){
        noStroke();
        for(int ii = 1 ; ii < waves.size();ii++){
          Wave w1 = (Wave)waves.get(ii-1);
          Wave w2 = (Wave)waves.get(ii);
          Node n1 = w1.sel(i-1);
          Node n2 = w1.sel(i);
          Node n3 = w2.sel(i-1);
          Node n4 = w2.sel(i);
          if(i==NUM){
            n2 = w1.sel(0);
            n4 = w2.sel(0);

          }
          tint(255,map(pow(w1.life,2.0),0,LASTING*LASTING,255,10));
          noStroke();
          beginShape(QUAD);
          texture(mapa);
          float b = 0.05;
          vertex(n1.pos.x,n1.pos.y,b,b);
          vertex(n2.pos.x,n2.pos.y,1-b,b);
          vertex(n4.pos.x,n4.pos.y,1-b,1-b);
          vertex(n3.pos.x,n3.pos.y,b,1-b);
          endShape();


        }
      }
    }
  }

  if(RENDER){
    saveFrame("/tmp/interferences/fr#####.png");
    if(frameCount>10000){
      exit();
    }
   dia+=0.1;
    dia = constrain(dia,0,width/8);

    if(frameCount%8==0){
      waves.add(new Wave(sin(frameCount/210.0)*dia+width/2, cos(frameCount/210.0)*dia+height/2));
    }

 }


}

class Wave{
  ArrayList nodes;
  PVector origin;
  int life;
  int id;

  Wave(float _x, float _y){
    id = waves.size();
    life = 0;
    origin = new PVector(_x,_y);
    create(_x,_y);
  }

  void create(float _x,float _y){
    nodes = new ArrayList();
    for(int i = 0 ; i <= NUM;i++){
      nodes.add(new Node(this,i,_x,_y));
    }

  }

  Node sel(int _id){
    Node n = (Node)nodes.get(_id);
    return n;

  }

  void move(){
    for(int i = 0 ; i < nodes.size();i++){
      Node n = (Node)nodes.get(i);
      n.move();
    }

    life++;

    if(life>LASTING){
      try{
        println("removing wave, length "+waves.size());
        waves.remove(0);
        println("removed? length "+waves.size());
      }catch(Exception e){
        println("Err. removing: "+this);
      }
    }
  }

  void dot(){

    for(int i = 0 ; i < nodes.size();i++){
      Node n = (Node)nodes.get(i);
      n.dot();
    }

  }


  void draw(){

    noFill();
    beginShape();
    for(int i = 0 ; i < nodes.size();i++){
      Node n = (Node)nodes.get(i);
      n.vert();
    }
    endShape(CLOSE);

  }



}

class Node{

  Wave parent;
  PVector pos,vel,acc;
  int id;
  int life = 0;

  Node(Wave _parent,int _id,float _x,float _y){
    parent = _parent;
    id = _id;
    pos = new PVector(_x,_y);
    acc = new PVector(cos(id/(NUM+1.0)*TWO_PI),sin(id/(NUM+1.0)*TWO_PI));
    vel = new PVector(0.0,0.0);

    acc.mult(FORCE);

  }

  void move(){
    border(BORDER);
    pos.add(vel);

    vel.add(acc);
    vel.mult(0.9999);
    acc.mult(0.0);



  }

  void vert(){
    stroke(255,map(pow(parent.life,2),0,LASTING*LASTING,ALPHA,0));
    vertex(pos.x,pos.y);



  }

  void dot(){
    stroke(255,map(pow(parent.life,2),0,LASTING*LASTING,ALPHA,0));
    point(pos.x,pos.y);



  }


  void draw(){
    stroke(255,map(pow(parent.life,2),0,LASTING*LASTING,ALPHA/2,0));
    point(pos.x,pos.y);

  }

  // precise solution
  void border(int b){

    if(pos.x>width-b){
      vel.x *= -0.9;
      pos.x = (width-b)-(pos.x-(width-b));
    }

    if(pos.x<b){
      vel.x *= -0.9;
      pos.x = b-(pos.x-b);
    }

    if(pos.y>height-b){
      vel.y *= -1.0;
      pos.y = (height-b)-(pos.y-(height-b));
    }

    if(pos.y<b){
      vel.y *= -1.0;
      pos.y = b-(pos.y-b);
    }


  }

}
