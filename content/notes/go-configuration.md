---
title: A Simple Go Configuration
date: 2021-03-26
description: >
  Configurations are part of most every program, configurations can be
  handled in a number of different ways. This is my simple method for
  handing configurations variables in Go. Check it out!
category: util
tags: go
---

I use this same configuration structure and supporting functions in
most every Go program I work on. It is pretty simple but makes it easy
to keep global variables orgranized and configurable.

Here is what I do:

1. Create a ```type config struct``` 

2. Every configurable variable for the program becomes a Member field
   of the Configuration structure.
   
2. Register every field of the Configuration Structure with go's
   builtin _flags_ package such that the flags are parsed when the
   program starts we can use our configuration variable.
   
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

func (c *Configuration) Save(fname string) error {
    // encode configuration into a JSON struct

    // save json string to file
}

func (c *Configuration) Read(fname string) error {
    // Read json string from file

    // decode configuration from the JSON struct.
}

```

Adding the Save() and Read() functions now allow us to read and write
our configuration to and from a file.


{{< gist rustyeddy 6007c0073146f08d9d905b882bb6ef8d >}}
