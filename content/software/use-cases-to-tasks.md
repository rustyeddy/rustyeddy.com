---
title: Use Cases to Tasks
description: >
  A use case is all the ways of using a system to achieve a particular
  goal for a particular user that can be measured or observed in a
  specific way
weight: 21
---

## Recap from Use-Cases

In our previous article [use-cases](/software/use-cases) we started
deriving _Kelly's Automatic Gardener_ into the first use-case

### Use Case

> Use-case 1: As a gardener I want my sprinkler system to peridoically
> measure the moisture level of soil and turn on a water pump when the
> soil is dry, then turn it off when it gets too wet.

This use-case can then be _sliced_ into a couple more use cases. The
additional use-cases can also be broke out to include:

> Use-case 1.1: As a gardner I want to be able to change the frequency
> the soil moisture of my are checked.

This is going introduce a configuration variable and a timer.

> Use-case 1.2: As a gardener I want my sprinkler system to record the
> historic sensor data.

This is going to introduce a data model and some type of data storage
such as a database.

which we then broke down into an initial set of _requirements_:

### Requirements

---

1. Periodically measure soil moisture levels

3. If the moisture level drops below a certain level start watering

3. Turn water off when the moisture hits a high point

4. Configurable moisture levels

5. Historic data storage 

---

### Acceptance Tests

This set of requirements can now be validated by with these acceptance
tests: 

---

1. Verify the water pump is not active when moisture level is below
   threshold 

2. Verify water pump activates when moisture crosses the dry threshold 

3. Verify Water pump de-activate when moisture crosses the damp
   threshold 

4. Verify periodic 

---

## Busting out the Tasks

This is the point that we start moving from the user POV to the
development side of the project. We are going to start breaking out
the above requirements and acceptance test into high level tasks that
I will need to develop.

We will still use high level language and not yet get into actual
programming languages, libraries or software systems. As matter of
fact this level of breaking out tasks could applied to just about any
hardware, language or sub-systems.


### Find a Soil Moisture Sensor

{{% requirement "Soil Moisture Levels" %}}

___TODO: point to article about soil moisture sensors___

We are going to need some type of sensor that we stick in soil to read
the level of moisture in the soil. The _soil moisture sensor_ we
choose comes from the wonderful 
[Adafruit's I2C Capacitive Moisture Sensor](https://www.adafruit.com/product/4026?gad_source=1&gclid=EAIaIQobChMI-s7HkoWKiQMVIwqtBh29dBKFEAQYASABEgLzl_D_BwE)

{{% /requirement %}}

### Find a Pump to send water

___TODO show the pump we picked___ and how to wire it up

### Turn Pump on and Off

___TODO GPIO library to control pump___

### Read Data from Soil Moisture Sensor

For this particular sensor we are going to read data from it using
and I2C data bus.  You can read about I2C here and look at the I2C
Adafruit driver we wrote HERE:

___TODO: pointer to I2C article___

___TODO: pointer to our Adafruit SeeSaw library driver___. 

### Timer to periodically read data

We are going to need a driver to periodically read data from the I2C
driver. 

___TODO: pointer to our article with Go timers___

### Local Storage

We are going to cache this data locally for the Soil Moisture data. 

___TODO: create an article about data models___


### MQTT Data Broadcast

We are going to _publish_ the _soil moisture data_ via MQTT and the
channels, the moisture data will then subscribe to the published data
to determine when to turn on and off the pump.

A subscriber will also record the data levels in a time series data
base of sorts.

___TODO: pointer to MQTT article___

### Configuration variables

We need configuration variables for the following tasks:

1. Frequency to read soil moisture data
2. The dry water mark
3. The damp water mark 
4. Location to store local data
5. MQTT channel to advertise data on

## Adding tasks to our Kanban Board

We are now ready to add our tasks to our todo list. We will also add
our _acceptance tests_ as part of our todo list.

This bring us to our next major article about
[Kanban boards](/software/kanban) and todo
lists. 
