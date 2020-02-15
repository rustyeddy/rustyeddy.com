---
title: How to Cross Compile for the Raspberry Pi
date: 2020-02-07
description: >
  Building software for the Raspberry Pi is both fun, and these days
  part of many professional prodcts. However, building complex
  software on a Raspberry Pi can be very painful. Read about my
  attempt(s) at speeding up my development cycle with
  cross-compiling. 
---

Production software development for a Raspberry Pi is a fairly common
thing now.  This is great for many reasons, but does have the downside
that compiling large hunks of software on the PI is extremely
slow compared to a modern laptop.
<!--more-->

The other major downside is that the development tools either do not run
on the pi, they are painfully slow to use, or hard to build.

Wouldn't it be nice to build software for a Raspberry Pi with the same
rich development environment and speed we have on our desktop!

## Set up cross compiling

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
