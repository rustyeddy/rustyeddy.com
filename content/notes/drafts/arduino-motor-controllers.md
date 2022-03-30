---
title: Arduino Motor Control Software
description: >
  In the distributed Mobile Robot Architecture, the Arduino acts as
  a dedicated micro-controller for the small brushed DC motors.  This
  Arduino is controlled via commands over a serial, RF or Blue Tooth
  port of some sort.
categories:
  - electronics
  - motors
image: https://mobilerobot.sfo2.cdn.digitaloceanspaces.com/display-and-motors.jpg
tags:
  - arduino
  - raspberry pi
  - adafruit
  - motorshield
github: http://github.com/mobilerobot-io/arduino/src/mctl
date: 2018-08-22
draft: true
---

Pictured about is the [OSEPP v2
Motor Shield](https://www.osepp.com/electronic-modules/shields/120-motor-shield-6612)
which can be used as a functional replacement to the [Adafruit v2
motorshield](https://learn.adafruit.com/adafruit-dc-and-stepper-motor-hat-for-raspberry-pi/using-dc-motors),
the motorshield I recommend. 

> Source code can be found here
> [http://github.com/mobilerobot-io/arduino/](http://github.com/mobilerobot-io/arduino/)
> within the src/mctl directory.

## Arduino Motorsheild and Distributed Controls

The software in the repository is to be loaded on an Arduino with
either an Adafruit v2 Arduino or OSEPP 6612 MotorShield.  The software
accepts commands as incoming text strings from one of several possible
_serial inputs_; UART, RF Radio, Blue Tooth, etc.

> TODO: place diagram showing an arduino accepting commands from a RPi

Input commands are parsed and the commands are acted on
accordingly. For example, our SkidSteer provide the following
_throttle_ method to change the speed and direction of the vehicle. 

I prefer to use an Arduino with a _Motor Shield_ as a dedicated
micro-controller regulating the voltage supplied to the DC motors, it
may carry on local conversions or control calculations dedicated to
proper motor handling.

Additional sensors and guidance inputs can be handled by additional,
perhaps less critical controllers.  Hopefully reducing the chance of
critical motor controllers from failing.

### The Big Skidder

My primary vehical is a 4wd, that is 4 DC motors directy spinning two
rubber tires.  I also have available two, two wheeled vehicals and a
_train tracked_ vehical.

In all cases each of these vehicle employ [_skid
steering_](/notes/skid-steering) on account a one wheel (wheels or
tread) will be skidding along when your turnin.

## Required Motors and Controller

We need to power the following motors (at minimum):

- 4 DC Motors
- 2 Servos

## Adafruit MotorShield

The first phase of building Robots I recommend the Adafruit Motor
Shield V2.  I also tried the OSEPP 6612 and Adafruit Motor Shield v1
(before I realized there was a version 2).

Links to the shields can be found here:

1. [Adafruit v2 Arduino DC/Stepper MotorController](https://learn.adafruit.com/adafruit-dc-and-stepper-motor-hat-for-raspberry-pi/using-dc-motors)
2. [OSEPP v2 MotorController]()

> Insert picture of Adafruit Motor shield

### OSEPP Shields v1 & v2

The OSEPP MotorSheilds effectively duplicate the functionality of the
Adafruite MotorShields.

The documentation is hard to find and must be pieced together through
the documentation of their hardware kits.  I do find the hardware to
be of a sturdy make.  The use connectors to help in learning, the
Adafruit are more through for real prototyping.

For particular details about the controller and other hardware please
refer to the Adafruit and respective product websites.

## Arudio MCTL Software 

The code in this library can be compiled by with the 
[Arduino IDE](http://arduino.io/downloads) to an UNO with an Adafrutit
v.2 (or compatible) motor controller.  One of the MBR vehicles OSEPP
Two Wheel balancer uses an OSEPP motor library wich is very similar
(but) different than the Adafruit version.

### Reads From Serial Input

This could be virtually any "stream" of data from a UART, RF, Blue
Tooth or Wifi ports.  Regardless, the software reads from the
appropriate input, parses the incoming commands and adjusts power to
the motors accordingly.

> Place snippet of Skidder software class here

### MQTT and Motor Control Channel

Connect the motor controller to the MQTT control channel.  NOTE: on
vehicle may use the motor control channel when availble, however, must
always be able to regain control (or shutdown completely) if the
control channel has been lost. 

## Testing and Validation

How is this software tested and valided for promotion?

> Todo document the testing procedure

## Maintanance and Upgrades

> Todo document the deployment and production release producedure.

Alas, too many projects, to little time!
