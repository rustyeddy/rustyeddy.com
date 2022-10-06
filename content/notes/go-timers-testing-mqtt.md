---
title: Using Go timers for MQTT testing
date: 2022-05-02
description: >
  Go timers along with a select can be used to simplify testing both
  read and write side of communication protocols. In this article you
  will learn to combine a Go timer along with a select statement to
  test both sides with a single test case.
category: go
tags: timers, iote
---

This article uses a Go timer and the Go select statement to test our
MQTT publish and subscribe in a single simple test statement. A quick
note on the ```go testing``` package: it is much like the JUnit where
tests using a particular naming convention ```TestXXX(t *testing.T)
{}``` will be run automatically with easy to reports having been
generated. 

## The Problem

The following code snippet is directly from the
[IoTe](http://rustyeddy.com/iote) edge gateway project. One of the
primary features of IoTe is the ability to send and receive MQTT
messages. 

The problem comes when trying to test code that is invoked only when a
network connection is made and data is copied. This typically requires
two different processes. 

### Performing read and writes in one function

For example testing MQTT publish and subscribe typically requires two
processes, one for each the publisher (sender) and one for the
(subscriber). Hence you need to control two different programs to
perform this type of test.

Another problem happens because the _subscriber_ has to register the
callback **before** a packet is published. The listen function will be
waiting for a packet to arrive before the call to publish a message is
called. 

### A timeout is needed

The subscribe (reader) will be waiting for an unspecified period of
time for the publisher (writer) to send a message. We need to
determine when too much time has passed for the test packet to be
recieved and the associtated message passed back to the parent
function indicating a successful message.

We will wait for half a second before we determine the test has
failed. 

The follow test taken directly from the iote test cases [see
mqtt_test.go](https://github.com/rustyeddy/iote/blob/main/mqtt_test.go)
as a reference. Let's check out the code.


```go
// TestMQTT ensures that we can a) subscribe to a specific channel
// b) publish data to a specific channel and c) recieve the data before
// a timeout.  In this test we 
func TestMQTT(t *testing.T) {
    
    // Messanger is basically a wrapper around the MQTT client, we
	// will use it to subscribe to the test channel and subsequently
    // publish a message to the channel
	msg := GetMessanger()
	if msg == nil {
		t.Error("Expected a messanger but got nil")
	}

    // set up some variables for the test
	topic := "iote/test"
	message := "Hello, World!"
    
    // this is the channel used by the callback to communicate to the 
    // select statement that an MQTT message
	heard := make(chan bool)
    
    // Subscribe to the test topic and provide the anonymous call back
	msg.Subscribe("test", topic, func(c mqtt.Client, m mqtt.Message) {

		// This anonymous function is the callback for all messages sent
		// to the MQTT 'iot/test' topic
		if topic != m.Topic() {
			t.Errorf("Expected topic (%s) got (%s)", topic, m.Topic())
		}
		if message != string(m.Payload()) {
			t.Errorf("Message expected (%s) got (%s) ", message, m.Payload())
		}
		heard <- true		
	})

    // Now publish the message
	msg.Publish("iote/test", 0, false, message)

    // wait for either a message on the 'heard' channel (pass!) or a
	// timeout (fail). 
	select {
	case <- heard:
		// Our message has been recieved. Yeah the test passed! Say nothing.

	case <-time.After(time.Second * 5):
		t.Error("Expected a message from client got nothing")
	}
}
```

### Explaining the Test

Since this is a _unit test_ I wanted to be keep the test self
contained in a single test case (function). with _Go_ this can be
easily accomplished without threads. 

To test MQTT publish and subscribe in the same function we need to do
the following:

1. Provide the _eclipse PAHO MQTT_ library with a _callback_ function.

2. The _callback_ function will be _anonymous_ with access to the
   variable in the scope of the test function. In other words, we
   don't need to use a global variable.

1. a _channel_ to let the test function know that an MQTT message has
   been passed to the _callback_ function.

4. Finally the _Go select_ statement will be used to select the first
   event between either a MQTT message being recieved by the
   _callback_ or a _timeout_ indicating no MQTT message was ever
   recieved. 
