+++
#   (`-')           (`-').->
#   ( OO).->        (OO )__
# ,(_/----. .----. ,--. ,'-' doubt everything,
# |__,    |\_,-.  ||  | |  |
#  (_/   /    .' .'|  `-'  | be curious,
#  .'  .'_  .'  /_ |  .-.  |
# |       ||      ||  | |  | learn.
# `-------'`------'`--' `--'

title = "Detecting Ethernet Cable Category"
date = "2025-12-21"

[taxonomies]
tags = ["linux", "networking"]
+++

This is a short case study with `iperf`, Windows, macOS, and `WSL`.

## The Curious Case

Recently, I was testing my downstream network performance on my Windows
and Mac machines, both of them connected to the same router.

The problem was: I was getting ~700Mbps downlink on Windows, while MacOS
saturated at >1Gbps.

> “If I’m only getting ~700 Mbps, my Ethernet cable must be bad, no?”

My first guess was that the cable was bad. But the modem had two green LEDs
on, on both ports.

So, I started digging, as usual.

## The Initial Observation

Two machines are connected to the same router, using what appears to be the 
same cabling:

* **Windows machine**: ~700 Mbps downlink in speed tests
* **macOS machine**: >1 Gbps under similar conditions
* **Router LEDs**: dual green lights on both ports (*indicating 1 Gbps link*)

## What Ethernet LEDs Actually Tell

On most consumer and SMB routers/switches:

* **Green (or dual green) LEDs** means link negotiated at **1 Gbps**
* Amber, single green, or mixed colors typically means **100 Mbps**

And a 1 Gbps link negotiation means:

* All four twisted pairs are working
* The PHY is happy
* The cable meets the electrical requirements for **1000BASE-T**

If the cable were truly the bottleneck (*damaged, Cat5, missing pairs*), 
the link would should have fallend back to 100 Mbps, which it didn't.

700Mbps was a particularly odd number, not fitting anywhere.

## Why Speed Tests Are Misleading

But, the issue was, I was conducting, browser-based speed tests.

Browser-based speed tests are convenient, but they are noisy, for the 
following reasons:

* Single TCP stream by default
* TLS overhead
* CDN path variability
* Antivirus / packet inspection (*especially on Windows*)
* Browser networking limits (*especially on Windows*)

Different operating systems behave differently here:
* macOS tends to be aggressive with TCP window scaling and congestion control.
* while, Windows is often more conservative unless tuned.

That difference alone can explain "*700 Mbps vs 1 Gbps*" without involving the 
cable at all.

But I was curious, and I wanted a definitive answer.

## Enter `iperf3`

To remove browser and application noise,I used `iperf3` from the command line.

My setup:

* macOS runs `iperf3 -s` (*server*)
* Windows runs `iperf3` **inside WSL2** as the *client*
* Test uses **4 parallel TCP streams** (`-P 4`)

WSL is good, and realistic enough for this test because it still uses
**Windows kernel and NIC drivers** under the hood. But it bypasses browser,
antivirus, and any userspace interference. That makes it ideal for isolating 
the problem.

## The Result

Here’s the key output (*from WSL2*)

```text
[SUM] sender   1.01 Gbits/sec
[SUM] receiver 939 Mbits/sec
```

This is exactly what **healthy Gigabit Ethernet** looks like.

But why ~939 Mbps and not a full 1000?

That's mostly due to the following factors:
* Ethernet framing
* TCP/IP overhead
* ACK traffic
* Measurement window differences

In practice, **~950 Mbps is the real ceiling** for a 1Gbps Ethernet.

## My Cable Was Fine

From this result alone, I was able to condlude that:

* The cable Windows uses supports **1000BASE-T**
* All four pairs are functioning
* he router/switch port is fine
* The NIC hardware is fine
* The Windows kernel and driver can sustain line rate
* There is no packet loss (0 retransmits)

In other words:

> The cable is **not** the bottleneck.

At minimum, it behaves as **Cat5e**, it's highly-likely **Cat6**. But 
performance-wise, there’s no practical way to distinguish them at 1 Gbps.

## So Why Did Windows Show ~700 Mbps Earlier?

Because that earlier test was almost certainly limited by 
**measurement method**, not physics.

My best guess is this was due to:

* Single TCP stream
* Browser limits
* TLS/CDN behavior
* Antivirus or endpoint inspection
* Application-level throttling

So when I removed those variables, the link immediately saturated.

## Conclusion

In summary:

* You **cannot reliably infer Ethernet cable category from a browser speed test**
* ~700 Mbps does *not* imply Cat5 or a bad cable
* A negotiated **1 Gbps link already proves cable adequacy**
* `iperf3` with parallel streams is the right diagnostic tool
* macOS vs Windows speed differences are often TCP behavior, not hardware

If you ever wonder whether your cable is the issue, don't guess; measure
at the right layer.
