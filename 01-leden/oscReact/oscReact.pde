import ddf.minim.*;
import oscP5.*;
import netP5.*;


Minim minim;
AudioInput in;

OscP5 oscP5;
boolean ack;

void setup() {
  size(1280,720,OPENGL);

  minim = new Minim(this);

  // use the getLineIn method of the Minim object to get an AudioInput
  in = minim.getLineIn(Minim.STEREO,735*2);
  in.mute();  
  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this,12000);

  ack = false;
  frameRate(60);

}

void draw() {
 // background(ack?255:0);  

  if(frameCount%60==0){
  frameRate(frameRate);
  println(frameRate);
  }

  scope();
}


void scope(){

 if(frameCount<10)
  frame.setLocation(10,10);

  fill(ack?0:255,180);
  noStroke();
  rect(0,0,width,height);
  strokeWeight(2);  
  stroke(ack?255:0,150);

  pushMatrix();
  translate(width/2,height/2);
  rotate(radians(90)); 
  // draw the waveforms so we can see what we are monitoring
  for(int i = 0; i < in.bufferSize()-1; i++)
  {
    float theta = TWO_PI/512.0*1000.0;//mouseX / 10.0;
    float ampl = in.left.get(i)*theta;
    float ampr = in.right.get(i)*theta;
    //float ampl2 = in.left.get(i+1)*theta;
    //float ampr2 = in.right.get(i+1)*theta;

    float l = cos(ampl)*200+ampl;
    float r = sin(ampr)*200+ampr;
    //float l2 = cos(ampl2)*200+ampl2;
    //float r2 = sin(ampr2)*200+ampr2;
    //line(l,r,l2,r2);
    line(l,r,l+2,r);
  }

  popMatrix();

}

void keyPressed()
{
  if ( key == 'm' || key == 'M' )
  {
    if ( in.isMonitoring() )
    {
      in.disableMonitoring();
    }
    else
    {
      in.enableMonitoring();
    }
  }
}
/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
  /* print the address pattern and the typetag of the received OscMessage */
  ack = !ack;
  print("### received an osc message.");
  print(" addrpattern: "+theOscMessage.addrPattern());
  println(" typetag: "+theOscMessage.typetag());
  
}

