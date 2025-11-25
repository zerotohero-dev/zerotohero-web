+++
#   (`-')           (`-').->
#   ( OO).->        (OO )__
# ,(_/----. .----. ,--. ,'-' doubt everything,
# |__,    |\_,-.  ||  | |  |
#  (_/   /    .' .'|  `-'  | be curious,
#  .'  .'_  .'  /_ |  .-.  |
# |       ||      ||  | |  | learn.
# `-------'`------'`--' `--'

title = "mTLS With SPIRE: Part 5: Containerizing the Client App"
date = "2022-08-19"

[taxonomies]
tags = ["SPIFFE","SPIRE","mtls"]
+++

{{img(
  src="/images/size/w1200/2024/03/severcloud.png",
  alt="mTLS With SPIRE: Part 5: Containerizing the Client App"
)}}

We'll continue creating creating container images and deploying the client app
to the cluster too, then observe how the client and server communicate with each
other within the pods.

{{youtube(
  id="tpxRI7XuctE?si=_ao-WI6Hd3wAKdLm", 
  title="mTLS With SPIRE: Part 5: Containerizing the Client"
)}}

--------

## Playlist

{{ spire_mtls_nav(selected=5) }}

## Read the Source

* [Access the source code and other related assets from **Zero to Hero** GitHub](https://github.com/zerotohero-dev/spire-mtls).
