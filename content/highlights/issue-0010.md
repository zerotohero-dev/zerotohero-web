+++
#   (`-')           (`-').->
#   ( OO).->        (OO )__
# ,(_/----. .----. ,--. ,'-' doubt everything,
# |__,    |\_,-.  ||  | |  |
#  (_/   /    .' .'|  `-'  | be curious,
#  .'  .'_  .'  /_ |  .-.  |
# |       ||      ||  | |  | learn.
# `-------'`------'`--' `--'

title = "Tough Conversation"
date = "2021-07-24"

[taxonomies]
tags = ["highlights"]
+++

![Tough Conversations](/images/size/w1200/2024/03/overwhelmed.png)

Welcome to the tenth issue of **Zero to Hero** Highlights.

Last week, it was part infrastructure, part content creation. Here's a quick
overview of what has happened.

## Radio Zero to Hero is Growing 🤘

I did several optimizations for the [**Radio Zero to Hero**](https://twitch.tv/VadidekiVolkan) 
stream. Here are the essential highlights.

I figured out that [**Wirecast**](https://www.telestream.net/wirecast/) already
has an audio plugin that can stream the system audio. It works **much** better
than the [**Shiny White Box**](https://shinywhitebox.com/) audio capture plugin
that I have. As a result, I don't have audio quality problems anymore. I can
stream music forever without restarting my machine (*which was not the case
before*).

So yeah, overall better audio quality.

Additionally, I reduced the frame rate from *60fps* to *25fps*, which is still 
**more than enough** if you are just streaming live coding sessions on an IDE. I
also figured out **4500Kbps** for *bitrate* was optimal for me.

Here are my entire settings for the interested.

![Zero to Hero Twitch stream settings.](/images/2021/07/Screen-Shot-2021-07-24-at-10.30.26-AM.png)

Zero to Hero Twitch stream settings.

But the gist is that I now have **much** better video and audio quality, with 
**a much** smoother streaming experience.

Ah, also, as of now, Radio Zero to Hero has...

✨ 3565 (*and increasing*) tracks

✨ totaling 187 hours 22 minutes and 56 seconds of

✨ non-stop, 24/7, beyond-this-world beats 🎶.

Want to see how it
looks? [Come join the fun on Twitch](https://twitch.tv/VadidekiVolkan).

It's my primary music source when I'm coding and developing right now (*sorry,
Spotify, my old friend*).

## What's on the Horizon 👩‍🍳

I finally finished configuring a TLS-terminated Kubernetes AWS ALB Ingress for
FizzBuzz Pro (*try saying that five times fast, huh? 😃*)

![FizzBuzz Pro Kubernetes settings.](/images/2021/07/Screen-Shot-2021-07-24-at-10.41.58-AM-1.png)

FizzBuzz Pro Kubernetes settings.

Anyhoo, I learned **a lot** during the process, which means more articles and
videos are on their way, so that you won't have to suffer what I've suffered 🙂.

Other than that I'm working on the IDM Service, which is all about
user-management things like login, logout, password reset, and all.

[I have also created a video going through the high-level system design 
of **FizzBuzz Pro**](@/zero-to-prod/fizzbuzz-pro-hla.md); you'll like it.

## Random Thought of the Week

### Feeling Stressed? You are Not Alone

Feeling stressed? Feeling overwhelmed? You are not alone. Let's see how you can
manage your productivity under stress.

First of all, you must realize that if you are stressed the hell out that you
cannot get stuff done in time, conventional time management strategies will not
help you. When under stress, trying to improve your efficiency will backfire and
make things worse.

Why? Because when you become more efficient, you'll make more room for tasks,
and you'll feel even further under pressure.

If you feel overwhelmed, attack the root cause. **Be honest** with yourself (
_and others_) about what you can actually commit to. Say "*No*" often. For the
tasks you maintain, **think in terms of priorities**, *not* in terms of time.

> Saying "*I don't have time for that*" to a superior can sound abrupt, awkward,
> and negative; however, reframing the phrase like "*Where would you like me
prioritize this against these three tasks that I already am committed to?*" can
> put things into context.

Additionally, this approach places the onus on them to tell you which task is
more important, so you have one less thing to worry about. Win-win 🙌.

### Tough Conversations

My next random thought is about "*tough conversations*", or "*giving though
feedback*".

Tough conversations are challenging for a reason, and---related to the above
discussion---when you are stressed out, it's easy to say the wrong thing at the
wrong time.

To keep the interaction going sideways, pay special attention to how you
communicate your ideas.

For instance phrases like "*obviously*", "*clearly*", "*certainly*", "*no
doubt*" will likely trigger defensiveness and negative emotions in your
counterpart.

Additionally, don't exaggerate things. Avoid sentences like "*We always...*", "
*We never...*". And needless to say, don't challenge anyone's character or
integrity.

> Focus on the issue, not on the person solving the issue.

Also people generally feel defensive about "*Why*" statements, and they feel
judged by "*Should*" statements. Instead, you can say "*You might want to
consider...*", "*Can this be a possibility...*", "*Have you thought of...*".
Leave room for them to elaborate and think creatively.

Ah, one final advice: **Don't say "*it's not personal*"**.

It might not be personal to you, but it **is** pretty darn personal to them.

## Look What I've Found

Here are the things that grabbed my attention this week.

I typically don't share these anywhere else.

Exclusively hand-picked for you 👌. Enjoy.

* [**DevOps Helper Bot** is used for helping in administration and moderation DevOps groups in telegram](https://github.com/Asgoret/devopshelper_bot).
* [**AnyStatus** is a remote control for your CI/CD Pipeline](https://github.com/AnyStatus/AnyStatus).
* [**Popeye** is a Kubernetes cluster resource sanitizer](https://github.com/derailed/popeye).

Thanks a Lot ❤️
---------------

That's all for this week. Next week, I'll gather more unique content and
resources.

So, until next time... May the source be with you 🦄.

## Issues

{{ issues_nav(selected=10) }}
