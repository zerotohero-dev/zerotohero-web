+++
#   (`-')           (`-').->
#   ( OO).->        (OO )__
# ,(_/----. .----. ,--. ,'-' doubt everything,
# |__,    |\_,-.  ||  | |  |
#  (_/   /    .' .'|  `-'  | be curious,
#  .'  .'_  .'  /_ |  .-.  |
# |       ||      ||  | |  | learn.
# `-------'`------'`--' `--'

title = "mTLS With SPIRE: Part 9: Configuring the Client to User SPIRE mTLS"
date = "2021-10-19"

[taxonomies]
tags = ["SPIFFE","SPIRE","git","security"]
+++

{{img(
  src="/images/size/w1200/2024/03/almost-there.png",
  alt="mTLS With SPIRE: Part 9: Configuring the Client to User SPIRE mTLS"
)}}

We are almost there! Once we configure the client to use **SPIRE** mTLS, the
client and the server can talk securely within a single cluster. In the
following video, we'll move the client to a different cluster and federate the 
**SPIRE** servers to establish cross-clsuter **mTLS** too.

{{youtube(
  id="5Onh7nR6xcs?si=q7SvMuDqZAxIhaRl", 
  title="mTLS With SPIRE: Part 9: Configuring the Client to User SPIRE mTLS"
)}}

--------

## Playlist

{{ spire_mtls_nav(selected=9) }}

## Read the Source

* [Access the source code and other related assets from **Zero to Hero** GitHub](https://github.com/zerotohero-dev/spire-mtls).
