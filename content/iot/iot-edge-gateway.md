---
title: "OttO: A Go-Based IoT Edge Gateway Architecture"
date: 2022-01-13
description: "How the OttO edge gateway in Go splits MQTT for device telemetry from REST and WebSockets for clients, and the limits that keep an edge gateway safe."
git: https://github.com/rustyeddy/otto
weight: 10
tags: ["IoT Architecture", "IoT Gateway", "Go", "MQTT", "REST"]
categories: ["IoT Systems", "Edge Computing"]
summary: "The OttO edge gateway: MQTT as the device boundary, REST and WebSockets as the application boundary, and the limits that keep an edge process healthy."
aliases:
  - /iot/iot-gateway-mqtt/
  - /iot/iot-gateway-rest/
---

[OttO](/projects/otto/) is the edge gateway for the Organic Gardener IoT
project. It sits between small device stations and the software that needs
their data: dashboards, REST clients, control logic, and eventually backend
services. In the [five-layer IoT model](/iot/iot-system-architecture-explained/)
it is the edge runtime layer.

This page is for the engineer or lead deciding what an edge gateway should
own. It covers the two boundaries that matter most, MQTT facing the devices
and HTTP facing the applications, and the limits that keep a gateway from
becoming a fragile monolith at the edge.

Older versions of this project used a few names interchangeably: _IoT Hub_,
_IoTe gateway_, _smart hub_, and _OttO_. Here **OttO** is the gateway
implementation, **IoT Hub** is the role it plays, and **Organic Gardener** is
the irrigation application that uses it.

![IoT Hub service architecture showing MQTT input, REST API, WebSocket dashboard, and in-memory data cache](/img/iothub.png)

## Why This Matters

Small IoT projects often start with one sensor, one script, and one hard-coded
destination. That works until the system needs a second sensor type, a
dashboard, a command path, a test harness, or a different network layout.

A gateway gives the system a stable middle layer. Devices stay small.
Applications talk to a clean API. The project can change its hardware,
dashboard, storage, or backend without rewriting every other piece at the same
time.

For Organic Gardener, irrigation control should not be buried inside a sensor
node. The gateway compares recent moisture readings, applies zone rules,
publishes commands, and shows the result to a person. The collection station
senses, the control station switches equipment, and OttO coordinates the two.

## The Gateway Then and Now

The gateway described on this page is the original OttO design, first built in
2022: stations publish to `ss/data/...` topics, the gateway caches readings in
memory, and it serves REST routes and a WebSocket dashboard.

