/*
  Serial Event example
 
 When new serial data arrives, this sketch adds it to a String.
 When a newline is received, the loop prints the string and 
 clears it.
 
 A good test for this is to try it with a GPS receiver 
 that sends out NMEA 0183 sentences. 
 
 Created 9 May 2011
 by Tom Igoe
 
 This example code is in the public domain.
 
 http://www.arduino.cc/en/Tutorial/SerialEvent
 
 */
 
#define RED 5
#define GREEN 6
#define BLUE 9

int input[200];         // an array to hold incoming data
int currentColor;       // setting red if 0, green if 1, blue if 2
int redValue, greenValue, blueValue;

void setup() {
  // initialize serial:
  Serial.begin(115200);
  currentColor = 0;
  pinMode(RED, OUTPUT);
  pinMode(GREEN, OUTPUT);
  pinMode(BLUE, OUTPUT);
}

void loop() {

}

/*
  SerialEvent occurs whenever a new data comes in the
 hardware serial RX.  This routine is run between each
 time loop() runs, so using delay inside loop can delay
 response.  Multiple bytes of data may be available.
 */
void serialEvent() {
  while (Serial.available()) {
    
    // get the new byte:
    int nextByte = Serial.read(); 
    // add it to the inputString:
    if(currentColor == 0){
      redValue = nextByte;
      currentColor++;
      Serial.println(redValue, HEX);
    } else if(currentColor == 1){
      greenValue = nextByte;
      currentColor++;
      Serial.println(greenValue, HEX);
    } else if(currentColor == 2){
      blueValue = nextByte;
      currentColor = 0;
      Serial.println(blueValue, HEX);
      analogWrite(RED, redValue);
      analogWrite(GREEN, greenValue);
      analogWrite(BLUE, blueValue);
    }
    
    
  }
}


