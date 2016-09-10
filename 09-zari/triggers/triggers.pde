import oscP5.*;
import netP5.*;

MidiThread midi;


boolean sent = false;

OscP5 oscP5;
//name the addresses you'll send and receive @
NetAddress remote;


void setup() {
  size(100,100,P2D);
  oscP5 = new OscP5(this,12000);
  remote = new NetAddress("127.0.0.1",1234);

  frameRate(30);
  // create new thread running at 160bpm, bit of D'n'B
  midi = new MidiThread(120);
  midi.setPriority(Thread.NORM_PRIORITY+2); 
  midi.start();
}

void draw() {
  // do whatever
  background(sent?255:0);

  if(sent)
    sent = false;
}

// also shutdown the midi thread when the applet is stopped
public void stop() {
  if (midi!=null) midi.isActive=false;
  super.stop();
}

class MidiThread extends Thread {

  long previousTime;
  boolean isActive=true;
  double interval;

  MidiThread(double bpm) {
    // interval currently hard coded to quarter beats
    interval = 1000.0 / (bpm / 60.0); 
    previousTime=System.nanoTime();
  }

  void run() {
    try {
      while(isActive) {
        // calculate time difference since last beat & wait if necessary
        double timePassed=(System.nanoTime()-previousTime)*1.0e-6;
        while(timePassed<interval) {
          timePassed=(System.nanoTime()-previousTime)*1.0e-6;
        }
        // insert your midi event sending code here
        println("midi out: "+timePassed+"ms");

        OscMessage msg = new OscMessage("/kof/bang");
        msg.add(1.0);
        oscP5.send(msg,remote);
        sent = true;

        // calculate real time until next beat
        long delay=(long)(interval-(System.nanoTime()-previousTime)*1.0e-6);

        if(delay<0)delay=0;

        previousTime=System.nanoTime();

        Thread.sleep(delay);
      }
    }
    catch(InterruptedException e) {
      println("force quit...");
    }
  }
} 
