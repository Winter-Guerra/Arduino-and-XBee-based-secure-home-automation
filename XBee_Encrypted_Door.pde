//Copyleft Winter Joseph Guerra "XtremD" April 2011.
//Released under the Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported (CC BY-NC-SA 3.0) license.
//The details of the license can be found here: http://creativecommons.org/licenses/by-nc-sa/3.0/

#include <NewSoftSerial.h>
#include <XBee.h>


uint8_t xbeeRX = 2;
uint8_t xbeeTX = 3;
uint8_t xbeeRTS = 4; //Pull high to stop the XBee from sending more data to the Arduino through its output line. Must be enabled first.
uint8_t xbeeCTS = 5; //Is pulled high by the XBee when the XBee input UART line is 17 byte away from full.
uint8_t xbeeDTR = 6; //Pull high to force sleep mode.
uint8_t xbeeReset = 7; //Pull low to reset the XBee (Usually after a command session).

//Addresses. This should be saved in EEPROM in the future!!
uint16_t myself = 0x1111;
uint16_t key1 = 0x2222, key2 = 0x3333;

uint8_t payload[40]; //Payload buffer. Clean this promptly after using!!!!!
uint8_t recievedPayload[40]; //Buffer for the recieved data. Clean promptly after using!

String thingsToSay[3] = {
  "Hello world!", "I see you!", "Are you still there?"}; //litle testing things.....

NewSoftSerial nss(xbeeRX, xbeeTX); //Instantiate a new NewSoftSerial instance for the XBee.
XBee xbee = XBee(); //Instantiate a new xbee instance


// 64-bit addressing: This is the SH + SL address of remote XBee
//XBeeAddress64 addr64 = XBeeAddress64(0x0013a200, 0x4008b490);
// unless you have MY on the receiving radio set to FFFF, this will be received as a RX16 packet
//Tx64Request tx = Tx64Request(addr64, payload, sizeof(payload));

TxStatusResponse txStatus = TxStatusResponse();

void setup() {
  //Serial.begin(9600);
  xbee.setNss(nss); //set the xbee to use nss
  xbee.begin(9600); //start communication with the xbee

  randomSeed(analogRead(0));
  delay(15000);
  Serial.begin(9600);
  Serial.println("Hello World! Starting aerial bombardment!");

}

void loop() {
  //build the payload
  randoPayload();


  // With Series 1 XBees you can use either 16-bit or 64-bit addressing
  // 16-bit addressing: Enter address of remote XBee, typically the coordinator
  Serial.println("Building and sending packet!");
  Tx16Request tx = Tx16Request(key1, payload, sizeof(payload)); //Build the txPacket
  xbee.send(tx);

  // after sending a tx request, we expect a status response
  // wait up to 5 seconds for the status response
  if (xbee.readPacket(5000)) {
    // got a response!

    // should be a znet tx status            	
    if (xbee.getResponse().getApiId() == TX_STATUS_RESPONSE) {
      xbee.getResponse().getZBTxStatusResponse(txStatus);

      // get the delivery status, the fifth byte
      if (txStatus.getStatus() == SUCCESS) {
        // success.  time to celebrate
        Serial.println("Packet sent with ACK!");
      } 
      else {
        // the remote XBee did not receive our packet. is it powered on?
        Serial.println("Packet transmission failed.....");
      }
    }      
  } 
  else {
    // local XBee did not provide a timely TX Status Response -- should not happen
    Serial.println("Wait, WTF? The Xbee did not respond!!!!");
  }
  cleanPayload();
  cleanRXPacket();

  delay(10000);
}

void cleanPayload() {
  for (int i = 0; i < 40; i++) {
    //clean the packet!
    payload[i] = '\0';
  }
}

void cleanRXPacket() {
  for (int i = 0; i < 40; i++) {
    //clean the packet!
    recievedPayload[i] = '\0';
  }
}

void randoPayload() {
  cleanPayload(); //clean it!
  uint8_t selection = random(0,3); //get our payload selection
  thingsToSay[selection].getBytes(payload, 40);
}



