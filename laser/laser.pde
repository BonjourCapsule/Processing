import java.util.*;
import beads.*;

import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;

AudioContext ac;
float ff = 121f;

class Caca {
  WavePlayer wp;
  Gain g;

  Caca() {
    wp = new WavePlayer(ac, 220f, Buffer.SINE);
    g = new Gain(ac, 1, new Envelope(ac, 0.1));
    g.addInput(wp);
  }

  void setGain(float f) {
    g.setGain(f);
  }
  void setFrequency(float f) {
    wp.setFrequency(f);
  }

  Gain getGain() {
    return g;
  }
}

ArrayList<Caca> cacaList = new ArrayList<Caca>();

void setup() {
  size(300,300);
   ac = new AudioContext();

   for( int i = 0; i < 5; i += 1) {
     Caca c = new Caca();

     cacaList.add(c);

     ac.out.addInput( c.getGain() );
   }

  for (Caca c : cacaList) {
  }
  ac.start();

  oscP5 = new OscP5(this,12000);
  myRemoteLocation = new NetAddress("192.168.1.31", 12000);
}

color fore = color(255, 102, 204);
color back = color(0,0,0);

void draw() {}

void oscEvent(OscMessage msg) {
  print("### received an osc message.");
  print(" addrpattern: " + msg.addrPattern());
  println(" typetag: " + msg.typetag());
  println(msg.get(0));

  String[] ss = match( msg.addrPattern(), "/chan([0-9])/([A-z]+)");
  String val = match( msg.get(0).stringValue(), "([0-9]*),([0-9]*)")[1];

  switch (ss[2]) {
    case "amp":
      cacaList.get(int(ss[1])).setGain( float(val) / 1000f );
      println(ss[1], ss[2], val);
    break;
    case "freq":
      cacaList.get(int(ss[1])).setFrequency( float(val) );
      println(ss[1], ss[2], val);
    break;
  }
}
