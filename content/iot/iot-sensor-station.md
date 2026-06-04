---
title: "ESP32 Collection Station Architecture for IoT Sensor Networks"
date: 2022-01-13
description: >
  How an ESP32-based collection station fits into an IoT system: sensor
  sampling, MQTT publishing, local buffering, sleep modes, OTA updates,
  and the boundary between device firmware and the edge gateway.
weight: 30
git: https://github.com/rustyeddy/ogesp
tags: ["ESP32", "IoT Architecture", "MQTT", "Sensor Networks", "Embedded Systems"]
categories: ["IoT Systems", "Embedded Systems"]
summary: "A device-side architecture note for ESP32 collection stations in the Organic Gardener IoT system."
---

A collection station is the device-side telemetry node in the Organic
Gardener system. Its job is to sense the physical environment and
publish readings to the gateway. In the larger [IoT System Architecture](/iot/iot-system-architecture-device-to-cloud/),
this is the device layer that feeds the [OttO edge runtime](/projects/otto/).

## Why This Matters

Collection stations are where software meets the physical world. Keeping their
responsibilities small makes the rest of the IoT system easier to test, replace,
and operate when networks fail or hardware changes.

That job should stay small and explicit. The collection station should
not own dashboard behavior, long-term storage, irrigation policy, or
fleet-wide decisions. It should collect data, identify itself, publish
readings, tolerate temporary network problems, and conserve power.

## Where the Collection Station Fits

In the larger architecture, the collection station sits at the edge of
the physical world:

1. Sensors measure soil moisture, temperature, humidity, light, or other
   environmental conditions.
2. The ESP32 firmware samples those sensors.
3. The station publishes telemetry over MQTT.
4. The OttO gateway receives the reading and updates local system state.
5. Applications and dashboards query the gateway instead of talking
   directly to the device.

This boundary keeps the device firmware focused. The ESP32 does not
need to know how the dashboard is rendered or where long-term telemetry
is stored. It only needs to publish a clear message to a stable topic.

See [Adding MQTT to the IoT Gateway](/iot/iot-gateway-mqtt/) for the
message boundary and [Self-Watering Garden: An IoT Architecture Case Study](/iot/self-watering-garden/)
for the end-to-end system.

## Why ESP32

The ESP32 is a practical choice for a garden collection station because
it combines wireless networking, GPIO, ADC inputs, low-power modes, and
a mature development ecosystem in an inexpensive package.

Useful ESP32 capabilities include:

- Wi-Fi for local network connectivity.
- Bluetooth Low Energy for provisioning or short-range communication.
- Digital GPIO for simple sensors and control lines.
- Analog inputs for voltage-based sensors.
- I2C and SPI for digital sensor modules.
- Deep sleep and light sleep modes.
- Non-volatile storage for configuration.
- Over-the-air firmware update support.

An ESP32 board and a few sensors can be assembled cheaply with a
breadboard or soldering iron, but the important design point is not the
price. The ESP32 is capable enough to run real firmware while still
forcing the software to respect embedded constraints.

## Published Data

A collection station can publish many kinds of environmental readings:

- Temperature.
- Humidity.
- Soil moisture.
- Light level.
- Barometric pressure.
- Battery voltage.
- Device health or signal quality.

The station should include enough identity in the message contract for
the gateway to route and store the reading. In the current MQTT topic
model, station and sensor identifiers are part of the topic:

```text
ss/data/{stationid}/{sensorid}
```

For example:

```text
ss/data/station-01/soil-moisture
```

The payload can start as a simple numeric value, but richer systems
should make units, calibration, and schema version explicit.

## Firmware Responsibilities

The firmware should own the device-local work:

- Initialize sensors and communication buses.
- Load station identity and configuration.
- Sample sensors at configured intervals.
- Validate or smooth readings when necessary.
- Publish telemetry to MQTT.
- Buffer a small number of readings during network outages.
- Report battery, firmware, and connection health.
- Enter sleep modes when idle.
- Support safe firmware updates.

