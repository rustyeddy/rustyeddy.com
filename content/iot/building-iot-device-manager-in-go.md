---
title: Building an IoT Device Manager in Go
description: >
  A practical guide to managing heterogeneous IoT devices with Go’s
  interfaces, generics, and concurrency.
date: 2025-11-02
tags: [ go, IoT devices, generics ]
---

## Introduction

Managing IoT devices becomes exponentially more complex as your
network grows. You end up juggling a mix of sensors, actuators, and
communication buses each with its own quirks and challenges.

In the [OttO Project](https://github.com/rustyeddy/otto) and companion
[Devices library](https://github.com/rustyeddy/devices), I attempted
to develop a mini framework that would have a clear _seperation of
concerns_ between the hardware layer (GPIO, I2C, serial, ADC, PWN,
UART, etc.) and the application layer (messaging, control logic,
logging, deployment, etc).

By having a clean seperation between the HW and application layers we
can focus more on the application layer that would simplify developing
managed IoT applications without necessarily getting into the weeds of
device drivers.  The goal: a _lightweight_, _generic_, _type-safe_
device system that can manage many kinds of _things_, from buttons,
meters, motors to full networks of sensors.

### Separation of Concerns

This article walks through the design of OttO's _device manager layer_
which sits above the particular devices and their underlying drivers.
The device interface is powered by [Go's
Generics](https://go.dev/doc/tutorial/generics) allowing me to write a
single generic interface that supports underlying concrete
implementations that either return or produce virtually any data type
including primatives (int, bool, float64, strings, etc) as well as
structures composed of multiple values along with examples.

> NOTE: The introduction of generics to Go has been controversial as
> interfaces or other methods could have worked as well, but I wanted
> to get some experience with Go's generics.

### Mocking Hardware

This design creates a clear seperation between the device and
application layers. As we will see later it also allows application
developers to focus on building the application on a powerful Linux
workstation without any actual hardware via mocking or faking the underlying hardware.

Running the same application on _real_ hardware, for example a
_Raspberry Pi_ is as simple as compiling for the target architecture
(e.g. ARM 64) and transfering to that device.

## Architectural Overview

The idea is simple: each device implements a shared interface ```With
Open(), Close(), Get() and Set()```, using the DeviceManager to
coordinate them — whether they’re real hardware or mocks running in
memory.

In practice we have two repositories that represent three layers:
_drivers_, _devices_ and an _application framework_. The first two
layers can be found in the repository https://github.com/rustyeddy/devices
the second can be found in https://github.com/rustyeddy/otto.

### The Drivers

The driver layer is agnostic to the actual sensor or actuator and sits
the closest to the hardware, for example drivers consist of 

- Serial Ports
- GPIO - Digital and Analog
- i2c
- SPI 
- 1-wire, etc
- Pulse Width Modulation (PWM)

### The Devices

The devices consist of hardware that uses the underlying drivers, for example
Buttons and LED use a single GPIO pin, GPS device uses serial port, soil sensor
(meter) uses an Analog to Digital Converter (ADC), etc.

In this layer I have leveraged a lot of good work by others that have
done a lot of great and the complex coding that has gone into them.

### The Application Framework

The heart of the _Application Framework_ is OttO that provides a
variety of _packages_ for _pub/sub_ messaging, REST API, Websockets, 
HTTP for standard HTML user interfaces, etc.

### The Application

There is also a reference application, the 
[The Garden Station](https://github.com/rustyeddy/garden-station) that 
implements an automatic watering system based on a soil moisture sensor, 
water pump and other devices like LEDs, Buttons and an OLED display.

---

TODO : Insert architectural drawing here

---

## The Device layer with Go Generics

Device Interface (from devices repo) In devices/device.go:

```go
package devices

type Device[T any] interface {
	ID() string
	Type() Type
	Open() error
	Close() error

	Get() (T, error)
	Set(v T) error
}

```

That’s it — the entire abstraction layer.

Each device can now expose its own data type, for example:

* Button bool -> true/false 
* Meter	int   -> 0–100 
* Voltage float64 -> 12.6V 
* Environment struct{Temp, Humidity, Pressure float64} -> multi-sensor readings 

###  Implementing Concrete Devices

You can see the full [Button driver implementation here](https://github.com/rustyeddy/devices/blob/main/button/button.go)

```go
package devices

// Example 1: Button (devices/button.go)
type Button struct {
    state bool
}

// Get returns the state of a button either on or off
func (b *Button) Get() (bool, error) {
    return b.state, nil
}

// Set is not used on real devices but can be leveraged
// when mocking
func (b *Button) Set(v bool) error {
    b.state = v
    return nil
}

```

Example two implements a complext type struct consisting of
temperature, humidity and pressure.

[Environmental Sensor](https://github.com/rustyeddy/devices/blob/main/bme280/bme280.go)

```go
type Env struct {
    Temp, Humidity, Pressure float64
}

type EnvSensor struct {
    data Env
}

func (e *EnvSensor) Get() (Env, error) {
    return e.data, nil
}

func (e *EnvSensor) Set(v Env) error {
    e.data = v
    return nil
}
```

[Full source code on GitHub](https://github.com/rustyeddy/devices)

These examples run natively on a Raspberry Pi and GPIO or via mock data on 
just about any Linux distribution. It would be fairly easy to port over to
other SoC style boards like the BeagleBone or Nvidia Jetson.

## Building the Device Manager

In the OttO project, the DeviceManager is the components that keeps track
of all devices.

A simplified version looks like this:

```go
package manager

import (
    "sync"
)

type DeviceManager struct {
    devices map[string]any
    mu      sync.RWMutex
}

func NewDeviceManager() *DeviceManager {
    return &DeviceManager{devices: make(map[string]any)}
}

func (dm *DeviceManager) Register(name string, dev any) {
    dm.mu.Lock()
    defer dm.mu.Unlock()
    dm.devices[name] = dev
}

func (dm *DeviceManager) Get(name string) (any, bool) {
    dm.mu.RLock()
    defer dm.mu.RUnlock()
    dev, ok := dm.devices[name]
    return dev, ok
}
```

[Full version](https://github.com/rustyeddy/otto/device_manager.go)

## Using the Device Manager

In OttO, you can create and register devices dynamically:

```go
dm := manager.NewDeviceManager()

dm.Register("on", button.New("On", 5))
dm.Register("off", button.New("Off", 6))
dm.Register("env", bme280.New("env", "/dev/i2c", 0x76))

// Read the environment sensor
if d, ok := dm.Get("env"); ok {
    env, err := env.Get()
	if err != nil {
		return err
	}
    fmt.Printf("Temp: %.2f°C, Humidity: %.2f%%\n", env.Temp, env.Humidity, env.Pressure)
}
```

## Concurrency and Polling Devices

In practice, OttO uses goroutines to read data from many devices at
once — ideal for real-time dashboards or edge gateways.

```go
// genericTimerLoop provides a standard timer loop for any device
func (md *ManagedDevice) GenericTimerLoop(duration time.Duration, done chan any) {
	ticker := time.NewTicker(duration)
	defer ticker.Stop()

	for {
		select {
		case <-ticker.C:
			md.ReadPub()
		case <-done:
			slog.Debug("Timer loop stopped", "device", md.Name)
			return
		}
	}
}

func pollEnv() {
	env := bme280.New("env", "/dev/i2c", 0x76)
	d := dm.Register("env", env)

	done := make(chan done any)
	d.StartTimerLoop(15 * time.Second, done, d.GenericTimerLoop)
}
```

This pattern is already integrated into OttO’s runtime polling layer,
which uses Go’s channels for non-blocking updates.

## Testing with Mocks

From the devices/mocks package:

```go
package mocks

type MockMeter struct {
    val int
}

func (m *MockMeter) Get() (int, error) { return m.val, nil }
func (m *MockMeter) Set(v int) error   { m.val = v; return nil }
```

## Unit test using testify:

```go
func TestMockMeter(t *testing.T) {
    m := &mocks.MockMeter{val: 42}
    got, _ := m.Get()
    require.Equal(t, 42, got)
}
```

Mocking lets OttO simulate an entire IoT environment on your laptop —
no physical hardware required.

## Extending the System

Once you have your device manager in place, you can extend OttO with:

**Persistence**: Save device state via SQLite or BoltDB

**Networking**: Expose devices over REST or MQTT

**Plugins**: Dynamically load Go modules for new device types

**Dashboards**: Visualize data with a web UI or CLI

_Example_: OttO’s HTTP layer exposes /api/devices endpoints built
directly on the manager.

```go
http.HandleFunc("/api/devices", func(w http.ResponseWriter, r *http.Request) {
    devices := dm.List()
    json.NewEncoder(w).Encode(devices)
})
```

## Performance and Deployment

Go’s lightweight runtime and static compilation make it perfect for
IoT and edge systems:

```bash
GOOS=linux GOARCH=arm64 go build -o otto-arm64
scp otto-arm64 pi@raspberrypi.local:/usr/local/bin/
```

You can deploy OttO to:

- Raspberry Pi or BeagleBone
- Linux gateways and routers
- Docker containers on ARM or x86
- Cloud-based device simulators

## Conclusion

By combining Go’s generics, interfaces, and goroutines, we’ve built a
foundation that scales from one sensor to an entire IoT network.

The RustyEddy ecosystem now includes:

_Devices_: Reusable drivers and interfaces

_OttO_: The orchestrator and runtime manager

Future modules: NavGo, OttoEdge, GardenStation, and beyond

If you’re looking for a clean, composable way to manage embedded
systems or smart devices — Go gives you type safety, concurrency, and
simplicity out of the box.

🔗 References

[OttO GitHub Repository](https://github.com/rustyeddy/otto)
[Devices GitHub Repository](https://github.com/rustyeddy/devices)
[RustyEddy.com](https://RustyEddy.com)

> Rusty Eddy builds open software for embedded systems and IoT. Follow
> along at RustyEddy.com or on GitHub @rustyeddy .


