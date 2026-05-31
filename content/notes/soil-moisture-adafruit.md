---
title: Adafruit Soil Moisture Sensor Notes for IoT Projects
date: 2024-03-13
description: >
  Notes on using the Adafruit STEMMA soil moisture sensor after unreliable
  results from cheap capacitive sensors in an ESP32 garden project.
categories:
  - electronic-components
tags:
  - soil moisture
github: https://github.com/rustyeddy/iotesp
---

Cheap capacitive soil moisture sensors are attractive for garden automation
because they are inexpensive and easy to find. In practice, the ones I tried
were inconsistent enough that they became a distraction from the larger
system design.

This note explains why I moved to the
[Adafruit STEMMA Soil Sensor](https://www.adafruit.com/product/4026), what
changes when the sensor communicates over I2C, and where it fits in the
[self-watering garden](/iot/self-watering-garden/) architecture.

## Why I Tried the Adafruit Sensor

The broader sensor-selection problem is covered in my earlier
[soil moisture sensor notes](/notes/soil-moisture-sensor/). The short version
is that many low-cost capacitive sensors have quality problems: questionable
timer chips, missing support components, slow settling behavior, and awkward
analog readings from an ESP32 ADC.

None of those issues are impossible to work around, but they add friction.
For this project, the sensor is only one part of a larger system: collection
stations, an edge gateway, MQTT data flow, REST APIs, and a dashboard. A
slightly more expensive sensor that behaves predictably is often cheaper than
spending days debugging noisy readings.

## What Changed

The Adafruit sensor is still a capacitive soil moisture sensor, but it has a
different integration model:

- It communicates over I2C instead of returning a raw analog voltage.
- It uses Adafruit's SeeSaw firmware interface.
- It is smaller than the common bare capacitive boards.
- It is designed for STEMMA QT / Qwiic-style wiring.

The important difference is not the shape or color of the board. The important
difference is that the microcontroller talks to a digital peripheral instead
of interpreting a raw analog signal directly.

## I2C and SeeSaw Integration Notes

I2C makes the sensor easier to integrate with microcontrollers that already
have a reliable I2C bus. It also changes the failure modes. Instead of asking
whether an ADC reading is stable, the software needs to handle bus addresses,
pull-up resistors, device discovery, and read failures.

Practical notes:

- SeeSaw runs as an I2C secondary device.
- The sensor operates at 3.3V and includes level shifting for 5V systems.
- I2C pull-up resistors still matter; 2.2k to 10k is a typical range.
- The base I2C address is set in firmware.
- Some SeeSaw boards can change address by shorting address pads.

For a single sensor station, the default address may be enough. For a station
with multiple I2C devices, address planning becomes part of the hardware
design.

This gist shows the I2C/SeeSaw integration code I used while testing the
sensor:

{{< gist rustyeddy adf10388f55e3e2a960b0b5c13b58539 >}}

## Common Pitfalls

- Treating I2C as automatically reliable. Loose wires, long runs, missing
  pull-ups, and mixed voltage assumptions can still produce intermittent
  failures.
- Ignoring address conflicts. Multiple I2C devices on one bus need unique
  addresses.
- Assuming cleaner hardware removes calibration. Soil type, placement, and
  moisture range still need to be tested in the real garden.
- Hiding sensor failures. The collection station should report read errors so
  the gateway can distinguish "dry soil" from "sensor not responding."

## Where It Fits

The Adafruit sensor is a better fit for my garden project because it moves the
collection station away from fragile analog interpretation and toward a
cleaner device abstraction. The station can read the sensor over I2C, publish
the measurement to the gateway, and let the rest of the system treat soil
moisture as telemetry instead of a hardware debugging problem.

That is the real value: not that the sensor is perfect, but that it lets the
software architecture stay focused on device management, messaging, storage,
and control decisions.
