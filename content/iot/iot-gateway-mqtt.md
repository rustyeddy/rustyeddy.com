---
title: "Adding MQTT to the IoT Gateway"
date: 2022-03-29
description: >
  How the OttO IoT gateway uses MQTT to receive telemetry from device
  stations, parse topic-based sensor identifiers, pass readings through
  Go channels, and protect the gateway from unbounded in-memory growth.
tags: ["MQTT", "Go", "IoT Gateway", "Edge Computing"]
categories: ["IoT Systems", "Edge Computing"]
git: https://github.com/rustyeddy/otto
summary: "A practical MQTT implementation note for the OttO IoT gateway, covering topic design, subscriptions, callbacks, testing, and memory boundaries."
---

MQTT is the device-facing message boundary for the OttO IoT gateway.
Collection stations publish sensor readings. Control stations subscribe
to command topics. OttO sits in the middle, receives telemetry, updates
its local state, and makes that state available to REST and WebSocket
clients.

## Why This Matters

MQTT is the boundary that keeps devices, gateways, dashboards, and storage from
needing to know too much about each other. A good topic model lets telemetry
flow through the system without turning every component into a direct dependency
of every other component.

![IoT Gateway MQTT architecture showing sensor data flowing from collectors through MQTT into the hub](/img/iot-hub-mqtt.png)

This article focuses on the MQTT side of the gateway. For the broader
architecture, see [OttO: A Go-Based IoT Edge Gateway Architecture](/iot/iot-edge-gateway/).

## Why MQTT Fits the Device Boundary

MQTT works well for small device networks because it is simple,
lightweight, and based on publish/subscribe messaging. A collection
station does not need to know which dashboard, database, or application
will consume a reading. It only needs to publish a message to a known
topic.

That separation is useful in an IoT system:

- Devices can publish readings without knowing about HTTP clients.
- The gateway can subscribe to many stations with a small number of
  topic filters.
- Control stations can listen for command messages without exposing an
  HTTP server.
- Test tools can publish fake sensor readings without running real
  hardware.

MQTT does not replace the gateway. It gives devices a compact messaging
protocol, while OttO provides the application boundary around that
message stream.

![MQTT publish-subscribe architecture showing publishers, broker, topics, and subscribers](/img/mqtt-overview.drawio.png)

## MQTT Architecture

MQTT has three primary roles:

- **Publisher**: a client that sends a message to a topic.
- **Broker**: the server that receives messages and routes them.
- **Subscriber**: a client that receives messages matching a topic
  filter.

In the garden project, a collection station is a publisher, the MQTT
broker routes the message, and OttO is a subscriber. For command flows,
OttO can publish commands and a control station can subscribe to them.

That pattern keeps each component small. Devices do not call the REST
API. The dashboard does not subscribe directly to raw device topics.
The gateway translates between device messages and application-facing
interfaces.

## Topic Design Is API Design

MQTT topics look informal because they are just strings, but they become
an API as soon as more than one component depends on them. Treat them
with the same care as REST paths or event names.

A simple telemetry topic shape for this project is:

```text
ss/data/{stationid}/{sensorid}
```

For example, a station with ID `10.11.4.22` publishing a Fahrenheit
temperature reading can use:

```text
ss/data/10.11.4.22/tempf
```

This topic tells OttO three things:

- `ss` identifies the sensor-station namespace.
- `data` identifies this as telemetry.
- `10.11.4.22` identifies the station.
- `tempf` identifies the sensor.

The topic should carry routing and identity information. The payload
should carry the reading. Avoid hiding too much meaning in positional
segments, and document the topic scheme before adding more devices.

Good topic contracts answer these questions:

- Which component owns this topic namespace?
- Which topic segments are stable identifiers?
- What payload format is expected?
- How are new versions introduced?
- What should happen when an unknown topic is received?

The broader device-to-cloud article covers this boundary in more depth:
[IoT System Architecture: Device to Cloud](/iot/iot-system-architecture-device-to-cloud/).

## Connecting from Go

OttO uses the Eclipse Paho MQTT client for Go:

```bash
go get github.com/eclipse/paho.mqtt.golang
```

A small gateway should make the broker address configurable. During
local development it might be `localhost`; in a deployed environment it
may be a broker running elsewhere on the network.

```go
package main

import (
    "flag"
    "log"

    mqtt "github.com/eclipse/paho.mqtt.golang"
)

type Config struct {
    Broker string
    ClientID string
}

var config = Config{}

func init() {
    flag.StringVar(&config.Broker, "broker", "tcp://localhost:1883", "MQTT broker URL")
    flag.StringVar(&config.ClientID, "client-id", "otto-gateway", "MQTT client ID")
}

func connectMQTT() mqtt.Client {
    opts := mqtt.NewClientOptions()
    opts.AddBroker(config.Broker)
    opts.SetClientID(config.ClientID)

    client := mqtt.NewClient(opts)
    token := client.Connect()
    token.Wait()
    if err := token.Error(); err != nil {
        log.Fatal(err)
    }

    return client
}
```

The important design point is not the exact flag package usage. The
important point is that broker configuration belongs outside the device
message handler so the gateway can move between development, lab, and
field deployments.

## Subscribing to Sensor Data

MQTT supports wildcards in subscription filters. The `+` wildcard
matches exactly one topic segment, so OttO can subscribe to telemetry
from every station and sensor with one filter:

