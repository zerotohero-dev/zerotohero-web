+++
#   (`-')           (`-').->
#   ( OO).->        (OO )__
# ,(_/----. .----. ,--. ,'-' doubt everything,
# |__,    |\_,-.  ||  | |  |
#  (_/   /    .' .'|  `-'  | be curious,
#  .'  .'_  .'  /_ |  .-.  |
# |       ||      ||  | |  | learn.
# `-------'`------'`--' `--'

title = "Zero to Prod in Half an Hour: Part 3 --- Mutating the Generated HTML Files"
date = "2022-01-09"

[taxonomies]
tags = []
+++

![Zero to Prod in Half an Hour: Part 3 --- Mutating the Generated HTML Files](/images/size/w1200/2024/03/mutation.png)

{{img(
  src="/images/size/w1200/2024/03/mutation.png",
  alt="Zero to Prod in Half an Hour: Part 3 --- Mutating the Generated HTML Files"
)}}

As it turns out, using `pygmentize` can only do so much for us and we'll need to
extend the generated HTML files. This section will update the generated HTML
files and implements custom mutations using Go programming language.

## Lecture

{{youtube(
  id="Ovj-iOIU8WQ?si=vggmDfdZaZPt0gH1",
  title="Zero to Prod in Half an Hour: Part 3 --- Generating Static HTML"
)}}

## Playlist

{{ zero_to_prod_nav(selected = 3) }}

## Tools and Technologies Mentioned

Here are the tools and technologies that were mentioned in the video, along with
related articles and other helpful links.

* [**Pygments**](https://pygments.org/)
* [**Go** Programming Language](https://go.dev/)
* [Places to Learn **Go**](https://go.dev/)
* [**Zero to Hero** Articles Tagged With "**_Go_**"](/tags/go/)
* [filepath.Walk()](https://pkg.go.dev/path/filepath#Walk)
* [filepath.WalkFunc](https://pkg.go.dev/path/filepath#WalkFunc)
* [Go By Example: egular Expressions](https://gobyexample.com/regular-expressions)
* [http-server](https://github.com/http-party/http-server)

Read The Source
---------------

* [Download the source code (*114kb zip
  archive*)](https://assets.zerotohero.dev/zero-to-prod-in-30/zero-to-prod-in-30.zip)

------------

Until the next lecture... May the source be with you 🦄.
