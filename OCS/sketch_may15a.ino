#include <OSCMessage.h>
#include <OSCBoards.h>

#define LEN 128
unsigned int vals[LEN] = {0};
unsigned int count = 0;

void setup() {
  Serial.begin(9600);
}

void loop(){
  while (count < LEN) {
    vals[count] = analogRead(0);
    count += 1;
  }
  {
    count = 0;


    //the message wants an OSC address as first argument
    OSCMessage msg("/analog/0");
    char s[16] = {0};

    unsigned long val = 0;
    for (int i = 0; i < LEN; i+= 1) {
      val += vals[i];
    }

    val /= LEN;
    itoa(val, s, 10);

    msg.add(s).add("\n");
    msg.send(Serial); // send the bytes to the SLIP stream
  }
  // delay(20);
}