OttO has since been reworked. As of
[otto@09836d0](https://github.com/rustyeddy/otto/tree/09836d0), the active code
wires typed devices to MQTT through a registry. Each device gets its own
`state`, `set`, `event`, `status`, and `meta` topics under
`{prefix}/devices/{name}/`, the registry keeps the latest state of each device,
and a small rules package runs edge automation. The old station server, REST
data routes, and WebSocket code are archived in the repo while the runtime is
rebuilt, and the HTTP server currently serves only a log endpoint.

The boundaries and pitfalls below apply to both versions. Where a route or
topic is specific to the 2022 gateway, the text says so.

## What OttO Does

An IoT gateway has one main job: make a messy physical environment look like a
coherent software system.

Collection stations publish telemetry such as soil moisture, temperature, and
humidity. Control stations wait for commands that switch equipment. Clients
need a stable way to read state, inspect recent data, and issue commands
without knowing every device detail.

The gateway provides that boundary:

- Subscribes to MQTT telemetry from collection stations.
- Parses station and sensor identifiers from topics.
- Holds recent readings in a bounded in-memory cache.
- Serves a REST API for current and recent values.
- Streams updates to browser dashboards over WebSockets.
- Hosts the application logic that coordinates sensors and actuators.

A typical flow:

1. A collection station samples a sensor.
2. The station publishes the reading to an MQTT topic.
3. OttO receives the message and extracts the station and sensor IDs.
4. OttO stores the reading in its local cache.
5. REST clients request current state; dashboards receive live updates.
6. Application logic publishes a control message when action is needed.

That makes the gateway more than a protocol adapter. It is the edge runtime
where device data becomes application state.

## Runtime Architecture

OttO is written in Go and uses a small set of standard building blocks:

- Go's `net/http` server for the REST API and dashboard assets.
- The [Eclipse Paho](https://github.com/eclipse/paho.mqtt.golang) MQTT client
  for telemetry and command topics.
- WebSockets for live dashboard updates.
- Goroutines and channels between protocol handlers and gateway state.
- In-memory structures for recent telemetry.

It is light enough to run on a Raspberry Pi while using the same patterns that
work in larger backend systems. Broker address and client ID come from
configuration, not code, so the same binary moves between a laptop, the lab,
and the garden.

![Raspberry Pi single-board computer suitable for running the IoT Hub](/img/rpi.jpg)

## MQTT: The Device Boundary

MQTT faces the devices. It is lightweight publish/subscribe messaging: a
publisher sends a message to a topic, a broker routes it, and every subscriber
whose filter matches receives it. A collection station does not need to know
which dashboard, database, or rule will consume its reading.

In the garden, a collection station publishes, the broker routes, and OttO
subscribes. For commands the direction reverses: OttO publishes and a control
station subscribes. Devices never call the REST API, and the dashboard never
subscribes to raw device topics. The gateway translates between the two.

That separation pays off in testing too. A command-line tool can publish fake
readings to the same topics a real station uses, with no hardware attached.

![IoT Gateway MQTT architecture showing sensor data flowing from collectors through MQTT into the hub](/img/iot-hub-mqtt.png)

### Topic Design Is API Design

MQTT topics look informal because they are just strings, but they become an
API as soon as more than one component depends on them.

The 2022 gateway used this telemetry shape:

```text
ss/data/{stationid}/{sensorid}
```

So a station at `10.11.4.22` publishing a Fahrenheit temperature used
`ss/data/10.11.4.22/tempf`: `ss` is the sensor-station namespace, `data` marks
telemetry, then the station and the sensor. The topic carries routing and
identity. The payload carries the reading.

The current OttO scheme moves identity from stations to devices and gives each
device a fixed set of topics, with JSON payloads:

```text
{prefix}/devices/{name}/state    published by the device
{prefix}/devices/{name}/set      commands to the device
{prefix}/devices/{name}/event
{prefix}/devices/{name}/status   online or offline
{prefix}/devices/{name}/meta     kind, unit, access, range
```

Either way, a topic contract should answer these questions before a second
device depends on it:

- Which component owns this namespace?
- Which segments are stable identifiers?
- What payload format is expected, and how is it versioned?
- How are new versions introduced?
- What happens when an unknown topic arrives?

### Subscribing Without Blocking

The `+` wildcard matches exactly one topic segment, so one filter,
`ss/data/+/+`, covers every station and sensor. The callback bound to it should
validate the topic, copy what it needs, hand the reading off, and return:

```go
func subscribeData(client mqtt.Client, readings chan<- Reading) error {
    token := client.Subscribe("ss/data/+/+", 0, func(_ mqtt.Client, msg mqtt.Message) {
        parts := strings.Split(msg.Topic(), "/")
        if len(parts) != 4 || parts[0] != "ss" || parts[1] != "data" {
            log.Printf("ignoring unexpected topic %q", msg.Topic())
            return
        }

        r := Reading{
            StationID: parts[2],
            SensorID:  parts[3],
            Payload:   append([]byte(nil), msg.Payload()...),
            Received:  time.Now(),
        }

        select {
        case readings <- r:
        default:
            dropped.Add(1) // queue full: drop and count, never block the client
        }
    })
    token.Wait()
    return token.Error()
}
```

The channel is the boundary between protocol handling and gateway state. A
worker on the other side updates the cache, so tests can either publish
through a real broker or send `Reading` values straight to the worker.

The current OttO code applies the same rule in the other direction: a command
arriving on a `set` topic is delivered to the device with a timeout, two
seconds by default, so a stuck device cannot wedge the MQTT callback path.

### Memory and Backpressure

If every reading is kept forever, memory grows with stations, sensors, and
publish rate until the gateway falls over. An in-memory cache is fine for live
dashboards and short local queries, but it needs limits:

- Keep only the most recent `N` readings per sensor and drop the oldest.
- Size buffered channels on purpose, not as an accidental infinite queue.
- Measure dropped messages, queue depth, and cache size.
- Move durable history to a database when historical analysis becomes a
  requirement.

```go
func (c *Cache) Add(r Reading) {
    c.mu.Lock()
    defer c.mu.Unlock()
    key := r.StationID + "/" + r.SensorID
    rs := append(c.data[key], r)
    if len(rs) > c.limit {
        rs = rs[len(rs)-c.limit:]
    }
    c.data[key] = rs
}
```

When the worker cannot keep up, the gateway needs a policy: block, drop,
sample, or fail visibly. The snippet above drops and counts. Silent queue
growth is the worst option, because it hides the problem until the gateway
runs out of memory.

## REST: The Application Boundary

Dashboards, admin tools, tests, and backend services ask direct questions.
Which stations are known? What is the latest reading for this sensor? What
data exists for this time range? What configuration is active for this zone?
They need request/response semantics and stable JSON, not a subscription to
raw device topics.

REST in the gateway covers three kinds of work:

- **Telemetry access:** current and recent readings, so a dashboard can show
  the latest soil moisture and a test can assert that a published message
  became visible.
- **Configuration:** station names, sensor labels, zone thresholds, broker
  settings, and retention limits, with controlled updates.
- **Control and diagnostics:** health, version, cache inspection, and
  user-initiated commands. A REST request can create a command, and the
  gateway then publishes it to MQTT, so the command model stays explicit.

### Endpoint Shape

The 2022 gateway exposed unversioned routes such as `GET /stations`,
`GET /station/{stationid}`, and `GET /data?stationid=...&sensor=...`. They
worked, and they are exactly the routes that get hard to change once clients
depend on them. A versioned shape gives the project a migration path:

```text
GET /api/v1/stations
GET /api/v1/stations/{station_id}
GET /api/v1/readings?station_id={station_id}&sensor_id={sensor_id}&start={start}&end={end}
GET /api/v1/health
```

The route names matter less than this rule: describe the system from the
client's point of view, not whatever map or slice the Go code happens to use
today.

### Thin Handlers, Stable Responses

A handler validates the method and parameters, asks the gateway for data, and
returns a response type defined for the API:

```go
type ReadingsResponse struct {
    Readings []ReadingJSON `json:"readings"`
}

func readingsHandler(cache *Cache) http.HandlerFunc {
    return func(w http.ResponseWriter, r *http.Request) {
        if r.Method != http.MethodGet {
            http.Error(w, "method not allowed", http.StatusMethodNotAllowed)
            return
        }
        station := r.URL.Query().Get("station_id")
        sensor := r.URL.Query().Get("sensor_id")
        if station == "" || sensor == "" {
            http.Error(w, "station_id and sensor_id are required", http.StatusBadRequest)
            return
        }

        resp := ReadingsResponse{Readings: []ReadingJSON{}}
        for _, rd := range cache.Get(station, sensor) {
            resp.Readings = append(resp.Readings, ReadingJSON{
                StationID: rd.StationID,
                SensorID:  rd.SensorID,
                Time:      rd.Received,
                Value:     string(rd.Payload),
            })
        }

        w.Header().Set("Content-Type", "application/json")
        if err := json.NewEncoder(w).Encode(resp); err != nil {
            log.Printf("encode readings: %v", err)
        }
    }
}
```

The wrapper object is deliberate. A later version can add pagination, units,
or metadata without changing the top-level response from an array to an
object, and the internal cache can change without the JSON changing. The
handler knows nothing about topic parsing or device code.

### Access Control

A local prototype can start without authentication, but that should be a
conscious limitation. Endpoints expose sensor state, device names, local
network details, and eventually control operations. Decide early which routes
are public health checks, local-only diagnostics, authenticated reads, and
authenticated writes or commands, and make that visible in route design and
deployment.

## WebSockets for Live Dashboards

REST suits request and response. Dashboards want live updates as readings
arrive. The 2022 gateway pushed new telemetry to connected browsers over
WebSockets, so the dashboard did not poll the REST API, and browser code never
connected to the MQTT broker directly. In Organic Gardener that gives a live
view of moisture, zone state, and control behavior while the gateway keeps
processing MQTT traffic in the background.

## Testing From the Outside

Because both boundaries are external contracts, the most useful system test
uses only external tools:

```bash
mosquitto_pub -t ss/data/10.11.1.11/tempf -m 98.6
curl 'http://localhost:8011/api/v1/readings?station_id=10.11.1.11&sensor_id=tempf'
```

The gateway should parse `10.11.1.11` as the station and `tempf` as the sensor,
store `98.6`, and return it with a timestamp. The test needs a broker, a topic,
a payload, and an HTTP response, and nothing about gateway internals.

![Terminal screenshot showing OttO gateway logs, mosquitto_pub test data, and curl fetching REST API JSON](/img/iothub-curl.png)

## Current State and Boundaries

OttO is an edge gateway and reference runtime, not a cloud platform. It is
responsible for:

- Receiving telemetry from device stations.
- Keeping recent state close to the devices.
- Exposing that state to local clients.
- Running simple edge decisions that must happen near the devices.

Long-term storage, fleet management, user accounts, alerting, analytics, and
remote updates belong in surrounding services once the project needs them. A
gateway should be strong enough to run the local system and bounded enough
that it does not become a monolith at the edge.

## Common Pitfalls

### The Gateway Does Too Much

Every new feature lands in the gateway because the gateway sees every message.
Keep it to ingestion, local state, protocol translation, and decisions that
must happen near the devices. Reporting, accounts, analytics, and business
workflows belong elsewhere.

### Topics and Payloads Without Contracts

A topic is easy to change while one script publishes to it and hard to change
once sensors, dashboards, tests, and rules rely on it. Plain numeric payloads
are fine for a first test; anything richer needs a versioned JSON shape.

### Blocking Inside the MQTT Callback

Expensive work in the callback stalls message delivery for everything else.
Validate, copy, enqueue, return.

### Unbounded Local State

A live dashboard cache is not durable storage. Without retention limits and a
backpressure policy, a healthy sensor network eventually exhausts memory.

### Unversioned, Unauthenticated, Leaky APIs

Routes like `/api/data` and raw Go maps in responses are convenient until a
client depends on them. Version the routes, define response structs that
expose only what clients need, and treat writes and commands as privileged
from the start.

### Treating REST as Device Messaging

HTTP works well for queries, configuration, diagnostics, and user-initiated
operations. MQTT remains the better fit for telemetry and asynchronous device
commands. Forcing either into the other's job makes both worse.

### Missing Observability

A gateway that fails silently is hard to debug unattended. Make message rates,
subscription status, parse failures, dropped readings, queue depth, cache
size, connected clients, and command outcomes visible through metrics and a
health endpoint, not only logs.

## Where OttO Fits in the Larger System

| Layer | Responsibility | OttO's role |
| --- | --- | --- |
| Device stations | Sense and actuate | Publish telemetry and receive commands |
| MQTT broker | Route device messages | Carries telemetry and command topics |
| OttO gateway | Coordinate edge state | Ingests, caches, exposes APIs, streams updates |
| Application | Decide what should happen | Organic Gardener uses gateway state and commands |
| Backend services | Store, analyze, manage | Optional services beyond the edge runtime |

This is the layered model from
[The Five Layers of a Practical IoT System](/iot/iot-system-architecture-explained/),
with OttO in the edge runtime layer.

## Related Articles

- [The Five Layers of a Practical IoT System](/iot/iot-system-architecture-explained/)
- [Building an IoT Device Abstraction Layer in Go](/iot/building-iot-device-manager-in-go/)
- [ESP32 Collection Station Architecture](/iot/iot-sensor-station/)
- [Self-Watering Garden](/iot/self-watering-garden/)
- [OttO: IoT Edge Runtime](/projects/otto/)
