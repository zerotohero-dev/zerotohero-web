+++
#   (`-')           (`-').->
#   ( OO).->        (OO )__
# ,(_/----. .----. ,--. ,'-' doubt everything,
# |__,    |\_,-.  ||  | |  |
#  (_/   /    .' .'|  `-'  | be curious,
#  .'  .'_  .'  /_ |  .-.  |
# |       ||      ||  | |  | learn.
# `-------'`------'`--' `--'

title = "mTLS With SPIRE: Part 8 --- Configuring the Server to Use SPIRE mTLS"
date = "2021-10-19"

[taxonomies]
tags = ["mtls", "spiffe", "spire"]
+++

![mTLS With SPIRE: Part 8 --- Configuring the Server to Use SPIRE mTLS](/images/size/w1200/2024/03/server.png)

Now that we have **SPIRE**, our server application can use it to establish an
**mTLS** connectivity.

{{ 
  vimeo(
    id="760885555", 
    title="mTLS With SPIRE: Part 8: Configuring the Server to User SPIRE mTLS"
  ) 
}}

--------

## Playlist

{{ spire_mtls_nav(selected=8) }}

## Tools and Technologies Mentioned

Here are the tools and technologies that were mentioned in the video, along with
related articles and other helpful links.

* [**SPIRE** Concepts](https://spiffe.io/docs/latest/spire-about/spire-concepts/)
* [MicroK8s](https://microk8s.io/) (_the Kubernetes variant that we used in these videos_)
* [go-spiffe: Go Library for **SPIFFE** Support](https://github.com/spiffe/go-spiffe)
* [Authentication and Authorization](https://auth0.com/docs/get-started/identity-fundamentals/authentication-and-authorization)
* [What's a Service Mesh](https://www.redhat.com/en/topics/microservices/what-is-a-service-mesh)
* [**istio**](https://istio.io/)
* [Open Policy Agent (**_OPA_**)](https://www.openpolicyagent.org/)
* [**Envoy** Proxy](https://www.envoyproxy.io/)
* [**Envoy** Secret Discovery Service](https://www.envoyproxy.io/docs/envoy/latest/configuration/security/secret)
