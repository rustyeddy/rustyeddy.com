---
title: IoT Software Development Process
url: iot-project-sensor-station
date: 2020-09-06T10:32:26-07:00
description: IoT Software Project
---

![High Level Sensor Station](/img/iot-project-drawing.png)

## What is this project about?

This project code name _Organic Gardner (OG)_ is an automated
irrigation system intended to help people with moderate sized
gardens manage semi complex watering schedules.

_On Demand Irrigation (ODI)_ is a feature that uses soil's
moisture level to control the sprinkler system and hence watering
schedules as an alternative to scheduling sprinkler based on time of
day and length of time the water runs.

_Organic Gardner (OG)_ is conceptually pretty simple. It consists
four primary components described below. There is a fith _cloud_
option wit an Internet connection.

1. The _Collection Station (CS)_ gathers environmental data from
   sensors then _publishes_ the data as _MQTT topics_.

2. The _Hub_ gathers this data by _subscribing_ to the same _MQTT
   Topics_. As the hub gathers and stores the data, it also feeds the
   data to the _sprinkler application_. 

3. The _sprinkler application_ uses moisture levels to send commands
   to The turn sprinkers on and off.
   
4. The _Control Station (CS)_ is connected to relays (switches)
   connected to sprinklers and lights. The _Control Station_ will
   switch the relays when it recieves commands from the _sprinkler
   app_.

5. The _Dashboard_ is used by Humans to control, program and monitor
   the _irrigation application_. The dashboard will provide access to
   historical and real time data streams, program lighting schedules
   and more.

Pretty simple, right?

This project is reflects _"real world"_ projects that it involves
different programming languages, protocols and technologies: _Go_,
C++, _JavaScript_, _HTTP_, _MQTT_, _Websockets_ and other stuff.

To avoid overwhelm and keep the project pointed forward and
interesting we will build the project by incrementally adding cool
features to our previous cool features.

Let's steal a term from lean startup.

## The Minimum Viable Product

Now that we have a pretty good idea of what we want to build we now
need to plot our development plan.  We are going to attempt to build
this system according to _milestones_ that bring an interesting and
useful feature to the project.

1. *Milestone 1 - Aggregation Hub* collect data published to MQTT
   topics and cache data in memory with a REST API
   
2. *Milestone 2 - Dashboard* a modern Responsive Webapp displaying
   historical sensor data from historical REST API.

3. *Milestone 3 - Real Time Datashboard* webapp enhanced to display
   _real-time_ datastream via Websockets.

4. *Milestone 4 - Collection Station* esp32 microcontroller with a
   DHT22 temperature and humidity sensor. The chips is capable of
   publishing data via MQTT with a standard Wifi connection.
   
5. *Milestone 5 - Persistance* A Time Series Database will house the
   data collected by the Hub. Introduce Influx or Promethus as the
   data store

6. *Milestone 6 - Fleet Management* As time goes on the application
   will change and need to be upgraded and monitored. The FM component
   makes sure all items are alive and running the latest software.

## The Software Components In Depth

