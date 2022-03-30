---
title: Control System Design
date: 2018-05-05
description: >
  Boy do I gotta lotta learn. This control systems is pretty serious
  stuff!  I'll have to learn some of this stuff to incorporate back
  into our driving algorithms. 
draft: true
---

Early in the process of building the first set of mobile robots I
discovered that I was not going to settle on a single micro
controller. 

The first two obvious choices being the Arduino or Raspberry Pi, for which
I tried both with a modest level of success.  I quickly realized that
I would not be providing my sole focus on either platform, neither was
sufficient for my grand plans for a number of reasons.

- limited software tools and debuggers, etc on the Arduino
- RPi lacking realtime hardware features, and being large
- limited number of pins and functionality on either platform
- Arduino needs sheilds for many types of communication.

And perhaps others. However, if I could combine them and use the best
of both worlds while also increasing the number of pins available for
mobile communications.

### Combining Controllers

If we could combine controllers that would be ideal, we would have a
lot of flexibility in terms of what functions the RPi vs. Arduino
would handle.

In order to combine controllers we are going to need to define an
"internal/private" communication link between the two devices.

Which is solved right off the bat with the serial (UART) port. The serial
port is already used to _flash_ the Arduino, it can certainly be used
to pass messages on the data control buses.

### I2C Inter-circuit Communication

While the serial port gives us leverage to build a _distributed
control system_, it does suffer a few disadvantages including the fact
that it is Point-to-Point (P2P).

That is two devices must be directly connected to communicate, ergo
every controller must have a UART connection to every device it needs
to talk to.  In other words, 

> Serial communication does not scale well

Fortunantely we have a few other options, we will consider on of these
options here: I2C which introduces a message bus, only two wires,
transmit and recieve (actually four if you count power wire), but only
two wires are required to connect to the bus, allowing, in theory,
over a hundred devices could all communicate.

> TODO: put a link in to my I2C article for an explantion

I2C also happens to be supported in hardware on pretty much every
microcontroller I have looked at thus far.  

> Many other legit choices are available including: SPI, CAN,
> ethernet, etc.

Wifi is also possible in some cases, but we are going to go with I2C
because it is more robust, simpler and faster than standard serial
comminication. 

It is very easy to wire up multiple I2C devices if and when we need
to. 

## The Value in Decoupling

By introducing a wired message bus for our controllers, first it
allows us to pick and choose which controllers and how many we need,
based on the demands of our application.

### Complexity with the Flexibility

An additional benefit  we can get from our decoupled hardware, is
decoupled software.  That is we now have to think hard about our
software as a _system_, and specifically identify what functionality
or service is going to be applied by which device.

If we do this correctly, we will end up with an incredibly flexible
vehicle in which we will be able to mix and match hardware, software
and expirement with algorightims, without having to recompile and
reload software with complex configurations.

## Control Software Design

In it's most simplest form, our _system_ consists of:

- Data producers (sensors or any timeseries data or event)
- Control Translator ~ accepts data messages, and converts them to a
  controller object as _new state_
- Control State Machine ~ computes _Control OUTPUTs_ from _new state_
  against _current state_
- Control Outputs ~ Control messages are created from controller
  object then written to message bus
- Output Controllor ~ Accepts messages from the bus, decode and
  santize them, convert them into specific control commands. 
  
### For example 

- Keyboard connected to laptop: script accepts keystrokes from the
  keyboard, turns it into an INPUT message and then writes that
  message to the KBD channel.
  
  Say we hit 'r' key to tell the robot to turn right.

- The Controller Translator subscribes to the KBD channel and accepts
  all messages, which contain keystrokes.  The translator parses the
  incoming message and provides the control software with _new
  state_. 
  
- The Controller does its thing with the _new state_, in light of the
  _current state_ against a stated _goal_ to determine the next move
  toward stated _goal_, produces CONTROL OUTPUT, which is to turn
  right. 
  
  This needs to be converted into a change in motor speed and
  direction for steering.  In our case, we are using skidsteering
  (most simple) which can effectively be controlled by grouping motors
  into _Left and Right_ groups, the adjusting the speed of the groups
  of wheels.
  
In other words, if right and left wheels both turn at half speed the
vehical will go striaght forward at half speed.  If we want to turn
right, we could make the left wheel go at, say half speed, and have
the right wheel go at 0.  

> Or maybe have the right wheel go in reverse at half speed?

### OUTPUT Controller

At the end of the day, our _Skid Steer_ motor controller only needs to
know two things: how fast to spin the motor (or not), and what
direction. 

When the four individual motors are combined into a system, that are
confronted with a set of constraints.  Specifically that:

1. Speed and steering are soley determined by the speed of the right
   and left motors.
2. Turning is performed solely by altering the speed of either group
   of wheels.
3. Wheel groups will always turn in the same direction at the same
   velocity.  Not doing so could cause damage and would likely produce
   no desired result. Only misery and suffering.


### Data Producers and Consumers

Data is produced in a number of ways, including sensors, camera
inputs, etc.  The data produced is captured, often from a hardware
pin, or a computer image, which is then written or **published** to
it's specific data channel.

For example, we could have a Keyboard, Joystick or Webapp control our
remote vehicle.  Further more, at runtime, you may choose to have the
vehicle drive itself using object detection and avoidance or computer
vision, radar, and so on..

#### The Message Bus

