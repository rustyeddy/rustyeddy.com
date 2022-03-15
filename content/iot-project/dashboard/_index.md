---
title: IoT Real-time Dashboard
date: 2022-01-12
weight: 30
description: >
  The dashboard is a responsive Web Application written with Vue to
  display historic and real time application data. The dashboard
  allows users to configure the application and switch connected
  relays. Front end developers advice is more than welcome!
---

![Example image](/img/dashboard.png)

## Dashboard WebApp

The snapshot of the _dashboard_ above is a WebUI served by the Hub
displaying the real time values for _temperature_, _humidity_ and
_uptime_. Actually three of the four stations in the screen shot above
are mocked using _mosquitto_pub_. See the "Mocking" section of
the [Hub](/iot-project/hub) section of the website.

### Recieving Data

The dashboard recieves all of it's data from the
[Hub](/iot-project/hub) which in turn streams the data to the
dashboard over Websockets in _real-time_.

> **TODO** add historic graphs of data from the REST data API

Historic data is available via the REST API, however as of this
writing the dashboard does not yet have the capability to fetch
and graph this data. This feature is coming..

### Mobile First

A great mobile experience is required to be relevant in the modern
world. For this reason the mobile app will be _responsive_ striving to
provide an excellent _mobile_ experience.

It is quite obvious that the number of _mobile users_ is huge. To stay
relevant today mobile support is a requirement. Ideally, beginning
this project as a 
[_mobile first_](https://www.uxpin.com/studio/blog/a-hands-on-guide-to-mobile-first-design/)
design is as modern as it gets!

### Written with Vue

React or Vue? That was the question, and Vue was the answer. I wanted
to use vuetify but as of this writting it still does not work with Vue
3.0, so I am using Bootstrap 5 at the moment.

## Lot's To Do!

There is a lot of work to do for the dashboard, including but not
limited to the following tasks:

1. Build the mobile version of the application
2. REST API call to graph historical time-series data
4. Single Page Station View
3. Make it much sexier!

Want to get involved? Join the Newsletter and say Hi! 
