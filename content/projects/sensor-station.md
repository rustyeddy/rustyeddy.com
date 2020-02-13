---
title: Sensor Station
description: >
  Sensor Statiion is an internet connected thermostat, that connects to local
  wifi and spits out the temprature via MQTT.  Sensor will also have
  REST and HTML interfaces.
date: 2019-05-19
categories:
  - iot
tags:
  - esp32
  - freertos
githubs: 
  - https://github.com/rustyeddy/sensorstation.io
image: https://rustyeddy.sfo2.digitaloceanspaces.com/SensorStation.png
---

SensorStation is built with an esp32 WRoom32 development board and a
connected temprature sensor with on chip wifi. The software runs an
event loop with a timer periodically broadcasting the local current
temperature via MQTT.

> TODO: place a pic of the breadboard

## Features 

Thermo32 has the following features currently implemented:

1. Temperature sampling with a [tmp36 temperature](https://learn.adafruit.com/tmp36-temperature-sensor)
2. On chip Wifi connection for Internet access
3. MQTT client to advertise temperature to broker 
4. LED flashes to indicate temperature has been sampled and
   broadcast. 
5. ESP-IDF / FreeRTOS, small, concurrent efficient and flexible.

### Feature Roadmap

1. Limited history of previous reads (15 minute increments)
1. HTTP Server with HTML pages to display time and temprature
2. REST API to retrieve temprature history
1. REST API for configuration changes
2. MQTT configuration changes
4. HTML configuration changes

## Resources

- Github: [http://github.com/rustyeddy/thermo32](http://github.com/rustyeddy/thermo32)
- ESP32 Chip: [ESP32](http://esp32.org)
- ESP-IDF: [ESP-IDF](https://docs.espressif.com/projects/esp-idf/en/latest/index.html)

## Hardware 

The _Sensor Station_ has been built on the esp32 with the FreeRTOS / ESP-IDF
software package. The ESP32 comes with a number of pins that provide
an astounding array of functionality.

### Bill Of Materials

- esp32 development board
- tmp36 temprature sensor
- LED and resistor
- breadboard and wires

### Schematic

> TODO: create a fritzing schematic of this layout

## Power and Batteries

> Todo: I need to research battery options for devices that will be
> completely wireless.


## Temperature and Sampling

The chip is capabile of reading temperature samples much faster than
we as humans can process. It is also possible that one or more of the
samples may not have been read accurately due to various reasons. For
that reason we take 64 samples back to back (in less than a second),
average the samples together then determine the final _sampled_
temperature.

### Samples and Alarms

Historic sampling of things like temperature are typically stored in
increments of every 15 minutes or so. Since the esp32 is capable of taking
samples much faster than every minute, we can also watch for anomolies like
temperature spikes from something that caught on fire, for example. 

## Historic Data On Board

We will keep a limited history of sensor data on chip in the event of
the network being inaccessable or a new user wanting recent historical
temperature readings.
