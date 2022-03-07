---
title: IoT Software Development Process
url: iot-project-sensor-station
date: 2020-09-06T10:32:26-07:00
description: IoT Software Project
---

![High Level Sensor Station](/img/iot-project-drawing.png)

## What is this project about?

This project code named _Organic Gardner (OG)_ is an automated
irrigation system intended to help my wife water her rather extensive
_succelent collection_ and our _edible garden_ which have some rather 
complex and diverse watering requirements.

_On Demand Irrigation (ODI)_ is a feature that uses soil's moisture
levels to control a network of pumps and sprinklers to ensure the 
different plants are watered just right.

The _Organic Gardner (OG)_ is conceptually pretty simple. It consists
of four primary components described below with a fith option if an
Internet connection is available.

1. The [_Collection Station (CS)_](/iot-sensor-station/collection-station)
   gathers environmental data from local sensors then _publishes_ that
   data as _MQTT topics_.

2. The [_Hub_](/iot-sensor-station/hub) gathers this data by
   _subscribing_ _MQTT data topics_. As the hub gathers and stores
   data it also feeds the data to the _sprinkler application_.

3. The _sprinkler application_ checks the moisture levels from the
   sensors to determine if a sprinkler needs to be turned on or off. 

   If the moisture levels are either too low or too high the
   _sprinkler application_ _publishes_ a _control
   command_ to turn the sprinkler on or off.

4. The _Control Station (CS)_ responds to commands from the _control
   channels_ by turning a relay (sprinkler) on or off according to the
   command it received.

5. The _Dashboard_ allows Humans to see the data collected by each
   station, control specific sprinklers and define schedules.

Pretty simple, right?

### Real World Diversity

This project is reflects _"real world"_ projects that it involves
different programming languages, protocols and technologies: _Go_,
C++, _JavaScript_, _HTTP_, _MQTT_, _Websockets_ and other stuff.

To avoid overwhelm and keep the project pointed forward and
interesting we will build the project by incrementally adding cool
features to our previous cool features.

Let's steal a term from lean startup.

## The Minimum Viable Product

Now that we have a pretty good idea of what we want to build we
need to plot our development plan.  We are going to attempt to build
this project in _milestones_ that each bring an interesting and
useful new feature to the project.

Here is the order in which we will out this project.

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

