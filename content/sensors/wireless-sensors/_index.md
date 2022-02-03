---
title: Wireless Battery Powered IoT Sensors
date: 2021-01-13
description: >
    This document specifies the requirements including an MVP for this
    IoT sensor hardware project. A small wireless device with sensors transmit
    data such as temperature, humidity, moisture and pressure. The
    sensors may be thrown around in areas without infra-structure or
    connected to the cloud when infrastructure is available.
weight: 10
vcs: https://github.com/sensorstation/ssesp
draft: true
---

## IoT Sensors data Published

> Todo provide schematic of esp32 with 

### Type of Sensors

Plan support for the following type of sensors. Now I must determine
exactly what model(s) of these sensors are going to be good fits.

- Temprature
- Humidity 
- Moisture
- Light
- Pressure 


### Data sent to a Hub

The IoT Hub acts as both the _message broker_ for IoT data sent from
sensors. It is also a _subscriber_ of said data with the explicit job
of displaying data real-time and archiving historic data whether it is
local or in the cloud.

### TBD: Control inputs 

The _IoT Station_ does not have to be a publisher only. It is also
possible that the _IoT Station_ act as a subscriber to control things
like relays or a potientiometer. 

## How Does SS work?

### Data Transmitted Via MQTT

Data will be transmitted by the very popular, well understood and
supported protocol MQTT.

### A TCP Connection is required
### MQTT Requires a broker
### The Broker is the [Sensor Hub](/sensors/sensor-hub)


## Implementation esp32

## Batteries 
### Sleep Modes
### Solar

## Networking
### Infrastructure or Not?
#### Wired Power?
#### Wireless Internet Connectivity?

### Wifi 802.x
### Mesh Network

## OTA Updates

