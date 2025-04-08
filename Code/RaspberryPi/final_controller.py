import sys
import os
import time
import board      # Added for hardware access
import busio      # Added for I2C
from adafruit_pca9685 import PCA9685 # Added for servo controller
from adafruit_motor import servo      # Added for servo control

from PyQt5.QtWidgets import (QApplication, QMainWindow, QWidget, QVBoxLayout,
                             QPushButton, QHBoxLayout, QLabel, QSlider, QGridLayout) # Added QSlider, QGridLayout
from PyQt5.QtCore import Qt, QTimer, QDateTime
from picamera2 import Picamera2
from picamera2.previews.qt import QGlPicamera2
from picamera2.encoders import H264Encoder
from picamera2.outputs import FfmpegOutput

class RobotControlWindow(QMainWindow):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("Raspberry Pi Robot Control")
        self.setGeometry(100, 100, 800, 750) # Adjusted size

        # --- Status Label ---
        self.status_label = QLabel("Status: Initializing...")

        # --- Define Initial Servo Angles ---
        # *** MODIFICATION: Define specific initial angles ***
        self.initial_angles = {
            13: 90,
            14: 180,
            15: 10
        }

        # --- PCA9685 Servo Controller Setup ---
        self.pca = None
        self.servo13 = None
        self.servo14 = None
        self.servo15 = None
        self.servos = {}          # Dictionary to hold servo objects
        self.servo_sliders = {}
        self.servo_labels = {}

        try:
            self.i2c = busio.I2C(board.SCL, board.SDA)
            self.pca = PCA9685(self.i2c)
            self.pca.frequency = 50
            self.status_label.setText("Status: PCA9685 Initialized.")
            self.servos_initialized = True

            # Create servo objects and set initial positions
            # *** MODIFICATION: Use specific initial angles ***
            servo_channels_to_init = [13, 14, 15]
            for channel in servo_channels_to_init:
                initial_angle = self.initial_angles.get(channel, 90) # Default to 90 if not specified
                try:
                    servo_obj = servo.Servo(self.pca.channels[channel], actuation_range=180)
                    # Clamp initial angle to valid range (0-180) just in case
                    initial_angle = max(0, min(180, initial_angle))
                    servo_obj.angle = initial_angle
                    self.servos[channel] = servo_obj # Store servo object
                    print(f"Servo {channel} initialized to {initial_angle} degrees.")
                except Exception as servo_init_e:
                    print(f"Error initializing servo on channel {channel}: {servo_init_e}")
                    # Handle error for specific servo, maybe disable its slider?

            # Assign specific servos if needed elsewhere (optional now with self.servos dict)
            self.servo13 = self.servos.get(13)
            self.servo14 = self.servos.get(14)
            self.servo15 = self.servos.get(15)


        except Exception as e:
            print(f"Error initializing PCA9685: {e}")
            self.status_label.setText(f"Error: PCA9685 not found or failed to initialize! {e}")
            self.servos_initialized = False


        # --- Camera Setup ---
        self.picam2 = Picamera2()
        self.preview_width = 800
        self.preview_height = 600
        self.video_config = self.picam2.create_video_configuration(
            main={"size": (1920, 1080)},
            lores={"size": (self.preview_width, self.preview_height), "format": "YUV420"},
            controls={"FrameRate": 30}
        )
        self.picam2.configure(self.video_config)

        # --- GUI Setup ---
        self.central_widget = QWidget()
        self.main_layout = QVBoxLayout(self.central_widget)

        # --- Camera Preview Widget ---
        self.preview_widget = QGlPicamera2(self.picam2, width=self.preview_width, height=self.preview_height)
        self.main_layout.addWidget(self.preview_widget)

        # --- Recording Controls Layout ---
        self.recording_controls_layout = QHBoxLayout()
        self.record_button = QPushButton("Record")
        self.stop_button = QPushButton("Stop Recording")
... (188 lines left)