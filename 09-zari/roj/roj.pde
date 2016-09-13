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


float ALIGN = 0.02;
float ATTRACT = 0.1;
float SLOWDOWN = 0.9;

float speed = 1.0;

float DIST = 100.0;
int NUM = 5000;
ArrayList entities;

float DIA = 350.0;


boolean render = true;

PVector cam;

///////////////////////////////////////////////////////
///////////////////////////////////////////////////////

void setup(){
  size(1280,720,OPENGL);

  entities = new ArrayList();

  cam = new PVector(width/2,height/2);

  rectMode(CENTER);
  for(int i = 0 ; i < NUM;i++){
    entities.add(new Entity(i));
  }
  
  background(0);
}

///////////////////////////////////////////////////////

void draw(){
  
  //background(0);
  fill(0,5,10,70);
  rect(width/2,height/2,width,height);

  float xx = 0;
  float yy = 0;
  for(int i = 0 ; i < entities.size();i++){
    Entity tmp = (Entity)entities.get(i);
    tmp.move();
    xx+=(tmp.pos.x/(entities.size()+0.0));
    yy+=(tmp.pos.y/(entities.size()+0.0));

  }

  cam.x += (xx-cam.x)/3.0;
  cam.y += (yy-cam.y)/3.0;

  

  pushMatrix();
  translate(-cam.x+width/2,-cam.y+height/2);
  for(int i = 0 ; i < entities.size();i++){
    Entity tmp = (Entity)entities.get(i);
    tmp.draw();

  }

  popMatrix();

  if(render)
  saveFrame("/home/kof/videos/roj/roj#####.png");

}
///////////////////////////////////////////////////////

class Entity{
  PVector pos,acc,vel,lpos;
  ArrayList contact;
  int id;

  Entity(int _id){
    float theta = random(-TWO_PI,TWO_PI);
    pos = new PVector(cos(theta)*random(DIA)+width/2.0,sin(theta)*random(DIA)+height/2.0);
    
    lpos = new PVector(pos.x,pos.y);
    acc = new PVector(0,0);
    vel = new PVector(0,0);
    id = _id;
  }

  void draw(){
    pushMatrix();
    translate(pos.x,pos.y);
    noStroke();
    fill(255,95);
    rotate(atan2(pos.y-lpos.y,pos.x-lpos.x));
    float sp = vel.mag(); 
    rect(-sp/2.0,0,sp,1);
    popMatrix();



    /*
       for(int i = 0 ; i < contact.size();i++){
       Entity tmp = (Entity)entities.get(i);
       stroke(255,5);
       line(tmp.pos.x,tmp.pos.y,pos.x,pos.y);
       }
     */

  }

  void move(){
    lpos = new PVector(pos.x,pos.y);
    pos.add(vel);
    vel.add(acc);
    vel.mult(SLOWDOWN);
    acc.mult(0.333);

    contact = new ArrayList();


    for(int i = 0 ; i < entities.size();i++){

      if(id!=i){
        Entity other = (Entity)entities.get(i);
        float ox = other.pos.x;
        float oy = other.pos.y;
        float dist = sqrt( pow(ox-pos.x,2.0) + pow(oy-pos.y,2.0) );
        PVector nn = new PVector(ox-pos.x,oy-pos.y);
        nn.normalize();
        nn.mult(ATTRACT/dist);
        //nn.mult(dist/10000.0);

        PVector nvel = new PVector(other.vel.x-vel.x,other.vel.y-vel.y);
        nvel.mult(ALIGN/dist);

        PVector nacc = new PVector(other.acc.x-acc.x,other.acc.y-acc.y);
        nacc.mult(ALIGN/dist);

        if(dist>DIST){
          acc.add(nn);
          //vel.sub(nvel);
          vel.sub(nacc);
        }else{
          if(dist<50)
            contact.add(other);

          acc.sub(nn);
          //vel.add(nvel);
          vel.add(nacc);
        }
        noStroke();
      }
    }

    //border();
  }

  void border(){
    if(pos.x>width || pos.x<0)
      vel.x *= -1.0;

    if(pos.y>height || pos.y<0)
      vel.y *= -1.0;

  }
}
