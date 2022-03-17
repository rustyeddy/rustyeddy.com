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
weight: 10
---

![High Level Sensor Station](/img/iothub.png)

## What Does OG Hub Do?

In a nutshell the _Hub_ gathers environmental data from a network of
[Collection Stations](iot-project/collection-station) using the well
known _MQTT Messaging_ protocol. The hub feeds the data to the
_Oraganic Gardner_ application, streams it real-time to
[_dashboard_](/iot-project/dashboard) users via
[Websockets](http://websockets.org) and caches the data in RAM.

## How Does the Hub Work?

The Hub is a small, fast server written in [_Go_](http://golang.org)
with the following dependencies:

1. Go's built-in HTTP Server to serve HTML
2. Go's built=in HTTP Server to serve REST API
3. [Websocket](https://github.com/nhooyr/websocket) Library for real
   time data to dashboard 
4. [MQTT](https://github.com/eclipse/paho.mqtt.golang) Eclipse MQTT
   Library

The software running on the Hub can be called a _Micro-service_.
_Go's_ built in _HTTP server_ is small, robust and fast allowing us
to easily add a _REST API_ and serve up some HTML and JavaScript to
for our WebUI, which happens to be a 
[_Single Page App_](https://developer.mozilla.org/en-US/docs/Glossary/SPA) 

The MQTT and Websockets libraries, like Go's built in HTTP library,
are also robust, fast and small allowing us to build this
sophisticated application and also keep it _small, robust fast_. YEA!

> As matter of fact, it is so small and fast, it is more than happy to
> run on a _Raspberry Pi_!

![High Level Sensor Station](/img/rpi.jpg)

### Readers, Writers and Concurrency

The Hub is really a  moderately sophisticed data multiplexer made up
of multiple _concurrent_ _readers_ and _writers_. The cuncurrency is
perhaps the most interesting design challenge of this software.

The Hub handles concurrency with features built into the _Go_
programming language: _Go Functions_ and _channels_ which will be
described in a future article.

> Todo write article on how hub uses channels and go functions

### Current Features (MVP)

The _1st Milestone_ of the 
[_Organic Gardener IoT Project_](/iot-project) has been completed. The
list of supported features are:

1. Collect environmental Data via MQTT
2. Cache collected data in RAM.
3. HTTP server to provide a REST API
4. HTTP server to serve the [Dashboard](/iot-project-organic-gardener/dashboard) webapp
4. HTTP server enhanced with Websockets to stream data live

#### Coming Soon ...

In a future phase of the project we will add an option to save
data in a persistent Database. We will discuss various choices between
SQL variants (MySQL, Postgres), Mongo and application specific
databases like InfluxDB and Prometheus.

## Demo of the Hub

This section will demonstrate using the REST API to retrieve data from
the Hub has collected. To pull this off we are going to _Mock_ a
_Collection_ or two by sending "fake" data using the _mosquitto_pub_
client. 

### Fire Up The Hub

![High Level Sensor Station](/img/screen-shot-hub-start.png)

Above is a screenshot of the logs displayed when the _Hub_ has
started. If we read logs beging with the first we will find that the
hub has:

1. Subscribed to the MQTT mesh network channel
2. Subscribed to the MQTT data channel
3. Connects to the MQTT broker on localhost
4. HTTP Server starts up listen on port 8011

Notice the MQTT subriptions using the '+' wildcard character allows
the subscriber to gather data from many sources with a single
subscription. 

The topic path form is ```ss/data/{stationid}/{sensorid}``` where the
```{stationid}``` and ```{sensorid}``` are variables that match the
sub-strings in segments 3 and 4 of the _topic_

#### MQTT Wildcard Subscriptions

MQTT supports wildcard subscriptions allowing the Hub to subscribe to
_ALL_ _data channels_ even without knowing the stationID's or
sensorIDs before hand.

By subscribing to ```/ss/data/+/+``` the Hub will recieve data from
every station and sensor on the network. 

### Publishing Test Data 

We are going to _mock_ a _Collector_ by publishing fake environmental
data using the cool MQTT publishing utility _mosquito_pub_.

```bash
% mosquitto_pub -t ss/data/10.11.1.1/tempf -m 98.6
```

We will fake data from sensor ```tempf``` to topic
```ss/data/10.11.1.11/tempf``` the value of ```98.6``` using the 
following command:

![High Level Sensor Station](/img/screen-shot-hub-data.png)

In the above screen shot ```mosquitto_pub``` published the temperature
in farenhiet to the topic ```ss/data/10.11.1.11/tempf``` where the CS
_station id_ is represented by ```10.11.1.11```. Likewise, the sensorID
is represented by the string ```tempf```. The value passed in 98.6
degrees farenhiet.

We can see the Hub recieving the data and parsing the _stationID_ and
_sensorID_ from the topic string. The data is parsed, formatted and
temporarily saved in RAM. 

When data _periodically_ arrives, the Hub will quickly extract
the following elements of the data point.

- **Station ID** probably in the form of an IP or MAC address
- **Sensor data** name such as: temprature, humidiy, air-pressure, etc
- **Value** this will either be an integer or a float64
- **Timestamp** when the data was sampled.

The data is reformatted and stored as a _time-series_ in RAM. Let's
have a look at the REST API that can be used to access this data.

### Using the REST API

Another screenshot is in order. This time I'll use curl to call the
data REST API to retrieve the one piece of data we have collected:

![Hub REST API](/img/screen-shot-hub-curl.png)

Notice the ```curl``` command in the bottom screen, the data has been
returned in full JSON format. This single data point looks like
this when pretty printed.

```JavaScript
{
    "10.11.1.11": {
        "id":"10.11.1.11",
        "sensors": {
            "tempf": { 
                "values": [
                    {
                        "val":98.6,
                        "time":1647301689
                    }
                ]
            }
        }
    }
}

```

#### Complete REST API

The Hub provides a REST API allowing other programs to access datasets
from the Hub for various applications. Some of the important REST API
_endpoints_ are:

```
- GET       /stations
- GET       /station/{stationid}
- GET       /data?stationid={stid}&sensor={sens}&start={start}&end={end}
- DELETE    /data?stationid={stid}&sensor={sens}&start={start}&end={end}
```

The first two gather and reply with _IoT Collection Station_ meta
data, such as the station ID, sensors hosted and performance
and metrics.

The ```/data ``` endpoint will return data ;-), filters can be used to
limit the response to certain _stations_, _sensors_ and / timespans.

### Dashboard and Websockets

Built into the Hub is a Web server capable of serving up a _Single
Page App (SPA)_ discussed on it's own section of this project
site. The _Hub_ and _Dashboard_ support _Websockets_ allowing the Hub
to update the Dashboard when new data arrives in _real-time_.

We will talk alot more about this in the
[Dashboard](/iot-project/dashboard) 
