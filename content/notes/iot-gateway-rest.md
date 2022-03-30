---
title: Adding the REST API to IoT Gateway 
date: 2022-03-30
description: >
  The IoT Gateway has cached environmental data it has collected from
  MQTT the HTTP package will be added to provide our REST API. The
  HTTP server will later be used to serve up our Webapp. 
category: iot-gateway
tags: [ go, http, rest ]
draft: true
---

Building a REST server over _HTTP_ is not much different than serving
a normal web page over _HTTP_. In either case the URL determines what
information the user is requesting.

In the case of the Webapp HTML is returned in response to the query,
in the case of the REST API the response is formatted as
JSON. The difference being the HTML response is intended for Human
consumption in a browser, where as the JSON returned from an API call
is intended for another program, or _machine_ to _machine_
communication. 

## Go HTTP Package

Go has a simple yet powerful, fast package of that implements the
_HTTP_ protocol including _HTTP/2_. 

### Import package and Register Callback function

### Call http ServeHTTP and serve callback

### Adding Endpoints

#### Serving Up Classes vs. Functions

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

## Puting it together 

1. import net/http
2. new source code is here
3. compile and ready to run.

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

## Run the network API

Should see two network stations.

## Conclusion

Now we are getting somewhere! We can retrieve the data previously
gathered by MQTT great!

Now what? Let's develop a Web app to access this data and display that
data in both tabular and graph forms?

Sound good? 

**Next** [IoT Dashboard in Vue](/notes/iot-dashboard-vue)

