+++
title = "Places to Learn Go"
date = "2021-05-22"

[taxonomies]
tags = ["go", "roadmap"]
+++

![Roadmap](https://www.zerotohero.dev/content/images/size/w1200/2024/03/roadmap.png)

## Introduction

If you are familiar with programming and you know basic concepts like loops, variables, flow controls, and the like, then there are many resources available that can help you ramp up with **Go** real fast.

In this article, I'll list some of those resources, and I'll share my **opinionated** order to consume them.

## Getting Your Feet Wet

Although if you squint enough, **Go** looks and feels like Python, C++, or even JavaScript, _Go_ is unique in the way it approaches fundamental programming concepts. Don't be deceived by the similarity.

> One piece of advice that I can give you is to always keep in mind while learning Go is to **unlearn** what you have previously learned.
>
> Most of the time, the "_**Go** way_" of doing things will be unique: Trying to mold it with patterns and paradigms that you've known from other programming languages will result in futile resistance.
>
> Forget everything you know and embrace the **Go** way.

### A Tour of **Go**

That clarified you can start with visiting [A Tour of Go](https://tour.golang.org/welcome/1), an interactive tutorial that teaches you the fundamentals of the language in under a few hours.

### **Go** Programming Language Specification

After finishing the tour, I would resist the temptation to start coding right away and read the [Go Programming Language Specification](https://golang.org/ref/spec). It's **amazingly human-readable** as far as a spec goes, and it's "the" authoritative source about how the program behaves, so don't skip it; read the spec **cover-to-cover** at least once. Later on, when you have trouble understanding how a code block behaves, refer to the spec first **before** digging into other places like Stack Overflow.

### **Go** Frequently Asked Questions

In [**Go** Frequently Asked Questions](https://golang.org/doc/faq), you'll find helpful information about the design principles and how the language feels from a higher perspective. I'd recommend you read it twice: First, **before** you begin your **Go** journey, and second, **after** you are comfortable with **Go** to be dangerous at least.

### Set Up Your **Go** Development Environment

After this initial exploration, now it's time for [Setting Up Your **Go** Development Environment](https://www.zerotohero.dev/go-setup/). Once you set up your development environment, have fun playing with **Go** locally to explore the language a bit further, and then proceed to the following sections for a deeper dive.

## Writing Canonical **Go** Code

The most challenging part of learning **Go** is maybe to feel comfortable with "_the **Go** way_". Here, I'll list a series of articles and resources that will help you get more comfortable with the patterns and paradigms of the language.

*   [How to Write **Go** Code](https://golang.org/doc/code) demonstrates developing a simple Go package inside a module and introduces the [`go` tool](https://golang.org/cmd/go/), the standard way to **fetch**, **build**, and **install** Go modules, packages, and commands.
*   [Effective **Go**](https://golang.org/doc/effective_go) is a brief overview that walks you through how to write canonical **Go** programs.
*   [**Go** Proverbs](https://go-proverbs.github.io/) are from [Rob Pike](https://twitter.com/rob_pike)'s talk at [Gopherfest SV 2015](https://www.youtube.com/watch?v=PAAkCSZUG1c). They might look like one-liner, zen-like suggestions, but you can write articles---even books---about each of those sayings. I'd, again, recommend you read them at least twice: First, while you are relatively new to **Go**, and then read them once more when you feel like you know enough **Go** to be dangerous at least.
*   [**Go** by Example](https://gobyexample.com/) is a collection of everyday **Go**\-related tasks in byte-sized annotated example code pieces. It's a _must-read_ if you want to have a general feel of the language and become more comfortable with it.

## Read the Docs

When you want to learn how a package is used and its public API, there's no better way than reading its documentation and usage examples.

[pkg.go.dev](https://pkg.go.dev/) is a place where you can read the public API documentation of standard **Go** libraries and any other publicly available **Go** packages.

## Dive in Further

If you have followed all of the resources outlined here so far, you should have gotten enough **Go**\-fu to be dangerous, at least.

If you want to drill down further, here are a few essential books that I recommend:

*   [The **Go** Programming Language](https://www.gopl.io/), authored by Brian W. Kernighan---and anything written by Kernighan is worth your time.
*   [Introducing **Go**](https://www.oreilly.com/library/view/introducing-go/9781491941997/) covers the language's core features with step-by-step instructions and exercises.
*   [Concurrency in **Go**](https://www.oreilly.com/library/view/concurrency-in-go/9781491941294/) is a book about... well... concurrency. To be honest, **concurrency** is an overly-marketed feature of **Go** that you don't end up using too much. But still, you cannot claim to know **Go** thoroughly without learning about concurrency and various concurrency patterns and practices. This book is one of the best resources you can find on the subject matter.

If you want to get **practical**, I can recommend [Go in Action](https://www.oreilly.com/library/view/go-in-action/9781617291784/) and (_especially if you are into Web and APIs_) [Go Web Programming](https://www.oreilly.com/library/view/go-web-programming/9781617292569/).

If you want a video course instead, **O'Reilly** has a [Learning Path on Go fundamentals](https://www.oreilly.com/library/view/learning-path-go/9781491958100/) that looks pretty decent too.

In addition to these books, [go.dev](https://learn.go.dev/) constantly updates its list of **Go** learning resources, and it is one of the "_go-to_" places on the web to learn **Go**.

There are also free books that you can read online:

*   [**Go** Bootcamp Book](http://www.golangbootcamp.com/book/) contains everything you need to know to get started with Go.
*   [Essential **Go**]([https://essential-go.programming-books.io) is another free book that you can read online. It's written to provide a clear and concise explanation of topics for both beginner and advanced programmers.
*   [**Go** 101](https://go101.org/article/101.html) is a book focusing on Go syntax/semantics and all kinds of runtime-related things and tries to help gophers gain a deep and thorough understanding of **Go**.
*   Digital Ocean has an excellent tutorial series on [How to Code in **Go**](https://www.digitalocean.com/community/tutorial_series/how-to-code-in-go): Great quality content.
*   Similarly, Microsoft has an [equally excellent series of tutorials about **Go**](https://docs.microsoft.com/en-us/learn/paths/go-first-steps/).

## Keep Up With the News

To keep up with the news and what's coming up next about **Go**, [the **Go** Blog](https://blog.golang.org/) is the official resource you might want to look into.

## Follow the Gophers

Programming is not a path that you walk alone, and learning **Go** is no exception to that. Join the following communities, and follow and interact with your fellow gophers:

*   [**Go** _Twitter_](https://twitter.com/golang)
*   [**Go** _Subreddit_](https://www.reddit.com/r/golang/)
*   [**Go** _Discord_](https://discord.com/invite/golang)
*   [**Gophers** on _Slack_](https://gophers.slack.com/join/shared_invite/zt-proap3pu-ElK1vL6rGPTFlMu5GfLviA#/)

## Conclusion

**Go** is a prevelant language, and with the simplicity and clarity it brings to the table, its popularity will likely grow even further.

In this article, I've tried to sum up valuable resources that can help you ramp up in **Go** no matter where you are in your programming journey.

If you know about other tools, tutorials, lessons, or resources that have helped you become a better gopher, share it in the [**Zero to Hero** Discord community](https://discord.gg/wmSTcV9gHx).

And until next time... May the source be with you 🦄.


