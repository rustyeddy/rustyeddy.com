---
title: Control Station
description: >
  The Control Station project was designed to create a flexible remote
  control station for the Mobile Robot. 
date: 2019-07-04
site: http://github.com/mobilerobot-io/projects/control-station
image: https://rustyeddy.sfo2.digitaloceanspaces.com/SensorStation.png
---

The first phase of the control station that you are looking at here
includes a Joystick for human control that directly moves the Camera
Pan & Tilt assembly.  The ControlStation is designed to allow the
addition of wireless connectivity and an easily interchangeable set of
input devices (Joystick, Gyro Displays or Computer Algorithms and so
on).  Output devices include motor controllers, cameras, displays and
cloud storage for example. 

## Project Requirements

Following are the high level requirements, or goals for this project.

- Provide a joystick control for robot
- Provide Pan tilt Servo Control for Camera Stand
- Split micro controllers between Input and Output 
- Wired i2c
- Wired serial / uart
- Wireless
- 802.11

Requirements 1-2 are complete, Requirement 3 is a Work In Progress
(WIP) where the micro controllers have been split and are now
communicating via I2C, remaining work to complete the serial code and
the code to activate the receiver. 

## High Level Diagram

<img src="{{ .Params.image }}" />

## Bill Of Materials

- 3-5v Thumbstick Joystick 
- 2 sg109 Hobby Servos
- Pan and Tilt Assembly
- Arduino nano 


## Source Code

Following is an important snippet from the [source code](https://github.com/rustyeddy/Arduino):

> TODO: add GIST

## Conclusion

This was a fun little project to rip out.  There is nothing more
exciting for me, than to write some software that causes hardware to
come alive.  As you will see in the soon coming video, each joystick
movement translates into the same ration of motion by the Servos.
This causes the mounted camera to move rather erratically.

Another issue: to park the camera in a set location currently requires
one to hold the joystick in a particular situation.  This is the
result of rather naive programming.  An upcoming version of the
software will use a more intelligent algorithm, and perhaps some
appropriate control software.

Until then we will mark this as a new requirement.
