---
title: IoT Software Development Process
url: iot-project-sensor-station
date: 2020-09-06T10:32:26-07:00
description: IoT Software Project
---

![High Level Sensor Station](/img/iot-project-drawing.png)

## What Does this project do?

I started this project to help water our home garden. You see my wife
is really into _succulents_ and while these plants are _drought
tolerent_ they do not like to be over watered. Second, being in
drought ridden Southern California I want to be able to limit our
water usage to only what is necessary.

### 1. Collection Stations (CS)

The way this _Organic Gardner (OG)_ works is pretty simple: build a
_Collection Staiton (CS)_ that gathers temperature and soil moisture
levels from sensors stuck in the dirt then publish that data to the 
application running on the Hub.

### 2. IoT Hub and Applications

The _application_ on the the Hub determines if sprinklers need to be
turned on or off. Likewise, luminence levels will cause the
application to turn lighting systems on or off.

### 3. Control Station (CS)

When the application needs to turn a pump or light on or off the
application will send an MQTT message to the _Control Station (CS)_
connected to a relay acting as a pump or light switch.

### 4. Dashboard

The _Dashboard_ was written as a _Web Application_ for the _User
Interface (UI)_. This gives humans easy access to historical and
real-time sensor data.

### 5. Cloud - Persistance and Global Control

And that is NOT ALL! The cloud is used for storing historical data,
global _access_, _control_ and _management_ of one or more _sensor
networks_. 

### System Summary

In summary the IoT project is made of these distinct components. 

1. _CS_ Collect and publish environmental data
2. _Hub_ gather data and run _Application Logic (AL)_
3. _CS_ Control lights, sprinklers and heaters
4. _Dashboard_ Human monitor and control
5. _Cloud_ Perpetual Persistence and Global Access

Pretty simple, right?


## Phase 1 - The Minimum Viable Product

Now that we have a pretty good idea of what we want to build and how
it is going to work we now need to plot our development plan.

In the spirit of _Lean Startup_ and _Agile_ we are going to build this
project in phases that each provide progressive levels of usefulness.

### The Proof Of Concept (PoC)

This is a complex system with a three or four distinct software
components and some hardware. This also involves at least 3 if not
four or five different programing languages and development
environments, which is pretty much what we see in the "real world".

The objective is to build the software such that each new addition of
software adds a specific verifiable benefit to the _user_.

The idea is We'll build this system one step at a time. The end goal is the
_irrigation application_, however we can still get something useful
from the software before the complete irrigation system can be built.

For example, in this project we'll use our _real time_ dashboard to
act like an _Internet Clock_ displaying real time temperature data
making the application a bit more useful every day.

#### Milestone 1 - Aggregation Hub

The first step is to get the Hub to subscribe to MQTT data channels, 
then start recieving and _caching_ the data in RAM.

- Read MQTT publications and cache in memory
- REST API provides access to cached data

#### Milestone 2 - Dashboard

The Dashboard is a WebApp that uses the REST API of the Hub to fetch
and display historic sensor data in graph and table forms.

1. Responsive WebApp written
2. REST API Client to fetch data
3. Graph and table display of historic data

#### Milestone 3 - Real Time Datashboard

We are going to add _Websockets_ to the _Hub_ and the _Dashboard_
allowing the Hub to stream data to the Dashboard to display
_real-time_ data stream on the dashboard.

1. Add websocket support to Hub
2. Add websocket support to Dashboard

#### Milestone 4 - Collection Station

The data in Milestones 1 - 3 was _mocked_ by a MQTT publishing
client. The Collection Station is an esp32 SoC with a DHT22 sensor
that will collect _temperature_ and _humidity_. The esp32 will publish
that data over the appropriate MQTT data channel.

1. esp32 Wifi
2. DHT22 temperature and humidity sampling
3. MQTT publication of data

Now we are collecting, publishing and displaying real _environmental_ data!

#### Milestone 5 - Time Series Database

Data that has been collected over a long period of time can be saved
locally or in the cloud. In our case, the data we have collected is
known as a _time series_. 

1. Introduce Influx or Promethus to store data

#### Milestone 6 - Fleet Management

As time goes on and the application evolves according to operation
experience and demand, features will be added and software will be
changed. This often leads to disruptive or difficult software upgrade
events. 

1. Over The Air (OTA) Updates
2. Remote monitoring 
3. Remote control

## The Software Components

