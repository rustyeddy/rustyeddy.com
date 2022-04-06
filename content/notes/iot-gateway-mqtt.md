---
title: Adding MQTT to the IoT Gateway
date: 2022-03-29
description: >
  The primary function of an IoT Gateway is moving data from one input
  source (often sensor data) to another output destination (like a
  control algorithm) with some data conversion and storage in
  between. Our first milestone building the IoT Gateway is reading
  data from MQTT then holding it in RAM for the upcoming REST API we
  will build for Milestone 2. 
category: 
  - iot-project
  - iot-gateway
tags: [ mqtt, go ]
git: https://github.com/iot-station/iothub
---

![MQTT Architecture](/img/iot-hub-mqtt.png)

This page marks the beginning of the _Organic Gardner (OG)_ [IoT
Project](/iot-project) Milestone 1 development!  If you want to
program along but have not yet worked with the _Go_ programming
language check this intro: [Getting ready to Go](/get-ready-to-go).

## A Brief About MQTT

[MQTT](https://mqtt.org) is the _messaging_ protocol that a
_Collector_ will use to periodically publish sensor data
(like temperature and humidity) to the _IoT Gateway_. _MQTT_ will also
be used to signal when the _Control Station_ or _Controller_ will
respond to commands to turn a sprinkler pump on or off.

### Why MQTT

MQTT fits nicely into compact hardware and embedded systems where RAM
and compute power are limited. Which is one reason why it is
ubiquitous in the IoT applications.

MQTT is easy to use both programming and operations. It compiles into
a small and fast binary. MQTT is built atop of _TCP_ the Internets
workhorse protocol which also means it is reliable and adapts well to
busy or low bandwidth networks.

---

![MQTT Architecture](/img/mqtt-overview.drawio.png)

---

### MQTT Architecture 

MQTT has three primary components: a _broker_, _publishers_ and
_subscribers_. _Publishers_ send messages to _Brokers_, _Brokers_ then
forward the message to _Subscribers_.

Messages are segregated by _Topics_ that resemble the path hierarchy
of a file-system. For example the _Collector_ sends the current
temperature to the _topic_ ```data/temperature``` and the topic
```data/soil-moisture``` is used for moisture as examples.. 

Similarly the pump for a sprinkler system would subscribed to the topic
```ctl/sprinkler``` waiting for commands to turn a sprinkler on and
off. 

That was just enough description of MQTT to get us started. As the
project progresses we will dive into more detail of MQTT particulars
as they effect our project. Now let's actually add MQTT to the IoT
Gateway as required by the first _Milestone_. 

## Import the Paho MQTT Library

The third party package 
[Paho MQTT Go](https://github.com/eclipse/paho.mqtt.golang) 
is a nice little library that is going to make it easy for us to
subscribe to the appropriate MQTT topics as well as enabling us to
_publish_ commands for the _sprinkler controller_.

First we need to do is import the package directly from it's repository
and with Go nothing could be easier! Just run the following command
from the command line.

```
% go get github.com/eclipse/paho.mqtt.golang
``` 

Second the package must be _imported_ into the application source code
during compile time with the following line of code.

```go
import mqtt "github.com/eclipse/paho.mqtt.golang")
```

As matter of fact here is the entire snippet for importing the MQTT
package and connecting to the MQTT with this code:

{{< gist rustyeddy 482556caef8010b1b0cc266007e9aec6 >}}

We can now connect to a MQTT Broker, which by default will be located
on the same host running our IoT-Gateway (i.e. localhost). However that
may not always be the case, the gateway may need to connect to an
external broker.

For this reason we are going to make the brokers _address_
configurable. This leads us to a brief introduction to the _Go_
builtin _flag_ package allowing us to easily create a command line
argument that is capable of setting the _broker_ configuration
variable. 

### The Configuration Struct

I typically create a struct called ```Configuration``` and a
single global variable (singleton) called ```config``` to house all
the programs configuration variables. Like so:

```go
import (
    "flags"
)

typedef Configuration struct {
    Broker string           `json:"broker"`
}

var (
    config Configuration
)

func init() {
    flags.StringVar(&config.Broker, "broker", "localhost", "Set the MQTT Broker")
}

func main() {
    flags.Parse()
    
    mqtt_init(config.Broker)
}
```

If you would like to read more about the configuration struct as well
as a discussion saving and reading the configuration structure from a
file and a quick introduction to Go's twist on "Object Oriented"
programming check out this article on the
[Go Config Struct](/notes/simple-go-configuration-structure).

Now we have turned the ```config.Broker``` variable into a command
line argument that defaults to ```localhost```. Meaning if we run the
command as:

```
% ./iot-gateway
```

It will automatically connect to the MQTT broker running on
```localhost```. Otherwise we can have our IoT Gateway connect to a
public MQTT broker, for example:

```
% ./iothub -broker mqtt.eclipse.org
```

Now all of the data from the topics we subscribe to will be published
from a Broker in the cloud, possibly even a _global_ broker.

### MQTT Topics for OG

The IoT-Gateway in it's first version will of course collect
_environmental_ data including _temperature_, _humidity_, _soil
moisture_ and _luminescence_ from various sensors scattered about. 

As mentioned earlier _MQTT topics_ are strings with a hiearchal
structure very similar to a files complete path representing the
_directory structure_. We are going to take advantage of this fact and
structure our topics such that we can extract the _StationID_ and
_SensorID_ directly from the topic itself. 

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
symbol_ to capture the _StationID_ and _SensorID_ even though the hub
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

1. Extract the _StationID_ and _SensorID_ from the MQTT topic
2. Extract the value delivered 
3. Save the timestamp for when the data was received
3. Use the StationID and SensorID to index the RAM Cache
4. Send the ```{timestamp, value}``` tuple to the RAM Cache
   consumer[1]. 

The Ram Cache consumer is a _Go routine_ that receives the
incoming _Msg_ over a _channel_. We'll talk about these novel
_Inter-Process Communication_ (IPC) mechanisms supplied by Go when we
add _Websockets_ during the 4th milestone.

Following this algorithm our memory usage is going to increase in
direct proportion to the number of stations, sensors and frequency of
data publications.

> Todo: in the future we'll add configurations that will allow us
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

Data will be _cached_ in RAM with the following format built from
Datapoint tuples ```{timestamp, value}``` as a series hanging from a
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

#### Mocking Collection Stations

This is one of the beautiful things about testing protocols like MQTT
and HTTP they are inherently _mockable_. Additionally with MQTT we'll
use the popular ```mosquito_pub``` MQTT publishing tool to _mock_ our
the Collection Stations (CS) that will eventually develop.

To demonstrate a quick test of the hub we will add a ```-verbose``` flag
to print data it is received. The data is then cached in RAM and made
ready for the _REST API_ coming in the next article (milestone).

All we have to do _mock_ a _Collector_ publishing a the temperature
for example is run the following command:

```
% mosquitto_pub -t ss/data/10.11.1.1/tempf -m 98.6
```

Our IoT-Gateway will pick up the fake data value ```98.6``` from
sensor ```tempf``` extracted from the topic
```ss/data/10.11.1.11/tempf```.

The upper screenshot shows logs from the _IoT Hub_ having just
received it's first data point from MQTT. The lower screen shows the
invocation of the ```mosquitto_pub``` command.

![High Level Sensor Station](/img/screen-shot-hub-data.png)

## Victory! 

In the above screen shot ```mosquitto_pub``` published the temperature
in Fahrenheit to the topic ```ss/data/10.11.1.11/tempf``` where the CS
_station id_ is represented by ```10.11.1.11```. Likewise, the SensorID
is represented by the string ```tempf```. The value passed in 98.6
degrees Fahrenheit.

We can see the Hub receiving the data and parsing the _StationID_ and
_SensorID_ from the topic string. The data is parsed, formatted and
temporarily saved in RAM. 

## HTTP REST Server Next ...

The gateway now receives periodic data from one of more stations, each
with one or more sensors. The data is reformatted and stored as a
_time-series_ in RAM. 

Now it is time build our REST API get the data out of the _MQTT
Gateway_. 

In this next article we are going to import Go's builtin
```net/http``` package to setup our HTTP server that will in turn
handle our _REST Endpoints_.  This same package will later allow us to
serve up the IoT Gateway web app.

[Next Adding the REST API](/iot-project/iot-qateway-rest)

<!--  LocalWords:  JSON IoT SDP mockable
 -->
