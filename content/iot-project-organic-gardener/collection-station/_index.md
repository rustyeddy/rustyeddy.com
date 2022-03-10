---
title: Collection Station
date: 2021-01-13
url: collection-station
description: >
    The Collection and Control Station (CS) is capable of gathering
    data from attached sensors. It publishes the sensor data to the
    Hub via MQTT data channels. The CS also subscribes to the MQTT
    command channels to cause the CS to switch connected sprinkler
    relays.. 
weight: 10
git: https://github.com/sensorstation/ssesp
---

## IoT Sensors data Published

The idea is pretty simple really: build a network of wireless battery
powered devices that gather environmental data such as temprature,
moisture, light levels, etc. The collected data will then be
_published_ via [MQTT](https://mqtt.org) _wirelessly_ for any
subscriber such as [_IoTHub_](/sensors/hub).

### Types of Published Data

The planned data types to be published by the system are concerned
with simple environmental data. However any _type_ of data could be
used, for example this system could be used to pub/sub data from 
hosts on a local network, turning it into a network monitoring
platform for example.

Cool, anyway, back to our application...

We have planned support for the following type of sensors. To be
determined are the exact model(s) of sensors will be a good fit.

- Temprature
- Humidity 
- Moisture
- Light
- Barometric Pressure 

Data will be transmitted as either integer or floating point,
depending on the sensor and how it collects the data.

## Data Storage

Due to the limited nature of the sensor stations storage space,
relatively little historic data will be saved on the _station_ itself.

The expectation that data published by the station will have been
consumed and aggregated by the Hub or a similar subscriber. 

Historic, real-time and _cloud persistence_ of said data is the job of
an aggregrator such as the Hub, or in the cloud based _Time Series
Database (TSDB)_ 

## esp32 Chip of Choice

We are going to the
[esp32](https://www.espressif.com/en/products/socs/esp32) as the _chip
of choice_ to building the environmental collection and publishing
platform (IoT Sensor Sation). 

Some features that make this chip very attractive for developing the
IoT Sensor station. In addition to it's availability and wonderfully
mature DevKit, the esp32 has the following features we will be taking
advantage of:

- Wireless support for Wifi & BLE
- Sophisticated low power modes
- Support for batteries
- Non Volatile Memory
- Over The Air Updates
- Digital GPIO
- Analog GPIO

We'll discuss all of these items and how they benefit the development
of our sensor station hardware. 

### The esp32 is CHEAP

An esp32 and a handful of sensors can easily be assebled for less than
$20 (if you have a solering iron or breadboard) on your kitchen
table. 

This is chip is no toy, it is an industrial stalwart!

### Network Connectivity

The most attractive part of the esp32, in my opinion is the built in
networking. Bluetooth Lightweight Edition (BLE) and ubiquitos
Wifi are built right on the esp32 itself.

The chip will come with an adequate antenna that will be strong enough
for local connections.  However, longer distance connections can be
had by adding a better antenna.

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