```text
ss/data/+/+
```

A subscription can bind that filter to a callback:

```go
func subscribeData(client mqtt.Client, handler mqtt.MessageHandler) error {
    token := client.Subscribe("ss/data/+/+", 0, handler)
    token.Wait()
    return token.Error()
}
```

That callback receives every matching message. It is responsible for
validating the topic, extracting identifiers, and handing the reading to
the rest of the gateway.

```go
type Reading struct {
    StationID string
    SensorID  string
    Payload   []byte
    Received  time.Time
}

func dataHandler(readings chan<- Reading) mqtt.MessageHandler {
    return func(client mqtt.Client, msg mqtt.Message) {
        parts := strings.Split(msg.Topic(), "/")
        if len(parts) != 4 || parts[0] != "ss" || parts[1] != "data" {
            log.Printf("ignoring unexpected topic %q", msg.Topic())
            return
        }

        reading := Reading{
            StationID: parts[2],
            SensorID:  parts[3],
            Payload:   append([]byte(nil), msg.Payload()...),
            Received:  time.Now(),
        }

        readings <- reading
    }
}
```

The callback should stay small. It should validate and enqueue the
message quickly, then return control to the MQTT client. Parsing,
storage, API updates, and control decisions can happen in gateway code
that consumes from the channel.

## Passing Readings Through the Gateway

A Go channel is a useful boundary between the MQTT callback and the rest
of the gateway. The callback writes readings into the channel; a gateway
worker reads from the channel and updates state.

```go
func runCache(readings <-chan Reading, cache *Cache) {
    for reading := range readings {
        cache.Add(reading)
    }
}
```

That division keeps protocol handling separate from state management.
It also makes the system easier to test: test code can publish MQTT
messages through a broker, or it can send `Reading` values directly into
the cache worker.

## Internal Data Model

The gateway stores recent data by station and sensor. Conceptually, the
shape looks like this:

```goat
   +----------+       +---------+
   | station1 |--+--> | sensor1 | --> [ reading1, reading2, ... ]
   +----------+  |    +---------+
                 |
                 |    +---------+
                 +--> | sensor2 | --> [ reading1, reading2, ... ]
                      +---------+

   +----------+
   | station2 | --> ...
   +----------+
```

That structure makes lookup straightforward for the REST API: clients
can ask for one station, one sensor, or a bounded range of readings.
The companion REST article covers that client-facing boundary:
[Adding the REST API to IoT Gateway](/iot/iot-gateway-rest/).

## Memory and Backpressure

An MQTT gateway must be explicit about memory. If every reading is kept
forever, memory grows with the number of stations, the number of
sensors, and the publish rate.

A proof-of-concept gateway can use an in-memory cache, but it still
needs limits:

- Keep only the most recent `N` readings per sensor.
- Drop or overwrite old readings when a sensor reaches its limit.
- Use buffered channels intentionally, not as an accidental infinite
  queue.
- Measure dropped messages, queue depth, and cache size.
- Move durable history to a database when historical analysis becomes a
  product requirement.

A bounded per-sensor ring buffer is often enough for live dashboards and
short local queries. Durable storage is a separate backend concern. The
edge gateway should keep enough state to operate locally, but it should
not become an unbounded time-series database by accident.

Backpressure deserves the same attention. If the cache worker cannot
keep up with the MQTT callback, the system needs a policy: block, drop,
sample, or fail visibly. Silent queue growth is the worst option because
it hides the problem until the gateway runs out of memory.

## Testing with MQTT Tools

MQTT is easy to test because tools can stand in for device stations.
The `mosquitto_pub` command can publish a fake reading into the same
topic path used by a real collection station:

```bash
mosquitto_pub -t ss/data/10.11.1.11/tempf -m 98.6
```

OttO should receive the message, parse `10.11.1.11` as the station ID,
parse `tempf` as the sensor ID, and store `98.6` as the reading payload.

![Terminal logs showing mosquitto_pub publishing sensor data and the IoT Hub receiving and parsing it](/img/screen-shot-hub-data.png)

This kind of system test is valuable because it exercises the external
contract. The test does not need to know about gateway internals. It
only needs a broker, a topic, a payload, and an observable result from
the gateway.

## Common Pitfalls

### Topic Paths Without Ownership

If every device invents its own topic path, the gateway becomes a pile
of special cases. Define the namespace and keep it stable.

### Payloads Without Versioning

Plain numeric payloads are fine for early tests, but richer payloads
need a versioned shape. A JSON payload with explicit fields is easier to
extend than a positional string format.

### Blocking Inside the Callback

The MQTT callback should not do expensive work. Validate the message,
copy the payload if needed, enqueue it, and return.

### Unbounded Local State

A live dashboard cache is not the same thing as durable storage. Put a
limit on in-memory readings and add a real storage layer when the system
needs history.

## Where This Fits

MQTT is one boundary in the larger system. The related articles show the
rest of the path:

- [OttO: A Go-Based IoT Edge Gateway Architecture](/iot/iot-edge-gateway/)
- [IoT System Architecture: Device to Cloud](/iot/iot-system-architecture-device-to-cloud/)
- [Adding the REST API to IoT Gateway](/iot/iot-gateway-rest/)
- [Self-Watering Garden: An IoT Architecture Case Study](/iot/self-watering-garden/)
