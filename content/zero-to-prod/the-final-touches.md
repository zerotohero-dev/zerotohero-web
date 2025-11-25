+++
#   (`-')           (`-').->
#   ( OO).->        (OO )__
# ,(_/----. .----. ,--. ,'-' doubt everything,
# |__,    |\_,-.  ||  | |  |
#  (_/   /    .' .'|  `-'  | be curious,
#  .'  .'_  .'  /_ |  .-.  |
# |       ||      ||  | |  | learn.
# `-------'`------'`--' `--'

title = "Zero to Prod in Half an Hour: Part 12 --- The Final Touches"
date = "2022-02-09"

[taxonomies]
tags = []
+++

{{img(
  src="/images/size/w1200/2024/03/artwork.png",
  alt="Zero to Prod in Half an Hour: Part 12 --- The Final Touches"
)}}

We are done with the authentication part. We are almost near the end of our
application's initial implementation. We just need a questions handlers, which,
in essence, is a glorified file server with some path traversal protection for
an added level of security.

## Lecture

{{youtube(
  id="17OZdX1WOOw?si=g4rIEKOhDQ2txaOj",
  title="Zero to Prod in Half an Hour: Part 12 --- The Final Touches"
)}}

## Playlist

{{ zero_to_prod_nav(selected = 12) }}

## Tools and Technologies Mentioned

Here are the tools and technologies that were mentioned in the video, along with
related articles and other helpful links.

* [Gin HandlerFunc](https://pkg.go.dev/github.com/gin-gonic/gin#HandlerFunc)
* [Regular Expressions: Go By Example](https://gobyexample.com/regular-expressions)
* [string Package](https://pkg.go.dev/strings)
* [Path Traversal Attack](https://owasp.org/www-community/attacks/Path_Traversal)

## Read The Source

* [Download the source code (*114kb zip
  archive*)](https://assets.zerotohero.dev/zero-to-prod-in-30/zero-to-prod-in-30.zip)

------------

Until the next lecture... May the source be with you 🦄.
