---
title: RF Joystick Controllor 
description: >
  This project adds a Joystick to the controlls for MobileRobot. The
  first version is simple, and Arduino Nano, with a cheap joystick and
  an nRF24L01 RF transciever.
date: 2019-04-26
image: https://mobilerobot.sfo2.cdn.digitaloceanspaces.com/tank-green-blue.png
draft: true
categories:
  - hardware
  - arduino
tags: 
  - joystick
  - nrf24l
  - arduino
  - nano
---

This was a simple but very cool project.  Setup an Arduino Nano with a
Joystick inputs with an RF output back to a control station (or the
vehicle if control software resides on vehical).

## Requirements

Develop a wireless Remote Control capable of controlling (i.e. send
inputs to control software) able to control the vehicles motion. 

The Joystick must be able to communicate wirelessley. 

- RF - required and PoC is complete
- Wifi optional and desired
- Blue Tooth optional and desired

## Design

Our first cut at the Joystick is very simple.  A cheap Joystick from
an Arduino starter kit wich is fine for PoC probably not for realtime
action! 

### Joystick


> Todo ~ find a better joystick. A little research and we will find a
> lot of optiions.  Just need to select the correct type and price
> range for our needs

### Micro Controller

We are going to roll with an Arduino Nano, since I have a few of them
and they have plenty of the appropriate pins for this job.  

> Todo: have a table that tracks and compares various communication
> mechanisms. 

### RF Transceiver

This would be the [nRF24L01](notes/nrf24), a fantastic, inexpensive
and very popular chip!  We can have some fun with this, can't wait to
play with mesh networks.

## Hardware

### Block Diagram

> TODO ~ add a block diagram

### Schematics

> TODO ~ add the schematics


## Power

Mobility requires a battery.

> Must select a battery

### Caseing

hat can we use to house our Joystic and associated electronics?  It
must be mobile!

## Software 

> Todo include a link to the software repository.  

Provide a configuration variable to determine whether to send a stream
of data or changes only.

### Communications

The communication software will be abstracted away from the
underlying transmission mechanism.  That is, that communication
software that sends data from Joystick over RF, will not change if RF
is changed to Wifi, BlueTooth,  Serial / UART / USB or any other
mechanism. 

That is the communication layer will understand the [TLV and TLString
protocols](/projects/tlv), provide the application. 

### Arduino I/O

Arduino recieves inputs from the Joystick, those inputs can be sent in
one of two modes: polling or event driven.  Polling sends data every
_delta_ period, where event driven sends only changes.



