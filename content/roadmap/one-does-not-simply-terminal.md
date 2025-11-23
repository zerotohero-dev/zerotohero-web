+++
#   (`-')           (`-').->
#   ( OO).->        (OO )__
# ,(_/----. .----. ,--. ,'-' doubt everything,
# |__,    |\_,-.  ||  | |  |
#  (_/   /    .' .'|  `-'  | be curious,
#  .'  .'_  .'  /_ |  .-.  |
# |       ||      ||  | |  | learn.
# `-------'`------'`--' `--'

title = 'One Does Not Simply "Terminal" 👌'
date = "2021-11-07"

[taxonomies]
tags = ["roadmap","shell"]
+++

{{img(
  src="/images/size/w1200/2024/03/one-does-not.png",
  alt="One does not simply..."
)}}

## Getting Comfortable With the Linux Terminal

Here are some articles you can read to get more intimate with the command line:

* [An introduction to the Linux Terminal](https://www.digitalocean.com/community/tutorials/an-introduction-to-the-linux-terminal)
* [Using the Terminal](https://help.ubuntu.com/community/UsingTheTerminal)
* [tldr Pages](https://tldr.sh/) (_easier to scan than_ [_man pages_](https://www.kernel.org/doc/man-pages/)_, more practical_)
* [Explain Shell](https://explainshell.com/) (_paste your command, and let explain shell... well... explain it_)

## Commands That You'll Use Frequently

The more terminal you know, the more power you'll have. Yet, here is a list of
common commands that you might want to start familiarizing yourself with:

[`awk`](http://man.he.net/?topic=awk&section=all),
[`sed`](http://man.he.net/?topic=sed&section=all),
[`grep`](http://man.he.net/?topic=grep&section=all), 
[`sort`](http://man.he.net/?topic=sort&section=all), 
[`uniq`](http://man.he.net/?topic=uniq&section=all), 
[`cat`](http://man.he.net/?topic=cat&section=all), 
[`cut`](https://man.he.net/?topic=cut&section=all), 
[`echo`](http://man.he.net/?topic=echo&section=all), 
[`egrep`](http://man.he.net/?topic=egrep&section=all), 
[`fgrep`](http://man.he.net/?topic=fgrep&section=all), 
[`wc`](http://man.he.net/?topic=wc&section=all), 
[`less`](http://man.he.net/?topic=less&section=all), 
[`more`](http://man.he.net/?topic=more&section=all), 
[`ps`](http://man.he.net/?topic=ps&section=all), 
[`top`](http://man.he.net/?topic=top&section=all), 
[`htop`](http://man.he.net/?topic=htop&section=all), 
[`atop`](https://linux.die.net/man/1/atop), 
[`nmon`](http://nmon.sourceforge.net/pmwiki.php), 
[`iostat`](http://man.he.net/?topic=iostat&section=all), 
[`vmstat`](http://man.he.net/?topic=vmstat&section=all), 
[`ifconfig`](http://man.he.net/?topic=ifconfig&section=all), 
[`nmap`](https://linux.die.net/man/1/nmap), 
[`tcpdump`](http://man.he.net/?topic=tcpdump&section=all), 
[`ping`](http://man.he.net/?topic=ping&section=all), 
[`traceroute`](http://man.he.net/?topic=ping&section=all)

👆 These are the ones that you might use frequently. Obviously, there are more
that you might want to look into.

## Know Enough Shell Scripting to Be Dangerous

Here are a few guides on the topic:

* [Bash Guide for Beginners](https://www.tldp.org/LDP/Bash-Beginners-Guide/html/)
* [Bash Scripting Tutorial](https://ryanstutorials.net/bash-scripting-tutorial/)
* [Bash One-Liners](http://www.bashoneliners.com/)
* [Advanced Bash Scripting Guide](https://www.tldp.org/LDP/abs/html/)
* [Bash Cookbook](https://www.goodreads.com/book/show/1130902.Bash_Cookbook)
* [Bash Guide](https://github.com/Idnan/bash-guide)
* [Bash Pocket Reference](https://www.goodreads.com/book/show/27112374-bash-pocket-reference)
* [Bash Programming Intro](http://tldp.org/HOWTO/Bash-Prog-Intro-HOWTO.html)
* [Bash Reference Manual](https://www.gnu.org/software/bash/manual/bash.pdf)
* [Bash Scripting Cheatsheet](https://devhints.io/bash)
* [Bash Shell Scripting](https://en.wikibooks.org/wiki/Bash_Shell_Scripting)
* [Bash Wiki](https://wiki.bash-hackers.org/)
* [Learn Shell](https://www.learnshell.org/)
* [Learn X in Y Minutes Where X is Bash](https://learnxinyminutes.com/docs/bash/)
* [Shell Guide](https://google.github.io/styleguide/shellguide.html)
* [The Art of Command Line](https://github.com/jlevy/the-art-of-command-line)
* [The Art of Command Line](https://github.com/jlevy/the-art-of-command-line)

## Connecting to a Remote Server

[Connecting a remote server via 
**SSH**](https://www.digitalocean.com/community/tutorials/how-to-use-ssh-to-connect-to-a-remote-server-in-ubuntu)
is something you'll have to do sooner or later.

> **Explore Community Docs** 
> 
> If you need more than connecting to a server. Like, for example, if you need
> to install and configure applications, services, proxies, firewalls,
> databases,
> containers, and the like, then [**DigitalOcean**'s community tutorials](https://www.digitalocean.com/community/tutorials) is
> one of the best resources that you can have; closely followed by [**Linode**'s helpful articles](https://www.linode.com/docs/).

The only commands you need to master probably
are [`ssh`](https://man.openbsd.org/ssh)
and [`ssh-copy-id`](https://man.openbsd.org/ssh).

Below, I'll list some terminal emulators that you might want to try out too;
however, most of the time, the default terminal emulator on your operating
system will be sufficient for your needs.

> **Windows and Terminal**  
> If you have a Windows development machine and you are planning to work on
> Linux-like environments, do yourself a favor and give 
> [Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/install)
> a go. You'll thank me later.

## Cross-Platform Terminal Emulators

### Alacritty

[**Alacritty**](https://github.com/alacritty/alacritty) is the **fastest**
terminal emulator that you can find around. It's fast, lightweight, based on
OpenGL.

However, when I say **lightweight**, it truly **is** lightweight. You cannot
find tabs, split windows, and other fancy add-ons that other terminal emulators
provide.

To be productive with [**alacritty**](https://github.com/alacritty/alacritty),
you'll have to learn [**tmux**](https://www.hamvocke.com/blog/a-quick-and-easy-guide-to-tmux/) 
too, so that you'll have an equivalent tabbed user interface experience that you might be
used to from other terminal emulators.

> 💁‍
>
> Here's [a quick and easy guide to **tmux**](https://www.hamvocke.com/blog/a-quick-and-easy-guide-to-tmux/).

### Kitty

[**Kitty**](https://sw.kovidgoyal.net/kitty/) is another fast, GPU-based
terminal. So what makes it different than,
say [alacritty](https://github.com/alacritty/alacritty)? It is feature-rich,
scriptable, and composable while still being fast and minimalistic.

### Hyper

[**Hyper**](https://hyper.is/) is an 
[electron](https://github.com/electron/electron)-based terminal emulator. It
is built on HTML/CSS/JS. Fully extensible, absolutely hackable. If you want
something customizable, with [hyper](https://hyper.is/) sky is the limit.

### Mosh

[**Mosh**](https://mosh.org/) is especially useful when you are, say, using your
terminal on a train, where connectivity is intermittent and unreliable.

It is a replacement for interactive SSH terminals. It works wonders, especially
over Wi-Fi, cellular, and long-distance links.

### Terminus

[**Terminus**](https://eugeny.github.io/terminus/) boast to be a customizable
terminal for the modern age, and it does look pretty slick if you ask me.

## Linux Terminal Emulators

For the Linux UI fans out there, here are a few terminal emulators that you can
try.

* [**Guake**](http://guake-project.org/), is my preferred terminal on my 
  [**Ubuntu**](https://ubuntu.com/), mostly because I'm so used to
  the [Quake](https://en.wikipedia.org/wiki/Quake_(video_game))-style keyboard
  shortcuts to show and hide it. If you are a gamer, it becomes second nature to
  use it.
* [**Terminator**](https://gnometerminator.blogspot.com/) is really useful if
  you find yourself needing to split your window horizontally and vertically to
  see multiple terminal sessions simultaneously.
* [**Konsole**](https://konsole.kde.org/) is another popular option to try out.
* So is [**Tilda**](https://github.com/lanoxx/tilda).

## Mac Terminal Emulators

Mac Terminal emulators come and go all the time, yet there's only a single one
that stays and gets better year after year: [**iTerm2**](https://www.iterm2.com/).

While the default Terminal app is more than enough for your programming needs,
in case you want to spice things up a bit, you can try out 
[**iTerm2**](https://www.iterm2.com/). It provides a split window view similar
to [terminator](https://gnometerminator.blogspot.com/), so if you come from the
Unix world and seek a similar experience, [iTerm2](https://www.iterm2.com/) can
be your ally.

### Windows Terminal Emulators

To be honest, I don't use Terminal on Windows too much; however, the following
are the terminal emulators I've used and liked over time. Pick your own poison
🙂.

* [**Windows Terminal**](https://www.microsoft.com/en-us/p/windows-terminal/9n0dx20hk701)
* [**Conemu**](https://conemu.github.io/)
* [**Fluent Terminal**](https://github.com/felixse/FluentTerminal)
* [**Powershell**](https://docs.microsoft.com/en-us/powershell/scripting/overview) 
  (_it's a shell, not a terminal, but still **very** useful_)
* [**PuTTY**](https://www.putty.org/)
* [**ZOC Terminal**](https://www.emtec.com/zoc/index.html)
* [**Cmder**](https://cmder.net/)

## Shells

Picking a terminal emulator is the first step in the journey of making your
terminal experience better. Next up is **picking up a shell**.

[**Z-shell**](https://en.wikipedia.org/wiki/Z_shell) is popular nowadays, and
whoever uses [Z-shell](https://en.wikipedia.org/wiki/Z_shell) also installs 
[**Oh My Zsh**](https://ohmyz.sh/) as a sane starting point in customizing their
shell.

There is a [zsh Quickstart Kit](https://github.com/unixorn/zsh-quickstart-kit)
that you might want to look at too.

[**Fish**](https://fishshell.com/) is another popular shell that is famous for
its autocomplete support.

Ah, there is also [**oh my fish**](https://github.com/oh-my-fish/oh-my-fish) to
set up your fish 🐠.

## Terminal Utilities

Here I'm listing terminal tools and utilities I've found useful over the course
of years.

### Find; Search; Filter Files, Folders and Streams

* [**ack**](https://beyondgrep.com/) (*this is a must-learn, especially if you
  search source code a lot*)
* [**fzf**](https://github.com/junegunn/fzf) (*Fuzzy Finder: Another finder
  utility that you'd question how you lived without it*)
* [**grep**](https://ss64.com/bash/grep.html) (*must be in your toolbox*)
* [**peco**](https://github.com/peco/peco) (**peco** is a simplistic,
  interactive filtering tool)
* **ripgrep** (_**ripgrep** recursively searches your directories_)
* [**The Silver Searcher**](https://geoff.greer.fm/ag/) (_a code searching tool
  similar to **ack**_)
* [**fx**](https://github.com/antonmedv/fx) (_a utility to view JSON in
  terminal_)
* [**jq**](https://stedolan.github.io/jq/) (_so as this one_)
* [**sed**](https://www.gnu.org/software/sed/manual/sed.html) (Stream
  Editor---another powerful tool to learn)
* [**zoxide**](https://github.com/ajeetdsouza/zoxide) (_alias cd zoxide_)

### Help

* [**ExplainShell**](https://explainshell.com/) is a web app to explain the
  shell command you paste in.
* [**fuck**](https://github.com/nvbn/thefuck) is a command-line utility that
  recovers you from your mistakes.
* [**how2**](https://github.com/santinic/how2) finds the simplest way to do
  something in a Unix shell.
* [**howdoi**](https://github.com/gleitz/howdoi) provides instant coding answers
  via the command line.
* [**tldr-pages**](https://github.com/tldr-pages/tldr) is for those who are
  tired of reading the full manual.
* [**tldr.sh**](https://tldr.sh/) is the website for `tldr-pages`.

### Terminal Multiplexing

* [**screen**](https://www.gnu.org/software/screen/)
* [**tmux**](https://github.com/tmux/tmux)
* [**tmuxinator**](https://github.com/tmuxinator/tmuxinator)

### File and Folder Management

* [**exa**](https://github.com/ogham/exa) (_alias ls exa_)
* [**trash**](https://github.com/sindresorhus/trash) (_moves files and
  directories to trash_)
* [**jump**](https://github.com/gsamokovarov/jump) (_jump helps you navigate
  faster by learning your habits_)
* [**autojump**](https://github.com/wting/autojump) (_similar to **jump**_)
* [**lazy-cd**](https://github.com/pedramamini/lazy-cd) (_path bookmarking for
  bash_)
* [**aliasme**](https://github.com/Jintin/aliasme) (_a shell script to organize
  your aliases_)
* [**fkill-cli**](https://github.com/sindresorhus/fkill-cli) (_fabulously kill
  processes with extreme prejudice_)
* [**direnv**](https://direnv.net/) (_unclutter your `.profile`_)

### Monitoring and System Info

* [**htop**](https://hisham.hm/htop/) (_better_ [
  _`top`_](https://man7.org/linux/man-pages/man1/top.1.html))
* [**vtop**](https://github.com/MrRio/vtop) (_similar to **htop**, but
  graphical_)
* [**glances**](https://github.com/nicolargo/glances) (_better **htop** 🙂_)
* [**neofetch**](https://github.com/dylanaraps/neofetch) (_a command-line system
  information tool_)
* [**progress**](https://github.com/Xfennec/progress) (shows the progress
  of `cp`, `mv`, `dd`, etc.)

### Getting $#!% Done

* [**todo.txt**](http://todotxt.org/) (_a future-proof task tracking tool_)

### Mac-Specific

* [**mas**](https://github.com/mas-cli/mas) (_Mac AppStore command-line
  interface because why not 🤷‍♂️_)
* [**homebrew**](https://brew.sh/) (_the closest you can get to a package
  manager for Mac OS_)
* [**macports**](https://www.macports.org/) (_similar to **homebrew**_)

## Conclusion

That's a lot of tools and utilities to get you started with the terminal. I
hope you find them useful.

Until next time... May the source be with you 🦄.

--------

## Section Contents

{{ roadmap_nav(selected=13) }}
