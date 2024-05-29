+++
#   (`-')           (`-').->
#   ( OO).->        (OO )__
# ,(_/----. .----. ,--. ,'-' doubt everything,
# |__,    |\_,-.  ||  | |  |
#  (_/   /    .' .'|  `-'  | be curious,
#  .'  .'_  .'  /_ |  .-.  |
# |       ||      ||  | |  | learn.
# `-------'`------'`--' `--'

title = "mTLS with SPIRE"
description = "A series of articles on how to use SPIRE to secure workloads with mTLS."
date = "2024-05-19"
template = "series-index.html"
+++

{{img(
  src="/images/size/w1200/2024/03/spire.png",
  alt="SPIRE rocks!"
)}}

This video series will guide you through establishing a secure cross-cluster *
*mTLS** connectivity between workloads across multiple clusters using **SPIRE**.

{{img(
  src="/images/2022/10/Fe0tEnHUcAAzJ45.jpeg",
  alt="SPIFFE, Turtles, and SPIRE"
)}}

We will start with a blank slate, create our apps from scratch, package them,
deploy them to our clusters, and then deploy and configure **SPIRE** to federate
our clusters to establish cross-cluster **mTLS** connectivity between workloads.

These video series assume that you have *some* level of familiarity with 
[**SPIFFE** and **SPIRE**][spiffe]. [If you are new to **SPIFFE** and 
**SPIRE**, check out this introductory article first][spire-rocks].

That said, let's get started with the first video in the series in the playlist
below.

[spire-rocks]: @/spire/spire-rocks.md
[spiffe]: https://spiffe.io/

--------

## Playlist

{{ spire_mtls_nav(selected=0) }}

## Read the Source

* [Access the source code and other related assets from **Zero to Hero** 
  GitHub](https://github.com/zerotohero-dev/spire-mtls).

--------

## Parent Section

{{ spire_nav(selected=2) }}
