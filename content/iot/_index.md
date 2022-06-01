---
title: How to Build a Self Watering Garden
date: 2022-05-25
description: >
  This article describes an automated irrigation 
  system for home gardens and small farms. It uses soil moisture
  levels and other telemetry data to drive watering schedules vs
  traditional time based scheduling. It is easy to program and Open
  Source.
category: iot
---

![Garden Diagram](/img/self-watering-garden.png)

-----

## Why Build this Thing

Typical small irrigation systems today are based on time schedules
where sections of the garden (zones) are watered based on days of the
week, a start time and a duration.  In otherwords your garden is
watered at the same times every couple days or so for the same
duration.

That means the schedule needs to be increased during long hot dry
days, and reduced as the days shorten and get colder. If it rains, you
probably need to turn it off altogether and remember to turn it on
again when it stops raining.

### Water Levels not Time

The _Organic Gardner (OG)_ waters your garden when the the ground is
too dry and stops watering it when the ground has reached the right
moisture level.

During a heat waves plants may need to be watered more frequently,
however when it rains they probably shouldn't be watered at all.

### Plants Get the Perfect Amount of Water

Different plants require a different amount of water, for example
Roses require quite a bit of water to produce beautiful healthy
flowers, however that same amount of water will destroy most varieties
of succulents.

Plants that produce food also require specific amounts of water, for
example peppers and watermelon would not survive or flourish if given
the same amount of water.

Control stations can be configured to start and stop watering
according to the amount of water a given type of plant requires.

### OG Conserve's Precious Water

Water is precious and life giving. In many parts of the world
including the South Western US and Southern California where I am from
are in a decade long drought with water levels at all-time lows.

#### Shamefully water is being wasted everyday

Despite the well known fact that we are having a water crises over
watering is the norm, watering in the middle of a hot summer day with
loads of water running down the sidewalk happens regularly. Even our
City manages to waste a lot of water on sidewalks and blacktop.

## How Does Organic Gardner Work?

The primary goal of _Organic Gardner_ is to build a smart irrigation
system that will provide watering zones with _the_ perfect amount of
water based on _the_ plant or crop being watered and not a drop extra.  

### The Collection Station

Soil Moisture and other telemetry (temperature, humidity, light
levels) are collected by a collection station diagrammed below. The
moisture sensor is placed in the soil near the plant(s) that need to
be watered.

![Collection Station](/img/collection-station.png)


The [_collector_](https://github.com/rustyeddy/ogesp) gathers and
publishes the moisture level periodically over a wireless network such
that a _subscriber_ such as the
[_smart hub_](https://rustyeddy.com/iot/iote) 
will read and process the data to determine when to send a _start
water_ command to the correct zone.

### The Smart Hub

The _IoTe Smart Hub_ also known as the IoTe gateway is the "brains" of
the system. IoTe gathers moisture data from the _collectors_ then uses
that data to determines when specific zones need to be watered. IoTe
sends the appropriate zone _controller_ the command to _start_
or _stop_ watering as appropriate.. 

IoTe also manages the storage of the data as well as driving the
_Dashboard_ that we will speak more about below.

### The Control Station

The control station is connected to a relay that controls a sprinkler
or drip system that can be turned on or off automatically according to
it's configuration.

The _control station_ may optionally connected to other accessories
such as a lighting or heating systems.

![Control Station](/img/control-station.png)

As the plant is being watered moisture levels are transmitted back to
the Hub when the soil has hit the appropriate moisture level the
_Smart Hub_ will send a control message back to the _controller_ to
stop the watering.

### The Dashboard

The Hub has a built in Dashboard that can be accessed from any browser
(Chrome, Firefox, Safari, etc) with screens that allow a user to
observe the telemetry data from the _collection stations_, manually
activate relays and configure thresholds that determine when
sprinklers, lights and heaters are activated and de-activated.

> Todo a Screenshot of the Dashboard

Essentially the dashboard gives humans the ability to monitor,
configure and control the irrigation system.

### The Cloud

No IoT project would be complete without adding the Cloud to the
project (the 'I' in IoT). The IoTe (hub) can be connected to the
Internet if it's available providing users access to the
Dashboard from anywhere in the world as long as they have an Internet
Connection. 

Your garden can be monitored, controlled and configured from anywhere
in the world from your phone!

> Todo Picture of a Phone and Dashboard

The cloud connection can also provide historical references to all
telemetry data and plugged into a _Machine Learning (ML)_ framework if
desired.  We will talk a bit more about _ML_ in a future article.

## The Project

As I mentioned earlier this project is a Proof Of Concept (PoC) with a
few distinct components that must all work together. These components
include, but are not limited to. 

- The _collection and control station_ these two components are
  actually the same piece of software.
  
- The smart Hub or _IoTe Gateway_

- The Dashboard which is served up by the _IoTe_ gateway

- The cloud which is actually a version of the IoTe gateway
  probably should call it IoTc?
  
If you are interested in this project either as a user or a developer
I encourage you to follow along or better yet get involved!

If you are a technical person either hardware or software and want to
contribute to building hardware devices or help out with software in a
meaningful and interesting Open Source project, please drop me a note!

