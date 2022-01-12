---
title: IOT Project Sensor Station 
url: iot-project-sensor-station
date: 2020-09-06T10:32:26-07:00
description: >
  Sensor Station is a project to gather environmental data from
  inexpensive battery operated, wireless sensors. The data is 
  aggregated and accessible via a builtin Web Dashboard. The stations
  can be made globally accessible via a web account.
---


![](images/ss-diagram.png)

## How Does Sensor Station Work?

Sensor Station is a System rather than single application: we have a
set of battery powered, wireless sensors that transmit environmental
data (temperature, humidity, moisture and light) to a hub that serves
up this data on a real-time dashboard. Optionally, if and when an
Internet connection is available, the hub will stash it's local data
(_time-series_ database) in _the cloud_.

## The Components 

### Sensors - Wireless and Battery Powered

Taking advantage of the esp32 Mesh Network, sophisticated power modes
allow these sensors to last for years before a battery change is
necessary, when battery power starts running low, the sensor will let
you know!

These sensors can be spread around in areas with little to no existing
network or _internet connection_.

Over-The-Air updates make pushing updated and fixed software out to
devices as soon as new code has been released. No need to attaching
USB cables and doing firmware updates! 


### Hub - Aggregate and care for sensors mesh network

The Sensor Data Aggregation Hub or just _Hub_ gathers data from all
sensors within it's _network_, makes that data available in
_real-time_ via _websockets_. 

The _Hub_ is also a _web server_ and will serve up an embedded web
allowing anybody authorized to watch data transmitted in
_real-time_. The _users_ can also access _historical_ data from the
more detailed _device_ and _data_ pages.

The _Hub_ also takes care of it's self organizing mesh network of
sensors. Finally the _Hub_ is the conduit between the dashboard and
the cloud.

### Dashboard - Real-Time and Historic Environmental Data

The dashboard is a WebUI built into the Hub providing a window into
your environmental health. All sensor data is transmitted over a
dedicated _MQTT_ _channel_, the channel is comprised of a _path_ that
looks like a _directory structure_ or URL path. Contained in the path
are the _identification_ of the device and the name of the _sensor_.

With this design, any _data publisher_ can contribute to the _Sensor
Station Application_.

### Cloud - Globalizing your Environment

_Cloud_ support extends the reach of the data globally allowing access
to both _real-time_ and _historical datas_, it also expands the length
data can be kept. Rather than a couple weeks to a month per hub, the
data loaded in the cloud can be persisted for _years_ at very low
cost.

Entire fleets of hubs can be managed from the cloud console making it
easy to manage, monitor and update large deployments of not only
sensor station but also the _hubs_.

Global Real-Time Monitoring

## Open Source / Open Tech 

- Go backend ~ small, FAST and easy to deploy
- VueJS Dashboard ~ styled with Paper it does not get any sexier
- REST API ~ it was designed to be part of an automation
- Web Sockets ~ makes the real-time dashboard not only possible, but
  exciting! 
- Ansible Deployment ~ It does not get any easy to deploy a complex
  environment with a nice clean ansible fired CI/CD pipeline
- Cloud Native ~ Our application(s) were designed to run as well in
  the cloud, a container or a baremetal host all the same!
  
