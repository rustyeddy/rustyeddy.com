---
title: "Soil Moisture Sensors for IoT Garden Projects"
date: 2024-02-15
description: >
  Notes on choosing soil moisture sensors for IoT garden projects,
  including resistive vs. capacitive sensors, common reliability
  problems, protection methods, calibration, and a practical
  recommendation for future builds.
categories:
  - electronic-components
tags:
  - soil moisture
  - sensors
  - iot
github: https://github.com/sensorstation/iotesp
summary: "Practical notes on soil moisture sensor reliability, calibration, protection, and sensor choice for a self-watering garden project."
---

Soil moisture sensing looks simple until you try to build a reliable
system around it. Many inexpensive sensors work well enough for a bench
demo, but behave poorly once they are pushed into soil, powered from a
battery, sampled by a sleeping microcontroller, and left outside.

These notes came from researching and experimenting with low-cost soil
moisture sensors for the [self-watering garden](/iot/self-watering-garden/)
project. The larger project treats each watering station as part of a
system: ESP32 collection stations publish readings, the OttO gateway
collects them, and a dashboard or control loop uses the data.

The sensor still matters. Bad readings at the edge leak into every layer
above it.

## Recommendation

For a real garden system, I would not start with the cheapest bare
capacitive boards again. They are useful for learning, but the quality
variance and protection work can consume more time than they save.

My current recommendation is:

- Avoid resistive probes for long-term outdoor use.
- Prefer capacitive sensing over resistive sensing.
- If using cheap capacitive boards, inspect the components before
  deployment and protect the electronics from moisture.
- For a more predictable project, use a better-supported digital sensor
  such as the Adafruit STEMMA soil sensor and treat it as an I2C device.

The follow-up note covers that direction in more detail:
[Adafruit Soil Moisture Sensor Notes for IoT Projects](/notes/soil-moisture-adafruit/).

## Resistive vs. Capacitive Sensors

The two common low-cost soil moisture sensor types are resistive and
capacitive.

Resistive sensors measure conductivity through exposed metal traces or
probes. They are cheap and easy to understand, but the exposed metal is
part of the measurement path. In wet soil, those probes corrode and the
readings change over time.

Capacitive sensors estimate moisture without relying on exposed metal in
the same way. They are generally the better starting point for a garden
project, but cheap capacitive boards still have problems: inconsistent
parts, missing components, slow response, noisy readings, and weak
protection around the electronics.

That makes capacitive sensors preferable, not automatically reliable.

## Research Notes

A few public teardown and test videos were useful while sorting through
which cheap capacitive sensors were worth trying.

This video discusses quality problems in common capacitive soil moisture
boards and claims a high failure rate among tested sensors:

{{< youtube IGP38bz-K48 >}}

The most useful takeaway was not the exact percentage. It was the
component-level checklist: inspect the regulator, timer chip, and support
components before assuming two boards with the same shape behave the same
way.

Another useful video discusses response time and a possible resistor
change for some boards:

{{< youtube QGCrtXf8YSs >}}

I kept these links because they explain the failure modes better than a
short text summary can. The exact board revisions in the market change,
so treat them as diagnostic guidance, not as a permanent buying guide.

## Common Cheap Sensor Problems

### Missing or Wrong Voltage Regulator

Some boards are advertised as working with either 3.3V or 5V, but not
all boards are populated the same way. If a board is missing the expected
regulator, battery-powered operation can become unreliable as voltage
falls.

Before deploying a batch, inspect the actual boards you received. Do not
assume the product photo and the delivered board are identical.

### Wrong Timer Chip

Some boards use a TLC555-style timer, while others use an NE555-style
chip. The distinction matters because the NE555 may require a higher
operating voltage than a battery-powered 3.3V design can reliably
provide.

For a low-power ESP32 station, that can turn into intermittent readings
that look like software bugs but are really hardware mismatch.

### Missing Support Resistors

Some boards appear to be missing support components that affect response
time. The practical symptom is that readings settle slowly after power is
applied.

