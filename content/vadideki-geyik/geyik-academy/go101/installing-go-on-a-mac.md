+++
#   (`-')           (`-').->
#   ( OO).->        (OO )__
# ,(_/----. .----. ,--. ,'-' doubt everything,
# |__,    |\_,-.  ||  | |  |
#  (_/   /    .' .'|  `-'  | be curious,
#  .'  .'_  .'  /_ |  .-.  |
# |       ||      ||  | |  | learn.
# `-------'`------'`--' `--'

title = "Installing Go on a Mac"
date = "2021-05-22"

[taxonomies]
tags = ["go"]
+++

![Gopher](/images/size/w1200/2024/03/macgoher.png)

> Here, you'll find the instructions to install 
> [**Go**](https://golang.org/ "Go Programming Language") on 
> a **Mac OS** computer.

Open [the package file you downloaded](https://golang.org/dl/) and follow the prompts to install **Go**.

*   The package installs the Go distribution to `/usr/local/go`.
*   The package should put the `/usr/local/go/bin` directory in your `PATH` environment variable.

Restart your terminal and verify the settings by entering the following commands.

```bash
which go
# returns: /usr/local/go/bin/go
```

```bash
echo $PATH
# Make sure PATH contains '/usr/local/go/bin/go'.
```

```bash
go version
# Prints something similar to the following:
# go version go1.16.4 darwin/amd64
```

## You Are All Set

That's it. You are now ready to use **Go** in your system.
