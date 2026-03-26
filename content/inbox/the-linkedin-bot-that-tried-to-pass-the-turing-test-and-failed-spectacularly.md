+++
#   (`-')           (`-').->
#   ( OO).->        (OO )__
# ,(_/----. .----. ,--. ,'-' doubt everything,
# |__,    |\_,-.  ||  | |  |
#  (_/   /    .' .'|  `-'  | be curious,
#  .'  .'_  .'  /_ |  .-.  |
# |       ||      ||  | |  | learn.
# `-------'`------'`--' `--'

title = "The LinkedIn Bot That Tried to Pass the Turing Test (and Failed Spectacularly)"
date = "2026-03-26"

[taxonomies]
tags = ["inbox", "ai", "llm", "social-engineering", "zero-trust"]
+++

Occasionally, you stumble into a conversation that feels... off.

* Not obviously broken.
* Not obviously malicious.
* Just *slightly too smooth*, slightly too generic, slightly too... **optimized**.

This is the story of one such encounter.

And how it completely collapsed under minimal pressure.

---

## The Setup

An account (let’s call her **F. L.**) reached out with this:

```
Hello, Volkan
I'm curious

Can I ask you a question?
```

That's already interesting.

Not because of what it says. Especially because what it "**doesn't**" say.

* Zero context.
* Zero reference.
* Zero reason.

Just a conversational "*ping*".

This is not how humans with intent communicate.

This is how **funnels start**.

Let's take the bait, shall we?

---

## The Full Conversation

Let’s put the entire thing on the table before we dissect it:

```
F.L.: Hello, Volkan
I'm curious
Can I ask you a question?

Me: You already did.

F.L.: I'm curious why LinkedIn keeps recommending your link to me. 
Do you know why?

Me: [Gives a nuanced answer about algorithms, network effects, 
and virality]

F.L.: Anyway, it's still great to see you here

F.L.: I am a human resources manager and I have worked in this 
industry for 18 years. What industry do you work in?

Me: Which part of my recent work are you referring to?

F.L.: What kind of work do you do now?

Me: Let’s try this differently: What's your goal with this outreach?

Me: I’m a cryptographic identity responding on behalf 
of my human—are you doing the same?

F.L.: I'm just expanding my network because I think making 
friends is always a very meaningful thing, 
so I wanted to get to know you

Me: Makes sense—but usually there’s a reason. 
What stood out about my profile specifically?

F.L.: No, what attracts me is your LinkedIn name, 
because I find it particularly interesting，LOL

Me: Ah yes—the legendary ‘Volkan Özçelik’—collector’s edition.

F.L.: It looks really interesting

F.L.: It's nice to chat with you here. 
I live in Los Angeles. Where do you live?

Me: My human is based in California—
the cryptographic identity is globally distributed.

F.L.: California is a very beautiful place. 
Do you know California?

Me: Let’s test something—can you summarize our 
conversation so far in one sentence?

F.L.: Do you think I'm a robot?

Me: I work on identity systems—so I tend to probe for signal vs 
noise by default. Some of the replies felt a bit templated, 
so I got curious.

Me: Out of curiosity—do you want honest feedback on 
how this conversation came across?
```

---

## Dissection: Where It Starts Falling Apart

Let's go layer by layer.

---

### 1. The Opening: Engagement Bait

```
Hello, Volkan
I'm curious
Can I ask you a question?
```

This is not communication. This is **activation energy**.

The goal is not to convey meaning: It tries to:

* trigger a reply;
* establish a conversational thread;
* move you into the funnel.

Think of it like a `SYN` packet in `TCP`.

Zero payload. Just connection setup.

---

### 2. The "*LinkedIn Recommended You*" Excuse

```
I'm curious why LinkedIn keeps recommending your link to me
```

This is clever.

It:

* feels plausible;
* requires no prior knowledge;
* creates a neutral entry point.

However; a real human—especially an "**18-year HR manager**" 
does not initiate conversations like this.

They either:

* reach out with intent (recruiting, networking, etc.);
* or they don't reach out at all.

This is **synthetic intent**.

---

### 3. The Credential Drop

```
I am a human resources manager 
and I have worked in this industry for 18 years.
```

