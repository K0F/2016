/**

Roj logo generator
Copyright (C) 2016 Krystof Pesek

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, see <http://www.gnu.org/licenses/>.

*/
///////////////////////////////////////////////////////


float DIST = 50.0;
int NUM = 1000;
ArrayList entities;

///////////////////////////////////////////////////////
///////////////////////////////////////////////////////

void setup(){
  size(320,320,P2D);

  entities = new ArrayList();

  rectMode(CENTER);
  for(int i = 0 ; i < NUM;i++){
    entities.add(new Entity(i));
  }

}

///////////////////////////////////////////////////////

void draw(){
  background(0);

  for(int i = 0 ; i < entities.size();i++){
    Entity tmp = (Entity)entities.get(i);
    tmp.move();
  }


  for(int i = 0 ; i < entities.size();i++){
    Entity tmp = (Entity)entities.get(i);
    tmp.draw();

    if(i==0)
    println("dump: "+tmp.pos.x+" "+tmp.pos.y);
  }

}
///////////////////////////////////////////////////////

class Entity{
  PVector pos,acc,vel;
  int id;

  Entity(int _id){
    pos = new PVector(random(width),random(height));
    acc = new PVector(0,0);
    vel = new PVector(0,0);
    id = _id;
  }

  void draw(){
    pushMatrix();
    translate(pos.x,pos.y);
    noStroke();
    fill(255,45);
    rect(0,0,1,1);
    popMatrix();

  }

  void move(){
    pos.add(vel);
    vel.add(acc);
    acc.mult(0.0);


    for(int i = 0 ; i < entities.size();i++){

      if(id!=i){
        Entity other = (Entity)entities.get(i);
        float ox = other.pos.x;
        float oy = other.pos.y;
        float dist = sqrt( pow(ox-pos.x,2.0) + pow(oy-pos.y,2.0) );
        PVector nn = new PVector(ox-pos.x,oy-pos.y);
        nn.normalize();
        nn.mult(0.1/dist);
        //nn.mult(dist/10000.0);
        
        
        if(dist>DIST){
          PVector nvel = new PVector(other.vel.x-vel.x,other.vel.y-vel.y);
          nvel.mult(0.01/dist);
          acc.add(nn);
          vel.add(nvel);
        }else{
          acc.sub(nn);
          acc.sub(nn);

          }
      }
    }

    border();
  }

  void border(){
    if(pos.x>width || pos.x<0)
    vel.x *= -1.0;
  
    if(pos.y>height || pos.y<0)
    vel.y *= -1.0;
 
  }
}
