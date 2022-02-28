---
title: IoT Project Data Aggregation Hub
date: 2022-01-13
description: >
  The IoT Hub gathers the environmental data published by our
  Collection Stations then uses that data to determine when to turn on
  and off a sprinkler systems and send data to the dashboard for human
  consumption. 
weight: 20
repo: https://github.com/sensorstation/sensors
---

## What Does IoT Hub Do?

For the _1st Milestone_ The IoT Hub has been developed to collect
temperature and humidity data from sensors connected to a wireless
network. The _Hub_ will cache the data in memory and provide a REST
API for access to the data it has stored.

Since the Hub already supports HTTP for the REST API, it will be used
to serve up the dashboard as a _Single Page App (SPA)_. The Dashboard
will be used to observe realtime and historical data, as well as
control the irrigation and lighting systems.

In a later phase the _IoT Hub_ will be programmed to cache limited
historic data in memory and persist data to a permenant resting
place. We'll discuss data and storage in much greater detail a bit
later in this adventure.

### How Does IoT Hub Work?

The IoT Hub uses the well known and supported [MQTT](https://mqtt.org)
light weight messaging protocol to gather data published by a network of
Collection Stations 

The _MQTT topics_ have been structured such that the Hub can gather
the Collection Station IP addresses, sensor type, sensor value and a
timestamp for when the data was fetched.

Here are a couple examples of example MQTT topics:

```
- ss/data/10.13.2.2/tepmc
- ss/data/10.13.2.2/humidity
```

The structure of these _topics_ have a specific structure that will
allow the _IoTHub_ to quickly parse the messages into an _efficient
internal_ structure called a <code>_Msg_</code> that contains these
four pieces of information:

- Station ID probably in the form of an IP or MAC address
- Sensor data name such as: temprature, humidiy, air-pressure, etc
- Value this will either be an integer or a float64
- Timestamp when the data was sampled.

### An Example 

For example an IoT station with the ID _10.11.2.19_ will start
_publishing_ temprature data via MQTT on the following path
```/ss/data/10.11.2.19/tempf```. The rate the data is published can be 
changed via a configuration knob. The MQTT _broker_ will ensure that
data gets to _all subscribers_ of that topic reliably.

The IoT hub is one of the subscribers to the CS data.

The first milestone includes temperature and humidy data channels
(topics). For example, we might have two stations
_s1_ and _s2_ that published fahernheit and a percentage
for temprature and humidity respectively.

You might see something like this:

>
> - /ss/data/s1/tempf: 75.5
> - /ss/data/s1/humidity: 12.5
> - /ss/data/s2/tempf: 87.7
> - /ss/data/s2/humidity: 10.2
>

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

This is a _normalized_ and _complete_ representation of a single data
_value_ at a specific _time_ indexed with the respective _station_ and
_sensor_. 

This format can be converted in any alternative format required quite
easily and be transported through the system with little overhead. For
example, most operations with 32bits of accuracy can be efficienty
stored in a _small_ _fixed size_ datastructre.

With an IP address of 32bits, most messages can be stored in two 64bit
integers! The standard unix timestamp <code>time_t</code> is a 32bit
int that has better than one second of accuracy.

```go
type Msg struct {
    Station int32
    Sensor  int32
    Value   int32
    Time    int32
}
```

## Data Consumers and Go Channels

Every subscriber has a _list of Consumers_ were _Consumers_ actually
consume the data the MQTT channels produce. The tricky part here is
that we may have more than one consumer of the data.

For example, we have the following consumers:

- Memory consumer saving new data into historic structures
- Web Socket real-time data publisher

### Consumer Requirements

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

IoT Hub provides a REST API allowing other programs to access datasets
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
