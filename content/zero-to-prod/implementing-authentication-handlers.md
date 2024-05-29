+++
#   (`-')           (`-').->
#   ( OO).->        (OO )__
# ,(_/----. .----. ,--. ,'-' doubt everything,
# |__,    |\_,-.  ||  | |  |
#  (_/   /    .' .'|  `-'  | be curious,
#  .'  .'_  .'  /_ |  .-.  |
# |       ||      ||  | |  | learn.
# `-------'`------'`--' `--'

title = "Zero to Prod in Half an Hour: Part 11 --- Implementing Authentication Handlers"
date = "2022-02-10"

[taxonomies]
tags = ["zero-to-prod"]
+++

{{img(
  src="/images/size/w1200/2024/03/authz.png",
  alt="Zero to Prod in Half an Hour: Part 11 --- Implementing Authentication Handlers"
)}}

Having implemented our middlewares, now it's time to implement the missing
OAuth0 callback, login, and logout handlers.

## Lecture

{{vimeo(
  id="662357647",
  title="Zero to Prod in Half an Hour: Part 11 --- Implementing Authentication Handlers"
)}}


## Playlist

{{ zero_to_prod_nav(selected = 11) }}

## Tools and Technologies Mentioned

Here are the tools and technologies that were mentioned in the video, along with
related articles and other helpful links.

* [Gin.HandlerFunc](https://pkg.go.dev/github.com/gin-gonic/gin#HandlerFunc)
* [Auth0](https://auth0.com/)
* [Which OAuth 2.0 Flow Should I Use?](https://auth0.com/docs/get-started/authentication-and-authorization-flow/which-oauth-2-0-flow-should-i-use)
* [Higher-Order Function](https://en.wikipedia.org/wiki/Higher-order_function)
* [JSON Web Token Introduction](https://jwt.io/introduction)
* [RFC 7519 --- JSON Web Token (JWT)](https://datatracker.ietf.org/doc/html/rfc7519)

## Read The Source

* [Download the source code (*114kb zip
  archive*)](https://assets.zerotohero.dev/zero-to-prod-in-30/zero-to-prod-in-30.zip)

------------

Until the next lecture... May the source be with you 🦄.
