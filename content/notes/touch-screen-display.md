---
title: Control Station Display
draft: true
description: >
  The control station is where the robot will come to refuel and
  reload applications, it also manages off vehicle cloud controls,
  including compute, storage networking.
date: 2019-04-22
categories:
  - software
  - hardware
tags:
  - tft display
  - touch screen
image: https://mobilerobot.sfo2.cdn.digitaloceanspaces.com/display-and-motors.jpg
---

We are going to build a simple control station that begins with a
Raspberry Pi and connected _7 inch touchscreen tablet_.  I have it
setup in "kiosk mode", which is basically full page chrome without the
tabs and tool bars etc.
<!--more-->

The touchscreen installation was nearly trivial, though I am using two
power supplies, it would complain with just one.

I decided that it would really cool to use a Raspberry Pi as the 
_control station_ for MBR, even cooler, why not attach a 7in touch
screen to the RPI for configuring and monitoring the robot / system. 

## Power

The standard power taken from Mains should be fed with a 2Amp power
supply connected to the **Display Adapter Card**.

You can optionally attach an additional 2am power supply to the
Raspberry Pi thus driving power to the display and adapter card, in
addition to the power supplied to the display, thus powering the Pi
and Display separately. 

## Graphics

Graphics for control software can be done in a number of different
ways.  Unless compelled by good reason otherwise, we'll stick to
webapps: HTML, CSS and JavaScript through a web server.

This will allow us the most bang for our buck.


## Chromium Kiosk Mode

Our user interface will be local server software that will provider
our controller with everyting it needs to do to control our mobile
robots and assocociated components.

> mode. 


### Monitor Mode

Monitor mode will provide us with a _health status_ of our
environment, Configuration mode allows us to modify configurations and
control mode allows us to control our vehicles.

We are going to write a Webapp served up by the local machine, which
will be run in Kiosk mode.  We'll need to determine all the screens
that will run in Kiosk mode, but we will have our local server,
serving up some cool stuff!

## Additional SPI(?) Pins

The adapter board attached to the screen has a couple additional pins
that allow stuff.
