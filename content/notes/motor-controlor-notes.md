---
title: Inexpensive Motor Controllers for Arduino and Raspberry Pi
description: >
  The first Robot I build, like many others used an Arduino Motor
  Controller, our first robots used Arduino Motor Controllers.  We use
  them as dedicated output devices used to control voltage sent to
  motors, where as controls run on a Master Controller.
categories:
  - electronics
  - motors
image: https://mobilerobot.sfo2.cdn.digitaloceanspaces.com/display-and-motors.jpg
tags:
  - arduino
  - raspberry pi
  - adafruit
  - motorshield
github: http://github.com/mobilerobot-io/arduino
date: 2018-08-22
---

I prefer to use an Arduino with a Motor Controller over say a
Raspberry Pi with a motor-controller.  I believe the Arudino has
better support for dedicated Real-time software vs. the Raspberry Pi
and as a superior platform for general computing including running
Control Software.  This is how we do it on the West side ...
<!--more-->

Whenever started to build a mobile robot and first started this
project I set out to pick up motor controller and a platform to
buildMy Tom's vehicle around. The two most on his choices at least to
me were a Raspberry Pie or an Arduino.  As I found out selecting
either platform I choose it would have been a bad idea, and here is
why. 


I eventually realized that neither platform, the Raspberry Pie nor the
Arduino had everything I really wanted.  The Arduino certainly lacks a
robust development environment, which Is great for getting started
programming embedded devices, but hardly sufficient for Somebody that
makes a living programming.

## Niether one will Cut it

The Raspberry Pi hardware and Linux OS are not well suited for an
"embedded real time" system.  But does offer an endless choice of
development environments.

### Leave our Options Open

It became clear, that neither platgorm would be ideal for my general
development plans.  Neither of them were ideal to solely commit to.

However, if I could combine them, I could get quite a bit further, by
having access to the advantages that both worlds?Add

Before I get into any detail on these "hobby" controllers is




What are the first things to consider when developing a mobile robot
Is how you're going to make it move, and that is typically using
motors.  The cool thing is that inexpensive electrical motors are
plentiful, however putting them to good use is a bit complex, Here we
will conquer some of that complexity. 

We will consider the following 3 things:

1. What _type_ of motor(s) do we need?
2. How are we going to _power_ them?
3. How are we going to _control_ them?

## TLDR - Summary

I have settled on the Adafruit MotorSheilds for Arudino and Raspberry
Pi as general purpose options.  At the moment, my ideal setup involves
a RPi as the controller with an I2C or SPI connection to an Arduino
with a MotorController.

But not for every circumstance.  It always depends on the application,
having said that, let me explain what I have found (very little) so
far with inexpensive electric motors...

## Project Requirements

First let me frame this discussion, I am strictly talking about cheap
DC motors (not AC that plug into the wall like a washing machine) that
can be had for less than $10USD, often less than $1 or found in scrap
electronics.

The first three motor types I discovered are the ubiquitous: DC
_brushed motor_, _toy servos_ and _stepper motors_.  Incase you are
uninformed like I was in early 2018.. 

### Select Motors and Motor Controller

The purpose of this project is to select the motors and the
corresponding _motor controller_ we need to control our vehicle.  The
motorshield will come as an attachment to a micro controller of some
sort, which happens to be either an Arduino or Raspiberry Pi, in my
case.  

### Brushed Motors Move Wheels

In a nutshell, the brushed motors we'll use to turn the wheels of the
vehicle, they have the advantages of being easily controlled (speed
up, slow down, stop) with just two wires (+ and -), the direction
of the motor can be changed simply by reversing the current to the
motor. 

They are also really cheap and can be found every where, including
scrap electronic toys and utilties.

### Servos to Pan and Tilt Camera

We will include two inexpensive _servos_ onto the vehicle to handle
the _pan and tilt_ camera functions.

## Drive Train

Moving the vehicle is one thing, steering it is a whole nother
thang. Fortunantely for us, we are going to adopt the fine art of
**skid steering**, the age old method of how the caveman commutted
back in the day.

### Skid Steering

My primary vehical is a 4wd, that is 4 DC motors directy spinning two
rubber tires.  I also have available two, two wheeled vehicals and a
_train tracked_ vehical.

In all cases each of these vehicle employ _skid steering_ on account a
one wheel (wheels or tread) will be skidding along when your turnin. 

[TODO ~ Create a skid steering page](/todo/skid-steering)

Of course, you can get real fancy and spin the thing on axis by
employing equal forces of forward and reverse on opposing sides of the
vehicle.  Which does have significant advantages in tight areas such
as those found in long corridors, warehouses and such.

## Required Motors and Controller

We need to power the following motors (at minimum):

- 4 DC Motors
- 2 Servos

Cut to the chase, the Adafruit XXXXX Arduino motor controller, and the
sister Adafruit YYYY stepper motor controller for the Raspberry Pi are
two such controllers that suite our purposes perfectly well.

### Which MicroController (MicroComputer)?

Todo has a discussion of using a Raspberry Pi + MotorController or
Arduino + Motor Controller.

### Alternative Shields

### Adafruit Sheild v1 & v2

Adafruit essentially has two versions of their MotorShield v1 and now
v2. ...

#### Version 2 I2C

Version 2 of the AFMS runs over the I2C bus.

### OSEPP Shields v1 & v2

The OSEPP MotorSheilds effectively duplicate the functionality of the
Adafruite MotorShields.

The documentation is hard to find and must be pieced together through
the documentation of their hardware kits.  I do find the hardware to
be of a sturdy make.  The use connectors to help in learning, the
Adafruit are more through for real prototyping.


## Motor Software

Adafruit software for Arduino MC and Raspberry Pi MC.

### MQTT and Motor Control Channel

Connect the motor controller to the MQTT control channel.  NOTE: on
vehicle may use the motor control channel when availble, however, must
always be able to regain control (or shutdown completely) if the
control channel has been lost. 

