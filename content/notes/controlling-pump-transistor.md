---
title: Controlling a Water Pump with a Transistor
description: >
  One important part of the garden-station (an IoT project I've been
  workiing on) is controlling pump with a signal from the Raspberry Pi
  (or other MCU). Rather than use a relay I built a circuit using a
  transistor, I'll discuss how it's done.
date: 2025-03-17
tags: [transistor, pump, diode, raspberry pi]
category: electronics
---

The project was created to use a _Soil Moisture Sensor_ to drive a
water pump to keep our plants watered.

## Bill Of Materials

1. 1 - Inexpensive 5v submersible pump
1. 1 - 1K Ohm Resistor
1. 1 - mps2222a Transistor
1. 1 - 1N4001 Diode
1. 1 - Raspberry Pi (model of your choosing, zero's work great)
1. 1 - External 5v Battery Supply (don't want to power the pump with
   the PI)

![Transistor circuit to control pump motor](/img/pump-switch.svg)
