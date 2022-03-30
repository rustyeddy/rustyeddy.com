---
title: Arduino Software
date: 2019-05-01
description: >
  This is a small sample of C/C++ sketches I wrote for the
  Arduino. Examples of other embedded chips including esp8266 and
  esp32 are also available.
draft: true
---

## Arduino Software

My github repo below is contains collection of Arduino code, sketches
and libraries that achieve a variety of simple but useful tasks, none
are necessarily a project in and of itself, but may be included in a
number of projects providing support for specific functionality.

Here is a description of some Arduino code you can find.

## Sketches include

- esp8266 a series of sketches for the esp8266 chip

- **LCDKeypad** drives a 16x2 LCD display with 7 additional buttons. These
  display's are very useful for projects that need to display short
  but important info.

- **SensorStation** load this software on an arduino loaded with
  sensors that will broadcast to an external station.  Sensors can be
  configured at runtime.  
  
  Various serial interfaces exist for UART, RF, Bluetooth and Wifi
  according to what is available.
  
- **Balance** controls a 2-wheeled balancing robot with the help of an
  MPU6050 gyroscope and accelorometer.
  
- **Blink** Hello, World!

- **i2c** Uses the Wire library to implement the 
  [TLVs application layer protocol](/projects/realtime-communications-and-tlvs) 
  enabling an Arduino wired to an I2C bus to communicate with other
  devices in a well defined, organzed manner.

- **lcd** An alternative LCD program for a display that lacks the
  input buttons of the LCDKeypad code.
  
- **mctl** Runs on an arduino accepting CONTROL OUTPUT _skid_ messages
  from a serial port (e.g. UART, RF, Bluetooth, etc) with the format
  /control/skid/<left>/<right>, modifying the load given to the
  throttle. 
  
- **rf24joy** This is code for the [RF Joystick
  project](/projects/rf-joystick).  It allows and Nano connected to a
  joystick with two degrees of freedom and a button.   Nano accepts
  signals from the Joystick, and attached button, advertised the data
  over an RF (Nordic Labs RF24L01 chip)
  
## Alternative Chips

For more recent and more complex project I will tend to use other more
sophisticated chipsets like the esp8266, esp32 and stm32, they are
cheaper and more powerful than the Arduino, in the case of the esp8266
and esp32, they have built in wifi!
