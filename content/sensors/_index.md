---
title: Sensor Station I/O
date: 2020-09-06T10:32:26-07:00
description: >
  Sensor Station is an Irrigation Application, sensors monitor soil
  moisture, while relays are used to activate a drip system all
  automated with an AI backend.
---

# Sensor Station

Sensor Station is a collection of software components that make up an
_Irrigation Application_, soil moisture sensors periodically gather
soil moisture levels (and other data) and _publish_ that data via
MQTT. 

A Station Hub subscribes to the soil moisture (and other data)
channels, the moisture level is used to trigger a command to be
_published_ on an appropriate _MQTT_ channel.

The data may (or may not) also get recorded locally, sent to a
_TimeSeries DataBase (TSDB) and/or streamed to a realtime Dashboard. 

## TODO Insert Diagram Here.

It starts by collecting data, cleaning and distribtuing the data to a
dashboard, databases, control logic and other interesting places. 

