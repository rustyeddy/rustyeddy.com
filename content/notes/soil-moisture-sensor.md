---
title: Soil Mosture Sensors
date: 2024-02-15
description: >
  Plenty has been written about resistive vs. capacitive soil moisture
  sensors and how laced they are with problems. After a lot of
  research and quite a bit of experimentation here are my notes
  getting them to work (or not) as well as making them last by
  protecting the fragile electronic components from the elements. 
categories: electronic-components
tags: soil moisture
github: https://github.com/sensorstation/iotesp
---

## Overview

Seems like I'm not as uniquely clever as I once thought, the idea of
creating a self watering garden is probably one of the more popular
DIY maker projects on the Internet it seems.

Check out my version of the [Self Watering Garden](/iot/self-watering-garden)

What makes my project different?  Probably not alot, however in this
project we treat each of the watering _stations_ as a part of a
larger, complete _system_ of the watering stations that can be
observed and controlled by a single hub and associated web
application. Check out the project, I'd love to hear what you 
think! 

Anyway, the key element or sensor to this project is the _soil
moisture sensor_. Unlink many of the other sensors used in this and
other project, which "just work", these soil sensors are problematic.

I'll explain.

## Capacitive over Resistive

If you do a quick google search on "arduino soil moisture sensors" you
will immediately see two types: _resistive_ and _capacitive_ sensors.

> TBD place a pic of capacitive and resistive sensors here

In short we choose the capacitive over resistive version of the
sensor. Many others have done a great job explaining why the resistive
sensor is NOT a good choice so I won't repeat them here, however, if
you are interested this 
[Adafruit product Description](https://www.adafruit.com/product/4026) 
does a great job explaing why resistive suck and capacitive are the
way to go.

However, all is not necessarily rosey even with the Capacitive
versions of these sensors. The remainder of this article I'll
summarize the research I have done and my practical experience with
these sensors.

## Capacitive have their problems

### What's up with the v1.2 or v2.0?

The video below says that v2.0 is no different than v1.2, it is simply a
marketing trick. GASP! The internet is taking advantage of us, for
shame! 

### Bad reputation for being unreliable

This is a really good video claiming 82% of them do not work
correctly. It also goes on to describe how to tell which sensors are
better. 

{{< youtube IGP38bz-K48 >}}

He makes a really smart plant pot! Turns out the capacitive sensors I
bought are the wrong ones, awww bummer. I bought 5 of those things,
sigh (good thing they were only a couple bucks).

Well, I'll still try to get them to work, which as you'll read later,
was not a whole lot of fun.

### Missing Voltage Regulator

In theory they could operate at 3.3v or 5v which is great, however the
autorh of the video found some productions of these sensors are
missing this voltage regulator. Which can really become a problem if
they are being powered by batteries that do not maintain a consistent
regulated flow of power to the sensor. 

Look for the 662K voltage regulator from the pics before you buy. And
hopefully the ones you buy will be the ones you were looking at in the
pic. 

### The wrong timer chip

He also goes on to explain how the timer chip can cause a problem on
sensor made without the appropriate 662 voltage regulator.

Look at the label on the timer chip.

> TLC555 good.  NE555 chip bad.

The NE555 needs at least 4v and will not work if power comes in less
than the 4v like can happen for certain batteries.

Turns out the sensors I bought have the NE555 chip. Sigh. That won't
stop me!

### Missing Resistor

He said a large number of chips were missing the 1M resistor (Todo
rewatch the video and make sure I have the correct value of the
resistor). 

This causes the sensors response to change to be very slow. I thought:
"that's not so bad, I really only need to check every 15 minutes".

Well, he points out why we should care in the video and why the
readings may be garbage if your sampling does not allow the values to
eventually settle down.

Now that can be a big problem, especially if you are allowing your MCU
to sleep and wake up, measure and go immediately back to sleep!

If I do end up using these sensors I'll wake up every 15 minutes or so
then wait for a couple minutes for the readings to stabalize. Of
course when the water is turned on, we should probably not sleep very
long as we don't want to over water.  Or perhaps just expect to water
for a specific limited period.

We'll see..

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

{{< youtube QGCrtXf8YSs >}}

https://youtube.com/watch?v=QGCrtstreaming-video-tools/Xf8YSs 

I will try this and see if it creates a noticable difference in
tracking the changes in moisture.

## Environmental Protective Actions (EPA)

You thought I was going to involve the formidable government agency,
naw. Just looking for a cheap accronym. Here I'll go over the
method(s) I choose to follow. I'll try two of them:

### Protecting the Electronics

This medium article on 
[Protecting](https://medium.com/@d.robertson/protecting-capacitive-soil-moisture-sensors-e1ab81f1c4fb),
Daniel Robertson does a great job collecting various methods he has
found across the Internet and describing various options for 
options .

> I wonder why the manufacture did not take care of protecting these
> devices. Hmm.

Daniel goes into a great amount of detail in his article, I'm not
going to repeat what he has to say, just choose a couple to try
myself. I highly recommend reading the article, however.

1. Sally Hansen Hard Nail Polish
2. Urethane Coating 

In both cases I'll also cover with a heat shrink tubing. 

### Protecting the Sensor PCB

After a relatively short period of time it seems the sensors suck up
water causing them to destroy themselves.  Here are some protective
methods to make them more reliable and last longer.
