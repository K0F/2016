
Network n;
float mm = 1000000.0;
float mx = -1000000.0;


void setup(){
  size(320,320,P2D);
  n = new Network(100);
  n.interconnect();
}


void draw(){

mm = 1000000.0;
  mx = -1000000.0;


  background(255);
  n.step();
  n.draw();

}


class Network{
  ArrayList nodes; 
  float size = 100.0;
  PVector pos;

  Network(int _num){

    nodes = new ArrayList();

    for(int i = 0 ; i < _num;i++){
      nodes.add(new Node(this,i));
    }

    pos = new PVector(width/2,height/2);
  }

  void interconnect(){
    for(int i = 0 ; i < nodes.size();i++){
      Node tmp = (Node)nodes.get(i);
      tmp.connect();
    }
  }

  void draw(){
    pushMatrix();
    translate(pos.x,pos.y);
    for(int i = 0 ; i < nodes.size();i++){
      Node n = (Node)nodes.get(i);
      n.draw();
    }
    popMatrix();

  }


  void step(){
    for(int i = 0 ; i < nodes.size();i++){
      Node n = (Node)nodes.get(i);
      n.step();
    }  
  }


}

class Node{
  Network parent;
  PVector pos;
  ArrayList w;
  float wsum;
  int id;

  Node(Network _parent,int _id){
    id = _id;
    parent = _parent;
    pos = new PVector(random(-parent.size,parent.size),random(-parent.size,parent.size));
    w = new ArrayList();

  }

  void connect(){
    for(int i = 0 ; i < parent.nodes.size();i++){
      Node tmp = (Node)parent.nodes.get(i);
      w.add(random(0,100)/100.0/((float)parent.nodes.size()));
    }
  }

  void draw(){

    for(int i = 0 ; i < parent.nodes.size();i++){
      Node tmp = (Node)parent.nodes.get(i);
      float _w = map((Float)w.get(i),mm,mx,0,2);
      stroke(0,sqrt(_w)*10);
      line(pos.x,pos.y,tmp.pos.x,tmp.pos.y);
    }   
  }

  void step(){
    float _sum = 0;
    for(int i = 0 ; i<parent.nodes.size();i++){
      Node n = (Node)parent.nodes.get(i);
      float _w = (Float)w.get(i);
      mm = min(_w,mm);
      mx = max(_w,mx);
      _sum += _w;
    }

    wsum = _sum/(float)parent.nodes.size();
    println(wsum);

    for(int i = 0 ; i<parent.nodes.size();i++){
      float _w = (Float)w.get(i);
      Node _n = (Node)parent.nodes.get(i);
      float _w2 = (Float)_n.w.get(id);
      float d = dist(pos.x,pos.y,_n.pos.x,_n.pos.y);
      _w += random(-100,100)/1000.0;
      _w *= (map(_w,mm,mx,0.5,1.5));
      w.set(i,_w);
//      pos.x += ((lerp(_n.pos.x,pos.x,map(_w,mm,mx,0,1))-pos.x )/100.0); 
//      pos.y += ((lerp(_n.pos.y,pos.y,map(_w,mm,mx,0,1))-pos.y)/100.0); 
    }

  }

}
