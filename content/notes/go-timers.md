---
title: Golang timers to remove stale sensor stations
description: >
  A brief look at Go timers to clear out stale sensor stations.
date: 2020-11-03
---

This articles introduces Go (Golang) Timers as the mechanism the the
[IoTa gateway](https://github.com/rustyeddy/iota) uses to identify
_stale_ IoT stations. Modifying the Station with with a new _Go
timestamp_ field will allow IoTe to determine how long it has been
since the last time it has heard from a given Station.

If the last _refresh_ time for a particular station has been longer
than the _timeout_ period the Station will be marked as _stale_.

## Designing Our Timer Usage

A new _Timeout_ field will be added to IoTa's 
[_simple go configuration_](http://rustyeddy.com/notes/go-configuration) 
to indicate how long in (seconds, minutes or hours) a station will
remain _active_ as long as it has been _refreshed_ within the
_config.StationTimeout_ interval.

### Refreshing IoT Stations

A _Station_ is _refreshed_ every time IoTa receives a message, either
a _network announcement_ or _data telemetry_ message from that
particular station. 

For example, Imagine IoTa receives a message from _Station 01_ at
10:15:33 with a _5_ minute timeout. The station will be considered
_stale_ at 10:20:33.

At some point in the future IoTa will delete the stations once the
Station has been _stale_ for a period of ```3 *
config.StationTimeout``` as an example.

Finally we'll provide a way to systematically determine when a station
will go stale then market as such.

### Setting up a Go Timer

```go

import (
    "time"
)

const (
    StateNone   = iota,
    StateActive
    StateStale
    StateExpired
)

struct Station type {
    // ... 

    State       int
    LastTime    time.Time  // Last time we heard from this Station
}

func StationTimeout() {
    ticker := time.NewTicker(time.Minute * 5)
    defer ticker.Stop()
    defer go cleanupStations() // will this work?

	for {
		case t := <-ticker.C:
            // Walk all stations and look for timeouts
            for _, station := range Stations {
                expiration :=  station.LastTime + conf.StationTimeout
                if station.LastTime.After(expiration * 3) { 
                   station.State = StateExpired
                } else if station.LastTime.After(expiration) {
                   station.State = StateStale 
                }  else {
                    station.State = StateActive
                }
            }
		}
	}
}

func cleanupStations() {
    // walk expired stations and perform cleanup
    
    // write cached Data to the filesystem before croaking
    
    // Announce to dashboard the station is being cleaned up
}

```

I will briefly summarize what the above code is doing. 

1. Add ```LastTime time.Time``` to the Station type
2. When an MQTT messages arrives from Station reset the ```LastTime```
   variable
3. Add a "state" variable to each station: Active | Stale | Expired
4. Start a timer to call the "Station Walker"
5. Calculate the Experiation Time for the Station
5. If station is active and  current-time > lastTime + config.StationTimeout 
6. Mark station as Stale, Expired or Active as needed

This is a rather simplistic, but good implementation of a _time out
function_. However this model may not scale well. The _best_ algorithm
directly depends on the scale and needs of the application.

#### Things to Consider for the Aging Algorithm

Questions that need to be answered before selecting the optimal aging
function are: 

1. How many entities need to be aged: 10, 100, 1,000,000?
2. How granular do the timeouts have to be every second, minute or 15
   minutes? 
3. How accurate do the timeouts have to be? immediately, within a
   second, a few seconds? 
4. Are the timeouts going to be evenly spaced, bursty or scattered/

These three numbers are going to ultimately have to deal with how many
timers will be expiring in a given period of time, for example timers
/ second will give us a sense of how many times that function will be
called every hour. The number of stations and frequency of timers play
obvious roles in the number of timers per second.

The interval or frequency timers errupt is also very important. For
example, if we have a 1,000 stations publishing telemetry at every 15
minute intervals, the timers for the stations become _clustered_
causing a lot of expired timers errupting at once with large gaps
between with silence.

A _timer wheel_ or _sorted timers_ are good options to consider when
our CavePerson algorithm begins to not scale well.

### Options for Timers

1. Timer goes off and walks all stations for time outs

Do this first to demonstrate how to setup and use a Go timer.

2. Every station has a timer that wakes up and marks station as stale

Easy to implement, scales much better than above until the station set
becomes to large

3. Timer wheel, preset timers that awake for a sub-set of 

More complex but can scale really well.

### Time Out Station on Dashboard

IoTe will time out stale stations Dashboard needs to be updated of
changes. Here are a couple design options: 

1. IoTa periodically sends updates to the Dashboard, Dasbhoard simply
   replaces entire map when it receives a "station announcement" from
   IoT.  CavePerson approach.

2. Dashboard has it's own timer to timeout stations, hmmm. No. Not
   truley synchronized. We would be _hoping_ the dashboard and
   frontend where in sync most of the time

3. Websockets with HTTP/1 - realtime two way mechanism

This could be binary or text or JSON, it is up to me.

Interested in exploring the Future with HTTP/2 + Protobufs = gRPC.
