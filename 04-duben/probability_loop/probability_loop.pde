

int SPEEDUP = 72;
float RES = 10;


Ball ball;
ArrayList decisions;
Graph graph;

void setup(){
  size(1280,720);


  graph = new Graph();
  ball = new Ball();

  decisions = new ArrayList();


  for(int y = 0 ; y < height ; y += (int)RES){
    for(int x = 0 ; x < width;x+=(int)RES){
      int mod = y%((int)(RES*2.0))==0?(int)(RES/2.0):0;
      decisions.add(new Decision(x+mod,y,decisions.size()));
    }
  }
}



void draw(){

  background(0);

  fill(255,30);
  noStroke();
  for(int i = 0 ; i < decisions.size();i++){
    Decision tmp = (Decision)decisions.get(i);
    tmp.draw();
  }

  graph.draw();
  ball.draw();
}

class Graph{
  float records[];
  float graph[];

  Graph(){
    records=new float[(int)(width/RES)];
    graph=new float[(int)(width/RES)];
    int idx = 0;
    for(int i = 0 ; i < width;i+=RES){
      records[idx] = 0.0;
      idx++;
    }
  }

  void add(float x){
    int idx = (int)(x/RES);
    records[idx]+=1.0;

    float MIN = 1000.0;
    float MAX = 0.0;

    for(int i = 0 ;i < records.length;i++){
      MIN = min(records[i],MIN);
      MAX = max(records[i],MAX);
    }

    for(int i = 0 ;i < records.length;i++){
      graph[i] = map(records[i],MIN,MAX,0,height/2.0);
    }
  }

  void draw(){
    noFill();
    stroke(#ffcc00);
    beginShape();
    int idx = 0;
    for(int i = 0 ; i < width;i+=RES){
      vertex(i,height-graph[idx]-10);
      idx++;
    }
    endShape();
  }

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
    stroke(255,10);
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
    pos = new PVector(width/2,RES);
    traces = new ArrayList();
    traces.add(new Trace());
  }

  void draw(){
    for(int i = 0 ; i < SPEEDUP;i++)
      move();

    fill(#ffcc00);
    ellipse(pos.x,pos.y,RES/2.0,RES/2.0);

    for(int i = 0 ; i<traces.size();i++){
      Trace t = (Trace)traces.get(i);
      t.draw();
    } 
  }

  void move(){
    pos.y+=RES/2.0;
    for(int i = 0 ; i < decisions.size();i++){
      Decision d = (Decision)(decisions.get(i));
      float distance = dist(d.pos.x,d.pos.y,pos.x,pos.y);
      if(distance<RES/2.0){
        if(d.result==0)
          pos.x-=RES/2.0;
        else
          pos.x+=RES/2.0;
      }
    }
    Trace last = (Trace)traces.get(traces.size()-1);
    last.add(pos.x,pos.y);

    if(pos.y>height){
      traces.add(new Trace());

      if(traces.size()>100.0)
      traces.remove(0);

      graph.add(pos.x);
      pos.y = 0;
      pos.x = width/2;


      for(int i = 0 ; i < decisions.size();i++){
        Decision d = (Decision)decisions.get(i);
        d.reseed();
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
    result = random(100)<=50?1:0;

  }

  void draw(){
    ellipse(pos.x,pos.y,RES/2.0,RES/2.0);
  }
}
