---
title: Soil Mosture Sensors Adafruit
date: 2024-03-13
description: >
  After having a not so great experience with capacitive soil moisture 
  sensors that are readily available all over the Internets, I tried 
  another alternatvie from Adafruit, this neat little sensor communicates 
  with I2C, it is a bit smaller than previous sensors, this document talks 
  about my experience with those little guys.
categories: electronic-components
tags: soil moisture
github: https://github.com/sensorstation/iotesp
---

## Why the Adafruit version?

<<<<<<< HEAD
I have had a hard time with the general Capacitive Soil Moisture
sensors that you find readily on the Internet as described in this
article about 
[soil moisture sensors](http://localhost:1313/notes/soil-moisture-sensor/).
In a nutshell, the ones I bought had the wrong timer chip in them, not
that was a total show stopper but I also had problems getting them to
work with the esp32 ADC (Analog Digical Converter). 

After spending way too much time trying to get them to work, I decided
to just go with a much more reliable source: 
[Adafruit STEMMA Soil Sensor](https://www.adafruit.com/product/4026?gad_source=1&gclid=EAIaIQobChMIlea3-Y-ihQMVNoHCCB0DLAylEAAYASAAEgJabvD_BwE).

## What is different

Right off the bat, they visually look different than the typical ones
splattered all over the Internet.  Besides the obvious visual, It is
green with a plant root, much cute-er than the other more commonly
found sensors.  It is also quite a bit smaller than previous sensors.
=======
Because I trust them. 

## What is different

Besides the obvious visual, It is green with a plant root, much cute-er
than the other more commonly found sensors.  It is also quite a bit
smaller than previous sensors.
>>>>>>> master

## I2C and Software

Technically, it also communicate via I2C which makes it more generally
usable by a whole slew of other Micro-controllers which is cool but it
also means we have to do a little more work reading values from the
devices.

### The SeeSaw Platform

SeeSaw is an i2c secondary device that operates at 3.3v but has a
level shifter that can operate with 5v systems.

7 bit addressing only

- Needs pull up resistors: 2.2k to 10k is a good range.
- base i2c address is set in the firmware of the device being
  communicated with 
- Addresses can be incremented by one by pulling one or two other
  specific pins low. Specifically the soil moisture sensor can change
  addresses by shorting a couple pads 
> TODO Show a picture


