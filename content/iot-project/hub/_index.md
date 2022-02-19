---
title: IoT Project Hub
date: 2022-01-13
description: >
  The Sensor Hub gathers data from all connected sensors, aggregates
  the data for real-time and historic display. The also gets your data
  to the cloud if you have the desire and an Internet connection.
weight: 20
repo: https://github.com/sensorstation/sensors
---

## About IoTHub

The _IoT Hub_ gathers data from a _network_ of sensors that publish
data at regular intervals. The _hub_ aggregates and sorts the data for
for access by clients. The hub will also push the data to the cloud if
desired.

The _IoT Hub_ comes equipped with a builtin WebApp for easy access to
real-time and historic station and sensor _time series_ data. 


### MQTT Delivers the Data

The Hub gathers data via the well known and supported
[MQTT](https://mqtt.org) light weight messaging protocol is an ideal
fit for IoT applications. 

The hub gathers data by _subscribing_ to MQTT _channels_ or _topics_
that each have data periodically _published_ by connected data
sources which typically are 
[battery powered wireless sensors](sensors/wireless-sensors).

The topics data sources _publish_ data to have the following format:

- /ss/data/{stationid}/tepmf
- /ss/data/{stationid}/humidity
- /ss/data/{stationid}/moisture

As you can see, the channels or _topics_ have a specific structure
allowing the _IoTHub_ to parse messages into an _internal_ structure
called a <code>_Msg_</code> that contains these four pieces of
information: 

- Station ID probably in the form of an IP or MAC address
- Sensor data name such as: temprature, humidiy, air-pressure, etc
- Value: this will either be an integer or a float64

### MQTT Example

For example an IoT station with the ID _1.1.2.1_ will start
_publishing_ temprature data via MQTT on the following path. The rate
the data is published is up to the application.  MQTT will just make
sure the data is reliably delivered to _all subscribers_, including
our IoTHub.

```bash
/ss/data/1.1.2.1/tempf
```

The actual _data_ transmitted via the MQTT channel is simply the
temperature in _farenhiet_. For example, if you have two stations
_station1_ and _station2_ that published fahernheit and a percentage
for temprature and humidity respectively.

You might see something like this:

>
> - /ss/data/station1/tempf: 75.5
> - /ss/data/station1/humidity: 12.5
> - /ss/data/station2/tempf: 87.7
> - /ss/data/station2/humidity: 10.2
>

## In Memory Data Model

A simple light weight and efficient message is created from a
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
