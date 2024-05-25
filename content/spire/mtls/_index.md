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

![mTLS With SPIRE](/images/size/w1200/2024/03/spire.png)

This video series will guide you through establishing a secure cross-cluster *
*mTLS** connectivity between workloads across multiple clusters using **SPIRE**.

![SPIFFE, Turtles, and SPIRE](/images/2022/10/Fe0tEnHUcAAzJ45.jpeg)

We will start with a blank slate, create our apps from scratch, package them,
deploy them to our clusters, and then deploy and configure **SPIRE** to federate
our clusters to establish cross-cluster **mTLS** connectivity between workloads.

These video series assume that you have _some_ level of familiarity with SPIFFE
and SPIRE. [If you are new to **SPIFFE** and 
**SPIRE**, check out this introductory article first](@/spire/spire-rocks.md).

That said, let's get started with the first video in the series in the playlist
below.

## Playlist

{{ spire_mtls_nav(selected=0) }}

## Read the Source

* [Access the source code and other related assets from **Zero to Hero** GitHub](https://github.com/zerotohero-dev/spire-mtls).

## Parent Section

{{ spire_nav(selected=2) }}
