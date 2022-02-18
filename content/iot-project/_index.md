---
title: IOT Project Sensor Station 
url: iot-project-sensor-station
date: 2020-09-06T10:32:26-07:00
description: >
  IoT Project Station is a project to gather environmental data from
  inexpensive battery operated, wireless sensors. The data is 
  aggregated and accessible via a builtin Web Dashboard. The data collected 
  from the stations can be made globally accessible via a web account.
---

## What does sensor station do?

Sensor Station is a _System_ rather than single application: we have a
set of battery powered, wireless sensors that transmit environmental
data (temperature, humidity, moisture and light) to a hub that serves
up this data on a real-time dashboard. Optionally, if and when an
Internet connection is available, the hub will stash it's local data
(_time-series_ database) in _the cloud_.

## IoT Sensor Station PoC to MVP

The first iteration of this _IoT Project_ was to get three critical
pieces of software to perform just enough of the core functionality to
demonstrate the most basic functionality and purpose for this project.

#### Proof Of Concept (PoC)

Following describes the very basic PoC I have created with the three
primary components:

### Wireless IoT Collection Station (CS) publishes temprature

1. Build battery operated wireless _Collection Station (CS)_ 
1. CS uses DHT11 sensor to gather temprature and humidity periodically
2. CS _publishes_ data to the _MQTT Broker_ 

### IoT Hub Aggregates CS data

1. Hub subscribes to _MQTT Topics_ data channels
3. Hub Sends real-time data updates via web-socket to _dashboard_
2. Hub aggregates data in memory for REST queries
4. Hub serves Dashboard to clients

### IoT Dashboard

1. Modern Responsive Webapp Written in Vue
2. Displays _Collection Stations_ that have published data
3. Display _Sensor Data_ collected by CSs
4. Display _real-time_ data for any / all stations


I have taken a less than $10 [_esp32 devboard_](https://www.espressif.com/en/products/devkits) 
attached a heat and humidity sensor. The _esp32_ has built in Wifi
allowing us to transmit data to the network.

The Hub can be any _Linux_ computer, however we are choosing the
Raspberry Pi with a touch screen to serve up the Webapp act as a handy
_IoT Kiosk_.
