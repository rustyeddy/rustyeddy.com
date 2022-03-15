---
title: MQTT Messaging
date: 2022-03-13
draft: true
---
The Hub gathers data with the well supported [MQTT](https://mqtt.org)
light weight messaging protocol. The data is collected the data is
parsed, formatted and temporarily saved in RAM.

Publishers send data to _Topics_ while subscribers subscribe to the
topic and subsequently recieve the corresponding data.  For example a
_CS_ with the ID 10.11.11.22 will publish the current temperature in
fahrenheit with this _topic_.

```
ss/data/10.11.11.2/tempf
```

In this _10.11.11.22_ is the StationID and and _tempf_ is the
SensorID. 


ss/data/10.11.11.2/tempf
```

In this _10.11.11.22_ is the StationID and and _tempf_ is the
SensorID. 

