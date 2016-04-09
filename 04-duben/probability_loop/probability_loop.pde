

Ball ball;
ArrayList decisions;


void setup(){
  size(400,400);


  ball = new Ball();

  decisions = new ArrayList();


  for(int y = 0 ; y < width;y+=10){
    for(int x = 0 ; x < height;x+=10){
      int mod = y%20==0?5:0;
      decisions.add(new Decision(x+mod,y,decisions.size()));
    }
  }
}



void draw(){

  background(0);


  fill(255);
  noStroke();
  for(int i = 0 ; i < decisions.size();i++){
    Decision tmp = (Decision)decisions.get(i);
    tmp.draw();
  }

  ball.draw();

}

class Trace{
  ArrayList points;

  Trace(){
    points = new ArrayList();
  }

  void add(float _x,float _y){
    points.add(new PVector(_x,_y));
  }

  void draw(){
    stroke(255);
    noFill();
    beginShape();
    for(int i = 0; i < points.size();i++){
      PVector vec = (PVector)points.get(i);
      vertex(vec.x,vec.y);
    }
    endShape();
  }

}

class Ball{
  ArrayList traces;
  PVector pos;
  Decision target;

  Ball(){
    pos = new PVector(width/2,10);
    traces = new ArrayList();
    traces.add(new Trace());
  }

  void draw(){
    move();
    fill(#ffcc00);
    ellipse(pos.x,pos.y,5,5);

    Trace last = (Trace)traces.get(traces.size()-1);
    last.add(pos.x,pos.y);

    if(pos.y>height){
      traces.add(new Trace());
      pos.y = 0;
      pos.x = width/2;
      for(int i = 0 ; i < decisions.size();i++){
          Decision d = (Decision)decisions.get(i);
          d.reseed();
      }
      }

    for(int i = 0 ; i<traces.size();i++){
      Trace t = (Trace)traces.get(i);
      t.draw();
    }
  }

  void move(){
    pos.y++;
    for(int i = 0 ; i < decisions.size();i++){
      Decision d = (Decision)(decisions.get(i));
      float distance = dist(d.pos.x,d.pos.y,pos.x,pos.y);
      if(distance<5.0){
        if(d.result==0)
          pos.x-=5;
        else
          pos.x+=5;
      }
    }
  }
}


class Decision{
  PVector pos;
  int result;
  int id;

  Decision(float _x,float _y,int _id){
    id = _id;
    pos = new PVector(_x,_y);
    result = noise(id,id)>0.5?1:0;

  }

  void reseed(){
    result = noise(id,id,frameCount)>0.5?1:0;

  }

  void draw(){
    ellipse(pos.x,pos.y,5,5);
  }
}
