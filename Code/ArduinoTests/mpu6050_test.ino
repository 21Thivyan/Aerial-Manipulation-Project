#include <MPU6050_light.h>
#include <Wire.h>

MPU6050 mpu(Wire);

void setup() {
  Serial.begin(115200);
  Wire.begin();
  mpu.begin();
  mpu.calcGyroOffsets(); // Calibrate gyro offsets
  Serial.println("MPU6050 initialized and calibrated!"); // Confirmation message
}

void loop() {
  mpu.update();

  // Print comma-separated values for Serial Plotter
  Serial.print(mpu.getGyroX());
  Serial.print(",");
  Serial.print(mpu.getGyroY());
  Serial.print(",");
  Serial.print(mpu.getGyroZ());
  Serial.print(",");
  Serial.print(mpu.getAccX());
  Serial.print(",");
  Serial.print(mpu.getAccY());
  Serial.print(",");
  Serial.print(mpu.getAccZ());
  Serial.print(",");
  Serial.println(mpu.getTemp()); // Use println to end the line

  delay(10); // Adjust delay for desired sampling rate
}