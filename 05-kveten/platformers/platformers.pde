
Hero hero;
Level level;
int game_state = 0;

void setup(){
  size(640,360);
  new_game();
}

void new_game(){
  hero = new Hero();
  level = new Level(0);
}

void draw(){
  switch(game_state){
    case 0:
      level.draw();
      hero.draw();
      break;
  }
}

class Level{
  int no;
  PImage background;

  Level(int _no){
    no = _no;
    background = loadImage("level"+no+".png");
  }

  void draw(){
    image(background,0,0);
  }

}



class Hero{

  String name;
  PVector pos;
  PImage asset;
  PGraphics curmap;
  int weapon;
  int [] ammo;
  int life;
  float angle;


  Hero(){
    name = "Rudolf";
    pos = new PVector(width/2,height/2);
    life = 100;
    weapon = 0;
    ammo = new int[9];
    angle = 0;

    asset = loadImage("hero.png");
    curmap = createGraphics(16,24);
    curmap.beginDraw();
    curmap.image(asset,0,0);
    curmap.endDraw();
  }

  void detect(){

  }

  void aim(){
    angle = atan2(mouseY-pos.y,mouseX-pos.x);
  }

  void draw(){
  aim();
    pushMatrix();
    translate(pos.x,pos.y);
    image(curmap,curmap.width/2,curmap.height/2);
    rotate(angle);
    stroke(255);
    line(100,0,0,0);
    popMatrix();
  }

}
