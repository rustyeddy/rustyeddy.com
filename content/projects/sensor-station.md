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
github: http://github.com/mobilerobot-io/esp
---

Thermo is built with an esp32 WRoom32 development board, with a
temprature sensor and a standard wifi connection, it is able to
periodically broadcast the local temprature via MQTT.

## Features 

Thermo32 has the following features currently implemented:

1. Temprature sampling with tmp36
2. Wifi connection to broadcast temprature
3. MQTT client to advertise temprature to broker 
4. LED is flashed to indicate temprature has been sampled and
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

The _thermo32_ has been built on the esp32 with the FreeRTOS / ESP-IDF
software package. The ESP32 comes with a number of pins that provide
an astounding array of functionality.

### Bill Of Materials

- esp32 development board
- tmp36 temprature sensor
- led and resistor
- breadboard and wires

### Schematic

> TODO: create a fritzing schematic of this layout

## Power and Batteries

Provide some words on how to power this module while holding to low
sfffpower requirements.

## Operating and Managing

Since this is an IoT device, it will hold some requirements that
traditionall, _non-connected_ devices did not have to worry about, as
well as capabilities, that were not previously accessable by _normal
people_, outside industry.

Now we are starting to see a plethora of these things invading our
home and business networks. Managing them, triaging problems and
rolling out releases that do not break working application is
paramount! 

## Taking the Temprature and Sampling

The chip is capabile of getting temprature readings at such a manner
much faster than we need to be consuming them, since it is also
possible that one or more of the samples may not be very accurate due
to noise, our read process is to take 64 samples back to back then
average them out to the final _sampled_ temprature.

### Sample History vs. Recorded History

During normal operation it is possible to average out a sampling every
5 seconds with plenty of cycles to spare. This maybe an important or
interesting number to track for abrupt temprature raises, such as
something catching on fire.

However for historical purposes, we most likely only want to track the
temprature in say 15 minute increments over the course of years. This
being the case, we will be able to configure the device to hold
backlog for a period of time, then just archive every 15 minutes of


