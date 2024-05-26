+++
#   (`-')           (`-').->
#   ( OO).->        (OO )__
# ,(_/----. .----. ,--. ,'-' doubt everything,
# |__,    |\_,-.  ||  | |  |
#  (_/   /    .' .'|  `-'  | be curious,
#  .'  .'_  .'  /_ |  .-.  |
# |       ||      ||  | |  | learn.
# `-------'`------'`--' `--'

title = "mTLS With SPIRE: Part 10: Establishing Cross-Cluster mTLS"
date = "2022-08-19"

[taxonomies]
tags = ["mtls", "spiffe", "spire"]
+++

![mTLS With SPIRE: Part 10: Establishing Cross-Cluster mTLS](/images/size/w1200/2024/03/connectivity.png)

In this final video of this series, we'll exchance trust bundles between two *
*SPIRE** servers to enable cross-cluster **mTLS** connectivity between workloads
that reside in different clusters.

{{ 
  vimeo(
    id="760885671", 
    title="mTLS With SPIRE: Part 8: Configuring the Server to User SPIRE mTLS"
  ) 
}}

--------

## Playlist

{{ spire_mtls_nav(selected=10) }}

## Tools and Technologies Mentioned

Here are the tools and technologies that were mentioned in the video, along with
related articles and other helpful links.

* [Deploying a Federated **SPIRE** Architecture](https://spiffe.io/docs/latest/architecture/federation/readme/)
* [Kubernetes Persistent Volumes](https://kubernetes.io/docs/concepts/storage/persistent-volumes/)
* [Microk8s](https://microk8s.io/)

## Read the Source

* [Access the source code and other related assets from **Zero to Hero** GitHub](https://github.com/zerotohero-dev/spire-mtls).
