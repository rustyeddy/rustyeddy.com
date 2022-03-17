---
title: A Guide to Developing IoT Software
url: iot-project
date: 2020-09-06T10:32:26-07:00
description: >
  This site documents the technical challenges and design decisions I
  used while developing the Organic Gardner IoT product, a self
  watering garden. If you are interested in developing IoT software or
  adding software to one of your projects you are in the right
  place. Join the NewsLetter below and say Hi!
---

![High Level Sensor Station](/img/iot-project-drawing.png)

## What is this project about?

Code named _Organic Gardner (OG)_ this automated irrigation system
will use soil moisture levels from inexpensive sensors to control 
sprinklers that water plants.  My wife will volunteer her rather
extensive _succulent collection_ as a test bed for this project!
She doesn't know this yet. 

An IoT project usually involves taking a well known functional device
like a doorbell (Ring) or Heater (Nest) and adding some "smart"
software with an Internet connection to develop a whole new world of
features. This is also true of our project.

While we are focusing on irrigation and gardens, the same framework
built to support OG can be leveraged to develop many different type of
IoT project. 

### On Demand Irrigation and Lighting Controls

The main application is what i call _On Demand Irrigation (ODI)_ which
is a feature that uses soil's moisture levels to control a network of
sprinklers ensuring every micro-section of the garden is optimally
watered. 

Lighting can be controlled by light levels or programmed with a
traditional time based scheduler, all according to application
requirements. 

## The Development Plan

To avoid being overwhelmed with details and keep the project moving
forward we will build it out incrementally, one interesting feature at
a time, stacking cool feature on top of cool feature. Testing will be
performed initially by _mocking_ MQTT publishers with the
```mosquitto_pub``` command line tool. 

Let's steal the term from [Lean Startup](http://leanstartup.com) and
define our **MVP** by etching out the details of our developmental
_milestones_. 

### Milestones

The milestones are structured such that completeing each milestone
incrementally adds useful features to the application until we
progressively iterate toward the completed gardening MVP. 

{{< milestone 1 "Hub Subscribes to MQTT and Serves HTTP " >}}
This first Milestone has three major components and requires two
libraries all written in the Go programming langauge. The successful
completion of this milestone has the hub subscribing to MQTT data,
caching the data in RAM and providing a REST API to access that data.
{{< /milestone >}}

   
{{< milestone 2 "Dashboard Displays Historic Data " >}} 
The next milestone is our responsive Single Page App (SPA) written
with the Vue JavaScript framework. The SPA will be served up by the
Hub's HTTP server. The Dashboard will display historic data retrieved
via the Hubs REST API.
{{< /milestone >}}

{{< milestone 3 "Dashboard Displays Real Time Data" >}}
The third phase of the project we add Websockets to the Hub and
Dashboard allowing the Hub to stream real-time sensor data to the
Dashboard. The Dashboard will always display the latest data for every
sensor it displays as soon as the data arrives.
{{< /milestone >}}

{{< milestone 4 "Collection Station Transmits Data" >}}
This is the most interesting part of the project for me. We are going
to write some real-time embedded software for the esp32
micro-processor. It will use sensors, Wifi and MQTT to publish
actual sensor data to the subscriber hub.
{{< /milestone >}}

{{< milestone 5  "Introducing the Cloud" >}} 
The final frontier, at least for this set of milestones is global
connectivity via the cloud. An Internet connection will allow us to
provide global access, safe persistent storage and fleet management
software.
{{< /milestone >}}


## The Software Components

This project reflects _"real world"_ projects in that it involves a
variety of programming languages, protocols and technologies: _Go_,
C++, _JavaScript_, _HTTP_, _MQTT_, _Websockets_ and other stuff.

When working on larger projects it is quite common for a single
programmer to work on a very small and focused piece of code. Smaller
projects on the other hand often require programmers to switch
langagues and development environments often, for example jumping back
and forth between backend and front end typically involves a couple
programming langauges, HTML, CSS and SQL are common.

For this reason, we are going to use a variety of programming
languages and communication protocols to complete this non-trivial
IoT application.
