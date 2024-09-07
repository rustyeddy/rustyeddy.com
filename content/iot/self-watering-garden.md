---
title: How to Build a Self Watering Garden
date: 2022-05-25
description: >
  This article describes an automated irrigation 
  system for home gardens and small farms. It uses soil moisture
  levels and other telemetry data to drive watering schedules vs
  traditional time based scheduals. This project is Open Source and
  easy to program.
category: iot
---

![Garden Diagram](/img/self-watering-garden.png)

-----

## Why Build this Thing

The typical small irrigation systems today are based on time schedules,
where sections of the garden (zones) are watered based on days of the
week, a start time and a duration. In otherwords, your garden is
watered according to a set schedule regardless of environmental
changes. 

In reality, the amount of water should be increased during long hot dry
days and decreased as the days shorten and get colder. For example,
if it rains you probably need to turn your sprinklers completely off
and remember to turn them on again when it stops raining.

### Water Levels not Time

The _Organic Gardner (OG)_ waters your garden when the the ground
becomes too dry for plant and stops watering it when the ground has
reached the right moisture level.

### Plants Get the Perfect Amount of Water

Different plants require a different amount of water, for example,
roses require quite a bit of water to produce beautiful healthy
flowers, but that same amount of water will destroy most varieties
of succulents.

Plants that produce food also require specific amounts of
water. Peppers and watermelon would not survive or flourish if they
are each given the same amount of water.

OG Control stations can be configured to start and stop watering
according to the amount of water a given type of plant requires.

### OG Conserve's Precious Water

In many parts of the world, including the South Western US and
Southern California where I live, are in a decade long drought with
water levels at all-time lows.

Saving water is a major goal of this project and one that
will hopefully help others convserve this scarce and precious
resource. 

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
publishes the soil moisture level periodically over a wireless network.
The [_smart hub_](https://rustyeddy.com/iot/iote) will then process
the data to determine when to send a _start water_ command to the
_control station_ in the respective watering zone. 

### The Smart Hub

The _Smart Hub_ also known as the IoTe gateway, is the "brains" of the
system. IoTe processes moisture data sent from _collection stations_
to determine when to send _start watering_ and _stop watering_
commands to the appropriate _control station_. 

### The Control Station

The control station is connected to a sprinkler or drip system that
can be turned on or off as a result of receiving the corresponding
message from IoTe.

The _control station_ may optionally be connected to other accessories
such as a lighting or heating systems.

![Control Station](/img/control-station.png)

As the plant is being watered, moisture levels are transmitted back to
the Hub when the soil has hit the appropriate moisture level. The
_Smart Hub_ will then send a control message back to the _controller_
to stop the watering.

### The Dashboard

The Hub has a built in Dashboard that can be accessed from any browser
(Chrome, Firefox, Safari, etc) with screens that allow a user to
observe the telemetry data from the _collection stations_. The
Dashboard also allows a user to manually activate sprinklers and
configure moisture thresholds that determine when
sprinklers are activated and de-activated.

> Todo a Screenshot of the Dashboard

Essentially the dashboard gives humans the ability to monitor,
configure and control the irrigation system.

### The Cloud

No IoT project would be complete without adding the Cloud to the
project (the 'I' in IoT). The IoTe (hub) can be connected to the
Internet when available, providing users access to the
Dashboard from anywhere in the world as long as they have an Internet
Connection. 

Your garden can be monitored, controlled and configured from your
phone anywhere in the world!

> Todo Picture of a Phone and Dashboard

The history of data collected in the cloud as well as watering times
can be plugged into a _Machine Learning (ML)_ or _Data Science_
framework if desired.  We will talk a bit more about _ML_ in a future
article.

## The Project

As I mentioned earlier this project is a Proof Of Concept (PoC) with a
few distinct components that must all work together. These components
include, but are not limited to: 

- The _collection and control station_. These two components are
  actually the same piece of software.
  
- The smart Hub or _IoTe Gateway_

- The Dashboard, which is served up by the _IoTe_ gateway

- The cloud component includes a version of the IoTe gateway and
  a _timeseries_ database

  
If you are interested in this project either as a user or a developer,
I encourage you to follow along or better yet drop me a line and get
involved! 

## About the Software Components



