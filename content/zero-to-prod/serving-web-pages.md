+++
#   (`-')           (`-').->
#   ( OO).->        (OO )__
# ,(_/----. .----. ,--. ,'-' doubt everything,
# |__,    |\_,-.  ||  | |  |
#  (_/   /    .' .'|  `-'  | be curious,
#  .'  .'_  .'  /_ |  .-.  |
# |       ||      ||  | |  | learn.
# `-------'`------'`--' `--'

title = "Zero to Prod in Half an Hour: Part 6 --- Serving Web Pages"
date = "2022-01-15"

[taxonomies]
tags = ["zero-to-prod"]
+++

{{img(
  src="/images/size/w1200/2024/03/recurse.png",
  alt="Zero to Prod in Half an Hour: Part 6 --- Serving Web Pages"
)}}

This section will add a bunch of static web page templates into our application
and serve them in several routes. We will also use a Gumroad embed form and a
very minimal dynamic templating in our subscription form.

## Lecture

{{vimeo(
  id="661883975",
  title="Zero to Prod in Half an Hour: Part 6 --- Serving Web Pages"
)}}

## Playlist

{{ zero_to_prod_nav(selected = 6) }}

## Tools and Technologies Mentioned

Here are the tools and technologies that were mentioned in the video, along with
related articles and other helpful links.

* [Gin Web Framework](https://gin-gonic.com/)
* [gin.HandlerFunc](https://pkg.go.dev/github.com/gin-gonic/gin#HandlerFunc)
* [gin.Context](https://pkg.go.dev/github.com/gin-gonic/gin#Context)
* [gin.Engine.LoadHTMLGlob()](https://pkg.go.dev/github.com/gin-gonic/gin#Engine.LoadHTMLGlob)
* [Higher-Order Function](https://en.wikipedia.org/wiki/Higher-order_function)
* [MongoDB](https://www.mongodb.com/)
* [mgo](https://pkg.go.dev/github.com/globalsign/mgo)
* [Gumroad](https://gumroad.com/)
* [Gumroad API](https://app.gumroad.com/api)
* [Papertrail](https://www.papertrail.com/)
* [Syslog](https://en.wikipedia.org/wiki/Syslog)
* [Application load balancing on Amazon EKS](https://docs.aws.amazon.com/eks/latest/userguide/alb-ingress.html)
* [Monitorama PDX 2016 - Kelsey Hightower - healthz: Stop reverse engineering applications and start monitoring from the inside](https://vimeo.com/173610242)
* [Kubernetes: Configure Liveness, Readiness and Startup Probes](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/)

## Read The Source

* [Download the source code (*114kb zip
  archive*)](https://assets.zerotohero.dev/zero-to-prod-in-30/zero-to-prod-in-30.zip)

Until the next lecture... May the source be with you 🦄.
