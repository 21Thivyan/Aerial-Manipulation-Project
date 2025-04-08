#include <Wire.h>
#include <Adafruit_PWMServoDriver.h>

Adafruit_PWMServoDriver pwm = Adafruit_PWMServoDriver(); // Create a PCA9685 object (default I2C address is 0x40)

// Servo channels on PCA9685
#define SERVO_0_PIN 0
#define SERVO_1_PIN 1

// Convert Servo.write() angle to PCA9685 ticks
int servoWriteAngleToPwmTicks(int angle) {
  // 1. Convert angle to pulse width (microseconds), assuming standard Servo library mapping
  int pulseWidth = map(angle, 0, 180, 1000, 2000);

  // 2. Convert pulse width (microseconds) to PCA9685 ticks
  int ticks = (pulseWidth * 4096.0) / 20000.0; // Use floating-point for accuracy
  return ticks;
}

void setup() {
  Serial.begin(9600);
  Serial.println("PCA9685 Servo Control");

  pwm.begin();
  pwm.setPWMFreq(50);  // Set PWM frequency to 50Hz (standard for servos)
  delay(10);         // Allow time for initialization
}

void loop() {
  // --- Control Servo 0 ---
  // Move to 50 degrees
  int angle0 = 50;
  int ticks0 = servoWriteAngleToPwmTicks(angle0);
  Serial.print("Servo 0: Angle = ");
  Serial.print(angle0);
  Serial.print(", Ticks = ");
  Serial.println(ticks0);
  pwm.setPWM(SERVO_0_PIN, 0, ticks0);
  delay(1000);

  // Move to 125 degrees
  angle0 = 125;  // Re-use the angle variable
  ticks0 = servoWriteAngleToPwmTicks(angle0);
  Serial.print("Servo 0: Angle = ");
  Serial.print(angle0);
  Serial.print(", Ticks = ");
  Serial.println(ticks0);
  pwm.setPWM(SERVO_0_PIN, 0, ticks0);
  delay(1000);


  // --- Control Servo 1 ---
  // Move to 50 degrees
  int angle1 = 50;
  int ticks1 = servoWriteAngleToPwmTicks(angle1);
  Serial.print("Servo 1: Angle = ");
  Serial.print(angle1);
  Serial.print(", Ticks = ");
  Serial.println(ticks1);
  pwm.setPWM(SERVO_1_PIN, 0, ticks1);
  delay(1000);

    // Move to 125 degrees
  angle1 = 125; // Re-use the angle variable
  ticks1 = servoWriteAngleToPwmTicks(angle1);
  Serial.print("Servo 1: Angle = ");
  Serial.print(angle1);
  Serial.print(", Ticks = ");
  Serial.println(ticks1);
  pwm.setPWM(SERVO_1_PIN, 0, ticks1);
  delay(1000);
}