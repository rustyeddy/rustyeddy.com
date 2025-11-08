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
communication buses — each with its own quirks.

In the [OttO Project](https://github.com/rustyeddy/otto) and companion
[Devices library](https://github.com/rustyeddy/devices), I set out to
to focus more on the application layer and create an device
abstraction layer that would simplify developing managed IoT
applications without necessarily getting into the weeds of device
drivers.  The goal: a _lightweight_, _generic_, _type-safe_ system
that can manage many kinds of devices, from buttons, meters to full
networks of sensors.

This article walks through how I added the Device Manager to OttO, and
created a Device interface powered by type-safe generics, with
examples from these open repositories.

## Architectural Overview

The idea is simple: each device implements a shared interface ```Get()
and Set()```, using the DeviceManager to coordinate them — whether
they’re real hardware or mocks running in memory.

In practice, this lets OttO manage GPIO switches, environmental
sensors, power monitors, or even simulated devices — all through one
consistent interface.

Device Interface (from devices repo)

```go
In devices/device.go:

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

Each device can now expose its own data type:

```go
// Device	Data Type	Example
// Button	bool	true/false
// Meter	int	0–100
// Voltage	float64	12.6V
// Environment	struct{Temp, Humidity, Pressure float64}	multi-sensor readings
// Implementing Concrete Devices
// Example 1: Button (devices/button.go)
package devices

type Button struct {
    state bool
}

func (b *Button) Get() (bool, error) {
    return b.state, nil
}

func (b *Button) Set(v bool) error {
    b.state = v
    return nil
}

```

You can see the full [Button driver implementation here](https://github.com/rustyeddy/devices/blob/main/button/button.go)

Example 2: [Environment Sensor](https://github.com/rustyeddy/devices/blob/main/bme280/bme280.go)

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

## Building the Device Manager (from otto repo)

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


