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


# Adafruit Soil Moisture Sensor Notes for IoT Projects

Notes on using the Adafruit STEMMA soil moisture sensor after unreliable
results from cheap capacitive sensors in an ESP32 garden project.

<https://github.com/rustyeddy/iotesp>

Cheap capacitive soil moisture sensors are attractive for garden automation
because they are inexpensive and easy to find. In practice, the ones I tried
were inconsistent enough that they became a distraction from the larger system
design — and that is the whole point of this note. When the sensor is one small
part of a larger system (collection stations, an edge gateway, MQTT data flow,
REST APIs, and a dashboard), a slightly more expensive sensor that behaves
predictably is cheaper than spending days debugging noisy readings.

So this note explains why I moved to the
[Adafruit STEMMA Soil Sensor](https://www.adafruit.com/product/4026), what
changes when the sensor communicates over I2C, and where it fits in the
[self-watering garden](https://rustyeddy.com/iot/self-watering-garden/)
architecture.

## Why I Tried the Adafruit Sensor

The broader sensor-selection problem is covered in my earlier
[soil moisture sensor notes](https://rustyeddy.com/notes/soil-moisture-sensor/).
The short version is that many low-cost capacitive sensors have quality
problems: questionable timer chips, missing support components, slow settling
behavior, and awkward analog readings from an ESP32 ADC.

None of those issues are impossible to work around, but they add friction, and
friction in the sensor layer leaks into every layer above it.

## What Changed

The Adafruit sensor is still a capacitive soil moisture sensor, but it has a
different integration model:

- It communicates over I2C instead of returning a raw analog voltage.
- It uses Adafruit's SeeSaw firmware interface.
- It is smaller than the common bare capacitive boards.
- It is designed for STEMMA QT / Qwiic-style wiring.

The important difference is not the shape or color of the board. The important
difference is that the microcontroller talks to a digital peripheral instead of
interpreting a raw analog signal directly.

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

- Treating I2C as automatically reliable. Loose wires, long runs, missing
  pull-ups, and mixed voltage assumptions can still produce intermittent
  failures.
- Ignoring address conflicts. Multiple I2C devices on one bus need unique
  addresses.
- Assuming cleaner hardware removes calibration. Soil type, placement, and
  moisture range still need to be tested in the real garden.
- Hiding sensor failures. The collection station should report read errors so
  the gateway can distinguish "dry soil" from "sensor not responding." The
  return contracts in the code above are written with exactly this in mind.

## Where It Fits

The Adafruit sensor is a better fit for my garden project because it moves the
collection station away from fragile analog interpretation and toward a cleaner
device abstraction. The station can read the sensor over I2C, publish the
measurement to the gateway, and let the rest of the system treat soil moisture
as telemetry instead of a hardware debugging problem.

That is the real value: not that the sensor is perfect, but that it lets the
software architecture stay focused on device management, messaging, storage,
and control decisions.

## Related reading

[More in Notes On Software](https://rustyeddy.com/notes/)

- [Soil Moisture Sensors](https://rustyeddy.com/notes/soil-moisture-sensor/) —
  Plenty has been written about resistive vs. capacitive soil moisture sensors
  and how riddled with problems they are. After a lot of research …
