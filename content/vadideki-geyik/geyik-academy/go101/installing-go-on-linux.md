+++
#   (`-')           (`-').->
#   ( OO).->        (OO )__
# ,(_/----. .----. ,--. ,'-' doubt everything,
# |__,    |\_,-.  ||  | |  |
#  (_/   /    .' .'|  `-'  | be curious,
#  .'  .'_  .'  /_ |  .-.  |
# |       ||      ||  | |  | learn.
# `-------'`------'`--' `--'

title = "Installing Go on Linux"
date = "2021-05-22"

[taxonomies]
tags = ["go"]
+++

![Gopher](https://www.zerotohero.dev/content/images/size/w1200/2024/03/gopher-linux.png)

> Here, you'll find the instructions to install [**Go**](https://golang.org/ "Go Programming Language") on a **Linux** computer.

Extract [the archive you downloaded](https://golang.org/dl/) into `/usr/local`, creating a **Go** tree in `/usr/local/go`.

For example, you can run the following command to do create the **Go** tree:

```bash
rm -rf /usr/local/go \
&& tar -C /usr/local -xzf go$version.$distro.tar.gz
```

After creating the directory tree, add `/usr/local/go/bin` to your `PATH` environment variable:

```bash
vim $HOME/.profile
# or /etc/profile (for a system-wide installation).

# add the following line to the end of your $HOME/.profile file.
# If you don't have such a file, create one.
export PATH=$PATH:/usr/local/go/bin
```

Note that changes made to a profile may not apply until you log out and log back into your machine. The apply the changes immediately, you can source your profile file as follows:

```bash
source $HOME/.profile
```

Finally, verify that you've installed **Go** by opening a terminal session and typing the following:

```bash
go version
```

After pressing the **Enter** key, if you see the installed version of Go, then you're off to the races.

## You Are All Set

That's it. You are now ready to use **Go** in your system.
