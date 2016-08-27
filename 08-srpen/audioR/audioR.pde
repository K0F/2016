import ddf.minim.*;

class AudioSocket implements AudioListener, AudioSignal
{

  private float[] left;
  private float[] right;
  private int buffer_max;
  private int inpos, outpos;
  private int count;

  // AudioSocket makes and AudioSignal out of an AudioListener.
  // That is, it will accept the samples supplied to it by other 
  // AudioSignals (like an AudioListener), but then it will 
  // pass these on to any listeners to which it is connected.
  // To deal with scheduling asynchronies, it maintains an 
  // internal FIFO buffer to temporarily stage samples it 
  // has been given until it has somewhere to send them.

  // Assumes that samples will always enter and exit in blocks 
  // of buffer_size, so we don't have to worry about splitting 
  // blocks across the ring-buffer boundary

  AudioSocket(int buffer_size)
  {
    int n_buffers = 4;
    buffer_max = n_buffers * buffer_size;
    left = new float[buffer_max];
    right = new float[buffer_max];
    inpos = 0;
    outpos = 0;
    count = 0;
  }

  // The AudioListener:samples method accepts new input samples
  synchronized void samples(float[] samp)
  {
    // handle mono by writing samples to both left and right
    samples(samp, samp);
  }

  synchronized void samples(float[] sampL, float[] sampR)
  {
    System.arraycopy(sampL, 0, left, inpos, sampL.length);
    System.arraycopy(sampR, 0, right, inpos, sampR.length);
    inpos += sampL.length;
    if (inpos == buffer_max) {
      inpos = 0;
    }
    count += sampL.length;
    // println("samples: count="+count);
  }

  // The AudioSignal:generate method supplies new output 
  // samples when requested
  void generate(float[] samp)
  {
    // println("generate: count="+count);
    if (count > 0) {
      System.arraycopy(left, outpos, samp, 0, samp.length);
      outpos += samp.length;
      if (outpos == buffer_max) {
	outpos = 0;
      }
      count -= samp.length;
    }
  }

  void generate(float[] sampL, float[] sampR)
  {
    // handle stereo by copying one channel, then passing the other channel 
    // to the mono handler which will update the pointers
    if (count > 0) {
      System.arraycopy(right, outpos, sampR, 0, sampR.length);
      generate(sampL);
    }
  }
}


Minim minim;
AudioInput in;
AudioOutput out;
AudioSocket socket;

void setup()
{
  size(512, 200);

  minim = new Minim(this);
  minim.debugOn();

  // get a line in from Minim, default bit depth is 16
  int buffer_size = 4096;
  in = minim.getLineIn(Minim.STEREO, buffer_size);
  out = minim.getLineOut(Minim.STEREO, buffer_size);

  // Create the socket to connect input to output
  socket = new AudioSocket(buffer_size);
  // Connect the socket as a "listener" for the line-in
  in.addListener(socket);
  // .. and then connect it as a "signal" for the line-out
  out.addSignal(socket);

}

void draw()
{
  background(0);
  stroke(255);

}


void stop()
{
  // always close Minim audio classes when you are done with them
  in.close();
  out.close();

  minim.stop();

  super.stop();
}

