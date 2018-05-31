// Example by Tom Igoe

import processing.serial.*;

Serial myPort;  // The serial port
//ArrayList<String> msg = new ArrayList<String>();

void setup() {
  printArray(Serial.list());
  myPort = new Serial(this, Serial.list()[1], 9600);
  size(800, 600);
  textSize(24);
  background(0);
  stroke(255, 0, 0);
  fill(255);
}

int[] timestamps = new int[800];
int[] vals = new int[800];
int last;
int count = 0;

void draw() {
  String in = myPort.readStringUntil(10);
  if (in != null) {
    clear();
    text(in, 24, 24);

    int tmp = millis();
    int m = tmp - last;
    last = tmp;

    if (count > 800 - 1) {
      timestamps = expand(subset(timestamps, 1), 800);
      vals = expand(subset(vals, 1), 800);
      count -= 1;
    }

    timestamps[count] = m;
    String[] res = match(in, "\\d+\\D*(\\d+)");
    if (res != null)
      vals[count] = int( match(in, "\\d+\\D*(\\d+)")[1] ) / 4;
    count += 1;

    int i = 0;

    i = 0;
    stroke(170, 57, 57);
    for (int n : vals) {
      //println(n);
      line(i, 600 - n, i, 600);
      i += 1;
    }
    i = 0;
    stroke(170, 108, 57);
    for (int n : timestamps) {
      //println(n);
      line(i, 600 - n, i, 600);
      i += 1;
    }

 }
}