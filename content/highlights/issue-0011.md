+++
#   (`-')           (`-').->
#   ( OO).->        (OO )__
# ,(_/----. .----. ,--. ,'-' doubt everything,
# |__,    |\_,-.  ||  | |  |
#  (_/   /    .' .'|  `-'  | be curious,
#  .'  .'_  .'  /_ |  .-.  |
# |       ||      ||  | |  | learn.
# `-------'`------'`--' `--'

title = "Assemble Your Personal Board of Advisors"
date = "2021-07-31"

[taxonomies]
tags = ["highlights","shell-scripting","encryption","infrastructure","kubernetes"]
+++

{{img(
  src="/images/size/w1200/2024/03/board.png"
  alt="Your personal board of advisors will help you navigate the tough times."
)}}

Welcome to the eleventh issue of **Zero to Hero** Highlights.

We had quite a ride in the last week. Let's take a look at a few highlights.

## FizzBuzz Pro** Kubernetes Cluster is Up and Running 🤘

Well, it's up, running; and there's still a lot to implement, but at least I can
get a list of pods and deployments. Also, the critical services
like `idm`, `mailer`, `crypto` are **mostly** complete.

Here's what I see when I query the cluster:

```bash
$ kubectl get deployment
NAME        READY   UP-TO-DATE   AVAILABLE   AGE
crypto      1/1     1            1           3d
idm         1/1     1            1           3d21h
mailer      1/1     1            1           4d2h
questions   1/1     1            1           4d2h
store       1/1     1            1           4d2h

$ kubectl get po
NAME                         READY   STATUS      RESTARTS   AGE
crypto-84f64dc7bf-qnj8l      1/1     Running     0          3d
idm-844969c6dd-pzmks         1/1     Running     0          3d21h
mailer-67fcf8b5dc-zc8lp      1/1     Running     0          4d2h
questions-7f5ccd5b84-2tmdp   1/1     Running     0          4d2h
store-5f8b66f949-tsc42       1/1     Running     0          4d2h

$  kubectl get ingress
NAME       CLASS    HOSTS              ADDRESS 
cerberus   <none>   api.fizzbuzz.pro   k8s-...amazonaws.com 80   10d
```

So nothing has been broken for days! Everything is healthy as a horse. Progress!

> I'll be writing more articles and creating more videos about how these
> services all tie together. Stay tuned.

## Deploying a Microservice to Kubernetes

While on the topic of videos, [I published a video about how you can deploy a 
microservice to an AWS EKS Kubernetes cluster][spire].

[spire]: @/spire/_index.md

In the video, I start from the source code:

* Build the code.
* Containerize it.
* Push it to a registry.
* Link the registry image to Kubernetes Deployments, Services, and Pods.
* And more.

It's an excellent overview of how everything ties together.

Note that this is just the **video** part of the content. There will be an
accompanying article on [**Zero to Hero**][home] that will dive deeper and 
provide you with additional *bedtime reading material* to dig in.

[home]: @/_index.md

## Installing an AWS EKS Kubernetes Cluster Using `eksctl`

The above video talks about deploying to **Kubernetes,** but how do we create a
**Kubernetes** cluster in the first place.

There are many ways but
[eksctl][eksctl] is the preferred way.
As always, there's more than mere instructions; I discuss the pros and cons of
things, and there are further reference material for the interested to do a
deeper dive.

That's more or less this week in a nutshell. So what's coming up next?

[eksctl]: https://eksctl.io/

## What's on the Horizon 👩‍🍳

I have a couple of [**Zero to Hero Twitch Screencasts**][twitch] that I 
haven't published yet.

On the **FizzBuzz Pro** end, I, at least, want to finish the **IDM** µService 
endpoints (*which is almost done*), but we'll see how it goes. 
I'll let you know next week.

## Random Thought of the Week

Don't take the phrase "*you must have a mentor*" too literally. The reality is 
**you need more than a single mentor**; you need your **personal board of
advisors** if you will. But how do you find all these people? Let's see.

I don't want to sound cheesy, but the first step is to 
[**know yourself**][issue-0003]. Finding what you
want requires knowing what you want. Then, reflect deeply and write down a *
*personal vision statement**. Make sure that your *personal vision statement*
resonates with what **you** want to aspire to be. **Not** what society, your
teammates, your managers, or your family expects from you.

[issue-0003]: @/highlights/issue-0003.md

> Think about how your career **aligns** with your personal vision down the
> road. How does your ideal life look like fifteen years ahead?  
> How will it be different from your present-day?

Then create a list of different kinds of support that you will need to 
**actualize** that aspiration. For example, what types of support do you need to
take yourself from where you are to where you want to be?

Then consider which areas are already fulfilled by mentors and helpers and which
aren't.

Do you want a few examples?

* Who do you go when you need to discuss some tactical advice to navigate
  company internals?
* Where do you go for emotional support?
* Whom do you rely on to enhance your technical understanding?

Enhance the list as much as you can.

Then for any role that is "*missing*" a mentor, think about who could fill that
need. Does that person exist in your network, do they exist in your
second-degree network; or do you need to look even further?

Based on that assessment, you can develop new relationships or strengthen the
existing ones.

You'll also find that a prospective mentor or a coach will be **much** inclined
to help you on a particular topic rather than the generic "*would you be my
mentor?*" questions.

In short, as I've been telling you a million times: **do your homework** before
reaching out for help.

## Look What I've Found

Here are the things that grabbed my attention this week.

I typically don't share these anywhere else.

Exclusively hand-picked for you 👌. Enjoy.

* [**Middy** is the stylish Node.js middleware engine for AWS Lambda][middy].
* [Here's how **GitHub** found and fixed a rare race condition in their 
  session handling][race].
* [**Flash News**: You can manage your complexity bias by... keeping things 
  simple, who knew][nesslabs]!

[middy]: https://github.com/middyjs/middy
[race]: https://github.blog/2021-03-18-how-we-found-and-fixed-a-rare-race-condition-in-our-session-handling/
[nesslabs]: https://nesslabs.com/power-of-simplicity-complexity-bias

## Thanks a Lot ❤️

That's all for this week. Next week, I'll gather more unique content and resources.

So, until next time... May the source be with you 🦄.

--------

## Issues

{{ issues_nav(selected=11) }}
