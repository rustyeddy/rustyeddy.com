---
title: Version Control Systems
date: 2020-06-12
weight: 30
description: >
  After all the planning time has come to change code. What happens
  now?  Clear evidence of a rookie team is the lack of a Version
  Control System (VCS) tool and associated processes built around your
  VCS will provide all the visibility you need to track progress of
  your software project. Your VCS becomes the source of truth for your
  project. 
---

It frightens me everytime I am introduced to a new software project
where the "latest" source code is somebodies folder _somewhere_ with
copies being passed around on thumb drives.

Such a lack process invites confusion from the beginning and inspires
questions like:

> which copy of the file has your changes?

If you are working like this STOP! It does not have to be this
way. no, start using Version Control now! 

Done correctly, your VC will track _every change_ to your source code
with clear well written summaries (logs) of the problem that was
solved.

## Git and Version Control

Version Control Systmes (VCS) has been around since at least the
1970's . These included RCS, CVS, SVN and lot's of clunky and lame pay
versions.

Now we have _GIT_.

Git was development by the famous _Linus Torvalds_ author of Linux to
handle the distributed nature of the **huge** Open Source software
[_Linux Kernel_](http://kernel.org). Development and the thousands of
software developers that continuously contribute to the code base. 

### Github is Git as a Service

We also have Github!

Github revolutionized software development by taking the widely
popular _Git_ version control system and wrapping online services
around them, such as an _Issue Tracker_, _Project Kanban Board_ and a
whole social infrastructure allowing developers to easily share Open
Source software projects.

## Github for Services and Workflow

To be clear, there are some other _great_ services built around _git_,
[_gitlab_](http://gitlab.org) and [_bitbucket_](http://bitbucket.org)
are just two. 

Fortunantely for us, _github_ provides quite a few services integrated
around git itself giving us a rich set of tools to build a sophisticated
development environment, and all for _free_.

Github works on a _freemium_ model where all Open Source projects get
all features for free. However, private repositories will be required
to pay a nominal fee to unlock all of githubs features.

For our purposes, everything we need is free, so don't pull out your
wallet! 

## Enough Theory?

OK, next we are going to roll up our sleeves and "_git busy_".

---

When a software developer or developers(s) leave a project without the
use of process or version control, it is a crap shoot as to the
quality of the code you will discover.

The odds are the code will be _crap_. Most people that are skilled and
care enough to write _clean code_, likewise are most likely following
some _process_ or _best practices_ by using version control and
documeneting the architecture.

The person that walks into a project own all of the bad decisions and
lies that have previously been told, the software person has nowhere
else to turn. Using Version control to establish both accountability
for decisions and trace modifications to their origin.
    
Communication should be:

1. easy for everybody
2. captured to context, history for example, to capture the rationale
   behind decisions that may have required a controversial
   trade-off. Invaluable for repeating the same convesation. 

   Also can be used to determine when old practices can be
   obsoleted. Technology has a way obliterating completely rational
   decision that were made a mere two years ago..

3. Do NOT allow project communications To be spread amongst email,
   Texts, Social media accounts and various Other arbitrary Cyber
   nooks and crannies.

You will Lose all history and context. Debates and decisions Will be
unnecessarily repeated.

## Github and making the Commitment

Now it is time for the developer to _commit_ the changes she has been
working on, tested and pushed through the peer reviews. This step is
pretty simple, however, we want to make sure we are doing it
correctly.

> Todo example commit

When the code is merged into the **main** or **master** repository,
just like commitments, it will be accompanied by the log comments
that go along with the log files.

Additionally, every _commit_ will have a _unique identifier_, a big
nasty looking hex-i-decimal string guaranteed to most likely be locally
unique. 

### History in the Making

Well written comments, source diffs and a unique identifier come
together to create a specific moment in the code life history.

Stringing all commitments together, one forms a very accurate history
of the source development. If the comments are well written, that
history is accompanied by a wonderful narrative told by the developers
as the software is being written. 

## The Beginning of Visibility

This can provide the viewer with literally a line by line replay of
the entire history of a software development project. The commitments
can also be directly related to the particular **github issues** that
have spurred the updates to the code in the first place.

This is a very powerful way for not only developers, but also users,
management and marketing a deep insight into the process of software
development. 

## Tagging - Releases

Git also provides a feature called _tagging_, which is in fact very
similar to _branching_. _Tags_ however are meant to _label_ a specific
reference of the source at a specific point in time.

_Software releases_ are a good reason to use _tags_. For example: a
tag **v1.0.2** would be a typical tag that might be used to reference
the version of code after **v1.0.1**.

This practice allows the team, or anybody interested, the ability to
_reference_ and _re-create_ a specific past version of the software.

## Automated Builds and Testing

Github provides a ton of goodies with it's well defined _API_ and the
plethora of _web-hooks_ it provides.

In the next section we'll get into _automatically_ building new images
upon every committment, running the images through automated tests and
finally sending **only** the tested images to a file server for
general access. 

