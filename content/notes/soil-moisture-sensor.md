---
title: Soil Mosture Sensors
date: 2024-02-15
description: >
  Plenty has been written about resistive vs. capacitive soil moisture
  sensors and how laced with problems they are. After a lot of
  research and quite a bit of practical experience here are my notes
  getting them to work, last and protecting fragile electronic
  components. 
categories: electonic-components
tags: soil moisture
github: https://github.com/sensorstation/iotesp
draft: true
---

## Overview

Seems like I'm not as uniquely clever as I once thought I was, the
idea of creating a self watering garden is one of the most popular DIY
maker projects on the Internet it seems.

Check out the [Sensor Station Project](/iot/self-watering-garden)

What makes my project different?  Probably not alot, except that each
of the watering stations can be observed and controlled by a hub and
associated app. Check out the project, I'd love to hear what you
think! 

## Capacitive over Resistive

Choose capacitive over resistive.

> TODO place a picture

## Capacitive have their problems

### What's up with the v1.2 or v2.0?

Video below says that v2.0 is no different than v1.2, it is simply a
marketing trick. GASP! The internet is taking advantage of us. For
shame! 

### Bad reputation for being unreliable

This is a really good video claiming 82% of them do not work
correctly. It also goes on to describe how to tell which are better.

https://www.youtube.com/watch?v=IGP38bz-K48

He makes a really smart plant pot!

### Missing Voltage Regulator

In theory they could operate at 3.3v or 5v which is great, however he
has found some of them are missing this regulator. Which can really
become a problem if they are being powered by batteries.

Look for the 662K voltage regulator from the pics before you buy.

### The wrong timer chip

He also goes on to explain how the timer chip can cause a problem on
sensor made without the appropriate 662 voltage regulator.

Look at the label on the timer chip.

> TLC555 good.  NE555 chip bad.

The NE555 needs at least 4v and will not work if power comes in less
than the 4v like can happen for certain batteries.

### Missing Resistor Chip

He said a large number of chips were missing the XXX resistory.

This causes the responses to be slow. I was thinking that is not such
a bad thing as the water does not need to take place immediately, heck
we can wait for a few minutes or hours, who cares. 

Well, he points out why we should care in the video and why the
readings may be garbage if your sampling does not allow the values to
eventually settle down.

Now that can be a big problem, especially if you are allowing your MCU
to sleep and wake up!

## How they work

A single analog input along with either 3.3v or 5v power and of course
ground.  A job easily handled by an Arduino, esp32 or Raspberry Pi
Pico. 

Note a regular Raspberry Pi can not handle these sensor directly due
to the lack of _analog pins_ or Analog to Digitcal Converter
(ADC). Not a bit deal, an ADC can easily be added to the Raspberry Pi
(or connect an esp32 or Pico to do the job).

### Calibrating 

High values when dry, low values when wet. They need to be averaged
out also the high and low values are not consistent amoung the various
choices out on the internet.

### Speed of Detecting

Some output values according to change faster than others.  A few
seconds to instantaneously. 

I have two different styles, they both work but have different scales
and speeds to detect the changes.

> Todo place a pic of the two version I have here.

## They are not all the same!

Differences amoung the choices out there are amazingly broad. They
have a bad reputation for being unreliable or unpredictable.

- nf555 vs. tme555 timer chip
- capacitors missing

## Response Times

Placing a 1M Ohm resistor between the ground and signal pins? 

As described in this video at the 5:05 minute mark.

https://youtube.com/watch?v=QGCrtstreaming-video-tools/Xf8YSs 

I will try this and see if it creates a noticable difference in
tracking the changes in moisture.

## Environmental Concerns

### Protecting the Electronics

1. Glue
2. Nail Polish
3. Shrink tubing
4. Silicon

### Protecting the Sensor from Itself

After a relatively short period of time it seems the sensors suck up
water causing them to destroy themselves.  Here are some protective
methods to make them more reliable and last longer.
