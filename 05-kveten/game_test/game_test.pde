

Ship ship;
PImage back;

void setup(){
  size(1024,768);
  ship = new Ship();
  back = loadImage("background.png");
}


void draw(){

  background(back);
  ship.draw();


}







class Ship{
  PImage mapa;
  PVector pos,vel,acc,dir;
  PGraphics phase[];
  int sel;
  float scale = 1;

  Ship(){
    mapa = loadImage("ship.png");
    pos = new PVector(width/2,height/2);
    vel = new PVector(0,0);
    dir = new PVector(0,0);
    acc = new PVector(0,0);
    dir = new PVector(0,0);

    phase = new PGraphics[32];

    for(int i = 0 ; i < 32;i++){
      phase[i] = createGraphics(mapa.height,mapa.height);
      phase[i].beginDraw();
      phase[i].image(mapa,-i*mapa.height,0);
      phase[i].endDraw();
    }
  }

  void draw(){
    dir = new PVector(vel.x,vel.y);
    dir.normalize();
    dir.mult(acc.mag());

    sel = (int)map(atan2(vel.y,vel.x),PI,-PI,0,33);
    sel = constrain(sel,0,31);
    
    vel.add(acc);
    pos.add(vel);
    vel.mult(0.9);
    

    acc.add(new PVector(mouseX-pos.x,map(mouseY-pos.y,0,1,0,0.45)));
    acc.div(width+1.1);

    pushMatrix();
    translate(pos.x,pos.y);
    imageMode(CENTER);
    image(phase[sel],0,0,mapa.height*scale,mapa.height*scale);
    popMatrix();
  }

}
