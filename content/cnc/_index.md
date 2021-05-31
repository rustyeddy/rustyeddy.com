---
title: CNC - Computer Controlled Dremel
description: This is a fun project turning my Dremel into a robot.
date: 2021-05-10
---

I bought a starter 3D printer kit with the intentions of turning my
Dremel [Todo Insert Pic] into a Robot! We'll being controlled by a
Robot anyway.  

## Electronics and Motors Kit

The bunch came as a kit for about $62 USD, the kit included:

- Imitation Arduino
- _CH340G CNC Shield v3.0_ for Arduino
- _DRV8825 Stepper Motor Drivers_ +4
- _Nema 17 Stepper Motors with Mounts_ +3 (m3 screws)
- _End Piece Limit Switches_ +3

Here is a link to the [CNC Motor and Arduino Kit](https://www.amazon.com/dp/B07QLM5PG5?psc=1&ref=ppx_yo2_dt_b_product_details)

## Software

The [GRBL CNC Software](https://github.com/gnea/grbl) basically does
one thing, but it does that one very import thing very well and that
is drive the motors from G-Code that has been sent to the Arduino to
control the stepper drivers. 

### Universal G-Code Sender

Need something to take the G-Code and send it to the GRBL system
could I write some python Fusion360 code to do this directly?

## The Arduino and CNC Cape

A good Youtube video Advising safe adjustment of the Arduino CNC
shield: https://youtu.be/OfyT1xTZC6o

### GRBL CNC Software

## The Nema 17 Stepper Motors

## The Pololu DRV8825 Motor Drivers

Resources:

- [Pololu DRV8825 Motor Driver Carrier High Current](https://www.pololu.com/product/2133)
- [DRV8825 Datasheet](https://www.ti.com/lit/ds/symlink/drv8825.pdf) from Texas Instruments

This is the breakout board for TI’s DRV8825 microstepping bipolar
stepper provided with the kit (from Pololu). It features:

- adjustable current limiting
- over-current and over-temprature protection
- six microstep resolutions (down to 1/32-step)
- It operates froom 8.2v to 45v
- Can deliver up to approximately 1.5 A per phase without a heat sink or forced air flow
  (rated for up to 2.2 A per coil with sufficient additional cooling)

[TODO: place the pinouts from the motor drivers.]

## Installation Process

1. Build and Install GRBL on the Arduino first. This allows it to take
control of the CNC shield once that has been added.
