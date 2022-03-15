---
title: The Organic Gardener Anatomy of IoT Software
url: iot-project
date: 2020-09-06T10:32:26-07:00
description: >
  For this project I will design and develop the software for an 
  automated garden irrigation system. We will use the soil moisture
  levels to control the sprinklers and the Internet to provide global
  access to our application. If you are interested how IoT software is
  built, this site the place for you! 
---

![High Level Sensor Station](/img/iot-project-drawing.png)


## What is this project about?

An IoT project usually involves taking a well known functional
device like a doorbell (Ring) or Heater (Nest) and adding some
"smart" software with an Internet connection to access a whole new
world of capabilties. 

This project code named _Organic Gardner (OG)_ was created to be an
automated irrigation system intended to help my wife water her rather
extensive _succelent collection_. It will also be in charge of
watering our _edible garden_ just right. This application has some
some rather complex and diverse watering requirements. 

### On Demand Irrigation and Lighting Controls

_On Demand Irrigation (ODI)_ is a feature that uses the soil's
moisture levels to control a network of sprinklers ensuring various
segments of the garden, aka micro-ecosystems are watered just right.
_Lighting Controls_ can be scheduled either by lumesence levels more
about that later.

## Diverse Project Technologies 

This project reflects _"real world"_ projects that involve
different programming languages, protocols and technologies: _Go_,
C++, _JavaScript_, _HTTP_, _MQTT_, _Websockets_ and other stuff.

When working on larger projects it is quite common for a single
programmer to work on a very small and focused piece of code. Smaller
projects on the other hand often require programmers to switch
langagues and development environments often, for example jumping back
and forth between backend and front end typically involves a couple
programming langauges, HTML, CSS and SQL are common.

For this reason, we are going to use a variety of programming
languages and communication protocols to build a complete non-trivial
system.

## The Minimum Viable Product

To avoid being overwhelmed and keep the project pointed forward and
interesting we will build the project by incrementally adding cool
features to our previous cool features.

Let's steal a term from the [Lean Startup](http://leanstartup.com)
**MVP**. 

Now that we have a pretty good idea of what we want to build we
need to plot our development plan.  We are going to attempt to build
this project in _milestones_ that each bring an interesting and
useful new feature to the project.

Here is the order in which we will build out this project.

#### *Milestone 1 - Collect MQTT Data*

The first Milestone we begin developing the _IoT Hub_ to listen to
MQTT data messages and cache the data in RAM. To provide access to the
cached data we are going to add a _REST API_ using Go's builting HTTP
server. 

1. Hub to subscribe to Websockets
2. Hub provides a REST API
   
#### *Milestone 2 - Dashboard*

The next milestone is our _Web App_ or _Dashboard_ written with Vue as
a _Mobile First_ responsive web page. The _Dashboard_ will be able to
display a list of _Collection Stations_ it has learned about, as well
as a list of sensors and the respective data for each sensor connected
to the _Collection / Control Station_.

1. Build SPA with Vue for Dashboard
2. Serve HTML pages from Hub with built in HTTP server


#### *Milestone 3 - Real Time Datashboard*

The third phase of the project we add _Websockets_ to the _Hub_ and
_Dashboard_ allowing the Hub to stream real-time sensor data to the
Dashboard. The Dashboard will display the latest data as it arrives.

1. Websocket library for Hub in Go
2. Websocket library for Vue in JavaScript

#### *Milestone 4 - Collection Station*

This is the most interesting part of the project for me. We are going
to build and _embedded_ IoT device with the _esp32_ micro controller
and connected sensors. This development is C++ and the FreeRTOS (Real
Time Operating System) as provided by the 
[esp-idf](https://github.com/espressif/esp-idf) development kit.

1. esp-idf to collect sensor data C++
2. esp-idf to connect to Wifi
3. esp-idf transmits MQTT data to IoT broker.

#### *Milestone 5 - The Cloud* 
    
The final milestone we have recorded here is introduced when an
_Internet_ connection is available. The _Cloud_ gives the application
a whole new set of capabilities, including but not limited to

1. Global Access - Access the application from anywhere in the world
2. Data storage and persistence
3. Fleet management - monitor, update and control all the devices in
   your sensor network .

## OG Software Components
