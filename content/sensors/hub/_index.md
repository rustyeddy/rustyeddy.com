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

## The Hub a Sensor Data Collector

The Sensor Data Aggregation Hub or just _Hub_ gathers data from all
sensors within it's _network_, makes that data available in
_real-time_ via _websockets_ or historic data via the REST API. 
Additionally the with a built in Web server capable of serving up a
webapp for the Hub..

## MQTT Gathers Data

The Hub gathers data via the well known and supported
[MQTT](https://mqtt.org) light weight messaging protocol is an ideal
fit for IoT applications. 

The hub gathers data by _subscribing_ to MQTT _channels_ or _topics_
such as:

- /ss/data/{stationid}/tepmf
- /ss/data/{stationid}/humidity
- /ss/data/{stationid}/soil

Where the topic _path_ are composed of the following elements:

- /ss/data let's us know this message contains sensor data
- {stationid} is the IP address of the IoT station that sends the data
- tempf is an example of the type of data (temprature in this case) to
  be sent.

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

## Normalizing the Message

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
_value_ at a specif _time_ from the respective _station_ and _sensor_.

This format can be converted in any alternative format required quite
easily and be transported through the system with little overhaed.

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

Because of the nature of _Web sockets_ in that you need a client to
transmit data, there are times where it is possibley no _consumer_ for
a particular channels data.  So the Hub was designed to quickly
discard data if there is no consumer for the data.

In practice, most likely the _memory_ or _station_ consumer will
always be listening to incoming data, reformatting it to the indexed
version of the data for easy station recovery.

This will almost always ensure there is at least one _consumer_ for
the data.

### Websocket Clients

Websocket clients on the other hand will come and go. A new connection
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

```txt
- station1
  - tempf: {t1, v1}, {t2, v2} .. {tn, vn}
  - humidity: {t1, v1}, {t2, v2} .. {tn, vn}
- station2
  - tempf: {t1, v1}, {t2, v2} .. {tn, vn}
  - humidity: {t1, v1}, {t2, v2} .. {tn, vn} 
```

## REST API

IoT Hub provides a REST API allowing other programs to access datasets
from the Hub for various applications. Some of the important REST API
_endpoints_ are:

- GET /stations
- GET /station/{stationid}
- GET /data/{stationid}/{sensor}/{start}/{end}
- DELETE /data/{stationid}/{sensor}/{start}/{end}

The first two gather and reply with _IoT Station_ specific meta data,
such as the station ID, sensors it hosts and other performance and
health characteristics.

### Go and Micro Services

The great thing about Go is that it was built out of the box with
great _micro-service_ support. That is, it is very simple to create
say an embedded web server capable of serving up _web-pages_ as well
as a _REST_ interface, _GraphQL_ and _Web-sockets_.

> TODO example of the go code registering callbacks, handling various
> protocols 

## Web Server / Webapp

## Persistence 

### Local

### Cloud
