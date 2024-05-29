+++
#   (`-')           (`-').->
#   ( OO).->        (OO )__
# ,(_/----. .----. ,--. ,'-' doubt everything,
# |__,    |\_,-.  ||  | |  |
#  (_/   /    .' .'|  `-'  | be curious,
#  .'  .'_  .'  /_ |  .-.  |
# |       ||      ||  | |  | learn.
# `-------'`------'`--' `--'

title = "Installing Go on Windows"
date = "2021-05-22"
template = "geyik.html"

[taxonomies]
tags = ["go", "geyik-academy", "go101"]
+++

# Installing Go on Windows

{{img(
  src="/images/size/w1200/2024/03/gopher-win.png",
  alt="Gopher"
)}}

> Here, you'll find the instructions to install [**Go**](https://golang.org/ 
> "Go Programming Language") on a **Windows** computer.

Open [the MSI file you downloaded](https://golang.org/dl/) and follow the 
prompts to install **Go**.

After installing, you will need to close and reopen any open command prompts so 
that changes to the environment made by the installer are reflected at the 
command prompt.

To verify that you've installed **Go**, execute this in your Terminal:

```bash
go version
```

If the command prints the installed version of **Go**, you're good to go.

## You Are All Set

That's it. You are now ready to use **Go** in your system.
