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
Additionally the HUB comes with a REST API and Web server.

## MQTT to Gather Data

The Hub gather data via the well supported [MQTT](https://mqtt.org)
light weight IoT messaging protocol. The hub gathers data by
_subscribing_ to MQTT _channels_ or _topics_ such as:

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
our IoT.

```bash
/ss/data/1.1.2.1/tempf
```

The actual _data_ transmitted via the MQTT channel is simply the
temperature in _farenhiet_. If the IoT Station transmits data every 15
minutes you might see a series about like this:

```bash
73.3, 73.4, 74.1, 75.0 ...
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

## Web Server / Webapp

## Persistence 

### Local

### Cloud
