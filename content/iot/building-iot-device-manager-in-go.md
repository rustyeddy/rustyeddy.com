---
title: Building an IoT Device Manager in Go - Generics, Interfaces and Concurrency
description: >
  In this article you’ll learn how to build a framework that lets you
  handle buttons, meters, motors and even full robots from a single Go
  codebase — real hardware or mocked.
date: 2025-11-02
tags: [ go, IoT devices, generics ]
---

## Introduction

Managing IoT devices becomes exponentially more complex as your
network grows. You end up juggling a mix of sensors, actuators, and
communication buses each with its own quirks and challenges.

In the [OttO Project](https://github.com/rustyeddy/otto) and companion
[Devices library](https://github.com/rustyeddy/devices), I attempted
to develop a mini framework that would have a clear _separation of
concerns_ between the hardware layer (GPIO, I2C, serial, ADC, PWN,
UART, etc.) and the application layer (messaging, control logic,
logging, deployment, etc).

By creating a clean separation between the HW and application layers
we can focus more on the application layer and simplify the
development of managed IoT applications without necessarily getting
into the weeds of device drivers.  The goal is: a _lightweight_,
_generic_, _type-safe_ device system that can manage all kinds of
_things_, from buttons, meters, motors to full robots.

The software is able to run on top of _real hardware_ e.g. a
_Raspberry Pi_ without modifications as easily as it can run on a laptop
with _mocked_ devices.

### The Device Interface Using Go Generics

Here we'll walk through the design of OttO's _device manager layer_
which sits above the particular devices and their underlying drivers.
The device interface is powered by [Go's
Generics](https://go.dev/doc/tutorial/generics) allowing me to write a
single generic interface that supports a multitude of underlying
concrete implementations that either produce or consume virtually any
type of data as well as perform real world activies. 

Generics allow us to capture the data-type of the device at compile
time, reducing casting and improving type-safety.

The type of data the device interface supports include primitives
(int, bool, float64, string, etc) as well as complex Go structs. 
A few example implementations 
[can be found here](http://github.com/rustyeddy/devices/tree/main/examples).

> NOTE: The introduction of [generics to
> Go](https://go.dev/doc/tutorial/generics) has been controversial as
> interfaces or other methods could have worked as well. I choose
> generics for this task partially because I wanted to get some
> experience with Go's generics.

Generics allow us to capture the data-type of the device at compile
time, reducing casting and improving type-safety. 

### Mocking for Development & Testing

This design creates a clear separation between the device and
application layers. As we will see later it also allows application
developers to focus on building the application on a powerful Linux
workstation without any actual hardware via mocking or faking the
underlying hardware, and avoid the inconveniences of working on embedded 
systems for much of the application logic.

This enables you to run the same application logic on your laptop,
without messing with GPIO pins or device setup. 

Running the same application on _real_ hardware, for example a
_Raspberry Pi_ is as simple as compiling for the target architecture
(e.g. ARM 64) and transfering to that device.

## Architectural Overview

The idea is simple: each device implements a shared interface ```With
Open(), Close(), Get() and Set()```, using the DeviceManager to
coordinate them — whether they’re real hardware or mock hardware
running in memory.

In practice we have two repositories that represent three layers:
_drivers_, _devices_ and an _application framework_. The first two
layers can be found in these two repositories
[devices](https://github.com/rustyeddy/devices)
the second can be found in 
[otto](https://github.com/rustyeddy/otto.)

One key reason for separating the OttO and Device repositories allows
OttO to be run as an IoT broker only, while other things can be built
to provide that will utilize the underlying hardware.

### The Device layer with Go Generics

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

* A Button produces a boolean: true/false 
* A Meter can provide a range of integers: 0–100 
* Voltage can produce a floatping point value: 12.6V 
* Environment can produce a multi-valued structure: 
  `{Temp, Humidity, Pressure float64}`

###  Implementing Concrete Devices

The first example is a simple _button_ device which provides a
```Get()``` method that returns a single _boolean_ type, on/off, true
or false. It does not get much simpler than this.

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

#### A More complex example

Example two implements a complex type struct consisting of
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

These examples run natively on a Raspberry Pi with GPIO pins, or via
mock data on just about any Linux distribution, or MAC and maybe even
Windows. It would be fairly easy to port over to other SoC style
boards like the BeagleBone or Nvidia Jetson.

### The Drivers

The driver layer sits closest to the hardware and is agnostic to the
how the data is used by the sensor or actuator that consumes or
produces let alone what the application is doing with the data.

This is the list of drivers currently supported

- Serial Ports
- Digital GPIO
- Analog GPIO via the ads1112 i2c chip (on the Raspberry Pi)
- i2c

This is the list of drivers that will likely be supported sometime in
the near future:

- SPI 
- 1-wire, etc
- Pulse Width Modulation (PWM)

### The Devices

The devices consist of hardware that uses the underlying drivers, for
example Buttons and LEDs use a single Digital GPIO pin, the GPS device
uses a serial port, while the soil sensor (meter) uses an Analog to
Digital Converter (ADC) made possible by the 
[i2c ads1112](https://www.ti.com/lit/gpn/ADS1112)
chip.

A major goal of the device layer is to leverage as much good, hard
work from smart people. After all, I don't have the chops or the time
to do all that stuff myself!

> Separation concerns: device drivers from the framework

In this layer we have been able to leverage a lot of good, hard work
from some really smart people. This was always a primay goal of this
project: was to have the freedom to employ great code from a variety
of great sources. 

### The Application Framework

The heart of the _Application Framework_ is OttO provides a variety of
_packages_ required to manage a fleet of IoT _things_, or just a
single thing for that matter.  The packages provide these features

- Data collection and storage 
- Messanger for _pub/sub_ messaging
- HTTP Server provides
  - REST API
  - Websockets for realtime updates
  - Standard HTML for Web application Interface
- Station package for fleet management
- Enhanced Security (Coming Soon)
- Well tested

### The Application

There is a reference application known as the [The
Gardener](https://github.com/rustyeddy/gardener) an automated
watering station that uses a soil moisture sensor to determine when to
turn a water pump on, as well as light up an LED and update the text
on an OLED display.


---

TODO : Insert architectural drawing here

---

## Managing Application Devices

The _DeviceManager_ keeps track of the devices that make up
a _thing_. It is a registery that organizes a variety devices allowing 
the _things_ application to do it's _thang_.

A simplified version looks like this:

```go
package manager

import (
    "sync"
)

type DeviceManager struct {
	// Internal generic device store for tests and loose coupling
	devices map[string]*ManagedDevice
	Metrics *DeviceMetrics
	mu      sync.RWMutex `json:"-"`
}

func NewDeviceManager() *DeviceManager {
    return &DeviceManager{devices: make(map[string]any)}
}

func GetDeviceManager() *DeviceManager {
	once.Do(func() {
		deviceManager = NewDeviceManager()
	})
	return deviceManager
}

func (dm *DeviceManager) Add(d Device) *ManagedDevice {
	md := NewManagedDevice(d.Name(), d, d.Name())
	dm.Register(md)
	return md
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
once — ideal for edge gateways and real-time dashboards.

```go
// ManagedDevice wraps any device and adds messaging capabilities
type ManagedDevice struct {
	Name   string
	Device any // The underlying device (from devices package)
	Topic  string
}

// GenericTimerLoop provides a standard timer loop for any device
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

This pattern is already integrated into OttO’s runtime timer based
polling layer for non-blocking updates via Go’s channels.

## Testing with Mocks

The devices and oTTo packages have been designed with mocked
development in mind, allowing focus on application logic and avoiding
the tedium that comes with test full bench setups and prototypes.

```go
package mocks

type MockMeter struct {
    val int
}

func (m *MockMeter) Get() (int, error) { return m.val, nil }
func (m *MockMeter) Set(v int) error   { m.val = v; return nil }
```

Mocking lets OttO simulate an entire IoT environment on your laptop —
no physical hardware required.

```go
func TestMockMeter(t *testing.T) {
    m := &mocks.MockMeter{val: 42}
    got, _ := m.Get()
    require.Equal(t, 42, got)
}
```
Using OttO's REST API we can query the configured devices controlled by the
_DeviceManager_: provided by the `/api/devices` API endpoint.

```go
http.HandleFunc("/api/devices", func(w http.ResponseWriter, r *http.Request) {
    devices := dm.List()
    json.NewEncoder(w).Encode(devices)
})
```

I started using the [testify
package](https://github.com/stretchr/testify) 
which makes tests more compact and expressive.

## Extending the System

With the device manager in place we can now focus on other powerful
features provided by OttO.

- **Persistence**: Save device state via SQLite or BoltDB
- **Networking**: Expose devices over REST or MQTT
- **Plugins**: Dynamically load Go modules for new device types
- **Dashboards**: Visualize data with a web UI or CLI

## Performance and Deployment

Go’s lightweight runtime and static binary make it perfect for
IoT application and edge systems:

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

The ecosystem now includes:

- _Devices_: Reusable drivers and interfaces
- _OttO_: The orchestrator and runtime manager
- _Gardner_: The watering application.

If you’re looking for a clean, composable way to manage embedded
systems or smart devices — Go gives you type safety, concurrency, and
simplicity out of the box.

## References

- [OttO GitHub Repository](https://github.com/rustyeddy/otto)
- [Devices GitHub Repository](https://github.com/rustyeddy/devices)
- [Gardener](https://github.com/rustyeddy/gardener)
- [RustyEddy.com](https://RustyEddy.com)

> Rusty Eddy builds open software for embedded systems and IoT. Follow
> along at RustyEddy.com or on GitHub @rustyeddy .


