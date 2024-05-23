+++
title = "Redirecting a Static Web Page"
date = "2024-05-23"

[taxonomies]
tags = ["tips", "html", "redirect"]
+++

![Redirect](/images/2024/redirect.png)

## Introduction

While migrating [zerotohero.dev](https://zerotohero.dev) to its new design, 
I needed to find a quick and dirty way to redirect incoming requests to 
certain websites to their corresponding pages on **Zero to Hero**.

This nugget gives a neat trick to achieve this with the least amount of
effort.

## `<meta>` Refresh to the Rescue

Since all of those websites were static sites backed by an S3 bucket, updating
the error page (`404.html`) and the index page (`index.html`) was the quickest
way to achieve this:

```html
<!DOCTYPE html>
<!--
404.html and index.html are the same.
S3 bucket is configured to serve 404.html for errors,
and index.html is configured to be the default page.
-->
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" 
   content="width=device-width, initial-scale=1.0">
  
  <title>Redirecting...</title>
  
  <meta http-equiv="refresh" content="0; 
    url=https://zerotohero.dev/about/volkan/">
  <link rel="canonical" href="https://zerotohero.dev/about/volkan/">
  <meta name="robots" content="noindex, follow">
  
  <script type="text/javascript">
    setTimeout(function() {
      window.location.href = "https://zerotohero.dev/about/volkan/";
    }, 0);
  </script>
</head>
<body>
<p>If you are not redirected automatically,
  follow this link:
  <a href="https://zerotohero.dev/about/volkan/"
    >https://zerotohero.dev/about/volkan/</a>.</p>
</body>
</html>
```

This way, I won't have to worry about configuring the S3 bucket to redirect
incoming requests to the new URL. And as a bonus, I can still keep certain
(*hidden*) pages on the old website without having to worry about them being
indexed by search engines.

## In a Nutshell

Here's a breakdown of the code:
 
 * The `meta` tag with the `http-equiv` attribute is used to refresh the page 
   after 0 seconds to the new URL.
 * The `script` tag is used as a fallback in case the `meta` tag is not 
   supported by the browser (*very unlikely*). 
   * The `setTimeout` function is used to redirect the user to the new URL 
     after 0 seconds (*i.e. immediately*).

For search engines:

 * With `<link rel="canonical" ... />`, we are telling the search engines that
   the alternative url is the preferred one.
 * The `<meta name="robots" content="noindex, follow">` tag is used to tell
   the search engines not to index the page but to follow the links on the page. 
 * Which is good enough for search engines to understand that the page has been
   moved to a new location.

## How About `3xx` Redirects?

The only thing I am not doing for the search engines is to set the `301` status
code in the HTTP response. 

That is doable with some [CloudFront][cloudfront] 
and [AWS Lambda at Edge][lambda-at-edge] trickery, but I feel 
it's an overkill. 

[cloudfront]: https://aws.amazon.com/cloudfront/
[lambda-at-edge]: https://aws.amazon.com/lambda/edge/

Why? 

* Firstly, search engines are a thing of the past. 
* And, secondly,  we already inform the search engines 
  about the change anyway.

## Conclusion

Hope you liked this little nugget. It's the fastest to way to achieve the task 
without having to worry about the underlying infrastructure.

Until next time… May the source be with you 🦄.

## Section Contents

{{ tips_nav(selected=11) }}