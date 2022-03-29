---
title: Adding MQTT to the IoT Gateway
date: 2021-11-04
description: >
  This is the first milestone of our IoT project, to create the
  IoT gateway and have it collect environmental sensor data by
  subscribing to MQTT. The data will be cached and indexed in memory
  for quick access when we add the REST API.
category: iot-gateway
weight: 200
draft: true
---

## Get Ready To _Go_

The IoT Hub was written in the _Go_ programming language. In a nutshell, 
_Go_ is an excellent programming langauge for this project. 

A couple immediate features that I love about Go does bring with it include the
fact that it is a _compiled_ language making the executable binaries:

1. Self contained with no external libraries required. That means you
   can build and transfer a single binary, nothing more required.

2. Go produces very small, efficient and fast programs! Ideal for
   Micro Services and Micro Controllers.

As the project moves forward we will discuss a number of other
interesting aspects of the langauge that we will be taking advantage
of as the needs of the project arise.

Go is very easy to setup. Either follow directions on the 
[Go Website](https://golang.org) or if your on ubuntu you can just run 
the command:

```bash
snap install go --classic
```

Make sure you have go installed by running:

```bash
% go version
go version go1.17.8 linux/amd64
```

## The Main Function 

To get started actually programming let's build a simple hello world
executable, make sure our set up is ready to go before we import our
MQTT library and start accepting external data.

First step is checkout the [IoT Gateway]() repo and write our first
hello, world program like so:

```go
package main

import "fmt"

func main() {
    fmt.Println("Hello, world!")
}
```

Let's run our little program to make sure everything is peachy keen:

```sh
% go mod init github.com/iot-project/iothub
% go mod tidy
% go run .
Hello, World!
```

If everything goes well, and why would it not? We'll see ```Hello,
World!``` printed on our screen. If so fantastic! Let's check this
code in to github for posterity and ready our program for MQTT.

## Importing Paho MQTT 

The IoT Hub will act as an MQTT _subscriber_ and _publisher_ hence
we'll need to _import_ the
[Paho MQTT Go library](https://github.com/eclipse/paho.mqtt.golang)
which turns out to be a piece of cake. We'll add an import statement
to our ```main.go``` file as follows.

To stay organized we are going to add a new file to our _IoT Hub_
program to house our MQTT support. We have a new file _mqtt.go_ which
consists primarily of

{{< gist rustyeddy 482556caef8010b1b0cc266007e9aec6 >}}

We now have MQTT imported and the code ready to connect to an _MQTT
broker_. Since the MQTT Broker may be different from installation to
installation it needs to be configurable, hence we'll add the
```Broker string``` field to the 
[Config Struct](/iot-logs/simple-go-configuration-structure/)

We have MQTT imported and hacked up some code to connect to the _MQTT
Broker_ which can change from deployment to deployment. This being the
case we are going to make the address of the _MQTT broker_ a
_configuration_ variable.

> Note I typically install the Mosquitto MQTT broker on my linux
> hub. However an external, global and/or public broker like
> mqtt.mosquitto.org could also be used.

### MQTT Topics for Network and Data Channels

The IoT-Hub in it's first version will of course collect
_environmental_ data including _temprature_, _humidity_, _soil
moisture_ and _luminesence_. 

The values for these individual type of sensors as _MQTT topics_
structured like like a file path:
```ss/data/{:stationid}/{:sensorid}``` where the ```:stationid``` and
```:sensorid``` are variables to be replaced by the values extracted
from the topics path name.

For example a station with an ID ``10.11.4.22`` will publish the
temprature in farehniet with a sensor ID of ```tempf``` results in the
data topic ```ss/data/10.11.4.22/tempf```.

#### MQTT and Wildcards

With the MQTT topic structure defined our client can now subscribe to
the various sensors data from a different stations.

We have a small problem however. When the Hub first starts up, it does
not know the _stationID_ or _sensorID_ of any of the _publishers_ and
their respective _sensors_.

For that reason the Paho MQTT library allows wildcards to be used when
_subscribing_ to _topics_ making it real easy for us subscribe to all
station and sensors with a single subscription.

```go
	hub.Subscribe("data", "ss/data/+/+", dataCB)
```

Where the above call gives our _subscription_ the name "data". The
path ```ss/data/+/+``` contains two wildcards represented with the
```+``` character. The third argument is the _callback_ that will be
invoked everytime a value is _published_ to one of the above topics.

#### MQTT Handling Incoming Data

The _callback_ as final argument in the code snippet above is the
function ```dataCB()``` refer to the ```data.go``` file in the iothub
repository as a reference, however the function is pretty simple:

1. Extract the _stationID_ and _sensorID_ from the MQTT topic
2. Extract the value delivered 
3. Save the timestamp for when the data was recieved
3. Use the stationID and sensorID to index the RAM Cache
4. Store the <timestamp, value> tuple in the RAM Cache

Following this alogrithm our memory is usage is going to increase in
direct proportion to the number of stations, sensors and frequency of
data publications.

> Todo: in the future we'll add configurations that will allow us
> control over how much data to keep in RAM and how long to keep it.

That will be an excersize for later. In the meantime we'll be wary of
running out of memory eventually, this needs to be fixed before
production. 

Until then we'll just put a limit on the number of data points that
can be kept, like say 1,000. 

### MQTT Data Store Structure

When data first arrives we'll arrange in a simple inclusive data
structure called ```Msg``` defined as

```go
type Msg struct {
    StationID   string
    SensorID    string
    time.Timestamp
    Value       interface{}
};

```

The interface value allows for an arbitrary value type. For example
Value can be an integer, floating point or a string formatted as
JSON. 

The ```Msg``` structure is fine for handling the immediate incoming
data and passing it along to a consumer, it is not efficient for
storing in memory for a quick API response.


## Internal Data Model

For this we'll create a more sophisticated data store that is built
from Datapoint tuple <timestamp, value> as a series hanging from a
Sensor which in turn is part of multiple sensors associated with a
Station. 

---

```goat
   +----------+       +---------+
   | station1 |--+--> | sensor1 | --> [ ts1, ts2, ts3, ... ]
   +----------+  |    +---------+
          .      |
          .      |    +---------+
          .      +--> | sensor2 | --> [ ts1, ts2, ts3, ... ]
          .           +---------+
   +----------+
   | station2 |-->
   +----------+
```

---

With this model we can easily adjust the number of _timestamps_
allowed per sensor to limit the amount of memory to be consumed. 

## Testing the Hub

### Go and Unit Tests

Now that we will begin programming, this is a good time to start
writing our supporting tests. Fortunantely _Go_ comes out of the box
with a simple, easy to use but very effective ```testing``` package. 

We won't go into any detail writing _Go unit tests_ a good resource
can be found here: [Go Testing package](https://pkg.go.dev/testing)

The _unit tests_ above can be considered _white box_ tests implying
that the test rig has access to internal data and data structures and
calls internal functions directly to test.

### System Tests with MQTT

System tests, specifically black box tests are _external_ tests run
against the public API. This is one of the beautiful things about
testing protocols like MQTT and HTTP they are inherently _mockable_.

For our testing needs, we'll use the popular ```mosquitto_pub``` MQTT
publishing tool. To demonstrate a quick test of the hub, we will add a
```-debug``` flag to print data as we recieve it.

#### Mocking Collection Stations


We are going to _mock_ a _Collector_ by publishing fake environmental
data using the cool MQTT publishing utility _mosquito_pub_.

```bash
% mosquitto_pub -t ss/data/10.11.1.1/tempf -m 98.6
```

We will fake data from sensor ```tempf``` to topic
```ss/data/10.11.1.11/tempf``` the value of ```98.6``` using the 
following command:

![High Level Sensor Station](/img/screen-shot-hub-data.png)


In the above screen shot ```mosquitto_pub``` published the temperature
in farenhiet to the topic ```ss/data/10.11.1.11/tempf``` where the CS
_station id_ is represented by ```10.11.1.11```. Likewise, the sensorID
is represented by the string ```tempf```. The value passed in 98.6
degrees farenhiet.

We can see the Hub recieving the data and parsing the _stationID_ and
_sensorID_ from the topic string. The data is parsed, formatted and
temporarily saved in RAM. 

When data _periodically_ arrives, the Hub will quickly extract
the following elements of the data point.

- **Station ID** probably in the form of an IP or MAC address
- **Sensor data** name such as: temprature, humidiy, air-pressure, etc
- **Value** this will either be an integer or a float64
- **Timestamp** when the data was sampled.

## HTTP REST Server Next ...

The data is reformatted and stored as a _time-series_ in RAM. Let's
have a look at the REST API that can be used to access the
environmental data.

Now we need a way to get the data out of the Hub with a REST API. This
will requires us to setup an internal Web server and register some
callbacks. 

[Next Stop](/iot-project/iot-qateway-rest)

