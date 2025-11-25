+++
#   (`-')           (`-').->
#   ( OO).->        (OO )__
# ,(_/----. .----. ,--. ,'-' doubt everything,
# |__,    |\_,-.  ||  | |  |
#  (_/   /    .' .'|  `-'  | be curious,
#  .'  .'_  .'  /_ |  .-.  |
# |       ||      ||  | |  | learn.
# `-------'`------'`--' `--'

title = "Zero to Prod in Half an Hour: Part 5 --- Implementing an OIDC Authenticator"
date = "2021-01-12"

[taxonomies]
tags = ["authentication"]
+++

{{img(
  src="/images/size/w1200/2024/03/oidc.png",
  alt="Zero to Prod in Half an Hour: Part 5 --- Implementing an OIDC Authenticator"
)}}

This lecture will implement the **Authenticator** that we outlined in the
previous lecture. Our authenticator will extend an OIDC provider, and and oauth2
Config. In the upcoming lectures we'll use this Authenticator to implement
identity management functionality of our app.

# Lecture

{{youtube(
  id="gFbvD-U8kcI?si=rmUqt0eTj1IZSmZI",
  title="Zero to Prod in Half an Hour: Part 5 --- Implementing an OIDC Authenticator"
)}}

## Playlist

{{ zero_to_prod_nav(selected = 5) }}

## Tools and Technologies Mentioned

Here are the tools and technologies that were mentioned in the video, along with
related articles and other helpful links.

* [OAuth2.0](https://oauth.net/2/)
* [OpenID Connect](https://openid.net/connect/)
* [Auth0 Documentation](https://auth0.com/docs)
* [OpenID Connect Scopes](https://auth0.com/docs/get-started/apis/scopes/openid-connect-scopes)

## Read The Source

* [Download the source code (*114kb zip
  archive*)](https://assets.zerotohero.dev/zero-to-prod-in-30/zero-to-prod-in-30.zip)

Until the next lecture... May the source be with you 🦄.
