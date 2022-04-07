---
title: Adding the REST API to IoT Gateway 
date: 2022-03-30
description: >
  The IoT Gateway has cached environmental data it has collected from
  MQTT the HTTP package will be added to provide our REST API. The
  HTTP server will later be used to serve up our Webapp. 
category: iot-gateway
tags: [ go, http, rest ]
git: https://github.com/iot-station/iothub
draft: true
---

Previously we added 
[MQTT to the IoT Gateway](/notes/iot-gateway-mqtt/) as part of the
[IoT Project](/iot-project). This gave the _IoT Gateway_ the ability
to cache environmental data in the programs RAM.

Now we want to access that data!

## Getting data with REST

The most popular and most appropriate style of API to provide access
to the data cache is 
[A REST API](https://www.redhat.com/en/topics/api/what-is-a-rest-api).
For most people that have either written or consumed an API are
familiar with REST, for those not familiar REST is a _conventional_
way to use HTTP.

### HTTP, HTML and REST

HTTP used to serve up a traditional webpage basically takes a URL
along with some optional arguments and returns an HTML to a _browser_
capable of rendering HTML.

HTTP used for automation can take the same style URL and optional
arguments to produce a file of another format such as JSON which is
typical of REST API's these days (XML, SOAP, binary, csv are also
possible). 

Just like MQTT HTTP is also built on top of _TCP_ which passes along
all the goodness TCP provides in particular *reliability* efficient
use of network bandwidth.

## Go HTTP Package

Go has a small, robust and very efficient implementation of the _HTTP_
protocol for both clients and servers. The IoT Gateway will import
this package giving it an embedded web server allowing the gateway to
serve up the sensor data and eventually the webapp without the
overhead of an additional HTTP server like nginx or apache.

The following code is a minimal but full working HTTP server that can
handle a heavy load for a sustained period of time.

```go

import (
    "time"
    "net/http"
)

// Msg holds each datapoint as it arrives 
type Msg struct {
    StationID   int         `json:"station-id"`
    SensorID    int         `json:"sensor-id"`
    Timestamp   time.Time   `json:"time"`
    Value       interface{} `json:"value"`
}

// DataCache is an array (queue) of Msg's that are pushed to
// the rear of the message.
type DataCache struct {
    Data    []Msg           `json:"data"`
}

var cache DataCache

// ServeHTTP satifies the http.Server interface requirement hence 
// allows our global data cache structure to act as the *receiver*
// function for the DataCache struct.
func (d DataCache) ServeHTTP(w *http.Writer, r http.Request) {
    // Only allow read requests
    if r.Method != "GET" {
		w.WriteHeader(http.StatusMethodNotAllowed)
		return
	}
	json.NewEncoder(w).Encode(d)		
}

func main() {
    flags.Parse()

    http.RegisterFunc("/api/v01/data", d)
    
    // Start listening on port 8080 on any interface
	err := http.ListenAndServe(":8080", nil) 
    log.Println("HTTP Server has stopped ", err)
}
```

This example demonstrates a couple points. First it is very easy to
add an embedded webserver into an application. The DataCache in the
contrived example above is over simplified, however it captures some
important points to be discussed ... 

Embedding an HTTP server is a Go application is basically following
these steps.

1. Define the _endpoints_ the application will support
2. Write the _callbacks_ that will handle incoming HTTP requests
3. Start up the HTTP server and listen for incoming HTTP requests.

Let's unravel these points a bit more.

#### Adding Endpoints

When discussing APIs the term _endpoint_ simply means the _root_ of
the URL that demarcs are particular topic. In our example we have a
single endpoint also known as a _URI_: ```/api/v01/data```.

Endpoints are appended to a _base URL_ to result in a complete URL
that a client would call. If our base URL is ```https://example.com```
the complete URL for this applications end point becomes:

```
https://example.com/api/v01/data
```

Our application will now allow any HTTP client to connect to our
server and extract the data cached in RAM. 

> NOTE: we have not implemented any security preventing "unauthorized"
> access. HTTP and API security will be addressed in a later writing

We can use ```curl``` to test our endpoint!

```
% curl http://example.com/api/v01/data
...
```

We are going to be using curl a lot for testing and debugging as this
project progresses. We'll have to implement 3-4 endpoints with plenty
of testing ahead!

Refering to the line 

```go 
if r.Method != "GET" {
		w.WriteHeader(http.StatusMethodNotAllowed)
		return
}
```

From this code snippet we can see only the GET HTTP request
type is supported. In other words we are allowing READ ONLY requests,
no POSTS, PATCHES, or DELETEs (only -R-- of CRUD).

Do notice how easy it is to return a proper error to our mis-informed
user. 

### Auto encoding JSON for HTTP Request

This single line of code is pretty amazing. We simply pass the
_DataCache_ variable we want to return to the user to the _Encode()_
function to be magically encoded into JSON.

```go
    json.NewEncoder(w).Encode(d)		
```

This causes our Msg above to look like this:

```js
{
    "data": [
        {
            "station-id": "station-01",
            "sensor-id": "tempf",
            "time": "2020-02-02T23:32.12Z",
            "value": "76.32"
        }
        {
            ...
        }
    ]
}
```

One reason it is so easy for Go to encode a structure into JSON is due
to reflection with the help of these _string literal tags_ refering to
the ``` `json:"xxx"` ```. 

Check out the [encoding/json](https://pkg.go.dev/encoding/json)
package for more detail.

#### Classes vs. Functions as Callbacks

Talk about the difference between having a _function_ as a _callback_
vs. a type reciever, which gives the end point callback access to all
the structures variables _and_ additional methods!

Another subtle difference vs more established frameworks, this design
keeps the _model_ and _control_ logic in the same structure
vs. dividing the structure into separate _model_ vs. _controller_
often reffered to as a _handler_.

> This architecutre lends itself directly to supporting plugins!
> Something we'll think about later in this project.

Wow that sounds pretty powerful!

##### A type with ServeHTTP method

Go does not have classes, rather go has _types_ that in turn can have
functions called methods. The instantiation of a _type_ is known as a
_reciever_ when accessed through a method.

For those familiar with OO terminology the _Type_ is similar to a
_Class_ where a _reciever_ is similar to an _Object_ (or instantiation
of the type).  

That was confusing, and not really the point we are here, a simple
example will straighten things out.

#### The Data type and /data endpoint and callback

```go
type Data struct {}

func (d *Data) ServeHTTP(http.Request r, *http.Writer) {
    // parse arguments, analyse request URL, reply to request
}

```

#### The Network type /net endpoint and callback

```go
type Stations struct {}

func (s *Stations) ServeHTTP(http.Request r, *http.Writer) {
    // parse arguments, analyse request URL, reply to request
}

```

## Demo

4. run iot-gateway
5. use curl to read about gateway, success!
1. use curl to read data and stations, non yet

### Mock CS with mosquitto_pub

1. run mosquitto_pub and send a datapoint

### Use curl to call the REST API 

1. Run curl and retrieve two data points.

Just for fun do it again with two stations and one and two data points
for each station.

## Conclusion

Now we are getting somewhere! We can retrieve the data previously
gathered by MQTT great!

Now what? Let's develop a Web app to access this data and display that
data in both tabular and graph forms?

Sound good? 

**Next** [IoT Dashboard in Vue](/notes/iot-dashboard-vue)

