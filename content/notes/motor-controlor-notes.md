---
title: "Raspberry Pi and Arduino Motor Controllers for Robots"
description: >
  Choosing a motor controller for a Raspberry Pi or Arduino robot, and
  why splitting real-time motor control from decision-making works
  better. Notes from my 2018-2019 robot builds.
categories:
  - electronics
  - motors
image: https://mobilerobot.sfo2.cdn.digitaloceanspaces.com/display-and-motors.jpg
tags:
  - arduino
  - raspberry pi
  - adafruit
  - motorshield
  - architecture
github: http://github.com/mobilerobot-io/arduino
date: 2018-08-22
aliases:
  - /notes/rpi-motor-control-service/
---

{{< older-note >}}

These are notes from the small mobile robots I built in 2018 and 2019. The
hardware is from that time: Adafruit Motor Shields, Arduinos, and a
Raspberry Pi 3. I haven't re-evaluated it against today's boards, so read
the parts list as *what I used*, not a current buying guide.

The part that hasn't aged is the architecture. **Don't make one board do
everything.** Let a microcontroller handle real-time motor control, let a
Linux computer make decisions, connect them with a message channel, and
decide up front what happens when that channel goes quiet.
<!--more-->

## Raspberry Pi or Arduino? Neither, On Its Own

When I started building a mobile robot, the obvious first question was which
board to build it around: a Raspberry Pi or an Arduino. I eventually
realized that committing to either one alone would have been a mistake.

- **The Arduino** is good at dedicated, real-time work like driving motors.
  Its development environment is great for getting started with embedded
  programming, but limited for building larger control software.
- **The Raspberry Pi** runs Linux, with an endless choice of languages,
  tools, and libraries. But Linux is not a real-time operating system, so
  the Pi is a poor fit for tight, timing-sensitive motor control.

Combining them gets the advantages of both.

## The Split

![A Raspberry Pi running control software and an MQTT broker sends throttle commands to an Arduino, which drives an Adafruit Motor Shield powering four DC motors and two servos from a separate battery, and stops the motors if the link is lost](/diagrams/robot-motor-control-split.svg)

My preferred setup was a Raspberry Pi as the controller, connected over I2C
or SPI to an Arduino with a motor shield:

- **The Pi makes decisions.** It runs the control software, the camera, and
  an MQTT broker, and turns goals into left and right throttle commands.
- **The Arduino executes them.** It owns the motor loop and the motor shield,
  and does nothing else.
- **A message channel connects them.** Commands are small and simple: a
  throttle and direction for each side of the vehicle.

On larger setups the "decisions" side doesn't have to be a Pi at all. It can
be a laptop or a Jetson Nano, and the microcontroller can be an ESP8266,
ESP32, or STM32. The split stays the same.

### Design for losing the channel

The rule I wrote down for the motor control channel still matters most: the
vehicle may take commands from the channel while it's available, but **it
must always be able to regain control, or shut down completely, if the
control channel is lost.**

Splitting the system makes that rule easy to enforce. The microcontroller
can treat silence as a command to stop, no matter what the software on the
Pi is doing. When one board does everything, a hung process can leave the
motors running at whatever speed they were last given.

## Motors

I was strictly working with cheap DC motors, the kind that cost less than
$10 and often less than $1, or come out of scrapped electronics. Three types
come up right away: brushed DC motors, hobby servos, and stepper motors.

**Brushed DC motors move the wheels.** They're simple to control with two
wires: vary the power to change speed, and reverse the current to change
direction. They're also cheap and everywhere. The ones on my single-Pi robot accepted
6 to 12 volts.

**Servos aim the camera.** Two inexpensive servos handled the camera's pan
and tilt.

For my primary vehicle that meant **four DC motors and two servos.**

## Steering: Skid Steering

Moving the vehicle is one thing; steering it is another. All of my vehicles
used **skid steering**: a 4WD with four motors directly driving the wheels,
two 2-wheel vehicles, and a tracked vehicle. To turn, you drive the left and
right sides at different speeds, and one side skids.

Drive the two sides in opposite directions at equal power and the vehicle
spins in place, which is very useful in tight spaces like corridors and
warehouses. See [Skid Steering](/notes/skid-steering/) for more.

## Power the Motors Separately

The Raspberry Pi can't supply nearly enough power for the motors, especially
under heavy load, so the motor controller needs its own battery pack. If you
want to chase your tail on weird problems, work with underpowered
electronics for a while.

## Motor Controllers I Used

I settled on Adafruit's motor shields as general-purpose options: the
Adafruit Motor Shield for Arduino, and its sister DC and stepper motor
controller for the Raspberry Pi. Together they covered four DC motors and
two servos.

- **Adafruit Motor Shield v1 and v2.** Version 2 talks to the
  microcontroller over I2C.
- **OSEPP motor shields** largely duplicate the Adafruit shields'
  functionality. The hardware is sturdy, but the documentation is hard to
  find and has to be pieced together from their kit documentation. For real
  prototyping I found Adafruit's support more thorough.

## When One Board Does Both: The Single-Pi Robot

One robot broke my own rule on purpose. It was a simple autonomous vehicle
built on a single Raspberry Pi 3 with Adafruit's Raspberry Pi DC and stepper
motor controller, two brushed DC motors, a separate battery pack for the
motors, and a cheap two-wheeled body. On that robot the Pi was both the
decision-maker and the motor controller.

I wrote a skid-steering library called Skidder and added it to my
[Raspberry Pi Device Server (RPID)](https://github.com/mobilerobot-io/rpid),
which let me drive the motors three ways:

- **MQTT:** the server subscribes to `/control/skid` and expects two numbers
  between -1 and +1, the left and right throttles. The magnitude is the
  share of power the motor gets, and the sign is its direction.
- **REST:** `GET /skid/` reads the current throttles, and `PUT /skid/l/r`
  sets them.
- **A keyboard controller,** for driving it over SSH.

### Keeping the message layer anyway

With minimal sensors, slow motors, and maybe a camera, a single multi-core
Pi had more than enough capacity, so I could have removed the messaging
layer and called the motor code directly. I kept it. Every other robot used
the same message-based architecture, and one architecture with one set of
tools and configurations was worth more than the overhead I'd save.

I expected the overhead to be trivial compared to the resources available,
but expectation isn't measurement. That's the general lesson: consistency
and maintainability are worth a small cost in production systems, and the
only way to know whether the cost really is small is to measure it.

## Parts List (Single-Pi Robot)

- Raspberry Pi 3
- Adafruit Raspberry Pi DC and stepper motor controller
- Separate battery pack for the motors
- 2 brushed DC motors
- Two-wheeled chassis
- Application-specific sensors

## Where This Fits

- [Skid Steering](/notes/skid-steering/) covers the drive model in more
  detail.
- [Control System Design](/notes/control-design/) covers the control
  software side.
- [OttO](/projects/otto/) is my current IoT edge runtime in Go.
