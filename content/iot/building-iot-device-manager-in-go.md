---
title: Building an IoT Device Abstraction Layer in Go
description: >
  How Go interfaces, generics, mocks, and a device manager separate hardware
  drivers from IoT application logic in an edge runtime.
date: 2025-11-02
tags: ["Go", "IoT Devices", "Device Abstraction", "Generics", "Edge Computing"]
categories: ["IoT Systems", "Edge Computing"]
---

IoT applications get hard to maintain when hardware code and application
logic are tangled together. A prototype can read one GPIO pin or one I2C
sensor directly. A real system has sensors, actuators, timing loops, message
publishing, local storage, APIs, dashboards, and failures that happen at the
edge.

The useful boundary is a device abstraction layer: hardware-specific drivers
stay below it, application logic stays above it, and the two communicate
through small interfaces.

This article explains the design behind the device layer used by
[OttO](/projects/otto/), the Go-based IoT edge runtime, and its companion
[devices](https://github.com/rustyeddy/devices) library. Read it as the implementation detail beneath the
[device-to-cloud architecture](/iot/iot-system-architecture-device-to-cloud/).

## The Architecture Boundary

OttO separates the system into three layers:

```text
Application logic
  control loops, MQTT, REST APIs, storage, dashboards
        |
        v
Device manager
  register devices, poll devices, expose state, publish updates
        |
        v
Device abstraction layer
  typed Get/Set interface, mocks, concrete device wrappers
        |
        v
Drivers and hardware
  GPIO, I2C, SPI, UART, ADC, serial ports, sensors, actuators
```

The important decision is not the package layout. The important decision is
where application code stops knowing about hardware details.

A watering rule should not care whether moisture came from an ADC, an I2C
sensor, or a mock. It should care about the value, the error, and the action
to take next.

## The Device Interface

The core abstraction is intentionally small:

```go
type Device[T any] interface {
    ID() string
    Open() error
    Close() error
    Get() (T, error)
    Set(v T) error
}
```

Each device chooses the type it produces or accepts:

- A button can be `Device[bool]`.
- A moisture meter can be `Device[int]`.
- A voltage sensor can be `Device[float64]`.
- An environment sensor can be `Device[Env]`.
- A motor or relay can use `Set` to accept a command value.

For structured readings, the type can be a normal Go struct:

```go
type Env struct {
    Temp     float64
    Humidity float64
    Pressure float64
}
```

Generics are useful here because the device type is captured at compile time.
The application does not need to cast from `any`, parse loosely typed maps, or
wait until runtime to discover that a humidity sensor was treated like a
button.

## Concrete Devices Stay Small

A concrete device wraps the hardware behavior behind the interface. A button
is the simplest example:

```go
type Button struct {
    id    string
    state bool
}

func (b *Button) ID() string { return b.id }

func (b *Button) Open() error  { return nil }
func (b *Button) Close() error { return nil }

func (b *Button) Get() (bool, error) {
    return b.state, nil
}

func (b *Button) Set(v bool) error {
    b.state = v
    return nil
}
```

A real implementation may read from GPIO. A mock implementation may keep the
state in memory. The code above is deliberately simple because the interface
is the point: the rest of the system should not need to know which version it
is using.

An environmental sensor follows the same shape with a richer value type:

```go
type EnvSensor struct {
    id   string
    data Env
}

func (e *EnvSensor) ID() string { return e.id }

func (e *EnvSensor) Open() error  { return nil }
func (e *EnvSensor) Close() error { return nil }

func (e *EnvSensor) Get() (Env, error) {
    return e.data, nil
}

func (e *EnvSensor) Set(v Env) error {
    e.data = v
    return nil
}
```

That same pattern works for meters, relays, displays, motors, and more
complex station-level devices.

## What the Device Manager Adds

A device interface gives each device a shape. A device manager gives the
application a registry and runtime boundary.

The manager is responsible for concerns such as:

- Registering devices by name or ID.
- Opening and closing devices during application lifecycle.
- Looking up devices for control logic or APIs.
- Polling devices on timers.
- Publishing readings to MQTT or another message bus.
- Reporting device errors without crashing the whole edge runtime.

A simplified manager looks like this:

```go
type ManagedDevice[T any] struct {
    Name   string
    Topic  string
    Device Device[T]
}

type DeviceManager struct {
    mu      sync.RWMutex
    devices map[string]any
}

func NewDeviceManager() *DeviceManager {
    return &DeviceManager{devices: make(map[string]any)}
}

func RegisterDevice[T any](dm *DeviceManager, name string, d Device[T]) {
    dm.mu.Lock()
    defer dm.mu.Unlock()

    dm.devices[name] = ManagedDevice[T]{
        Name:   name,
        Topic:  "devices/" + name,
        Device: d,
    }
}
```

This is a representative sketch, not a complete copy of the production code.
The useful idea is that the manager owns registration and runtime behavior,
while each device owns only the hardware-facing operations.

## Polling Without Coupling

Many IoT devices are read on an interval. That polling loop should not know
whether it is reading a real sensor or a mock.

```go
func Poll[T any](ctx context.Context, interval time.Duration, d Device[T], publish func(T) error) error {
    ticker := time.NewTicker(interval)
    defer ticker.Stop()

    for {
        select {
        case <-ctx.Done():
            return ctx.Err()
        case <-ticker.C:
            value, err := d.Get()
            if err != nil {
                return err
            }
            if err := publish(value); err != nil {
                return err
            }
        }
    }
}
```

That function can be tested with a fake device and a fake publisher. On a
Raspberry Pi, the same shape can poll a real sensor and publish telemetry to
MQTT.

The point is not that every polling loop should look exactly like this. The
point is that timing, reading, publishing, and hardware access are separate
concerns.

## Mock-First Development

Mock devices make the application runnable on a laptop without a hardware
bench.

```go
type MockMeter struct {
    val int
}

func (m *MockMeter) ID() string     { return "mock-meter" }
func (m *MockMeter) Open() error    { return nil }
func (m *MockMeter) Close() error   { return nil }
func (m *MockMeter) Get() (int, error) { return m.val, nil }
func (m *MockMeter) Set(v int) error   { m.val = v; return nil }
```

That lets the project test control logic before wiring the actual sensor:

```go
func TestDrySoilTurnsPumpOn(t *testing.T) {
    meter := &MockMeter{val: 18}

    moisture, err := meter.Get()
    if err != nil {
        t.Fatal(err)
    }

    if moisture >= 25 {
        t.Fatalf("expected dry soil reading, got %d", moisture)
    }
}
```

In a garden system, this means the watering rules, MQTT messages, REST API,
and dashboard behavior can be developed while the physical station is still
being assembled.

## Why This Matters

A device abstraction layer buys flexibility in places where IoT projects are
usually brittle.

**Testing gets easier.** Control logic can be tested with mocks instead of
requiring GPIO, I2C, or serial hardware for every test run.

**Hardware can change.** A cheap analog moisture sensor can be replaced by an
I2C SeeSaw sensor without rewriting the gateway or dashboard.

**Deployment gets simpler.** The same application logic can run on a laptop,
a Raspberry Pi, or another Linux edge gateway.

**Failures become explicit.** A device read can return an error that the edge
runtime logs, publishes, or exposes through an API instead of hiding the
failure inside application code.

**Responsibilities stay clear.** Drivers talk to hardware. Devices expose
typed behavior. The manager coordinates devices. Applications make decisions.

## Common Pitfalls

- Letting application code import hardware drivers directly. That shortcut
  makes tests slower and hardware replacement harder.
- Making the device interface too large. A broad interface forces every
  device to implement methods it does not need.
- Hiding errors behind default values. A failed moisture read is not the same
  as dry soil.
- Treating mocks as second-class code. If mocks do not follow the same
  interface as real devices, they stop protecting the design.
- Polling everything at the same frequency. Different devices have different
  timing and power requirements.
- Using generics where a plain interface would be clearer. Generics help when
  the value type matters; they should not make simple drivers harder to read.

## Deployment Shape

Go fits this style of edge runtime because it builds static binaries and
cross-compiles cleanly:

```bash
GOOS=linux GOARCH=arm64 go build -o otto-arm64
scp otto-arm64 pi@raspberrypi.local:/usr/local/bin/otto
```

That binary can run on a Raspberry Pi, an ARM industrial gateway, an x86 Linux
box, or inside a container. The hardware-specific behavior stays behind the
device layer.

## Where OttO Fits

The ecosystem around this design has three roles:

- [devices](https://github.com/rustyeddy/devices): device interfaces,
  hardware wrappers, and mocks.
- [OttO](https://github.com/rustyeddy/otto): the edge runtime, device manager,
  MQTT, REST API, WebSocket API, and persistence.
- [Gardener](https://github.com/rustyeddy/gardener): the reference irrigation
  application that exercises the full stack.

The same architecture is useful beyond irrigation. Any edge system that reads
sensors, controls actuators, and needs to run without constant cloud access
benefits from the same boundary.

## Where This Fits

The device abstraction layer sits between hardware drivers and the edge runtime.
Read it after [IoT System Architecture](/iot/iot-system-architecture-device-to-cloud/)
when you want to understand how device boundaries become Go interfaces, and
before [OttO Edge Gateway Architecture](/iot/iot-edge-gateway/) when you want to
see the runtime that uses those abstractions.
