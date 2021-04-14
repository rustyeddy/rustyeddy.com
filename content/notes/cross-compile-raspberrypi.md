---
title: How to Cross Compile for the Raspberry Pi
date: 2020-02-07
description: >
  Building software for the Raspberry Pi is both fun, and these days
  part of many professional prodcts. However, building complex
  software on a Raspberry Pi can be very painful. Read about my
  attempt(s) at speeding up my development cycle with
  cross-compiling. 
resources:
  - https://github.com/raspberrypi/tools
  - https://www.raspberrypi.org/documentation/linux/kernel/building.md
---

Production software development for a Raspberry Pi is a fairly common
thing now.  This is great for many reasons, but does have the downside
that compiling large hunks of software on the PI is extremely
slow compared to even a low end laptop.
<!--more-->

## Getting The Toolchain

Fortunantely the good folk at Raspberry Pi made the tool chain they
use internally available as a download, second _they_ wrote a really
good document on how to use it.

We need to grab the tools from here:

- cross-compile tools: https://github.com/raspberrypi/tools
  - install them by following the directions they provide
- cmake for arm

```sh
/radian/RadianConfig/build$ cmake .. -DCMAKE_TOOLCHAIN_FILE=../toolchain.armhf
```

Now we can read this document: 

The other major downside to building on a Pi is that you may not be
able to set up your desired development environment, or that is way to
slow. 

Setting up the environment for cross compiling.

## Set up cross compiling

The first part is grabbing the correct toolchain. Google searches lead
in a bunch of different directions.

### Finding the Toolchain

The embeded world has been doing this for decades: using your desktop
(linux, mac or windows) to build software that will run on a totally
different chip architecture and operating system, or in many cases no
OS at all. 

To do this we have a bit of preparation to do:

### The ARM Toolchain

First we are going to grab _toolchain_ (the compiler, linker, etc.)
that will compile our code on our Linux development machine and
produce a Raspberry Pi executable. 

> TODO put a link to down load

...
