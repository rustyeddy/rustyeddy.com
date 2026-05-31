---
title: "REST APIs for IoT Gateways: Control, Configuration, and Telemetry Access"
date: 2022-03-30
description: >
  How the OttO IoT gateway exposes sensor state through a Go REST API,
  why HTTP is the application boundary for dashboards and tools, and
  what to avoid when turning internal device data into public responses.
categories:
  - iot-gateway
tags: ["Go", "HTTP", "REST", "IoT Gateway", "API Design"]
git: https://github.com/rustyeddy/otto
summary: "A practical REST API design note for IoT gateways, covering Go handlers, JSON responses, endpoint boundaries, testing, and common API pitfalls."
---

MQTT is a good device boundary for the OttO gateway, but it is not the
right interface for every client. Dashboards, admin tools, tests, and
backend services usually need a request/response API with stable JSON
responses.

That is the role of the REST API. It turns recent gateway state into an
HTTP interface that other software can query without knowing how the
gateway stores readings internally or how devices publish messages.

This article is the companion to
[Adding MQTT to the IoT Gateway](/iot/iot-gateway-mqtt/). MQTT brings
telemetry into the gateway. REST exposes selected state back out.

## Why This Matters

An IoT gateway sits between two very different worlds.

On the device side, messages are small, asynchronous, and topic based.
A collection station publishes a reading and moves on. A control station
subscribes to a command topic and acts when a command arrives.

On the application side, clients usually ask direct questions:

- Which stations are known?
- What sensors does this station report?
- What is the latest reading for this sensor?
- What data is available for this time range?
- What configuration is active for this zone?

A REST API gives those clients a stable boundary. It should expose the
concepts the application needs, not the private structs the gateway uses
internally.

## What REST Should Do in an IoT Gateway

For OttO, REST is useful for three broad categories.

### Telemetry Access

Clients need a way to fetch current and recent readings. A dashboard may
show the latest soil moisture value. A test may assert that a published
MQTT message became visible through the API.

### Configuration Access

A gateway often owns local configuration: station names, sensor labels,
zone thresholds, broker settings, or retention limits. REST can expose
configuration reads and controlled updates.

### Control and Diagnostics

Some operations are not raw device commands but gateway-level actions:
health checks, cache inspection, version reporting, or diagnostic state.
These are natural HTTP endpoints.

Device commands can also be represented through HTTP, but the API should
make the command model explicit. A REST request may create a command;
the gateway may then publish that command to MQTT.

## Endpoint Shape

A small gateway API might start with endpoints like these:

```text
GET /api/v1/stations
GET /api/v1/stations/{station_id}
GET /api/v1/stations/{station_id}/sensors/{sensor_id}/readings
GET /api/v1/readings?station_id={station_id}&sensor_id={sensor_id}&start={start}&end={end}
GET /api/v1/health
```

The important point is not the exact route names. The important point is
that each endpoint has a clear owner and a stable response shape.

Avoid exposing routes that mirror whatever internal map or slice happens
to exist in the current Go implementation. The API should describe the
system from the client perspective.

## A Minimal Go Handler

Go's `net/http` package is enough to expose a small REST API. A handler
receives a request, validates it, reads gateway state, and writes a
response.

```go
package main

import (
    "encoding/json"
    "log"
    "net/http"
    "time"
)

type Reading struct {
    StationID string    `json:"station_id"`
    SensorID  string    `json:"sensor_id"`
    Time      time.Time `json:"time"`
    Value     float64   `json:"value"`
}

type Server struct {
    Cache *Cache
}

type Cache struct {
    readings []Reading
}

func NewCache() *Cache {
    return &Cache{readings: []Reading{}}
}

func (c *Cache) Latest() []Reading {
    return c.readings
}

func health(w http.ResponseWriter, r *http.Request) {
    w.Header().Set("Content-Type", "application/json")
    json.NewEncoder(w).Encode(map[string]string{"status": "ok"})
}


func (s *Server) latestReadings(w http.ResponseWriter, r *http.Request) {
    if r.Method != http.MethodGet {
        http.Error(w, "method not allowed", http.StatusMethodNotAllowed)
        return
    }

    readings := s.Cache.Latest()

    w.Header().Set("Content-Type", "application/json")
    if err := json.NewEncoder(w).Encode(readings); err != nil {
        log.Printf("encode readings: %v", err)
    }
}

func main() {
    server := &Server{Cache: NewCache()}

    mux := http.NewServeMux()
    mux.HandleFunc("/api/v1/readings/latest", server.latestReadings)
    mux.HandleFunc("/api/v1/health", health)

    log.Fatal(http.ListenAndServe(":8011", mux))
}
```

