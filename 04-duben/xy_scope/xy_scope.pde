import ddf.minim.*;

Minim minim;
AudioInput in;

ArrayList mem;
int SIZ = 1024;
float AMP = 125.0;
float TAIL = 2;
float SLOPE = 0.9;

void setup()
{
  size(800,900,OPENGL);

  frameRate(60); 
  minim = new Minim(this);

  mem = new ArrayList();

  // use the getLineIn method of the Minim object to get an AudioInput
  in = minim.getLineIn(Minim.STEREO,SIZ);
  in.mute();
}

void draw()
{
  if(frameCount<10)
  frame.setLocation(10,10);

  fill(0,75);
  noStroke();
  rect(0,0,width,height);
  strokeWeight(1);  
  stroke(255,75);

  pushMatrix();
  translate(width/2,height/2);
  rotate(radians(90)); 
  // draw the waveforms so we can see what we are monitoring
  for(int i = 1; i < in.bufferSize(); i++)
  {
    float pos1 = (1.0/(in.bufferSize()+0.0)) * (i-1) * TWO_PI;
    float pos2 = (1.0/(in.bufferSize()+0.0)) * (i) * TWO_PI;
    float ampl1 = in.left.get(i-1);
    float ampr1 = in.right.get(i-1);
    float ampl2 = in.left.get(i);
    float ampr2 = in.right.get(i);
    float theta1 = (ampl1)*AMP*PI;
    float theta2 = (ampr1)*AMP*PI;
    float theta3 = (ampl2)*AMP*PI;
    float theta4 = (ampr2)*AMP*PI;
     //float ampl2 = in.left.get(i+1)*theta;
    //float ampr2 = in.right.get(i+1)*theta;

    float l1 = cos(pos1)*theta1;
    float r1 = sin(pos1)*theta2;
    float l2 = cos(pos2)*theta3;
    float r2 = sin(pos2)*theta4;
//float l2 = cos(ampl2)*200+ampl2;
    //float r2 = sin(ampr2)*200+ampr2;
    //line(l,r,l2,r2);
    //stroke(255,map(i,0,in.bufferSize(),0,100));
    strokeWeight(map(theta1+theta3,-AMP*PI,AMP*PI,1,3));
    line(l1,r1,l2,r2);
    
    mem.add(new Fram(l1,r1,l2,r2));
    if(mem.size()>SIZ*TAIL)
    mem.remove(0);
  }

  stroke(255,40);

  for(int i = 0 ; i < mem.size();i++){
    Fram tmp = (Fram)mem.get(i);
    tmp.fall(SLOPE);
    stroke(255,map(i,0,mem.size(),0,100));
    line(tmp.a,tmp.b,tmp.c,tmp.d);
  }

  popMatrix();

 // String monitoringState = in.isMonitoring() ? "enabled" : "disabled";
 // text( "Input monitoring is currently " + monitoringState + ".", 5, 15 );
}

class Fram{
  float a,b,c,d;
  
  Fram(float _a,float _b,float _c,float _d){
    a=_a;
    b=_b;
    c=_c;
    d=_d;
  }

  void fall(float am){
    a*=am;
    b*=am;
    c*=am;
    d*=am;
  }
}

