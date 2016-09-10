



thisProcess.openUDPPort(1234);
o = OSCFunc({ arg msg, time, addr, recvPort; [msg, time, addr, recvPort].postln; }, '/kof/bang', n);


(
SynthDef(\alpha,
  {|freq = 50|
    var sig = SinOsc.ar(freq);

    Out.ar(0,sig);
  }
).send(s);
)
