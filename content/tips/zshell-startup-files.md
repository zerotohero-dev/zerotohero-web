+++
#   (`-')           (`-').->
#   ( OO).->        (OO )__
# ,(_/----. .----. ,--. ,'-' doubt everything,
# |__,    |\_,-.  ||  | |  |
#  (_/   /    .' .'|  `-'  | be curious,
#  .'  .'_  .'  /_ |  .-.  |
# |       ||      ||  | |  | learn.
# `-------'`------'`--' `--'

title = ".zprofile, .zshrc, .zenv, OMG! What Do I Put Where?!"
date = "2021-08-09"

[taxonomies]
tags = ["linux", "tips", "zsh", "shell"]
+++

![.zprofile, .zshrc, .zenv, OMG! What Do I Put Where?!](/images/size/w1200/2024/03/plac2.png)

## Introduction

[Z-shell](https://zsh.sourceforge.io/Doc/Release/index.html) has quite a bunch
of [startup and shutdown](https://zsh.sourceforge.io/Intro/intro_3.html) files.
So sometimes it gets difficult to decide what kind of functions, aliases, and
operations to define in which of those files.

Here is the complete list of files:

```txt
$ZDOTDIR/.zshenv
$ZDOTDIR/.zprofile
$ZDOTDIR/.zshrc
$ZDOTDIR/.zlogin
$ZDOTDIR/.zlogout
```

In this article, we'll cover what those files are for, when, and how to use
them.

## What is ~/.zprofile

`~/.zprofile` is one of
the [zsh startup and shutdown files](https://zsh.sourceforge.io/Doc/Release/Files.html#Files).
It is **read at login**. There's also its cousin, `~/.zshrc`, which is **read
when interactive**.

## Login and Interactive Shells

But what is **login**, and what is **interactive**?

Or---to ask differently---what is a **login shell** and what is an **interactive
non-login shell**?

A **login shell** is a shell where you log in. You can recognize a login shell
from a `ps -f` listing. For example, when I call `ps -f` after opening a Mac
terminal, I get the following:

```txt
volkan@iMac ~ % ps -f
  UID   PID  PPID   C STIME   TTY           TIME CMD
  501 22250 22249   0  6:47PM ttys000    0:00.18 -zsh
```

An **interactive non-login shell** is typically a shell environment that you can
read from and write to (_i.e., your typical terminal session_). An interactive
non-login shell can be invoked from the _login shell_, such as when you
type `zsh` and press enter in the command prompt. Or, it can be invoked when you
open a new terminal tab.

## What Goes to `~/.zprofile` and What Goes to `~/.zshrc`?

Since `~/.zprofile` is loaded **only once** at login time, it's best to put
things that are loaded only once and can be inherited by subshells. An excellent
example of this is **environment variables**.

On the other hand, `~/.zshrc` is typically reserved for things that are **not**
inheritable by subshells, such as **aliases** and **functions**, custom prompts,
history customizations, and so on.

In addition, put the commands that should run **every time** you launch a new
shell in the `.zshrc` file, too.

> **What About `.zshenv`?**
>
> For **Z-Shell**, another good place to put environment variables is
> the `~/.zshenv` file. The `~/.zshenv` file is **always loaded**. See the
> remainder of the article for details. That said, I, personally, prefer putting
> my environment variables into `~/.zprofile`.

## `zsh` Startup and Shutdown Files

`.zprofile` and `.zshrc` are the two main startup files that you'll 99% be
dealing with. Yet, other files have their uses too. Let's see all together.

[You can refer to the official reference](https://zsh.sourceforge.io/Doc/Release/Files.html)
if you like. I will just add some notes and comments that you may not find in
the official docs, to clarfiy things a little, if you will.

### .zprofile

`.zlogin` and `.zprofile` do the same thing. They set the environment for *
*login shells**. The only difference is they just get loaded at different
times (_see below_). I would use `.zprofile` at all times for consistence.

### .zshrc

`.zshrc` sets the environment for **interactive shells**. `.zshrc` gets loaded *
*after** `.zprofile`. It is a place where you "_set and forget_" things.

Since it's loaded after `.zprofile`, in interactive shells, it will override
anything you set in `.zprofile`. Like the `$PATH` variable. It's a good place to
define **aliases** and **functions** that you would like to have both in login *
*and** interactive shells (_see the sidenote below_).

> **.zprofile Quirks**
>
> Apple terminal initially opens **both a login _and_ an interactive shell**
> even though you don't authenticate (i.e., enter login credentials). That's
> why `.zshrc` will **always** be loaded. However, after the first terminal
> session, any subsequent shells that are opened are only interactive;
> thus `.zprofile` will **not** be loaded.
>
> You can test this out by putting an alias or setting a variable
> in `.zprofile`, then opening Terminal and seeing if that variable/alias exists.
> Then open another shell (type `zsh`); that variable won't be accessible anymore.

### .zshenv

This is read first and read **every time**, regardless of the shell being login,
interactive, or none.

This is the **recommended** place to set **environment variables**, though I
still prefer to set my environment variables in `.zprofile`

Why would you need it? Because, for example, if you have a script that gets
called by `launchd`, it will run under **non-interactive non-login** shell, so
neither `.zshrc` nor `.zprofile` will get loaded.

I've never needed to use this file so far, but it's there if you need it, and
there is nothing wrong with using it to define envinronment variables.

### .zlogout

This file is read when you **log out** of a session. Useful for cleaning things
up.

### File Load Order

Here's the order these profile files are processed, without getting into too
much detail:

`.zshenv` → `.zprofile` → `.zshrc` → `.zlogin` → `.zlogout`

## Conclusion

That was an overview
of [Z-Shell startup and shutdown file](https://zsh.sourceforge.io/Intro/intro_3.html)
s. If you are a **bash** user, [bash has a a similar set up startup files too](https://www.gnu.org/software/bash/manual/html_node/Bash-Startup-Files.html).

> **Aside**
>
> For the sake of
> completeness, [this knowledge base contains startup and termination files used by various unix systems](https://kb.iu.edu/d/abdy).

I hope this article clarifies what all these **Z-Shell** startup files are, and
how to use them in the most canonical way.

Until the next article... may the source be with you 🦄.

--------

## Section Contents

{{ tips_nav(selected=10) }}