The firmware should avoid system-wide decisions. For example, it should
not decide the full watering policy for a zone. That belongs in the
gateway or application layer, where it can be observed, tested, and
changed without reflashing every sensor node.

## Power Budget and Sleep Modes

Battery-powered collection stations are power-budget problems first and
software problems second.

Wi-Fi is usually one of the most expensive operations. A station that
stays awake and connected all day will drain a small battery quickly. A
better pattern is often:

1. Wake from deep sleep.
2. Power or initialize the sensor.
3. Wait for the reading to settle if the sensor requires it.
4. Sample the sensor.
5. Connect to Wi-Fi.
6. Publish the reading.
7. Optionally wait for an acknowledgement or command.
8. Return to sleep.

The right interval depends on the physical process. Soil moisture does
not usually need second-by-second readings. A slower sample interval can
save significant power without reducing the value of the data.

Solar charging and rechargeable batteries can extend lifetime, but they
do not remove the need for a power budget. Measure current draw during
sleep, sensor warm-up, Wi-Fi connection, publish, and failure retries.
Those numbers tell you whether the device can run for days, months, or
longer.

## Local Buffering

A collection station should expect the network to fail. Wi-Fi may be
out of range, the broker may restart, or the gateway may be offline.

The device does not need to become a database, but it should have a
small, explicit buffering policy:

- Keep the latest reading if only current state matters.
- Keep the last `N` readings if short outages should be filled in.
- Drop old readings when storage is full.
- Publish a health signal when readings are dropped.

The key is to make the behavior intentional. Silent data loss is hard to
debug, and unbounded buffering is not realistic on a small device.

## OTA Updates

Over-the-air updates matter because collection stations may be deployed
in inconvenient places. Reflashing every device over USB is fine on a
bench and painful in a garden.

OTA support should be treated as a reliability feature, not just a
convenience. A safe update path needs:

- A known firmware version.
- A way to verify the update payload.
- A rollback strategy if the new image fails to boot.
- Enough battery or external power to complete the update.
- A clear maintenance window if the device controls anything physical.

Even if OTA is not implemented in the first prototype, the firmware
layout should leave room for it.

## Common Pitfalls

### Noisy Sensors

Soil moisture and other analog sensors can be noisy. Readings may drift
with temperature, supply voltage, corrosion, cable length, or soil
composition. The station should either smooth readings locally or report
enough raw data for the gateway to handle filtering.

### Wi-Fi Power Cost

A reliable Wi-Fi connection is convenient, but it is expensive for
battery devices. Reconnection loops, weak signal, and long retry windows
can dominate the power budget.

### OTA Failure Modes

An OTA system that can leave a device unbootable is worse than no OTA at
all. Updates need verification and rollback, especially when devices are
not easy to reach.

### Unbounded Local Storage

A station cannot buffer forever. Decide how many readings to keep, what
to drop, and how to report that data was lost.

### Too Much Policy on the Device

If every station contains its own irrigation rules, the system becomes
hard to inspect and update. Keep station firmware focused on sensing and
reporting; keep coordination in the gateway.

## Where This Fits

The collection station is one part of the larger IoT system:

- [Self-Watering Garden: An IoT Architecture Case Study](/iot/self-watering-garden/)
  shows the station in the full irrigation workflow.
- [Adding MQTT to the IoT Gateway](/iot/iot-gateway-mqtt/) explains the
  publish/subscribe boundary.
- [OttO: A Go-Based IoT Edge Gateway Architecture](/iot/iot-edge-gateway/)
  describes the gateway that receives collection station data.
- [Soil Moisture Sensors](/notes/soil-moisture-sensor/) covers sensor
  selection problems.
- [Adafruit Soil Moisture Sensor Notes for IoT Projects](/notes/soil-moisture-adafruit/)
  discusses a more reliable digital soil sensor option.
