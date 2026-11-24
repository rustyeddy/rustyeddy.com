---
title: "Adafruit Soil Moisture Sensor (I2C) vs. Cheap Capacitive Sensors"
date: 2024-03-13
lastmod: 2026-11-23
description: "Soil moisture sensors for an ESP32 garden: why cheap capacitive boards fail, calibration and protection, and the Adafruit STEMMA I2C sensor with code."
categories:
  - electronic-components
tags:
  - soil moisture
  - sensors
  - iot
  - i2c
github: https://github.com/rustyeddy/iotesp
aliases:
  - /notes/soil-moisture-sensor/
---

Soil moisture sensing looks simple until you try to build a reliable system
around it. Many inexpensive sensors work well enough for a bench demo, but
behave poorly once they're pushed into soil, powered from a battery, sampled by
a sleeping microcontroller, and left outside.

These notes come from the [self-watering garden](/iot/self-watering-garden/)
project, where each watering station is part of a larger system: ESP32
collection stations publish readings, the OttO gateway collects them, and a
dashboard or control loop uses the data. The sensor is one small part of that
system, and that's the point. Bad readings at the edge leak into every layer
above it, so a slightly more expensive sensor that behaves predictably is
cheaper than days spent debugging noisy readings.

## Recommendation

For a real garden system, I wouldn't start with the cheapest bare capacitive
boards again. They're useful for learning, but the quality variance and
protection work can consume more time than they save.

- Avoid resistive probes for long-term outdoor use.
- Prefer capacitive sensing over resistive sensing.
- If you use cheap capacitive boards, inspect the components before deployment
  and protect the electronics from moisture.
