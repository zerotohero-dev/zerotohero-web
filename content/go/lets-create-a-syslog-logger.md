+++
#   (`-')           (`-').->
#   ( OO).->        (OO )__
# ,(_/----. .----. ,--. ,'-' doubt everything,
# |__,    |\_,-.  ||  | |  |
#  (_/   /    .' .'|  `-'  | be curious,
#  .'  .'_  .'  /_ |  .-.  |
# |       ||      ||  | |  | learn.
# `-------'`------'`--' `--'

title = "Let's Create a Syslog Logger"
date = "2021-09-06"

[taxonomies]
tags = ["development","go","kubernetes","networking","tips"]
+++

{{img(
  src="/images/size/w1200/2024/03/papertrail.png",
  alt="Papertrail."
)}}

## Introduction

In this article, we'll create a logging wrapper module that will log messages
to [Syslog](https://en.wikipedia.org/wiki/Syslog): a standard network-based
logging protocol that works on a wide variety of different types of devices and
applications.

I chose **Syslog** because I want to stream **FizzBuzz Pro**
microservices' logs to [_Papertrail_](https://papertrailapp.com/), 
and _Papertrail_ has a _Syslog server_ for that purpose listening on 
a **UDP** port.

## Creating a Papertrail Syslog Destination

Before getting into code, I'll create a 
[**Papertrail**](https://papertrailapp.com/) log destination. Our logger will use 
this destination as a sink to stream logs.

> [Papertrail](https://papertrailapp.com/ "Papertrail") is a "*logging as a
> service*" solution that aggregates logs from applications, devices, and platforms
> to a central location.

For that, I'll go to my dashboard, find **Log Destinations**, and tap **Create
Log Destination**:

{{img(
  src="/images/size/w1200/2024/03/papertrail-destination.png",
  alt="Create a log destination."
)}}

Then I'll give my log destination a description, tap **Create**, and I'll be all
set:

{{img(
  src="/images/2021/06/Screen-Shot-2021-06-06-at-8.51.35-AM-2.png",
  alt="Configuring the Papertrail log destination."
)}}

> **Note**
>
> When you tap **Create**, you'll see an endpoint URL in the form
> of `logs$n.papertrailapp.com:$port`. Note the URL down; you'll need it when
> configuring your logger.

Dependencies

Let's start with the dependencies that we need.

We'll use
the [`fizz-env` module from the last article](@/go/make-your-code-leaner.md).
Other dependencies we need are all parts of **Go** standard library.

```go
// $WORKSPACE/fizz-logging/pkg/log/log.go

package log

import (
    "fmt"
    "github.com/zerotohero-dev/fizz-env/pkg/env"
    "log"
    "log/syslog"
    "os"
)
```

## Initializing a Syslog Writer

Next up, we'll write a method that initializes our logger. `appName` is the name
of our app, typically the name of the microservice that you are streaming the
logs for.

```go
// $WORKSPACE/fizz-logging/pkg/log/log.go

var writer *syslog.Writer

func Init(appName string) *syslog.Writer {
    e := env.New()
    e.SanitizeLog()
    // The destination is in the form 
    // "logs$n.papertrailapp.com:$port".
    dest := e.Log.Destination

    w, err := syslog.Dial("udp", dest, 
        syslog.LOG_INFO|syslog.LOG_USER, appName)
    if err != nil {
        Info("failed to dial syslog for log destination '" + 
            dest + "'.")
        return nil
    }

    // Cache the writer for other helper methods to call.
    writer = w

    return writer
}
```

## Wrapping Common Log Methods

Then we'll create utility methods that call our *Syslog* writer `writer`.

Note that if `writer` hasn't been initialized, or if `writer` cannot be
initialized, we fall back to the **Go** standard library's `log` module instead.

```go
// $WORKSPACE/fizz-logging/pkg/log/log.go

func Info(s string, args ...interface{}) {
    if writer == nil {
        log.Printf(s, args...)
        return
    }

    _ = writer.Info(fmt.Sprintf(s, args...))
}

func Err(s string, args ...interface{}) {
    if writer == nil {
        log.Printf(s, args...)
        return
    }

    _ = writer.Err(fmt.Sprintf(s, args...))
}

func Warning(s string, args ...interface{}) {
    if writer == nil {
        log.Printf(s, args...)
        return
    }

    _ = writer.Warning(fmt.Sprintf(s, args...))
}

func Fatal(e interface{}) {
    log.Fatal(e)
}
```

## Our Papertrail Syslog Logger in Action

Let's see our logger in action:

```go
// This will be our microservice that uses the logger.

package main

import "github.com/zerotohero-dev/fizz-logging/pkg/log"

func main() {
    // Initialize the logger first:
    log.Init("fizz-crypto-svc")

    // Log something:
    response := 2
    log.Info("Got a response '%d' from the server.", response)
}
```

If you have set up everything correctly, running the above `main()` method will
stream a log similar to the following to your **PaperTrail** console.

{{img(
  src="/images/2021/06/Screen-Shot-2021-06-06-at-8.59.43-AM-2.png",
  alt="Papertrail log tail output."
)}}

## Conclusion

In this article, we've created a logger class that uses a **Syslog** writer to
stream logs to Papertrail over **UDP**.

We will use (*and improve*) this logger while developing our 
[**FizzBuzz Pro**](https://fizzbuzz.pro/)API microservices.

## Read the Source

Below, you'll find the **zip archives** of the projects and other related
artifacts that we've covered in this article.

Enjoy... And may the source be with you 🦄.

* [`fizz-logging` (**3KB** zip archive)](https://assets.zerotohero.dev/lets-create-a-syslog-logger/5f7a69db-658d-482c-bac1-9f036bb01edd/fizz-logging.zip)

--------

## Section Contents

{{ tips_nav(selected=4) }}
