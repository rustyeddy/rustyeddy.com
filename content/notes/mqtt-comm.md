---
title: MQTT For Controllor Communication
description: >
  Publish/Subscribe is an popular solution to distributed system
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

[Todo] put a link here to a page that compares communication models:
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

## TODO

- draw an image of the MQTT communication
- document the MQTT installation process for broker
- document otto mqtt client to output process
- show some code examples.

---

date: 2019-03-04
description: >
  This project has use create a micro service that provides access to the
  Raspberry Pi Camera and Adafruit Motor Controller.  So I built a
  service that can be controlled via Web App, REST API or MQTT message
  bus. 
categories:
  - software
  - micro service
tags:
  - picamera
  - pi camera
  - camera
  - motorkit
todo: 
  - images
  - video
  - block diagrams
  - link to github report
image: https://mobilerobot.sfo2.cdn.digitaloceanspaces.com/display-and-motors.jpg
resources:
  github: http://github.com/mobilerobot-io/rpid
---
MQTT works with three components: data _publisher_, _subscriber_ and
a _broker_. This model is commonly refered to as the _pub/sub_ model.

The Collection Stations (CS) _publish_ data to the MQTT _broker_. The 
broker then forwards the data to all of the subscribers, which
includes the _IoT Hub_. 

#### MQTT Topics

MQTT uses topics are simply strings that have a syntax very similar to
a _filesystem path_ used by a computers operating system. The elements
that make up a topic are sepearated by the '/' characture. The words
between the slashes give the topic structure and semantics.

MQTT clients can use _wildcards_ when subscribing to topics allowing
the subscriber to recieve data from multiple unknown publishers. 

This application provides access and control to various Raspberry
devices like the camera, GPIO pins, or a possible MotorShield if
needed. 
<!--more-->

Access is provided via a Webapp and REST API thanks to
[Flask](http://getflask.org/todo).  Control can also be done by
sending the appropriate messages to specific MQTT message buses. 

## Optional Motorsheild

I built a Raspberry Pi mobile robot [r3] with just a Raspberry Pi and
the [Adafruit RPi MotorController](http://todo/url), if the
MotorController is present the corresponding Adafruit _motor_
controller library will be installed and used.

If the Motorshield is not present, the motorcontroller library will
not be loaded, or a Fake (do nothing) library will be loaded on
devices that do not including the Adafruit MC, which includes
non-Raspberry Pi platforms.

> TODO: put a link to installing the Motorshield library, and a quick
> cheat.

### Motors and Skid Steering

The 'motors' provides the library ```Skidder``` that provides a _Skid
Steering_ steering control, that uses the Adafruit MotorKit library to
control the _throttles_ of the motors being used.

> For a brief overview of [Skid Steering refer to this article](/notes/skid-steering)

That article will describe this project within the bigger Mobile Robot
Architecture (MRA). 

### Pi Cameras and Video Control

Another big hunk of the device server is controlling the Video
camera.  We have the ability to start and start recording video, or
take snapshots.

The videos and images can be transfered to a remote host if a network
is available, they can be saved on vehicle if no network is available
until one is.

The camera is also able to _stream_ video over a network, if present,
for _real time_ consumption of the video as it is being filmed.

#### Video is Consumed by Humans and Computers

The video is made accessible to Humans for and Computers alike by
multicasting the video over an IP network with an IP multicast
address.

> Read more about [IP Multicast here](/notes/ip-multicast)

Refer to the PiCamera documentation here:
https://picamera.readthedocs.io/en/release-1.13/. 

The software can be found in [github
repository](http://github.com/mobilerobot-io/rpid). 

And how to write and operate a flask based server for your project. 

## TODO ~ Turn streaming On and Off

The next task is to turn video streaming On and Off, this may require
duping and modifying somewhat a python script ...

