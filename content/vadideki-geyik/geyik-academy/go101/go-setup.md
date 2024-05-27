+++
#   (`-')           (`-').->
#   ( OO).->        (OO )__
# ,(_/----. .----. ,--. ,'-' doubt everything,
# |__,    |\_,-.  ||  | |  |
#  (_/   /    .' .'|  `-'  | be curious,
#  .'  .'_  .'  /_ |  .-.  |
# |       ||      ||  | |  | learn.
# `-------'`------'`--' `--'

title = "Setting Up Your Go Development Environment"
date = "2021-05-11"

[taxonomies]
tags = ["go"]
+++

![Gopher](/images/size/w1200/2024/03/gopher.png)

## Hi Gopher 👋

In this mini-article, we'll see how we can set up our Go development environment.

Installing and configuring [**Go**](https://golang.org/) on your system is pretty streamlined. Once you follow the instructions here, you'll be up and running in no time.

> **See It in Action**  
> Here's [a video about setting up **Go** development 
> environment a Mac](@/vadideki-geyik/geyik-academy/go101/installing-go-on-mac-os.md).

## Download the `go` Binary

First, head over to the [official **Go** downloads page](https://golang.org/dl/). Then, find a suitable download for your operating system.

> **Aside**
>
> **Go** can be installed on Apple macOS, Microsoft Windows, and Linux. It's unlikely, but if you cannot find a suitable installer, [you can follow the instructions to build it from the source, too](https://golang.org/doc/install/source "Use the source, Leia.").

## Install Go

Once you have the binary, follow the **installation instructions** below that are relevant to your operating system:

* [Installing **Go** on a **Mac**](@/vadideki-geyik/geyik-academy/go101/installing-go-on-a-mac.md)
* [Installing **Go** on **Linux**](@/vadideki-geyik/geyik-academy/go101/installing-go-on-linux.md)
* [Installing **Go** on **Windows**](@/vadideki-geyik/geyik-academy/go101/installing-go-on-windows.md)

## Set Your `GOPATH` Environment Variable

It is also customary to set a default **Go** workspace by setting your `GOPATH` environment variable.

For **Mac OS** and **Linux**, you can do that by editing your `~/.profile` file as follows:

```bash
vim ~/.profile
# or /etc/profile (for a system-wide installation).

# Add the following line to the end of your $HOME/.profile file.
# If you don't have such a file, create one.
export GOPATH=$HOME/go
```

For **Windows**, the steps to create an environment variable is slightly different:

*   Right-click the Computer icon and choose **Properties**.
*   Choose **Advanced system settings**.
*   On the **Advanced** tab, click **Environment Variables**.
*   Click **New** to create a new environment variable.

## Hello, **Go** World

Are you all set? Have you configured your `go` binary and your `GOPATH` environment variable?---Let's test our installations by writing a sample **Go** program.

First, we'll create a test project folder and an empty `main.go` file:

```bash
# Declare a $GOPATH workspace directory first.
export $GOPATH=~/Documents/PROJECTS/go

# Go organizes source code by "Project"s.
# Each project is a separate folder under '$GOPATH/src'.
#
# Let's create a 'go-test' project folder for our sample project.
mkdir -p $GOPATH/src/go-test

# Now switch to our project folder and create a blank file there.
cd $GOPATH/src/go-test
touch main.go
```

Next, we'll create a small program that prints a message on the console and exits:

```go
// $GOPATH/src/go-test/main.go

package main

import "fmt"

func main() {
	fmt.Println("\nzerotohero.dev: Always be curious.\n")
}
```

> **Aside**
>
> After the introduction of [Go Modules](https://blog.golang.org/using-go-modules "Using Go Modules"), it's not strictly necessary to maintain your projects under `'$GOPATH/src'`; however, it's still considered a good practice to do so.

Now, let's run our program by entering the following in the terminal:

```bash
go run main.go
```

If everything is set up correctly, you will receive the following output in the terminal:

```bash

zerotohero.dev: Always be curious.

```

## Choosing a **Go** IDE

After setting up a development environment, you can write your **Go** code comfortably in any text editor.

My favorite editors that I code **Go** are as follows:

*   [**Vim**](https://www.vim.org/): Also, its cousin [Mac vim](https://github.com/macvim-dev/macvim) for working on relatively small projects and utility scripts.
*   [**Sublime Text**](https://www.sublimetext.com/): **Sublime** is the **WinRar** of editors (_if you know what I mean_). I use **Sublime** to edit and develop almost anything quickly.
*   [**JetBrains GoLand**](https://www.jetbrains.com/go): **GoLand** is an absolute power-hose. It is my **go-to** tool for developing any large-scale **Go** project.

Note that the above list is by no means conclusive. You can comfortably program go in almost any modern editor. And **Go** being a popular and widespread programming language, it's highly likely that your favorite code editor either has builtin support for **Go**. Either that or your editor enables **Go** support with additional plugins.

Feel free to pick any editor that you feel comfortable with.

> **Patience, Young Padawan**
>
> It might sound counter-intuitive, but I **do not** recommend **GoLand** if you are just starting to learn **Go**.
>
> If you are beginning your **Go** journey, a lighter editor (_such as `vim`_) will be much helpful during your initial getting-used-to phase.
>
> Once you are comfortable with the language and learned how things tie together, you can give **GoLand** a go.

## 👋 Bye, Gopher

In this article, we've seen how to set up a **Go** development environment, configure our **Go** working directory, and looked into some options to pick from as a **Go** development environment.

I hope it was informative.

Until the next article... May the source be with you 🦄.
