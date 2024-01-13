---
title: website
description: >
  Websites are as common as magazines and shoes in today's
  society. However the types and usage of websites vary from extremely
  simple single pages to absurdly complex corporate sites that come
  from different departments and a variety of authors, editors and
  web-masters. 
date: 2018-12-04
---

# Websites

According to the W3.org (official web people), modern websites may
consist of, i.e. modern browsers must support 3 things:

- HTML for basic website structure and other things
- CSS for style
- JavaScript for all things _dynamic_.

The most basic of all websites is a single text file containing some
*content* wrapped in some *HTML markup*.  For example here is a
working, but incomplete example of HTML snippet attempting to display
a _level 1 header_ with the words _Hello, world!._:

```html
<h1>Hello, World</h1>
```

Now HTML provides us with layout options (html
reference)[http://html5.org], we can add some styling to do cool
things like, change the fonts, colors and layout.

Here is another example, complete this time of an HTML h1 header with
a little bit of style thrown in..

```html
<!doctype html>
<head>
  <style>
	h1 {
		font-size: 90px;
		font-color: yellow;
		background: red;
		text-justify: center;
	}
  </style>
</head>
<body>
<h1>Hello, World!</h1>
</body>
```

Now we'll have a big giant yellow _Hello, World!_ in the center of a
red screen.  Yikes, hopefully you are a better designer than me.

### Programming

The final required feature of modern websites is _JavaScript_,
whithout getting into any level of detail, we know that modern
webbrowsers actually use _JavaScript_ to turn HTML and CSS into an
actual webpage that we can, as "programmers" call JavaScript directly
to change the web page as we see fit.

In a later example we will use JavaScript to replace our Hello, World
message with the current time and date:

```html
TODO: Put full-code here
```

The above example is a very simple, yet complete web page including
the _content_, _markup_, _stylesheet_ and some _javascript_. 

### Webserver 

Now we are going to need to find a computer somewhere to _server up_
the web page, we handle this topic in the [webservers](webservers)
article. 

Before we go finding servers and evertyhing that comes along with
spinning them up, let's take some time to realize that, in it's
simplest form a webpage need not be complex at all, of course high end
complex websites have web server setups that are mind boggling, but we
aren't going to get into that stuff here.  At least no right away.

## Static Web Page

So a simple web page, or static web page will typically have the
following things:

1. HTML for structured layout
2. CSS to make things stylish
3. Some images or maybe a link to a video to give some context. 

The most important property of this Type of website is that it doesn't
changeYou can have it on the Web server for years decades and the same
identical web page will presumably show up. 

## From Static to Dynamic Website

Now let's say we want a website it's going to update periodically when
a new event happens or periodically overtime.SpaceFor exampleLet's say
we want to have a webpage and print out o'clock and 1 o'clock to be
taking as time goes onDisplaying the accurate time.

Well we can do that by adding just a tiny bit a JavaScript to
ourExisting HTML website. 

Will do here is will add some JavaScriptThat will create newTag that
had will contain constantly updated display of the time. 

We are purposely getting keep this version of our JavaScript as simple
as possibleWith his little code is the following lines will get our
clock ticking clock on our webpage:

```javascript
// Todo: fill in java script for webpage clock
```

Now When we load at this webpageWe'll see the current time in that
time will be updatedConstantly. We have just went from a static
webpage and display the same thing day after day year after year to a
webpage that is constantly updatingBased on in this case the time. 

That is a very simple example of the dynamic website versus a static
website. 

### From Dynamic Site to Web App

Always he is a dynamic websiteThat that's the ability to
updateAccording toSome simple things like time in this case. 

We'll see hear thatGoing from a simple dynamic website something
thinking changeAutomatically toSomething that not only changes
automatically butIs able to maintain some substantial amount of
information or contactSuccess service on behalf of the userRapidly
becomes call complicated.

Here we are going to look at the primary things thatTakeThe website or
A simple dynamic webpageTo a full-blown application and we'll look at
some of the complexities some of the challenges andAnd maintain some
sanity in building the application. 
