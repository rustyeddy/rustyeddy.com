---
title: Wireless Battery Powered IoT Sensors
date: 2021-01-13
description: >
    We are going to build a Sensor Station capable of wirelessly
    broadcasting environmental data to any entity that will subscribe
    to the data. The stations are typically wireless and will often
    run with low power batteries.
weight: 10
git: https://github.com/sensorstation/ssesp
---

## IoT Sensors data Published

The idea is pretty simple really: build a wireless, battery powered
device that has sensors to collect temprature, moisture, light levels
and any other desired environmental data and _publish_ that data
_wirelessly_ to a [_Hub_](/sensors/hub) that acts as a _data
agregator_.

### Type of Data

Plan support for the following type of sensors. Now I must determine
exactly what model(s) of these sensors are going to be good fits.

- Temprature
- Humidity 
- Moisture
- Light
- Pressure 

### Publishing Done via MQTT

The station will _publish_ it's collected data via the well known and
supported _MQTT_ lightweight messaging protocol. Consumers of that
data, including the [IoT Hub](sensors/hub) simply _subscribe_ to the
data channels it will be consuming.

#### MQTT and Openess

MQTT provides a distinct advantage in that it opens up integration
from third party products and add ons. Any software capable of MQTT
can become either a _producer_ or _consumer_ of the systems data.

## Data Storage

Due to the limited nature of the sensor station and it's chip,
very little historic data will be maintained on the _station_ itself. 

The expectation that published data by the station will have been
consumed and aggregated by the Hub or similar device. Historic,
real-time and _cloud persistence_ of said data is the job of an
aggregrator such as the Hub.

## esp32 Chip of Choice

We are going to the
[esp32](https://www.espressif.com/en/products/socs/esp32) as our chip
of choice for building an environmental collection and publishing
platform. 

Some features that make this chip very attractive for developing an
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

An esp32 and a handful of sensors can easily be assebled for less the
$20 if you have a solering iron or breadboard on your kitchen
table. Of course, from there one could go insanely crazy with
complexity and features driving costs as high as you might want to go.

This is no toy chip, it is an industrial stalwart!

### Network Connectivity

The most attractive part of the esp32, in my opinion is the built in
networking you get. Bluetooth Lightweight Edition (BLE) and ubiquitos
Wifi are built right on the esp32 itself.

With an appropriate development kit, the chip will come with an
adequate antenna that will be strong enough for local connections.
However, longer distance connections can be had by adding a more power
antenna. 

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
that can truely be "_set it and forget it" for years off a single
battery.

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
