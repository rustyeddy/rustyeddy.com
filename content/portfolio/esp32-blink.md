---
title: ESP32 C++ LED Blinker
description: >
  I just started working with the very cool ESP32 Wifi chip and the
  ESP-IDF framework built on FreeRTOS by the Espressif chip
  manufacture.  Here is a C++ class and main function to blink a
  couple LEDs. 
date: 2019-05-19
categories:
  - software 
  - esp32
  - freertos
github: http://github.com/mobilerobot-io/esp
draft: true
---

I wrote an LED C++ class to configure an ESP32 GPIO pin as a digital
output, such that we can turn the LED on and off, by setting the
voltage to pin HIGH, turn the LED off by setting _pin_ to 0.

The ESP32 esp-idf development software, built on top of FreeRTOS is a
rich and powerful environment that is friendly to command line
hackers, but certainly C-centric.  However, C++ programs are just a
couple small "bookeeping items" away from full Ojbect Oriented
Programming!

### Resources

- Github: [http://github.com/mobilerobot-io/esp](http://github.com/mobilerobot-io/esp)
- ESP32 Chip: [ESP32](http://esp32.org)
- ESP-IDF: [ESP-IDF](https://docs.espressif.com/projects/esp-idf/en/latest/index.html)

I prefer this chip and development environment over the Arduino IDE
myself.  The boards can be had for about $10 (vs. $16) retail USD. The
have WIFI built in, and lot's of other hardware features that improve
a bit on the Arduino. 

### Outgrowing the Arduino

The Arduino IDE is an absolutely wonderful way of getting started
doing embedded systems development, getting started writting C/C++
that allows novices to do amazing things by bringing hardware alive! 

But as the amount of hardware increases, the need for more advanced
development tasks will start creeping in, things like: interupts,
tasks and scheduling, event loops, multi processors, critical sections
and messaging become requisit to efficiently solving real world
problems, this is when the Arduino starts to become out matched.

### FreeRTOS and ESP-IDF

Welcome the ESP-IDF riding on the excellent OpenSource FreeRTOS.  This
environment is a legit embedded systems development environment.  We
have full access to timers, schedulers, CPUs, tasks, interupts,
communication abstrations, messaging, IPC primatives and so much more.

The best part is, that it works perfect as a command line _first_
"IDE".  That is, hard core _vim_ and _emacs_ hackers will quickly feel
right at home with a command line verison of REPL or really the 

> edit -> build -> run -> debug -> edit 

cycle.  In other words hackers rooted in the unix style command line
are going to feel right at home with their favorite editing tools,
whithout loosing any of the ease or simplicity of the menuconfig
configuration utility provided with every build project.

### About C++ on the ESP C++

This set of C++ files was useful for me to discovere how to develop
and use C++ on the ESP32 and esp-idf.  I will be doing a lot more work
on this platform, and this was a good hello world program for me to
get started with. 

### Code

<script src="https://gist.github.com/rustyeddy/da838496344c327869488602975ba437.js"></script>
