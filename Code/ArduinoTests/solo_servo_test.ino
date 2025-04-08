#include <Servo.h>

Servo myServo; 

int servoPin = 9; 

void setup() {
  myServo.attach(servoPin);  
}

void loop() {

    myServo.write(90);  
    delay(1000); 


     
  }

  