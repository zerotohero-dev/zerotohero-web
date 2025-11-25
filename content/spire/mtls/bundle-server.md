+++
#   (`-')           (`-').->
#   ( OO).->        (OO )__
# ,(_/----. .----. ,--. ,'-' doubt everything,
# |__,    |\_,-.  ||  | |  |
#  (_/   /    .' .'|  `-'  | be curious,
#  .'  .'_  .'  /_ |  .-.  |
# |       ||      ||  | |  | learn.
# `-------'`------'`--' `--'

title = "mTLS With SPIRE: Part 4: Containerizing the Server Appp"
date = "2022-08-19"

[taxonomies]
tags = ["SPIFFE","SPIRE"]
+++

{{img(
  src="/images/size/w1200/2024/03/containers.png",
  alt="mTLS With SPIRE: Part 4: Containerizing the Server App"
)}}

This section will bundle the server application, create and image out of it,
create deployment manifests, and deploy it into the cluster.

{{youtube(
  id="VuT5zaZwq2Y?si=9nVhMhb_QdzHWYyj", 
  title="mTLS With SPIRE: Part 4: Containerizing the Server App"
)}}

--------

## Playlist

{{ spire_mtls_nav(selected=4) }}

## Tools and Technologies Mentioned

Here are the tools and technologies that were mentioned in the video, along with
related articles and other helpful links.

* [**Docker**](https://www.docker.com/)
* [Open Container Initiative (**_OCI_**)](https://opencontainers.org/)
* [Multistage Builds](https://docs.docker.com/build/building/multi-stage/)
* [Dockerfile Reference](https://docs.docker.com/engine/reference/builder/)
* [Distroless Container Images](https://github.com/GoogleContainerTools/distroless)
* [Docker Registry](https://docs.docker.com/registry/)
* [Deployments](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)
* [Services](https://kubernetes.io/docs/concepts/services-networking/service/)
* [**MetalLB**](https://metallb.universe.tf/) (_this is the LoadBalancer we used
  in this video series_)

## Read the Source

* [Access the source code and other related assets from **Zero to Hero** GitHub](https://github.com/zerotohero-dev/spire-mtls).
