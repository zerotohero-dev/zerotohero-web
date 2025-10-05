+++
#   (`-')           (`-').->
#   ( OO).->        (OO )__
# ,(_/----. .----. ,--. ,'-' doubt everything,
# |__,    |\_,-.  ||  | |  |
#  (_/   /    .' .'|  `-'  | be curious,
#  .'  .'_  .'  /_ |  .-.  |
# |       ||      ||  | |  | learn.
# `-------'`------'`--' `--'

title = "mTLS With SPIRE: Part 3: Creating the Client Appp"
date = "2022-08-19"

[taxonomies]
tags = ["mtls", "spiffe", "spire"]
+++

{{img(
  src="/images/size/w1200/2024/03/client-server.png",
  alt="mTLS With SPIRE: Part 3: Creating the Client App"
)}}

This section will create the client app and establish connectivity between the
client and the server. The connectivity is insecure: There is no **mTLS**
security yet---we'll come to that later.

{{youtube(
  id="zp1JiA2Kni8?si=XhDNihlicw7pJGFb", 
  title="mTLS With SPIRE: Part 3: Creating the Client App"
)}}

--------

## Playlist

{{ spire_mtls_nav(selected=3) }}

## Read the Source

* [Access the source code and other related assets from **Zero to Hero** GitHub](https://github.com/zerotohero-dev/spire-mtls).