That matters for a sleeping sensor station. If the firmware wakes up,
powers the sensor, samples immediately, and goes back to sleep, the
reading may reflect sensor settling behavior instead of actual soil
moisture.

### Board-to-Board Variation

Cheap capacitive boards are not all equivalent. Two boards can have the
same general shape and still use different components or produce
different ranges. Calibration should happen per board or per batch.

## Integration Notes

Most low-cost capacitive sensors expose three pins:

- Power.
- Ground.
- Analog signal.

That signal can be read directly by a microcontroller with an ADC, such
as an ESP32 or Raspberry Pi Pico. A full Raspberry Pi does not have
analog input pins, so it needs an external ADC or a small microcontroller
acting as the sensor interface.

The basic firmware loop should account for settling and calibration:

1. Wake the microcontroller.
2. Power or enable the sensor.
3. Wait long enough for the reading to settle.
4. Sample multiple times.
5. Average or filter the samples.
6. Publish the reading.
7. Return to sleep.

The right delay depends on the specific sensor board. Measure it instead
of guessing.

## Calibration

Do not assume the raw value means the same thing across boards.

A practical calibration process is:

1. Record the value in air or dry soil.
2. Record the value in saturated soil or water, depending on the test
   setup.
3. Repeat with each sensor board.
4. Convert raw readings into a normalized percentage or named range.
5. Store calibration values with the station or gateway configuration.

For irrigation control, stable relative readings are often more useful
than pretending the sensor reports a precise physical moisture unit.

## Protecting the Electronics

The sensor blade goes into soil, but the electronics should not be left
unprotected. Moisture can creep into exposed components and eventually
ruin the board.

This article collects several practical protection options:
[Protecting Capacitive Soil Moisture Sensors](https://medium.com/@d.robertson/protecting-capacitive-soil-moisture-sensors-e1ab81f1c4fb).

The methods I considered were:

- Clear nail polish over exposed electronics.
- Urethane or conformal coating.
- Heat shrink tubing over the protected electronics area.

The goal is to protect the electronics while leaving the sensing area
able to interact with the soil. Do not coat the entire board blindly
without understanding which section is the sensing surface.

## Personal Experiment Notes

The cheap capacitive sensors I bought were not the ideal variant. The
boards appeared to use the less desirable timer chip, and the response
behavior was not something I would trust without additional testing.

That does not make them useless. They can still be used for learning,
bench testing, and understanding the sensor path. But they are not where
I would spend most of the effort for a reliable self-watering garden.

The better engineering move is to reduce uncertainty at the sensor layer
so the rest of the system can be tested against cleaner data.

## Common Pitfalls

### Sampling Before the Sensor Settles

A sleeping station may wake, read, and sleep too quickly. If the sensor
needs time to settle after power-up, the first reading may be wrong.

### Ignoring Calibration

Raw ADC values are not portable across boards. Calibrate each board or
at least each batch.

### Confusing Sensor Failure with Software Failure

Noisy or drifting readings can look like bugs in MQTT, the gateway, or
the dashboard. Check the physical sensor before debugging every software
layer above it.

### Leaving Electronics Exposed

A sensor that works indoors for a day may fail outside after moisture
gets into the electronics. Protection is part of the design, not a final
detail.

## Where This Fits

Soil moisture sensing is one part of the larger garden architecture:

- [Self-Watering Garden: An IoT Architecture Case Study](/iot/self-watering-garden/)
  shows how the sensor reading is used in the full system.
- [ESP32 Collection Station Architecture for IoT Sensor Networks](/iot/iot-sensor-station/)
  explains the device-side firmware boundary.
- [Adding MQTT to the IoT Gateway](/iot/iot-gateway-mqtt/) explains how
  readings move from station to gateway.
- [Adafruit Soil Moisture Sensor Notes for IoT Projects](/notes/soil-moisture-adafruit/)
  covers the digital sensor I would use for the next iteration.
