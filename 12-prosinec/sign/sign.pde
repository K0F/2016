
PImage in,inin,ininin,out,leg;

int NUM = 1;
ArrayList clockworks;

int SEED = 2016;

//corrds relative to center
float x[] = {0,-426/4.0,426/4.0};
float y[] = {0};

float tempo = (250/60.0);

void mousePressed(){

  reload();
}

void reload(){
  in = loadImage("in2.png");
  inin = loadImage("inin2.png");
  ininin = loadImage("ininin2.png");
  out = loadImage("out2.png");
  leg = loadImage("legend2.png");


}



void setup(){
  size(1280,720,P2D);
  reload();
  imageMode(CENTER);


  reload();
  clockworks = new ArrayList();

  for(int i = 0 ; i < min(x.length,y.length);i++){
    clockworks.add(new Clockwork(x[i],y[i],SEED+i));
  }

}


void draw(){

  background(0);
  for(int i = 0 ; i < clockworks.size();i++){
    Clockwork tmp = (Clockwork)clockworks.get(i);
    tmp.draw();
  }


}


class Clockwork{
  PVector pos;
  int seed;
  float r1,r2,r3,r4;
  int SIZE = 512;
  int alphas[] = {255};
  color c[] = {color(255,255,255),color(255,255,255),color(255,255,255)};
  int ITERATIONS;


  Clockwork(float _x,float _y,int _seed){
    pos = new PVector(_x,_y);
    seed = _seed;

    ITERATIONS = alphas.length;

  }

  void draw(){

    noiseSeed(seed);

    float speed1 = map(pow(noise(frameCount/1000.1*tempo),3.1),0,1,0.01,10.1);
    float speed2 = map(pow(noise(frameCount/1000.3*tempo),3.11),0,1,0.01,10.3);
    float speed3 = map(pow(noise(frameCount/1000.5*tempo),3.111),0,1,0.01,10.5);
    float speed4 = map(pow(noise(frameCount/1000.9*tempo),3.1111),0,1,0.01,10.7);

    r1 += pow(noise(frameCount/1000.01*tempo),2.4)/speed1;
    r2 += pow(noise(frameCount/1000.02*tempo),2.3)/speed2;
    r3 += pow(noise(frameCount/1000.03*tempo),2.2)/speed3;
    r4 += pow(noise(frameCount/1000.05*tempo),2.1)/speed4;


    pushMatrix();
    translate(pos.x,pos.y);
    pushMatrix();
    translate(width/2,height/2);
    for(int i = 0;i<ITERATIONS;i++){
      rotate(r1);
      tint(c[i],alphas[i]);
      image(in,0,0,SIZE,SIZE);
    }
    popMatrix();

    pushMatrix();
    translate(width/2,height/2);
    for(int i = 0;i<ITERATIONS;i++){
      rotate(r2);
      tint(c[i],alphas[i]);
      image(out,0,0,SIZE,SIZE);
    }
    popMatrix();

    pushMatrix();
    translate(width/2,height/2);
    for(int i = 0;i<ITERATIONS;i++){
      rotate(r3);
      tint(c[i],alphas[i]);
      image(inin,0,0,SIZE,SIZE);
    }
    popMatrix();

    pushMatrix();
    translate(width/2,height/2);
    for(int i = 0;i<ITERATIONS;i++){
      rotate(r4);
      image(ininin,0,0,SIZE,SIZE);
    }
    popMatrix();

    tint(255,127);
    image(leg,width/2,height/2,SIZE+(speed1/100.0),SIZE+(speed1/100.0));
    popMatrix();
  }

}
