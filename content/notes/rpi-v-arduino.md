---
title: Comparing the Arduino and Raspberry Pi
date: 2018-03-14
description: >
  A quick discussion of the differences between the Arduino and
  Raspberry Pi and how they fit into the MBR Architecture.
categories:
  - electronics
---

### Arduino vs. Raspberry Pi in Control Systems

I believe the Arudino has better hardware support, a real-time clock
and due to itself simplicity creates a better platform to interact
with external hardware in real-time.

The Raspberry Pi, however has a much more powerful set of processors,
more memory and a general purpose operating system making it a more
suitable choice for general purpose, sophisticated software, such as
communicaitons and control software. 

#### Assume a Distributed System

Combining the Raspberry Pi and Arduino, or similar SoC / MCU's, like
for example the NVIDIA Nano with an esp32 wifi module can make for
some very flexible and powerful designs.

Of course that does come with a bit of a cost, in communication and
messaging, which means such a sophisticated system needs to be
designed with care.


