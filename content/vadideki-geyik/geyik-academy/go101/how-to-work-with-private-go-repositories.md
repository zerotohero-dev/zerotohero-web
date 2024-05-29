+++
#   (`-')           (`-').->
#   ( OO).->        (OO )__
# ,(_/----. .----. ,--. ,'-' doubt everything,
# |__,    |\_,-.  ||  | |  |
#  (_/   /    .' .'|  `-'  | be curious,
#  .'  .'_  .'  /_ |  .-.  |
# |       ||      ||  | |  | learn.
# `-------'`------'`--' `--'

title = "How to Work With Private Go Repositories"
date = "2021-11-26"
template = "geyik.html"

[taxonomies]
tags = ["go"]
+++

# How to Work With Private Go Repositories

{{img(
  src="/images/size/w1200/2024/03/private.png",
  alt="Private repositories, being private."
)}}

Introduction
------------

**Go** works seamlessly when the code that you are working with resides in public repositories. However, suppose you maintain your projects in **private** repositories. In that case, you need to tweak your environment a little to be able to work with your private **Go** modules.

In this lecture, you'll learn:

*   How to version and export **Go** modules.
*   How to import **Go** modules.
*   And how to configure your system to allow importing _private_ **Go** modules.

Lecture
-------

Let's jump right in:

How to work with private Go repositories.

Resources and Additional Reading
--------------------------------

### Bedtime Reading

Here are additional study material about some of the concepts that we've covered in this lecture:

*   [What are Microservices](https://microservices.io/)
*   [`GOPRIVATE` Environment](https://www.goproxy.io/docs/GOPRIVATE-env.html)
*   [Using Modules in **Go**](https://blog.golang.org/using-go-modules)
*   [Private Modules](https://golang.org/ref/mod#private-modules)
*   [Why Does `go get` Use `https` When Cloning a Repository?](https://golang.org/doc/faq#git_https)
*   [Go Module Mirror, Index, and Checksum Database](https://sum.golang.org/)
*   [Glob](https://en.wikipedia.org/wiki/Glob_(programming))
*   [Z-Shell User Guide](https://zsh.sourceforge.io/Guide/zshguide.html)
*   [Bash Reference Manual](https://www.gnu.org/software/bash/manual/bash.html)
*   [An Overview of **Go**'s Tooling](https://www.alexedwards.net/blog/an-overview-of-go-tooling)
*   [Pro Git Book](https://git-scm.com/book/en/v2)
*   [Git Configuration](https://git-scm.com/book/en/v2/Customizing-Git-Git-Configuration)

### Tools, Apps, and Services Mentioned

Here are the tools, apps, and services I've used or talked about in this lecture:

*   [Git Tower](https://www.git-tower.com/)
*   **FizzBuzz Pro**

Conclusion
---------------

In this mini video, you've learned how to work with private **Go** modules and import from private repositories; and tag, export, and publish private **Go** repositories. In the **additional resources** section, we also briefly mentioned various **Z-Shell** startup files.

> **Note**  
>   
> You can check out this **Zero to Hero** article about 
> [Z-Shell Startup Files](@/tips/zshell-startup-files.md) for more information 
> about the subject.

We'll have more fun with **Go** in the upcoming videos and articles.

Until then... May the source be with you 🦄.