This example leaves out the MQTT setup so the HTTP boundary is easy to
see. In the real gateway, MQTT workers update the cache while HTTP
handlers read from it.

## JSON Response Design

JSON encoding in Go is straightforward, but the response type still
needs care. The JSON shape becomes part of the API contract.

A response like this is easy for clients to consume:

```json
{
  "readings": [
    {
      "station_id": "station-01",
      "sensor_id": "tempf",
      "time": "2022-04-09T20:04:55Z",
      "value": 72.3
    }
  ]
}
```

Prefer explicit fields over raw internal structures. For example,
`station_id` and `sensor_id` are clearer than forcing the client to
reverse-engineer nested maps. If the internal cache changes, this JSON
response can stay stable.

A wrapper object also gives the API room to grow. Later versions can add
pagination, units, or metadata without changing the top-level response
from an array to an object.

## Handlers as Boundaries

A Go HTTP handler should be thin, but it still has important
responsibilities:

- Validate the HTTP method.
- Parse path and query parameters.
- Check authorization when the endpoint requires it.
- Ask the application layer for the requested data.
- Return a stable response or a useful error.

The handler should not know how MQTT topics are parsed. It should not
reach into device-specific code. It should call gateway services that
already represent station, sensor, reading, and command concepts.

That division keeps HTTP as an application boundary rather than a thin
wrapper around internal memory.

## Testing with curl

The API can be tested with ordinary HTTP clients. A simple health check
might look like this:

```bash
curl http://localhost:8011/api/v1/health
```

A data query might look like this:

```bash
curl 'http://localhost:8011/api/v1/readings?station_id=station-01&sensor_id=tempf'
```

A useful system test combines MQTT and REST:

1. Publish a fake reading with `mosquitto_pub`.
2. Wait for the gateway to process it.
3. Fetch the reading through the REST API.
4. Assert that the station, sensor, value, and timestamp are present.

```bash
mosquitto_pub -t ss/data/station-01/tempf -m 72.3
curl 'http://localhost:8011/api/v1/readings?station_id=station-01&sensor_id=tempf'
```

![Terminal screenshot showing OttO gateway logs, mosquitto_pub test data, and curl fetching REST API JSON](/img/iothub-curl.png)

That test exercises the public behavior of the gateway without coupling
the test to private Go data structures.

## Security and Access Control

A local prototype can start without authentication, but that should be a
conscious limitation, not an accidental omission.

REST endpoints can expose current sensor state, device names, local
network details, and eventually control operations. Any endpoint that
changes configuration or creates commands needs explicit access control
before it is exposed beyond a trusted development network.

At minimum, decide which endpoints are:

- Public health checks.
- Local-only diagnostics.
- Authenticated reads.
- Authenticated writes or commands.

Those categories should be visible in route design and deployment
configuration.

## Common Pitfalls

### Unversioned Endpoints

Routes such as `/api/data` are fine for a first sketch, but they become
hard to change once clients depend on them. A versioned prefix such as
`/api/v1` gives the project a controlled migration path.

### No Authentication Boundary

It is easy to build a useful local API and accidentally expose it too
widely. Treat write operations, command creation, and configuration
changes as privileged from the start.

### Unstable Response Shapes

Returning a raw Go map may be convenient, but it leaks implementation
details. Define response structs for the API and keep them stable even
when the internal cache changes.

### Leaking Internal Structs

Internal structs often contain fields that are convenient for the
program but awkward or unsafe for clients. API responses should contain
only the fields clients need, named from the client's point of view.

### Treating REST as Device Messaging

REST is not a replacement for MQTT in this architecture. HTTP works well
for queries, configuration, diagnostics, and user-initiated operations.
MQTT remains the better fit for device telemetry and asynchronous
commands.

## Where This Fits

The REST API is one layer in the larger gateway design:

- [Adding MQTT to the IoT Gateway](/iot/iot-gateway-mqtt/) covers the
  device messaging boundary.
- [OttO: A Go-Based IoT Edge Gateway Architecture](/iot/iot-edge-gateway/)
  describes the gateway responsibilities.
- [IoT System Architecture: Device to Cloud](/iot/iot-system-architecture-device-to-cloud/)
  explains how the gateway fits into a broader system.
- [Self-Watering Garden: An IoT Architecture Case Study](/iot/self-watering-garden/)
  shows the gateway in an end-to-end project.
