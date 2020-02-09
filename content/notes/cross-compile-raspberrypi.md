---
title: How to Cross Compile for the Raspberry Pi
date: 2019-02-07
---

Production software development for a Raspberry Pi is a fairly common
thing now.  This is great for many reasons, but does have the downside
that compiling large hunks of software on an RPI is slow compared to a
modern lowend laptop.

## Cross Compile to Rescue

To speed things up a bit we will do something the embedded world has
been doing from day 1, cross compile.

That is, we are going to use our fast desktop/laptop x86 linux box to
compile our program(s) for us, only it will produce a file that is
capable of running remotely on the Raspberry Pi.

Once we have built our _target_ application, we will need to do a
couple other things, including transfer it to our target
architecture. 

The basic workflow is as follows:

1. Compile your application _image_ for the target architecture using
   the appropriate _tool-chain_.

2. Transfer the new image to the target host: in our case a simple ssh
   will do, NFS could be used as well to effectively eliminate this
   step. 
   
3. Start/Restart the application with the new image. This can be a
   simple stop the old/start the new cold switch over, or it may be
   more complex depending
