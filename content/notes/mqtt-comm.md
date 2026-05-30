---
title: MQTT For Controllor Communication
description: >
  MQTT is a messaging protocol commonly reffered to as Publish/Subscribe or is an popular solution to distributed system
  communications, where you do not want to directly couple the
  publisher and subscribers.  That is a fundamental design of this MBR
  project. 
date: 2019-05-03
image: https://mobilerobot.sfo2.cdn.digitaloceanspaces.com/software-block.png
categories:
  - software
  - communications
tags:
  - mqtt
  - mosquitto
---

The MQTT message bus is a simple but critical element of our MBR
software design.  MQTT provides what is known as a _publish/suscribe_
or _pubsub_ communications model.  This model of machine to machine
communication has some attractive benefits for realtime driving
algorithms that we will discuss in this post.
<!--more-->

## Pubsub message bus and realtime communications 

The pubsub communication model boasts some properties that are
attractive to _a real time_ application.  Specifically, messages can
be sent and delivered efficiently with little delay, provided none of
the resources are over burdened.

## Decoupling the Controller from Control Object

Traditionally, the software, and most likely the hardware intrinsicly
ties a particular device with a specific controller.  For example, a
Joystick or Keyboard.  Replacing, say the keyboard with Joystick
control requires new  software to be added to the controlled item, as
well as created for the controller.

It also opens up opportunity for logging, learning, testing and
replays! 


Keyboards, programs or canned messages can be formed to sned the same
communication. 

### Talk to The Bus

All entities talk to the bus, and read from the bus.  No two
components speak directly to one another.  This allows an incredible
amount of flexibility, but it does add a level of abstraction and
compexity. 

#### Publishers

Adding a message bus requires us to adjust from a tight, 
input -> output coupling to a _decoupled_ intention based messaging
system. 

For example, a Joystick can publish rapid stick movement /
positioning informaiton to an MQTT bus such that _subscribers_ like
the _Control software_, a logger or debugger as well.

A temprature sensor may send out periodic temprature. Distance, light,
heat and other sensor can periodical advertise to appropriate
channels. 



## Funcation Call, REST vs. Pub/Sub

such as Routing Protocols, Web/REST servers, RealTime sockets,
Real-time Websockets, real time messaging.


### MBR and the Pubsub Commuication Model

For our application, we will be controlling a set of DC motors through
a micro-controller (i.e. Arduino with shield) attached via some
serial/RF/BT/??? mechanism.




For this project we will focus on the MQTT protocol and we will
specifically use _Mosquitto_ the MQTT broker.

useful for many types of computer communication,
including _real time_ control software, like we use to drive our
mobile vehicle.  This article will go into detail on our controll
system software and the various components required to make it happen! 


The MQTT message server a general purpose as a systems message bus our
project components can use to read and write data in near realtime.
This data is used for a number of purposes, to advertise changes to
control inputs and sensors, publish control messages to motor
controllors and by the dashboard to display our realtime sensor
data. This describes how our MQTT bus is being used and how we got it
all hooked up!


## MQTT Bus Uses

- Advertise Joystick inputs for vehicle control
- Advertise Sensor readings for sensor networks
- Consume vehical controls by the motor controllers
- Consume all sorts of data for the Dashboard and realtime graphs

## Architecture

Mosquitto MQTT Broker is running on a system wide Raspberry Pi. All
sensor and control inputs are written to the appropriate topics on the
MQTT bus.

In the future we'll want to run an MQTT bus on vehical incase we
loose contact with our control station.

## MQTT Channels

- sensors/<sensor>/data
- motor/<cmd>/data...
- errors
- warnings

 