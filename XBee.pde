//Copyleft Winter Joseph Guerra "XtremD" April 2011.
//Released under the Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported (CC BY-NC-SA 3.0) license.
//The license can be found here:http://creativecommons.org/licenses/by-nc-sa/3.0/

#include <NewSoftSerial.h>
#include <XBee.h>

uint8_t xbeeRX = 2;
uint8_t xbeeTX = 3;
uint8_t xbeeRTS = 4; //Pull high to stop the XBee from sending more data to the Arduino through its output line. Must be enabled first.
uint8_t xbeeCTS = 5; //Is pulled high by the XBee when the XBee input UART line is 17 byte away from full.
uint8_t xbeeDTR = 6; //Pull high to force sleep mode.
uint8_t xbeeReset = 7; //Pull low to reset the XBee (Usually after a command session).

uint8_t payload[] = {
  "Hey! It's me! Stop Shooting!!"};

NewSoftSerial nss(xbeeRX, xbeeTX); //Instantiate a new NewSoftSerial instance for the XBee.

XBee xbee = XBee();


// With Series 1 XBees you can use either 16-bit or 64-bit addressing

// 16-bit addressing: Enter address of remote XBee, typically the coordinator
Tx16Request tx = Tx16Request(0x1111, payload, sizeof(payload));

// 64-bit addressing: This is the SH + SL address of remote XBee
//XBeeAddress64 addr64 = XBeeAddress64(0x0013a200, 0x4008b490);
// unless you have MY on the receiving radio set to FFFF, this will be received as a RX16 packet
//Tx64Request tx = Tx64Request(addr64, payload, sizeof(payload));

TxStatusResponse txStatus = TxStatusResponse();

void setup() {
  //Serial.begin(9600);
  xbee.setNss(nss);
  xbee.begin(9600);
  //nss.begin(9600);
  delay(15000);
  //Serial.println("Hello World! Starting aerial bombardment!");

}

void loop() {
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
      } 
      else {
        // the remote XBee did not receive our packet. is it powered on?
      }
    }      
  } 
  else {
    // local XBee did not provide a timely TX Status Response -- should not happen
  }


  delay(10000);
}

