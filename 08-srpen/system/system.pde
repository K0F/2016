
Network n;

void setup(){
  size(320,320,P2D);
  n = new Network(100);
  n.interconnect();
}


void draw(){

  background(255);
  n.draw();
  n.step();

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
      float _w = (Float)w.get(i);
      stroke(0,pow(_w-1.0,2)*25.0);
      line(pos.x,pos.y,tmp.pos.x,tmp.pos.y);
    }   
  }

  void step(){
    float _sum = 0;
    for(int i = 0 ; i<parent.nodes.size();i++){
      Node n = (Node)parent.nodes.get(i);
      float _w = (Float)w.get(i);
      _sum += _w;
    }

    wsum += (_sum-wsum)/10.0;

    println(wsum);

    for(int i = 0 ; i<parent.nodes.size();i++){
      float _w = (Float)w.get(i);
      Node _n = (Node)parent.nodes.get(i);
      for(int _i = 0; _i<parent.nodes.size();_i++){
        float _w2 = (Float)_n.w.get(_i);
        _w += (sqrt((_w2)*(_w))-_w)/2.0;
      }
      w.set(i,_w);
      //pos.x = ((lerp(_n.pos.x,pos.x,wsum))); 
      //pos.y = ((lerp(_n.pos.y,pos.y,wsum))); 
    }
    w.set(0,(sin(frameCount/((id+1.0)*2.0))+1.0) /2.0);

  }

}
