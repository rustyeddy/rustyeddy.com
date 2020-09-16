---
title: An HTTP Server written in Go
description: Serve up HTML5 compiliant websites!
---

## HTML5 Websites

Serves a web page routed in the '-pub' path. If path is empty, it
will serve up an in-memory page, meaning you will get a web page
regardless of whether you provide a filesystem or not. 

## Serve HTML Websites 

To run the static website directly from memory do this:

```
% spa
```

If you want to run a specific website that contains a directory with
an index.html file in it, we can serve that up like this:

```
% spa -pub examples/static
```

That should produce a website that looks like: (Todo put a screen
shoot of our super simple static website).

## REST Interface

- GET /api/health


## Build

```bash
% go build
```

