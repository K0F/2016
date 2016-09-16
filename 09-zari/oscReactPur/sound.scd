


(
  p=ProxySpace.push(s.reboot);
  p.makeTempoClock;
);

(
  n = NetAddr("127.0.0.1", 12000);  //for sending to processing
  OSCFunc({|msg|
    //msg.postln;  //debug
    n.sendMsg(*msg);
  }, '/trig');
)
().play



// one synth ///////////////////////////////////////

(
  ~one.ar(2);
  ~one.quant=2;
  ~one.fadeTime=0.1;
  ~one={
    var speed = 48000/320*4;
    var mod = Duty.kr((1..32),0,Dseq([1,2,1.5,1.33333]*4,inf));
    //var pattern = 4/((1..32));
    //var env = Decay.ar(Impulse.ar(pattern),1);
    var sig = SinOsc.ar(4320/mod/((1..32).reciprocal+1).scramble) * SinOsc.ar((1..32).scramble/32/4);
    //sig = sig + (WhiteNoise.ar(0.5!16) * Pulse.ar(1/4/(1..16)));

    SendReply.ar(Impulse.ar(speed),'/trig',sig*255);

    sig = Limiter.ar(sig,0.9).softclip;
    
    Splay.ar(sig,0.65,0.25);
  };
  ~one.play;
);
~one.stop(10);
~one.clear;
~one.pause;
~one.resume;

// ff filter ///////////////////////////////////////

(
~ff.quant=1;
~ff.fadeTime=1;
~ff={
  var synths = p.playingProxies;
  var high,mid,low;
  var sig = [];
  synths.collect{|n| if(n!=\ff){sig=sig++p.[n.asSymbol];}};

  //sig = Resonz.ar(sig,MouseX.kr(100,10000,(1..8)),MouseY.kr(0.1,1,(1..4)/16))/4;
  //sig = CombN.ar(sig,4,[4,8,16],32)+sig;
  //sig = GVerb.ar(LPF.ar(sig,7000)+HPF.ar(sig,300),100,[3,4],spread:[95,96])/4 + sig;
  low = CompanderD.ar(LPF.ar(sig,LFNoise2.kr(1/2!2).range(100,800)),3/4,1,1/2);
  mid = CompanderD.ar(BPF.ar(sig,LFNoise2.kr(1/2!2).range(700,1500),2),3/4,1,1/2);
  high = CompanderD.ar(HPF.ar(sig,LFNoise2.kr(1/2!2).range(1000,10000)),3/4,1,1/2);
  sig = CompanderD.ar((high+mid+low).flat,3/4,1,1/2,0.002,0.3);
  sig = LPF.ar(DWGReverb.ar(NumChannels.ar(sig,2),[4000,4010]),2000);
  Splay.ar(sig,0.5,0.25);
};
~ff.play;
);
~ff.stop(7);
~ff.clear;

TRand.help
