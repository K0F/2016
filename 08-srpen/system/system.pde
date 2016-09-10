
Network n;
float mm = 1000000.0;
float mx = -1000000.0;


void setup(){
  size(720,720,P2D);
  n = new Network(100);
  n.interconnect();
}


void draw(){

  mm = 1000000.0;
  mx = -1000000.0;


  background(255);
  n.step();
  n.draw();

  println(mx-mm);
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
  PVector pos,ppos;
  ArrayList w;
  float wsum;
  int id;

  Node(Network _parent,int _id){
    id = _id;
    parent = _parent;
    pos = new PVector(random(-parent.size,parent.size),random(-parent.size,parent.size));
    ppos = new PVector(pos.x,pos.y);
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
      float _w = map((Float)w.get(i),mm,mx,0,1);
      stroke(0,_w*25);
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

    wsum = _sum;//_sum/(float)parent.nodes.size();

    for(int i = 0 ; i<parent.nodes.size();i++){
      float _w = (Float)w.get(i);
      Node _n = (Node)parent.nodes.get(i);
      float d = sqrt(sq(_n.pos.x-pos.x)+sq(_n.pos.y-pos.y))+1.0;

      _w = (sin(frameCount/d)+1.0)/2.0 ;

      w.set(i,_w);
      
      //pos.x += (lerp(-_n.pos.x,ppos.x,pow(_w+1.0,0.5))-pos.x)/100.0;///map(_w,0,1,100000.0,10000.0);
      //pos.y += (lerp(-_n.pos.y,ppos.y,pow(_w+1.0,0.5))-pos.y)/100.0;///map(_w,0,1,100000.0,10000.0);
      
      //pos.y += (_n.pos.y-pos.y)/map(_w,0,1,100000.0,10000.0);
      pos.x += (cos((frameCount+d)/100.0)*ppos.x*2.0-pos.x)/100.0; 
      pos.y += (sin((frameCount+d)/100.0)*ppos.y*2.0-pos.y)/100.0; 
     
      
    }

  }

}
