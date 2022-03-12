---
title: Iot Data Aggregation Hub
date: 2022-01-13
description: >
  The IoT Hub is the center piece of the OG system it aggregates
  environmental measurements from MQTT data channels, provides an HTTP 
  server for the REST API and serves up the responsive Dashboard
  Webapp. The Hub is also responsible for running the application
  logic and ensuring data is archived as required. This page we
  discuss how the Hub is constructed as a MicroService.
weight: 20
---

## What Does OG Hub Do?

In a nutshell the _OG Hub_ gathers data from MQTT then makes that data
available to programs and humans via a REST API and Dashboard
served from a builtin HTTP server.  You can call this tiny, fast
program a [_Micro-Service_](https://en.wikipedia.org/wiki/Microservices).

> As matter of fact, it is so small and fast, it is more than happy to
> run on a _Raspberry Pi_!

The _1st Milestone_ of the 
[_Organic Gardener IoT Project_](/iot-project-organic-gardener)
is complete. The list of supported features are:

1. Collect environmental Data via MQTT and save in RAM
3. HTTP server to provide a REST API
4. HTTP server to serve the [Dashboard](/iot-project-organic-gardener/dashboard) webapp
4. HTTP server enhanced with Websockets to stream data live

In a future phase of the project we will add the option of saving
the data in a persistent Data Store (DS) such as a Time Series
database. It will be a future task to select a database or databases
the program will be able to use.

### How Does Hub Work?

The Hub uses the well known and supported [MQTT](https://mqtt.org)
light weight messaging protocol to gather data published by a network of
[Collection Stations](/iot-project-ogranic-gardener/collection-station)
MQTT uses the [Pub/Sub](https://en.wikipedia.org/wiki/Publish%E2%80%93subscribe_pattern)
Messaging Model. 

Publishers send data to _Topics_ while subscribers subscribe to the
topic and subsequently recieve the corresponding data.  For example a
_CS_ with the ID 10.11.11.22 will publish the current temperature in
fahrenheit with this _topic_.

```
ss/data/10.11.11.2/tempf
```

In this _10.11.11.22_ is the StationID and and _tempf_ is the
SensorID. 

> **TODO** Write MQTT briefing

#### MQTT Wildcard Subscriptions

MQTT supports wildcard subscriptions allowing the Hub to subscribe to
_ALL_ _data channels_ even without knowing the stationID's or
sensorIDs before hand.

By subscribing to ```/ss/data/+/+``` the Hub will recieve data from
every station and sensor on the network. 

When data _periodically_ arrives, the Hub will quickly extract
the following elements of the data point.

- **Station ID** probably in the form of an IP or MAC address
- **Sensor data** name such as: temprature, humidiy, air-pressure, etc
- **Value** this will either be an integer or a float64
- **Timestamp** when the data was sampled.

The data is reformatted and stored efficiently in RAM. Let's have a
look at what happens after data is accepted and parsed by the Hub.

## In Memory Data Model

A light weight and efficient message is created from a
combination of the _StationID_ and _SensorID_ elements of the MQTT
topic. Combined with the _Value_ and _Timestamp_ we are able to
construct the following _Message_:

```go
type Msg struct {
    Station string
    Sensor  string
    Value   float64
    time.Time
}
```

This is a _normalized_ and _complete_ representation of a single _data
point_ at a specific _time_ indexed by the respective _station_ and
_sensor_. 

## Data Consumers and Concurrency

Every subscriber has a _list of Consumers_ where the _Consumer_
actually reads the incoming data and applies some _applicaiton logic_
to that data. For example, soil moisture level of 10% might cause the
consumer to send _on_ command to the sprinkler responsible for
watering that soil.

The tricky part is supporting more than one consumer of this data
stream. For example, we almost always have the in memory cache
running reading incoming data then giving it a time stamp and indexing
for API reference.

Additionally, every dashboard user will require a copy of the current
data in real-time over a websocket.  At any given time, there may be 0
1 or more consumers.

### Consumer Interface

```go
type Consumer interface {
    GetID()     string
    GetRecvQ()  chan Msg
    Listen()
}
```

Where _GetID()_ helps identify exactly what consumer we
have. _RecvQ()_ will produce a ```chan Msg``` that will deliver data
_Msgs'_ to a loop in the _Listen()_ function.

### Consumers will come and Go

Due to the fact that _Web sockets_ are built on TCP/IP a client is
required to transmit data. At times there may be _no consumers_, at
other times there maybe two or more.

In the event of no consumers for the data, the hub must be prepared to
quickly discard the data. 

Most likely the _memory_ consumer will always be listening to incoming
data, reformatting it to the indexed version of the data for easy
station recovery. If so, the hub will most likely always have at least
one consumer for the data.

## Websocket Consumers

Websocket consumers on the other hand will come and go. A new connection
will establish a _websocket_ connection via TCP/IP to recieve data for
the duration of that conneciton. 

When the _websocket_ connection is closed or dropped, the websocket
_Consumer_  will be removed from the _Data Subscription_. 

#### Multiple Websocket Client

It is quite possible for more than one connection to be established
from different clients. We would like to permit at least _Read only_
copies of the data over the websocket connection.

## Volatile Memory Storage

The data as it is gathered is converted into different in memory
structures index first on the Station and then by a Sensor, where each
sensor has a _time series_ (stream of values and successive times).

At anytime an active hub will have an in memory representation of the
timeseires data that abstractly looks like:

```yaml
- station1
  - tempf: {t1, v1}, {t2, v2} .. {tn, vn}
  - humidity: {t1, v1}, {t2, v2} .. {tn, vn}
- station2
  - tempf: {t1, v1}, {t2, v2} .. {tn, vn}
  - humidity: {t1, v1}, {t2, v2} .. {tn, vn} 
```

## Global API

The Hub provides a REST API allowing other programs to access datasets
from the Hub for various applications. Some of the important REST API
_endpoints_ are:

- GET       /stations
- GET       /station/{stationid}
- GET       /data?stationid={stid}&sensor={sens}&start={start}&end={end}
- DELETE    /data?stationid={stid}&sensor={sens}&start={start}&end={end}

The first two gather and reply with _IoT Collection Station_ meta
data, such as the station ID, sensors hosted and performance
and metrics.

The ```/data ``` endpoint will return data ;-), filters can be used to
limit the response to certain _stations_, _sensors_ and / timespans.

### Go and Micro Services

The programming language _Go_ was is a perfect fit for micro-services!
Very fast, small syntax and lot's of built in system level support for
protocols, marshaling, data structures and concurrant programming
support allow us to build a nice compact little IoT server.

We will get into the structure of the Micro-services and how Go helps
us build robust, fast and stable system you expect from _"Industrial
Strength"_ software written with C/C++ or Java.

If you are not familiar with go and write backend services, system
tools, distributed control systems or command utilities the _Hub_ is a
great place to start!

## Web Server / Webapp

The hub is also capable of serving up a webapp providing human
consumption for gathered data. This modern _mobile first_ web app is
discussed at length on this page [dashboard](/iot-project-sensor-station/dashboard)

> Todo: put a nice pic with a link to the webapp.

## Persistence Local and Global

We will save data for future use, the _nerdy_ sounding term for this
is _persitence_ other people may say _store_ or _save_ data. 

The data is typically stored in memory, that memory or the live
incoming data can be _persisted_ _locally_ or in the cloud.

Write data from memory to file storage. For this we will use the
JSON formatted files written to local disk, if we have one.

Write data periodically to the Cloud for global accessl.

### Storage Strategy

- How much / long to keep data in memory
- How much / long to keep data on disk
- How long to keep data in cloud

Need to have a data persistence strategy.

## Next Steps

Where to now? 
