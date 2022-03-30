---
title: Adding MQTT to the IoT Gateway
date: 2022-03-29
description: >
  The primary function of an IoT Gateway is moving data from one input
  source to another output destination with some data conversion and
  possible storage in between. Our first milestone building our IoT
  Hub is reading data from MQTT then caching it for the coming REST
  API we will be building in Milestone 2.
category: iot-gateway
---

## Get Ready To _Go_

The IoT Gateway was written in the _Go_ programming language. I won't
get into the reasons why _Go_ is an excellent choice of programming
language for this project other than to point out two advantages this
project will benefit from right away:

### Go is Compiled and easy to distribute

First, Go is a _compiled_ language making the resulting executable
self contained with no external libraries or run time environment to
rebuild, just copy a single binary, that is it.

Unlike Node/JS, Python and other interpreted languages the entire run
time environment must be replicated or recreated everywhere the
program is to be run. With Go a single _binary_ can be transferred
and run with out any additional installation steps, build process or
external dependencies. 

### Go executable are small and fast

A second wonderful advantage Go produces very small and fast programs
that works well on some of the _micro-controllers_ we are going to be
working on such as the _Raspberry Pi_.

As the project moves forward we will discuss a number of other
interesting aspects of the language that we will be taking advantage
of as the needs of the project arise.

### Install The Go Compiler

Go is very easy to setup. Either follow directions on the 
[Go Website](https://golang.org) or if your on Ubuntu you can just run 
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

Let's build a simple ```Hello, world!``` program to make sure our set
up is ready and that we can actually write, compile and run a Go
program. Go is built around packages, every executable must have a
```package main``` and ```main()``` function (similar to C), like
so: 

```go
package main

import "fmt"

func main() {
    fmt.Println("Hello, world!")
}
```

Now run the little program to make sure everything is working as
expected:

```sh
% go mod init github.com/iot-project/iothub
% go mod tidy
% go run .
Hello, World!
```

If all goes well (and why would it not?) we'll see ```Hello,
World!``` printed on our screen. Fantastic! 

Now let's get to reading some MQTT data using the 
[Paho MQTT Go library](https://github.com/eclipse/paho.mqtt.golang).
This nice little library is going to make it easy for us to start
receiving the data we want.

## Importing Eclipse Tahoe MQTT 

We are going to rely on the third party Eclipse Pogo MQTT package for
Go, all we need to do is import the package directly from it's
repository nothing could be easier!

First the package needs to be fetched with

```sh
% go get github.com/eclipse/paho.mqtt.golang
``` 

Second the package must be _imported_ into the application during
compile time with this single line of code.

```go
import mqtt "github.com/eclipse/paho.mqtt.golang")
```

As matter of fact here is the entire snippet for importing the MQTT
package and connecting to the MQTT with this code:

{{< gist rustyeddy 482556caef8010b1b0cc266007e9aec6 >}}

We can now connect to an MQTT Broker, knowing the MQTT Broker may
change from installation to installation we will need to make the
Broker's address a _configuration variable_.

### The Configuration Struct

```Broker string``` field to the 
[Config Struct](/iot-logs/simple-go-configuration-structure) allowing
us to set the Broker address via the command line. By default we
assume the broker is running on Localhost but we can't be sure the
application may call for an MQTT broker in the cloud.

Note I typically install the Mosquito MQTT broker on my Linux
hub. However an external, global and/or public broker like
mqtt.eclipse.org could also be used.

```sh
% ./iothub -broker mqtt.eclipse.org
```

Will cause us to connect to the broker specified in the command line. 

Later we'll see how we can use this Configuration structure to easily
store and retrieve our configuration to and from a JSON formatted
configuration file. 

Meanwhile back to receiving MQTT packets...

### MQTT Topics for Network and Data Channels

The IoT-Gateway in it's first version will of course collect
_environmental_ data including _temperature_, _humidity_, _soil
moisture_ and _luminescence_ from various sensors scattered about. 

_MQTT topics_ are a hiearchal structure very similar to a file path
separated with a slash '/'. For example our environmental data will be
published as _MQTT topics_ structured like this:

```
ss/data/{:stationid}/{:sensorid}
``` 

Where the ```:stationid``` and ```:sensorid``` are variables to be
replaced by the values extracted from the topic path-like strings.

For example a station with an ID ``10.11.4.22`` will publish the
temperature in Fahrenheit with a sensor ID of ```tempf``` results in the
data topic 

```
ss/data/10.11.4.22/tempf
```

#### MQTT and Wildcards

Lucky for us MQTT topics can be subscribed to using the '+' _wildcard
symbol_ to capture the _stationID_ and _sensorID_ even though the hub
did not know about any of these stations or sensors before they were
published by the _Collection Station_.

By subscribing to a single _Topic_ using wildcards we can be ensured
of receiving data from all stations and sensors with the single
call to hub.Subscribe() below:


```go
	hub.Subscribe("data", "ss/data/+/+", dataCB)