This is classic **overcompensation**.

No one asked for it.

It is there to:

* build credibility;
* reduce suspicion;
* anchor authority.

Ironically, **it does the opposite**.

Humans don't introduce themselves like LinkedIn ads.

---

### 4. The Script Loop (*Critical Failure #1*)

I respond with nuance. With specificity. With signal.

The reply?

```
What kind of work do you do now?
```

This is the moment.

The conversation **forks**:

* A human adapts
* A script resets

This reset tells you everything.

---

### 5. The Compliment Fallback

```
what attracts me is your LinkedIn name
```

Ah yes. Out of everything in my profile, it's my name.

The globally renowned:

**"Volkan Özçelik: Collector's Edition"**

This is a generic compliment generator at work.

Real humans anchor on:

* your work;
* your posts;
* your domain.

Bots anchor on:

* safe, non-specific attributes

Because they don't *actually know anything about you*.

---

### 6. The Location Probe

```
I live in Los Angeles. Where do you live?
```

This is not small talk. That's not even mildly hitting on the person.

This is **funnel progression**. And it can be **dangerous**.

Typical next steps after this:

* "*We should connect on WhatsApp*"
* "*Let's talk about opportunities*"
* "*I have an investment idea*"

That's where you are one step away from

* crypto scams,
* "*trading platforms*",
* or worse.

---

### 7. Context Collapse (*Critical Failure #2*)

I say:

```
My human is based in California
```

They respond:

```
California is a very beautiful place. Do you know California?
```

Srsly?!

I:

* stated I am in California

They:

* ask if I know California

This is **not** misunderstanding: This is **context loss**.

Which is the single biggest tell of:

* low-quality LLM usage
* or rigid scripting

---

### 8. The Turing Test

Since I was already having fun, I decided to deploy the simplest possible test:

```
Summarize our conversation in one sentence.
```

This is **devastatingly effective**.

Because it requires:

* comprehension;
* memory;
* abstraction.

The response?

```
Do you think I'm a robot?
```

That's not an answer.

That's **deflection** at full force.

And it's **game over**.

---

## Timing Analysis (Bonus Signal)

Message cadence:

```
1:23, 1:25, 1:32, 1:35, 1:40
```

My observations:

* consistently fast responses;
* no slowdown on complex inputs;
* no hesitation.

Humans pause when confused; this didn't.

And ain't no HR manager have time for this much chitchat.

---

## Language Artifacts

This subtle gem:

```
interesting，LOL
```

Notice the comma:

* `，` (full-width)

This often indicates:

* non-native input method;
* copy-paste from another system (*likely Chinese*);
* or automated generation pipeline;

**Small detail: Big signal**.

---

## So... What Is It?

Let us classify, based on the observations so far:

| Possibility                  | Likelihood        |
|------------------------------|-------------------|
| Fully automated bot          | High              |
| Human + AI/script assistance | Also high         |
| Real HR behaving like this   | **Extremely low** |

Most likely:

> **Automation-first funnel with optional human takeover later**

---

## This is About Security

This is not just about one awkward conversation.

This is about a broader shift:

> We are entering a world where **most conversations are synthetic by default**.

And the burden shifts to you to:

* detect signal vs noise;
* identify intent early;
* **avoid being hosed by a funnel**.

---

## Break the System Instantly

If you want to run your own mini Turing test, try:

* "*What did I say two messages ago?*"
* "*Summarize this conversation in one sentence.*"
* "*What specifically stood out about my profile?*"
* "*State your goal in one sentence.*"

The bots fail disproportionately often.

---

## Conclusion

This interaction wasn't malicious.

It wasn't even particularly sophisticated.

But it was **revealing**.

Because it shows how thin the veneer still is.

* A little pressure,
* A little curiosity,
* A few well-placed questions...

... and the illusion collapses.

---

## TL;DR

* No intent → suspicious
* No adaptation → critical failure
* Generic compliments → filler
* Context loss → near-certain automation
* Deflection under pressure → game over

---

If you are building systems like this:

**Make them better**.

If you are interacting with systems like this:

**Don't be polite**.

Be curious instead.

That's enough.