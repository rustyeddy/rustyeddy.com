---
title: TLV the Type Length Vector Protocol
description: >
  A very simple byte oriented protocol used to swap unformatted
  messages over a variety of communication channels (i2c, SPI, UDP,
  TCP, RF, BLT, etc).
date: 2019-04-17
categories:
  - software
  - communications
tags:
  - tlv
image: https://mobilerobot.sfo2.cdn.digitaloceanspaces.com/display-and-motors.jpg
---

TLV is a very simple communication protocol that can be used to send
messages around a complex, distributed system.  
<!--more-->

The TLV protocol provides only message formatting by definition.  How
the application handles said messages is up to the application, that
is NO assumptions or gaurauntees about losing message, parts of
messages, ordering or retransmission.

If any of these more advanced capabilities are to be provided, they
must be done so at the application layer (so to speak).

### Generic Underlying Transports

The underlying physical and mac layers will have a huge effect on the
possibility of packet loss, ordering, delay and possible bandwidth.
Each of the communicaiton mediums we use, we will post a comparison of
characteristics, bandwidth, delay and reliability amoung other
things. 

## TLV and TLString

Type, Length Vector (Value) is as old as the hills, but still just as
useful!  Type length Vector is byte oriented, with three types of
messages: compact (1 byte), short (2 bytes) and full (up to 0xffff
size). 

```
+--------+--------+--------+--------+
|  Type  | Length | Value  ...
+--------+--------+--------+--------+
```

The first byte is the type of message, the second byte is the length
of the message, inclusive, that is the 2 bytes of the Tyte and Length
field are INCLUDED in the Length of the message.

### Compact Messages

The nature of many types of communication are just quick short
messages that only require a single byte, which not only determines
the _type_ of message, it also supplies _no payload_ beyond the type. 

In this case, TLV supports the message type **compact** or
**1-byte**.

### Short Messages

In a similar vein, some types my contain only a single value, for
example a sensor value between 0 & 0xff can be advertised with only
two bytes.  

Normally, a two byte message: 1-byte for type and 1 byte for the
length would require a 3rd byte for the value.  Hence, that makes the
two byte message unused.

To that end, we provide a 2nd small optimization: Short messages
support the message type and a message value between 0x0 and 0xff in
the length field, thus reducing the *Short Message* from 3 bytes to 2
bytes. 

### Distinguishing Compact, Short and Normal Packets

The packet types can be identified by the first two bytes of the type
field.  Compact packets always have the first two bits of the type
set:

#### Compact Packets

```
+--------+
|11xxxxxx|
+--------+
```

Compact packets are a single byte in the **range of 0xC0 to 0xFF**,
depending on how the remaining 2^6 bits are set.

#### Short Packets

```
+--------+--------+
|10xxxxxx| Value  |
+--------+--------+
```

#### Reserved Packets

```
+--------+--------+
|01xxxxxx| Value  |
+--------+--------+

The reserved range can be associated with the Short or Regular packet
types is one type is getting used up quicker than another.

```

Short packets are two bytes, with the type value in the range of 0x80
to 0xBF.  Again, short packets have (2^6 = 32)  independent types.

#### Regular Packets

```
+--------+--------+--------+--------+
|00  Type  | Length | Value  ...
+--------+--------+--------+--------+
```

If desired, the compact and short packets can be turned off,
altogether allocating the entire 2^8 == 256 types to be regular
messages.