```

Where the above call gives our _subscription_ the name "data". The
path ```ss/data/+/+``` contains two wildcards represented with the
```+``` character. The third argument is the _callback_ that will be
invoked every time a value is _published_ to one of the above topics.

Here is the ```Subscribe()``` function from the IoT gateway:

```go
func (s *Hub) Subscribe(id string, path string, f mqtt.MessageHandler) {
	sub := &Subscriber{id, path, f, nil}
	s.Subscribers[id] = sub

	qos := 0
	if token := mqttc.Subscribe(path, byte(qos), f); token.Wait() && token.Error() != nil {
		panic(token.Error())
	} else {
		if config.Verbose {
			log.Printf("subscribe token: %v", token)
		}
	}
	log.Println(id, " subscribed to ", path)
}
```

and the callback function that is invoked every time new data arrives:

```go
// TimeseriesCB call and parse callback data
func dataCB(mc mqtt.Client, mqttmsg mqtt.Message) {
	topic := mqttmsg.Topic()

	// extract the station from the topic
	paths := strings.Split(topic, "/")
	category:= paths[1] 
	station := paths[2]
	sensor  := paths[3]
	payload := mqttmsg.Payload()

	consumers := hub.GetConsumers(category) 
	if consumers == nil {
		log.Println("DataCB no consumers for ", topic)
		return					// nobody is listening
	}

	log.Printf("MQTT Message topic %s - value %s\n", topic, string(payload))
	switch (category) {
	case "data":
		msg := Msg{}
		msg.Station = station
		msg.Sensor = sensor
		msg.Data = payload
		msg.Time = time.Now().Unix()
		for _, consumer := range consumers {
			consumer.GetRecvQ() <- msg
		}

	default:
		log.Println("Warning: do not know how to handle", topic)
	}
}
```


#### MQTT Handling Incoming Data

The _callback_ shown above is pretty simple:

1. Extract the _stationID_ and _sensorID_ from the MQTT topic
2. Extract the value delivered 
3. Save the timestamp for when the data was received
3. Use the stationID and sensorID to index the RAM Cache
4. Send the <timestamp, value> tuple to the RAM Cache consumer[1].

[1] The Ram Cache consumer is a _Go routine_ that receives the
incoming _Msg_ over a _channel_. We'll talk about these novel
_Inter-Process Communication_ (IPC) mechanisms supplied by Go when we
add _Websockets_ during the 4th milestone.
   
Following this algorithm our memory usage is going to increase in
direct proportion to the number of stations, sensors and frequency of
data publications.

> Tod: in the future we'll add configurations that will allow us
> control over how much data to keep in RAM and how long to keep it.

Controlling memory in sophisticated ways is an exercise for
later. Until then we'll just put a limit on the number of data points
that can be kept, like say 1,000 so we don't perpetually run out of
memory before implementing more complex memory controls.

## The Msg Data Structure

Data is reformatted into the following ```Msg``` struct by the
```dataCB()``` callback for every new _datapoint_. The structure is
defined as

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

Data will be _cached_ in RAM with the following format built
from Datapoint tuples <timestamp, value> as a series hanging from a 
Sensor which in turn is part of multiple sensors associated with a
_Collection Station_. 

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

We now have enough code that we can build and test our fledgling
_IoT Gateway_. First we will of course write the obligatory _unit
tests_ we all should be writing as part of our Software Development
Process (SDP) with _Test Driven Design (TDD)_ 

### Go and Unit Tests

We won't go into any detail writing _Go unit tests_ here as there
are plenty of good documentation for writing tests and the best place
to start is the 
[Go Testing package](https://pkg.go.dev/testing)
documentation itself.

The _unit tests_ above can be considered _white box_ tests implying
that the test rig has access to programs internal data structures and 
functions directly for testing.

### System Tests with MQTT

System tests are considered _black box_ and completely _outside_ the
Gateways external _public API_. 

This is one of the beautiful things about testing protocols like MQTT
and HTTP they are inherently _mockable_. Additionally with MQTT we'll
use the popular ```mosquito_pub``` MQTT publishing tool to _mock_ our
the Collection Stations (CS) that will eventually develop.

To demonstrate a quick test of the hub we will add a ```-verbose``` flag
to print data it is received. The data is then cached in RAM and made
ready for the _REST API_ coming in the next article (milestone).


#### Mocking Collection Stations

Thankfully it is very easy to _mock_ a _Collector_ by publishing fake
environmental data using the MQTT publishing utility _mosquito_pub_.

For example, the following command

```bash
% mosquitto_pub -t ss/data/10.11.1.1/tempf -m 98.6
```

will fake the data value ```98.6``` from sensor ```tempf``` extracted
from the topic ```ss/data/10.11.1.11/tempf```. 

The upper screenshot shows logs from the _IoT Hub_ having just
received it's first data point from MQTT. The lower screen shows the
invocation of the ```mosquitto_pub``` command.

![High Level Sensor Station](/img/screen-shot-hub-data.png)

## Victory! 

In the above screen shot ```mosquitto_pub``` published the temperature
in Fahrenheit to the topic ```ss/data/10.11.1.11/tempf``` where the CS
_station id_ is represented by ```10.11.1.11```. Likewise, the sensorID
is represented by the string ```tempf```. The value passed in 98.6
degrees Fahrenheit.

We can see the Hub receiving the data and parsing the _stationID_ and
_sensorID_ from the topic string. The data is parsed, formatted and
temporarily saved in RAM. 

## HTTP REST Server Next ...

The gateway now receives periodic data from one of more stations, each
with one or more sensors. The data is reformatted and stored as a
_time-series_ in RAM. 

Now it is time build our REST API get the data out of the _MQTT
Gateway_. 

In this next article we are going to import Go's builtin _net/http_
package to setup our HTTP server that will in turn handle our _REST
Endpoints_.  This same package will later allow us to serve up the IoT
Gateway web app.

[Next Adding the REST API](/iot-project/iot-qateway-rest)


<!--  LocalWords:  JSON IoT SDP mockable
 -->