- For a more predictable project, use a better-supported digital sensor such as
  the [Adafruit STEMMA Soil Sensor](https://www.adafruit.com/product/4026) and
  treat it as an I2C device. The rest of this note explains why, and how.

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

## Common Problems With Cheap Capacitive Boards

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

## Reading an Analog Capacitive Sensor

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

## The Adafruit STEMMA Sensor: What Changes

The Adafruit sensor is still a capacitive soil moisture sensor, but it has a
different integration model:

- It communicates over I2C instead of returning a raw analog voltage.
- It uses Adafruit's SeeSaw firmware interface.
- It's smaller than the common bare capacitive boards.
- It's designed for STEMMA QT / Qwiic-style wiring.

The important difference isn't the shape or color of the board. It's that the
microcontroller talks to a digital peripheral instead of interpreting a raw
analog signal directly.

## I2C and SeeSaw Integration Notes

I2C makes the sensor easier to integrate with microcontrollers that already
have a reliable I2C bus. It also changes the failure modes. Instead of asking
whether an ADC reading is stable, the software needs to handle bus addresses,
pull-up resistors, device discovery, and read failures.

Practical notes:

- SeeSaw runs as an I2C secondary device.
- The sensor operates at 3.3V logic and the I2C lines are 5V tolerant. Confirm
  the exact level-shifting details against the
  [product page](https://www.adafruit.com/product/4026) before wiring a 5V
  bus.
- I2C pull-up resistors still matter; 2.2k to 10k is a typical range. STEMMA QT
  boards already include pull-ups, so you usually do not add your own unless
  you have a long run or many devices on the bus.
- The base I2C address is `0x36`, set in firmware.
- Some SeeSaw boards can change address by shorting address pads.

For a single sensor station, the default address may be enough. For a station
with multiple I2C devices, address planning becomes part of the hardware
design.

The code below is the I2C/SeeSaw integration I used while testing the sensor.
It is written for ESP-IDF using the modern `i2c_master` driver, and it is
structured to make one point from the pitfalls section concrete: a failed read
and dry soil travel different return paths, so the rest of the system can tell
them apart. It also reads the temperature the SeeSaw exposes for free, which is
useful context for interpreting moisture and for spotting a sensor baking in
the sun.

```c
#include "driver/i2c_master.h"
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "esp_log.h"

static const char *TAG = "soil";

// Adafruit STEMMA soil sensor (SeeSaw) defaults
#define SEESAW_ADDR              0x36
#define SEESAW_STATUS_BASE       0x00
#define SEESAW_STATUS_HW_ID      0x01
#define SEESAW_STATUS_TEMP       0x04
#define SEESAW_TOUCH_BASE        0x0F
#define SEESAW_TOUCH_CH_OFFSET   0x10
#define SEESAW_HW_ID_ATTINY8X7   0x87   // newer boards; SAMD09 reports 0x55

// SeeSaw needs a short gap between the register write and the read-back.
static esp_err_t seesaw_read(i2c_master_dev_handle_t dev,
                             uint8_t base, uint8_t reg,
                             uint8_t *buf, size_t len, uint32_t delay_us)
{
    uint8_t cmd[2] = { base, reg };
    esp_err_t err = i2c_master_transmit(dev, cmd, sizeof(cmd), pdMS_TO_TICKS(50));
    if (err != ESP_OK) return err;
    esp_rom_delay_us(delay_us);
    return i2c_master_receive(dev, buf, len, pdMS_TO_TICKS(50));
}

// Confirm the device is actually a SeeSaw before trusting any reading.
static esp_err_t soil_probe(i2c_master_dev_handle_t dev)
{
    uint8_t hw_id = 0;
    esp_err_t err = seesaw_read(dev, SEESAW_STATUS_BASE, SEESAW_STATUS_HW_ID,
                                &hw_id, 1, 250);
    if (err != ESP_OK) {
        ESP_LOGE(TAG, "no response from 0x%02x: %s", SEESAW_ADDR, esp_err_to_name(err));
        return err;
    }
    ESP_LOGI(TAG, "SeeSaw hardware id 0x%02x", hw_id);
    return ESP_OK;
}

// Returns ESP_OK and a 0-4095-ish capacitance value, or an error.
// The caller can then tell "dry soil" (low number, ESP_OK) apart from
// "sensor not responding" (non-OK), which the gateway needs to know.
esp_err_t soil_read_moisture(i2c_master_dev_handle_t dev, uint16_t *out)
{
    uint8_t raw[2];
    esp_err_t err = seesaw_read(dev, SEESAW_TOUCH_BASE, SEESAW_TOUCH_CH_OFFSET,
                                raw, sizeof(raw), 5000);  // ~5ms settle
    if (err != ESP_OK) return err;
    *out = ((uint16_t)raw[0] << 8) | raw[1];
    return ESP_OK;
}

// Temperature comes back as a signed 32-bit fixed-point value:
// degrees Celsius scaled by 2^16. Same error contract as the moisture read.
esp_err_t soil_read_temperature(i2c_master_dev_handle_t dev, float *out_c)
{
    uint8_t raw[4];
    esp_err_t err = seesaw_read(dev, SEESAW_STATUS_BASE, SEESAW_STATUS_TEMP,
                                raw, sizeof(raw), 1000);
    if (err != ESP_OK) return err;
    int32_t fixed = ((int32_t)raw[0] << 24) | ((int32_t)raw[1] << 16) |
                    ((int32_t)raw[2] << 8)  |  (int32_t)raw[3];
    *out_c = (float)fixed / 65536.0f;   // 1.0 / (1 << 16)
    return ESP_OK;
}

void soil_task(void *arg)
{
    i2c_master_bus_config_t bus_cfg = {
        .i2c_port   = I2C_NUM_0,
        .sda_io_num = GPIO_NUM_21,
        .scl_io_num = GPIO_NUM_22,
        .clk_source = I2C_CLK_SRC_DEFAULT,
        .glitch_ignore_cnt = 7,
        .flags.enable_internal_pullup = true,  // STEMMA QT boards also have their own
    };
    i2c_master_bus_handle_t bus;
    ESP_ERROR_CHECK(i2c_new_master_bus(&bus_cfg, &bus));

    i2c_device_config_t dev_cfg = {
        .dev_addr_length = I2C_ADDR_BIT_LEN_7,
        .device_address  = SEESAW_ADDR,
        .scl_speed_hz    = 100000,   // SeeSaw is happiest at 100kHz
    };
    i2c_master_dev_handle_t dev;
    ESP_ERROR_CHECK(i2c_master_bus_add_device(bus, &dev_cfg, &dev));

    if (soil_probe(dev) != ESP_OK) {
        ESP_LOGE(TAG, "soil sensor not found, station will report sensor fault");
        vTaskDelete(NULL);
        return;
    }

    while (1) {
        uint16_t moisture;
        float    temp_c;
        esp_err_t m_err = soil_read_moisture(dev, &moisture);
        esp_err_t t_err = soil_read_temperature(dev, &temp_c);

        if (m_err == ESP_OK && t_err == ESP_OK) {
            ESP_LOGI(TAG, "moisture=%u temp=%.1fC", moisture, temp_c);  // telemetry
        } else {
            ESP_LOGW(TAG, "read failed: moisture=%s temp=%s",
                     esp_err_to_name(m_err), esp_err_to_name(t_err));   // fault
        }
        vTaskDelay(pdMS_TO_TICKS(2000));
    }
}
```

The full version lives in the [iotesp repository](https://github.com/rustyeddy/iotesp).

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

### Treating I2C as Automatically Reliable

Loose wires, long runs, missing pull-ups, and mixed voltage assumptions can
still produce intermittent failures on an I2C bus.

### Ignoring Address Conflicts

Multiple I2C devices on one bus need unique addresses.

### Assuming Cleaner Hardware Removes Calibration

Soil type, placement, and moisture range still need to be tested in the real
garden, digital sensor or not.

### Hiding Sensor Failures

The collection station should report read errors so the gateway can tell "dry
soil" from "sensor not responding." The return contracts in the code above are
written with exactly this in mind.

## Where This Fits

The Adafruit sensor moves the collection station away from fragile analog
interpretation and toward a cleaner device abstraction. The station reads the
sensor over I2C, publishes the measurement to the gateway, and the rest of the
system treats soil moisture as telemetry instead of a hardware debugging
problem. That's the real value: not that the sensor is perfect, but that it
lets the software architecture stay focused on device management, messaging,
storage, and control decisions.

- [Self-Watering Garden: An IoT Architecture Case Study](/iot/self-watering-garden/)
  shows how the sensor reading is used in the full system.
- [ESP32 Collection Station Architecture for IoT Sensor Networks](/iot/iot-sensor-station/)
  explains the device-side firmware boundary.
- [MQTT topic design for the OttO gateway](/iot/iot-edge-gateway/#mqtt-the-device-boundary)
  explains how readings move from station to gateway.
