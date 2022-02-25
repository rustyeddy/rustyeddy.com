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
tolerent_ they do not like to be over watered. Being in drought ridden
Southern California smart water usage is very important.

The way this _Irrigation System (IS)_ works is pretty simple: build a
_Collection Staiton (CS)_ to gather temperature and soil moisture
levels and publish that data to a _Hub_ that runs application logic
and determines based on moisure levels when to send messages to the
_Control Stations (CS)_ to turn water pumps on or off.

We also have a _Web Application_ that acts as a dashboard to monitor
and control the irrigation system.

And that is NOT ALL! We can also use the cloud for persistent storage
of historical data, and allow control of the system from anywhere in
the world with an Internet connection.

1. _CS_ Collect and publish environmental data
2. _Hub_ gather data and run _Application Logic (AL)_
3. _CS_ Control lights, sprinklers and heaters
4. _Dashboard_ Human monitor and control
5. _Cloud_ Perpetual Persistence and Global Access

Pretty simple, right?

### Process and Protocol Over Technology

I will not dive too deep into anyone of the technologies, but rather
document this project from an _architectural_, _design_ and
_software development process_ lens. 

We necessarily get into a few technical discussions, however we'll
supply plenty of references to quality tutorials and deep dives as we
breech various technologies.

Every part of this system could be built with a different technology
and process, that is not important, rather the importance is in the
process management and how the craft people work together.

#### Open Source 

This project uses _Open Source_ software _Open Protocols_ and all
freely available development systems. Somebody could easily come along
a build a _Microsoft C#_ CS just as easily as I can build the esp32
version. 

### Proof Of Concept (PoC)

This is a complex system with a three or four distinct software
components and some hardware. This also involves at least 3 if not
four or five different languages and development environments, just
like in the "real world".

We'll build this system one step at a time. The end goal is the
_irrigation application_, however we can still get something useful
from the software, before it is released if we build it wisely.

For example, in this project we'll use our _real time_ dashboard to
act like an _Internet Clock_ displaying real time temperature data
making the application a bit more useful every day.


## Milestone 1 - Aggregation Hub

The first step is to get the Hub to subscribe to MQTT data channels, 
then start recieving and _caching_ that data in RAM.

Now that the Hub has data stashed in memory, we will build a _REST
API_ to access the data. We'll also consider _GraphQL_ as a possible
architectural choice.

The Hub is a _Micro Service_ written in Go.

## Milestone 2 - Dashboard

Now that we have the Hub collecting data and that data is available
via the _REST API_ we'll build a Dashboard Web application to display
the collected data.

The _Dashboard_ will query the historic data via
the REST API and display that data in graph and table form.

The _Dashboard_ is a _Responsive Web Application_ written with Vue.

## Milestone 3 - Real Time Datashboard

We are going to add _Websockets_ to Hub and the Webapp allowing the
former to send data to the later in _real time_ allowing the dashboard
to display data as it arrives immediately.

The _Dashboard_ and _Hub_ need to be updated to support _Websockets_
involve adding a _Websocket Library_ for both  _JavaScript_ and _Go_.

## Milestone 4 - Collection Station

The _third milestone_ we are going to build the _Collection Station_
to gather temperature and humidity. Eventually we'll add sensors for
humidity and light levels.

This component has physical hardware involved making this application
particularly interesting for me. This is what officially makes it an
_IoT Project_ :)

We'll build the _CS_ from an _esp32 devkit_ and a _DHT22_ sensor. This
is an _embedded_ _real-time_ application written in C++ using the
_esp-idf_ development kit and the Free Real Time Operating System
(_FreeRTOS_). 

## Milestone 5 - Time Series Database

Data that has been collected over a long period of time can be saved
locally or in the cloud. In our case, the data we have collected is
known as a _time series_. 

The data can be saved in many different formats or databases. SQL or
MongoDB are choices, however we will go with a _Time Series DB_ built
just for applications such as these. 

The two databases in consideration will be _prometheus_ and
_influxDB_ both fast and purpose built specifically _time-series_
databases.  

## Milestone 6 - Fleet Management

As time goes on and the application evolves according to operation
experience and demand, features will be added and software will be
changed. This often leads to disruptive or difficult software upgrade
events. 

We are going to strive to managing all of our software update process
with total automation using modern _CI/CD_ techniques and
_Over-The-Air_ software updates. If we can hit this goal _and all goes
well_ we will be able to seamlessly roll out software with very little
human interaction.
