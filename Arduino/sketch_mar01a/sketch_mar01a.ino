/*
KST O3 UART - BTLE Sheild code

@author bmerryman
@date Wed Nov 14, 2012

*/

String inputString = "";         // a string to hold incoming data
boolean stringComplete = false;  // whether the string is complete

int rxPin = 0;                 // **NOTE** digitalWrite(rxPin, LOW) disable the internal pullup

void setup() {
    

  // initialize serial:
  Serial.begin(19200);

  //Serial.print("Startup");
  //Serial.print((uint8_t)0x2, HEX);
   
  //Serial1.begin(115200);
  //Serial1.print("{S}");
  
  //Serial.println("{S}\n\r");
    delayMicroseconds(10);
  pinMode(rxPin, INPUT);
  delayMicroseconds(10);
  digitalWrite(rxPin, LOW);
  
}

uint8_t newbuffer[19];
int newbufferpos = 0;
boolean gotIT = false;
int test = 0;
boolean done = false;
char inChar = 0x07;

boolean meas = true;
boolean first = true;




uint8_t newbuffer1[19];
int newbufferpos1 = 0;
boolean done1 = false;
char inChar1 = 0x07;
boolean stringComplete1 = false;  // whether the string is complete


void loop() {

	if (stringComplete) {
  
		Serial.print(inChar);
                if(done)
                {

                      Serial.print( newbuffer[0], HEX);
                      done = false;
                      newbufferpos=0;
  
                }
                
            stringComplete = false;
        }

}


/*
  SerialEvent occurs whenever a new data comes in the
 hardware serial RX.  This routine is run between each
 time loop() runs, so using delay inside loop can delay
 response.  Multiple bytes of data may be available.
 */
void serialEvent() {
  
	while (Serial.available()) 
        {                
                inChar = (char)Serial.read(); 
                Serial.print("Something happened");
		newbuffer[newbufferpos] = inChar;

                done = true;


		newbufferpos = newbufferpos + 1;  
	}

	stringComplete = true;
}

