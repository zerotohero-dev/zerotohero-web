+++
#   (`-')           (`-').->
#   ( OO).->        (OO )__
# ,(_/----. .----. ,--. ,'-' doubt everything,
# |__,    |\_,-.  ||  | |  |
#  (_/   /    .' .'|  `-'  | be curious,
#  .'  .'_  .'  /_ |  .-.  |
# |       ||      ||  | |  | learn.
# `-------'`------'`--' `--'

title = "mTLS With SPIRE: Part 7: Registering Nodes and Workloads to SPIRE"
date = "2022-10-19"

[taxonomies]
tags = ["mtls", "spiffe", "spire"]
+++

{{img(
  src="/images/size/w1200/2024/03/mutual-1.png",
  alt="mTLS With SPIRE: Part 7: Registering Nodes and Workloads to SPIRE"
)}}

For SPIRE to be able to attest workloads and distribute **SVID**s to them, we'll
have to register the nodes and the workloads to **SPIRE**. That's what this
section is all about.

{{ 
  vimeo(
    id="760885483", 
    title="mTLS With SPIRE: Part 7: Registering Nodes and Workloads to SPIRE"
  ) 
}}

--------

## Playlist

{{ spire_mtls_nav(selected=7) }}

## Tools and Technologies Mentioned

Here are the tools and technologies that were mentioned in the video, along with
related articles and other helpful links.

* [**SPIRE** Concepts](https://spiffe.io/docs/latest/spire-about/spire-concepts/)
* [**SPIRE** Kubernetes Workload Registrar](https://github.com/spiffe/spire/blob/main/support/k8s/k8s-workload-registrar/README.md)
* [**SPIRE** Controller Manager](https://github.com/spiffe/spire-controller-manager)

## Read the Source

* [Access the source code and other related assets from **Zero to Hero** GitHub](https://github.com/zerotohero-dev/spire-mtls).
