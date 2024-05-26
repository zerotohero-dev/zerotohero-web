+++
#   (`-')           (`-').->
#   ( OO).->        (OO )__
# ,(_/----. .----. ,--. ,'-' doubt everything,
# |__,    |\_,-.  ||  | |  |
#  (_/   /    .' .'|  `-'  | be curious,
#  .'  .'_  .'  /_ |  .-.  |
# |       ||      ||  | |  | learn.
# `-------'`------'`--' `--'

title = "Words Matter"
date = "2022-02-26"

[taxonomies]
tags = ["highlights"]
+++

![Words Matter](/images/size/w1200/2024/03/framing.png)

Welcome to the 20th issue of **Zero to Hero** Highlights.

It has been a while since the last update; and *as always*, I have been busy
with a lot of things. Here are some highlights.

## **OpsBeacon** is Back on Track 🤘

If you've been following **Zero to Hero** since the beginning, then case, you'll
remember that [with a group of fellow engineers, we'd started **OpsBeacon** to
help operations and level-1 responders **#sleepmore**][opsbeacon-highlight].

[opsbeacon-highlight]: @/highlights/issue-0027.md

That was around **September 2021**. Then life got in the way, and we had to
pause the development of **OpsBeacon** for a while.

Guess what? We are back on track, baby! There is a horde of things on our
roadmap, and it will be a hell of a ride 🤘.

That means you'll hear me talking more about [**OpsBeacon**][opsbeacon], and
mentioning more **OpsBeacon** use cases [in the **Zero to Hero** live
streams][twitch].

[opsbeacon]: https://ob2.ai

[twitch]: https://www.twitch.tv/VadidekiVolkan

## Life is Better at the Slopes

Last week, we were at [**South Lake Tahoe**][tahoe]. The plan was to stay there
for a few days; yet, we found ourselves in the middle of a snowstorm and had to
extend our stay for a few more days.

[tahoe]: https://en.wikipedia.org/wiki/Lake_Tahoe

![View of the lake from the summit of the mountain.](/images/2022/02/IMG_2807.jpeg)

View of the lake from the summit of the mountain.

We've had a lot of fun, and suffice it to say, the kiddos had enough snow for a
year 🙂.

![Snow everywhere. Freezing cold.](/images/2022/02/IMG_2824.jpeg)

Snow everywhere. Freezing cold.

## Would You Like Some Water In Your Ice?

It was snow everywhere. Ice-cold weather. And since this is America, they still
serve iced water ❄️ when the temperature is -20 degrees Celcius outside. Or, in
this case, it is "**_watered ice_**" instead 🙂.

!["America".](/images/2022/02/IMG_2853.jpeg)

## Bye Bye EKS 👋

I terminated the EKS cluster that I was experimenting with on other news.
[You can watch the VOD about the entire process here on **Twitch**][eks-vod].

[eks-vod]: https://www.twitch.tv/videos/1408100867

But, why so? Because I only have a handful of microservices, and paying Amazon
around $90 every month just for a Kubernetes control plane is not worth it.

From this point on, I'll go old school and use an [**Application Load
Balancer**][alb] and some good old [**EC2** instances][ec2] fronted by
[**NGINX**][nginx] reverse proxies and tie everything together with scripts.
It will be a "_poor man's orchestration solution_" that won't tear a hole in
your pocket if you will. And I'll, of course, write and
[live stream about it][twitch] on the go.

[alb]: https://aws.amazon.com/elasticloadbalancing/

[ec2]: https://aws.amazon.com/ec2/

[nginx]: https://www.nginx.com/

## More Live Streams Are Coming Up

I upgraded my streaming setup, and I plan to do regular streams, mostly at night
Pacific time. [Follow me on Twitch and get notified whenever
I'm online][twitch].

## Zero to Hero Changes

I've updated the navigation a little on the Zero to Hero front, highlighting
essential parts that could have been harder to search otherwise.

![The new navigation.](/images/2022/02/Screen-Shot-2022-02-26-at-8.31.09-AM.png)

Here are the links for the interested:

* [**The Roadmap**](@/roadmap/_index.md) is where you can find resources to
  become a better version of yourself.
* [**Z2H Highlights**](@/highlights/_index.md) is an ordered list of these
  weekly updates that you are reading right now.
* [**Live Streams**][twitch] take you directly to **Twitch**, where I'll be more
  active, mostly around nighttime pacific time. Join me, and let's **break
  production** together.

Also, if you remember, I was keeping a list of live streams as a separate page.
I decided to archive that page, as maintaining it was consuming a
disproportionate amount of my time. I'd instead create content than do
bookkeeping to utilize the opportunity cost of the limited time.

## Zero to Prod in Half an Hour

I have been working on this for the last few weeks, and finally, it is ready for
your viewing pleasure.

[**Zero to Prod in Half an Hour**](@/zero-to-prod/_index.md) is 14-part video
series that I have been creating for a while. The lectures show how to create a
full-blown app with **identity** **management**, **payment gateway**
integration, business logic, and all and deploy it to a production **Kubernetes
**
(*EKS*) cluster. The total recording time is around **half an hour**.

The videos are free. If you are a premium member, you can also get **learning
resources**, links, and additional **study material** to dig in, along with the
**source code**.

At any rate, [have fun, and enjoy the content](@/zero-to-prod/_index.md).

## Random Thought of the Week

How you frame a problem directly impacts whether you can solve it. That means
words are more important than one might think they are. When you pick your
words carefully when describing your issue, you'll have a much better chance of
solving it.

If you struggle to generate effective solutions to complicated problems, you
might want to change the way you define the problem statement.

Specifically, ask yourself these two questions:

### What's the Subject?

Let's say that you want to change a feature on an application. If the app is
targeted towards an expert audience, then you'll generate a different solution
than an app targeted towards beginners.

### How can you measure the problem?

Without metrics and measurement, solving a problem can turn into a futile
effort. After all, how can you know you have achieved something if you cannot
quantify your achievement.

In your metrics, define what **success** and **failure** look like.

For example, "*we strive to create as much services as the customer as we can*"
will lead you to a different solution than "*only 20% of our feature set is
widely used, and out of that 20%, only 5% generate revenue*."

So next time you are struggling to find a solution, **try rewriting the problem
statement**. You'll possibly find that a minor change in your wording can lead
to a significant shift in your perspective.

Words **do** matter.

## Look What I've Found

Here are the things that grabbed my attention this week.

I typically don't share these anywhere else.

Exclusively hand-picked for you 👌. Enjoy.

* [**`soft-serve`** is a tiny self-hostable Git server](https://github.com/charmbracelet/soft-serve).
* [**Pika** is an open source color picker app for Mac OS](https://superhighfives.com/pika).
* [**`trunk`** is a static analyzer to make your code better, faster, stronger](https://trunk.io/products/check).

## Thanks a Lot ❤️

That's all for this week. Next week, I'll gather more unique content and
resources.

So, until next time... May the source be with you 🦄.

--------

## Issues

{{ issues_nav(selected=20) }}
