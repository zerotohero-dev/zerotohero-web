+++
#   (`-')           (`-').->
#   ( OO).->        (OO )__
# ,(_/----. .----. ,--. ,'-' doubt everything,
# |__,    |\_,-.  ||  | |  |
#  (_/   /    .' .'|  `-'  | be curious,
#  .'  .'_  .'  /_ |  .-.  |
# |       ||      ||  | |  | learn.
# `-------'`------'`--' `--'

title = "Interview Done. Radio Silence 🎃 What Now?"
date = "2021-10-22"

[taxonomies]
tags = ["highlights","security","SPIFFE","SPIRE"]
+++

![Interview Done. Radio Silence 🎃 What Now?]()

{{img(
  src="/images/size/w1200/2024/03/radio.png"
  alt="Radio silence?"
)}}

Welcome to the 24th issue of **Zero to Hero** Highlights.

My schedule had been a total trainwreck for the last few months, and I couldn't
find much time to show ❤️ to **Zero to Hero** Highlights highlights.

Starting from this one, I'm planning to change this 🙂.

## 👩‍🍳 Tiny Updates Here and There

If you are a frequent visitor, you might have realized some minor design changes
here and there. More of those are coming, and I'm also creating a mini video
about my overall design process.

After all, Zero to Hero is one of the **central** places I create content, and
no matter how hectic my life is, it deserves attention and care.

## Turtle Power 🐢⚡️

If you are interested in federating identities across multiple clusters and
using mutual transport layer security over **gRPC** to let workloads talk
between those clusters. First of all, you have weird interests 🙂. And secondly,
I have a series of ten videos over forty-five minutes that you can
enjoy [mTLS With SPIRE][spire-mtls].

{{img(
  src="/images/2022/10/Fe0tEnHUcAAzJ45-2.jpeg"
  alt="SPIFFE, SPIRE, Ninja Turtles 🐢🐢🐢"
)}}

[In the series][spire-mtls], as usual, I assume
nothing and begin with a blank slate, coding everything from scratch and
creating a brand-new project. On the videos' web page, you can also get the
source code and find many relevant links and articles to dive further.

[spire-mtls]: @/spire/mtls/_index.md

## Distributed Systems Are Grinches

Well, I thought of something else instead of a "*grinch*", but I'm so very
polite, and I'm not going to say that thing.

This is from [Evan Gilman][evan] on **SPIFFE** Slack
Channel. Evan is also the author
of [Zero Trust Networks][zero-trust-networks].
So, when he talks about **Distributed Systems**, you can assume he knows what
he's talking about (*content edited for brevity and clarity*):

[evan]: https://twitter.com/evan2645
[zero-trust-networks]: https://goodreads.com/book/show/31805610-zero-trust-networks
[spire]: https://spiffe.io/docs/latest/spire-about/

> Here are a few things that come to mind when you want to use a remote database
> such as Google Cloud Spanner as the backing store of a distributed system that
> requires **strong consistency** (*such as [SPIRE][spire]*):
>
> **Performance**
> 
> Tight consistency will always require some number of round trips with some
> quorum of nodes to commit changes and move forward. And, there will always be an
> upper limit applied to how fast this system can progress: The latency or round
> trip time between participants is a crucial factor.
>
> Given (*increased*) latency, the system will naturally hit a performance wall.
> This can be (*sometimes disastrously*) exacerbated by the "*Internet weather*".
>
> **Operational Overhead**
> 
> Some systems require synchronization periods when starting new or restarting
> existing nodes. During these periods, bulk transfer of data occurs.
>
> Cross-region pipes or commodity Internet is usually (*comparatively*) lower
> throughput. So, depending on how much data you're talking about, it can induce
> significant amounts of overhead on the wire and wait time during operations for
> the cluster to stabilize following some event.
>
> There will be similar concerns about time-to-recover from a restore 
> (*i.e., make sure your restore data is close by*).
>
> **Exotic Failure Modes**  
> 
> Most distributed systems aren't written, and don't get tested, for use across
> high latency lossy links. Lots of weird things can happen across these links,
> which tend to have at least a couple middle boxes:
>
> -- TCP sessions that get held open but nobody is there,  
> -- High jitter on one link in the system that is traversing a really busy
> router,  
> -- And many more...
>
> Persistence systems---particularly those requiring consensus---like to fall
> over when these things happen.
>
> And many times, bugs are uncovered because nobody ever tried it before.

For the record, [here is an article that Evan wrote about exactly one of 
these cases][poison-packet].

Why did I share it? Because I didn't want it to be lost in Slack archives. And
dear Slack: **show some ❤️ to open source communities**. Not many of them have
the funds to secure a paid plan.

[poison-packet]: https://ars-technica.com/information-technology/2015/05/the-discovery-of-apache-zookeepers-poison-packet/

## Interview Done. Radio Silence. What Now?

Radio silence after a job interview can be a painful feeling. But it doesn't
always mean rejection.

Especially in large companies, the hiring teams might take a very long time to
deliberate, discuss potential candidates, and decide on the candidate to extend
an offer. It can take an equal amount of time to come up with an official offer
latter obtaining all the required approvals.

To better understand what's holding up the process, ask questions and listen
carefully. In this process---like it or not---your recruiter is your ally. So
ask them (_or whoever the facilitator of the process is_) questions similar to
these:

* When will you be reviewing candidates with the hiring manager?
* When is the hiring manager hoping to make a decision?

This time frame is essential. Because if the hiring manager isn't communicating
with you after this deliberation period, you are most likely not a top
candidate.

And there is nothing wrong with that, either.And, there is nothing wrong with
that either. Companies choose candidates for variety of reasons, and some of
those reasons are not related to knowledge, skills, and abilities.

Though if they say something like, "*We'll have some decision made in the next
two weeks*," you are likely still in consideration.

Once the debriefing time passes, don't take the silence personally. Either the
hiring manager has not been dedicated yet. Or, more likely, the recruiter has
offered another candidate the job before rejecting you.

Also, as I said, don't beat yourself up if you don't end up getting the job.
Interviews, especially in the tech industry, are a numbers game. The more you
attend, the higher your odds are.

**Look from the bright side:** Your résumé demonstrated that your experience and
interview skills were solid. You weren't the top candidate and maybe got a 
"*silver medal*," so what? That's a-o-kay. Chin up, buckle up, and move on to the
next opportunity.

## Look What I've Found

Here are the things that grabbed my attention this week.

I typically don't share these anywhere else.

Exclusively hand-picked for you 👌. Enjoy.

* [**Prisma** is an "all batteries included" **ORM** for **Node.js** and 
  **TypeScript**][prisma].
* [**Goose** is a Database migration tool to migrate your databases. 
  Goose---get it?][goose].
* [Have you ever wanted to embed a calculator inside a text editor? 
  Me neither. But **NumPad** has][numpad].

[prisma]: https://www.prisma.io/
[goose]: https://github.com/pressly/goose
[numpad]: https://numpad.io/

Thanks a Lot ❤️
---------------

That's all for this week. Next week, I'll gather more unique content and
resources.

So, until next time... May the source be with you 🦄.

--------

## Issues

{{ issues_nav(selected=24) }}
