---
title: Software Development
draft: true
date: 2019-10-02
description: >
  A response I wrote to a person this morning, turn this into an article or two.
---

moni/

Most of the questions above have a pretty short answer, if you want to organize them I can supply answers.  By separating them into individual threads, or a doc of some type.  Answering here would get messy.

Here are couple high level comments I have after looking over your list.

1. Many of the technologies you mention are either/or choices, you pick one over the other.  This is especially true with anything JavaScript related because everything changes on a monthly basis.

If you focus less on specific technologies and principals of sound Software Engineering and Design, it you will care much less about languages and technologies because you will see them as tools (not an end product).

2. Pick an application to work on first.  Spend some time creating a little "design", pick your technologies: Go-Wasm for example and start working on it, learning the things you need as you are building your application.

Put Design Principals and Application Requirements first, THEN learn the technologies required satisfy your application requirements.

Regarding Gopher slack, thanks it is a great channel. I do not tend to hang out on chat channels much because I need to focus when I am programming and that is pretty much all day.  :)

It is a great place with lots of smart and helpful people I will say.

- rusty

I will briefly answer one of your questions above: asynchronous and concurrency are realted concepts, but they are not the same.

A pratical example of asynchronous is a "blocking" call vs. non-blocking call.  For example you are going to call a web service to gather a lot of data, it will take a long time.  You can:

1) Make a blocking call (synchronous) that pauses (blocks) the program from doing anything else until you receive a reply (or error).

2) Make a non-blocking (asynchronous) call that requests the data from the remote server, after sending the request the program continues to run even though the response from the server has not yet been returned.

You can design your "I/O" requests to be blocking or non-blocking, depending on the applications requirements.

Concurrency in go is a different, but related concept. Concurrency is the ABILITY for two or more different "instruction" sets to run simultaneously.  They do NOT HAVE to run simultaneously, but they could under the right circumstances, that is considered concurrent.

For example: putting on your shoes and getting coffee are "concurrent" events, they could, theoretically be done at the same time, but do not have to.

Putting on socks then shoes is NOT concurrent, the sock MUST be put on before the shoes and must be done in order (synchronously).

If two or more "concurrent" events are in fact running at the same time, they are said to be running in parallel.  
