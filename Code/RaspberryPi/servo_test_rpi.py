import time
import board
import busio
from adafruit_pca9685 import PCA9685
from adafruit_motor import servo

# Initialize I2C and PCA9685 
i2c = busio.I2C(board.SCL, board.SDA)
pca = PCA9685(i2c)
pca.frequency = 50  # Set PWM frequency to 50Hz -

# servo objects for channels 13, 14, and 15
servo13 = servo.Servo(pca.channels[13])
servo14 = servo.Servo(pca.channels[14])
servo15 = servo.Servo(pca.channels[15])

# Function to get input
def get_angle_input(servo_num):
    while True:
        try:
            angle = int(input(f"Enter angle for servo {servo_num} (0-180): "))
            if 0 <= angle <= 180:
                return angle
            else:
                print("Invalid angle. Please enter a value between 0 and 180.")
        except ValueError:
            print("Invalid input. Please enter a number.")

# Main control
try:
    while True:  # Continuous loop until Ctrl+C
        # Get angle input for each servo
        angle13 = get_angle_input(13)
        angle14 = get_angle_input(14)
        angle15 = get_angle_input(15)

        # Set servo angles
        servo13.angle = angle13
        servo14.angle = angle14
        servo15.angle = angle15

        print(f"Servos set to: Servo 13 = {angle13}, Servo 14 = {angle14}, Servo 15 = {angle15}")

        # delay for stability
        time.sleep(1)

except KeyboardInterrupt:
    print("Exit.")

finally:
    pca.deinit()
    print("PCA9685 deinitialized.")
