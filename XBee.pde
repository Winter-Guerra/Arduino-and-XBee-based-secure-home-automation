//Copyleft Winter Joseph Guerra "XtremD" April 2011.
//Released under the Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported (CC BY-NC-SA 3.0) license.
//The license can be found here:http://creativecommons.org/licenses/by-nc-sa/3.0/

#include <NewSoftSerial.h>

byte xbeeRX = 2;
byte xbeeTX = 3;
byte xbeeRTS = 4; //Pull high to stop the XBee from sending more data to the Arduino through its output line. Must be enabled first.
byte xbeeCTS = 5; //Is pulled high by the XBee when the XBee input UART line is 17 byte away from full.
byte xbeeDTR = 6; //Pull high to force sleep mode.
byte xbeeReset = 7; //Pull low to reset the XBee (Usually after a command session).

NewSoftSerial xbee(xbeeRX, xbeeTX); //Instantiate a new NewSoftSerial instance for the XBee.



void setup() {
  Serial.begin(9600);
  xbee.begin(9600);
  delay(10000);
  Serial.println("Hello World! Starting aerial bombardment!");
}

void loop() {
  xbee.println("Hey! It's me!!");
  delay(10000);
}
