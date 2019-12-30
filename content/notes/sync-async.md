---
title: Sync vs. Async, Blocking vs. Non-blocking
date: 2019-03-03
draft: true
---

A pratical example of asynchronous is a "blocking" call
vs. non-blocking call.  For example you are going to call a web
service to gather a lot of data, it will take a long time.  You can:

1) Make a blocking call (synchronous) that pauses (blocks) the program
from doing anything else until you receive a reply (or error).

2) Make a non-blocking (asynchronous) call that requests the data from
the remote server, after sending the request the program continues to
run even though the response from the server has not yet been
returned.

You can design your "I/O" requests to be blocking or non-blocking,
depending on the applications requirements.

Concurrency in go is a different, but related concept. Concurrency is
the ABILITY for two or more different "instruction" sets to run
simultaneously.  They do NOT HAVE to run simultaneously, but they
could under the right circumstances, that is considered concurrent.

For example: putting on your shoes and getting coffee are "concurrent"
events, they could, theoretically be done at the same time, but do not
have to.

Putting on socks then shoes is NOT concurrent, the sock MUST be put on
before the shoes and must be done in order (synchronously).

If two or more "concurrent" events are in fact running at the same
time, they are said to be running in parallel.

For example, in Go it is typical to use "Go routines" to run parts of
programs asynchronously. By placeing a 'go xxxxx' infront of a
function runs the function ASYNCHRONOUSLY because these functions are
CONCURRENT (can be ran at the same time).

However, if there is only 1 CPU, each of these tasks will have to take
turns being run through gold old CPU timesharing.

Now if the computer happen to have 1 available CPU per tasks where
each task ran on it's own CPU, then the program would in fact be
running in PARALLEL, because each task is in fact executing at the
same time (or asynchrounously).

Did that make sense? :)

