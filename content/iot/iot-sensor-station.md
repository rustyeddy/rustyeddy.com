---
title: Collection Station
date: 2022-01-13
description: >
    The Collection Stations are small battery powered wireless devices
    outfitted with environmental sensors. They collect and publish the
    data to the Hub for processing. This project is built with the
    esp32 micro-controller, C++ and embedded realtime operating
    system. 
weight: 30
git: https://github.com/rustyeddy/ogesp
url: /iot-project/collection-station
---

## Publishing Sensor Data

The idea is pretty simple really: build a network of wireless battery
powered devices to gather environmental data such as temprature,
moisture, light levels, etc. The collected data will then be
_published_ via [MQTT](https://mqtt.org) _wirelessly_ to the 
[_Hub_](/sensors/hub).

### Types of Published Data

The planned data types to be published by the system are concerned
with the following types of sensors.

- Temprature
- Humidity 
- Moisture
- Light
- Barometric Pressure 

Technically any _type_ of data could be published and collected
however we are focused on the type of data our OG application will
use. Data will be transmitted as either integer or floating point,
depending on the sensor and how it collects the data.

## Data Storage

Due to the limited nature of the sensor stations storage space,
relatively little historic data will be saved on the _station_ itself.
The expectation that data published by the station will have been
consumed and aggregated by the Hub or a similar subscriber.

Long term storage of the data is the job of the
[Hub](/iot-project/hub) or other data aggregator. The CS is an
embedded system expected to run with very little resources.

## The esp32 Chip of Choice

We are going to the
[esp32](https://www.espressif.com/en/products/socs/esp32) as the _chip
of choice_ for building the _Collection / Control Station_.

Some features that make this chip very attractive for building the
_Collection / Control Station_. In addition to it's availability and
the wonderfully mature [esp-idf](https://github.com/espressif/esp-idf)
DevKit, the esp32 has the following features we will be taking
advantage of: 

- Wireless support for Wifi & BLE
- Sophisticated low power modes
- Support for batteries
- Non Volatile Memory
- Over The Air Updates
- Digital GPIO
- Analog GPIO

We'll discuss all of these items and how they benefit the development
of our projects hardware.

### The esp32 is CHEAP

An esp32 and a handful of sensors can easily be assebled for less than
$20 (if you have a solering iron or breadboard) on your kitchen
table. 

This is chip is no toy, it is an industrial stalwart!

### Network Connectivity

The most attractive part of the esp32 in my opinion are the networking
capabilities for wireless networking. Bluetooth Lightweight Edition
(BLE) and ubiquitos Wifi are built right on the esp32 itself.

#### Mesh Networks

During the 2nd phase of development, the Sensor Station will be
enhanced with _Mesh Network_ capabilities. That is the ability for an
esp32 to build a self forming network, eliminating the need to
pre-configure devices.

Mesh Networks also provides the capability of running a network where
no previous _network_ infrastructure exists or is accessible.

### Batteries and Low Power Modes

Battery options in stereo with _smart_ programming of sleep and
low power network protocols provide the potential of building sensors
that can truely be "set it and forget it" dutifuly running for years
with a single watch battery.

This will become a primary area of research and development for this
project in the near future.

### Solar

Options for solar power and rechargeble batteries give us the hope of
building something that could last into perpituity.  In other words,
the hardware should fail before one of these devices ever run out of
power. 

## OTA Updates

The downside of little wireless, battery operated devices scattered
about to and fro becomes very real when it is time to upgrade all
these devices.

That is where _Over-The-Air (OTA)_ updates becomes a life saver! When
new versions of software become available, they can be either _pushed_
down to the devices, or _pulled_ by the device from a _server_.

The updates happen in a matter of seconds, reboot and the station will
resume it's previous duties, most likely with out missing a single
published datapoint.

## Conclusion

If this project sounds interesting to you at all, please drop me a
line and say hello. Also consider signing up for the project email
list, where you will get only good stuff about the project, no SPAM,
never.
