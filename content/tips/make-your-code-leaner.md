+++
#   (`-')           (`-').->
#   ( OO).->        (OO )__
# ,(_/----. .----. ,--. ,'-' doubt everything,
# |__,    |\_,-.  ||  | |  |
#  (_/   /    .' .'|  `-'  | be curious,
#  .'  .'_  .'  /_ |  .-.  |
# |       ||      ||  | |  | learn.
# `-------'`------'`--' `--'

title = "Make Your Code Leaner By Extracting Methods"
date = "2021-06-06"

[taxonomies]
tags = ["development","go","tips","encryption"]
+++

{{img(
  src="/images/size/w1200/2024/03/extract.png",
  alt="Extracting methods."
)}}

## Introduction

In this article, we'll see an example
of [method extraction](https://refactoring.com/catalog/extractFunction.html).
We'll make our code less repetitive, cleaner, and easier to follow.

## Duplicating a Method

Let's take the `SanitizeCrypto()` function
from [our former `fizz-env` module](@/tips/microservice-env-vars.md):


```go
func (e FizzEnv) SanitizeCrypto() {
    sanitizeCommon(e)

    v := reflect.ValueOf(e.Crypto)

    for i := 0; i < v.NumField(); i++ {
        val := v.Field(i).String()
        name := v.Type().Field(i).Name

        if val == "" {
            panic(
                fmt.Sprintf(
                    "The environment variable for" +
                    "'%s' is not defined.", name,
                ),
            )
        }
    }
}
```

What if, along with `e.Crypto`, we also have... say... an `e.Log` member that
requires the same kind of sanitization. We can come up with a `SanitizeLog()`
method like this:

```go
func (e FizzEnv) SanitizeLog() { // <-- (1)
    sanitizeCommon(e)

    v := reflect.ValueOf(e.Log) // <-- (2)

    for i := 0; i < v.NumField(); i++ {
        val := v.Field(i).String()
        name := v.Type().Field(i).Name

        if val == "" {
            panic(
                fmt.Sprintf(
                    "The environment variable for " +
                    "'%s' is not defined.", name,
                ),
            )
        }
    }
}
```

If you look closely at the replicated `SanitizeLog()` function, aside from the
method name and the attribute `e.Log` that we are reflecting upon (_`(1)`
and `(2)` in the source code, respectively_), we are repeating the majority of
the code.

> These kind of **copy/paste** method duplications is a fact of development
> life. They happen all the time. It's your responsibility, as a developer, to be
> vigilant and **defend the code quality**.

## Extracting the Repetitive Code Piece

Instead, we can extract the for loop into its own method like this:

```go
func sanitize(v reflect.Value) {
    for i := 0; i < v.NumField(); i++ {
        val := v.Field(i).String()
        name := v.Type().Field(i).Name

        if val == "" {
            panic(
                fmt.Sprintf(
                    "The environment variable for " +
                    "'%s' is not defined.", name,
                ),
            )
        }
    }
}
```

## Calling the Extracted Function

Then we can call it in our methods:

```go
func (e FizzEnv) SanitizeCrypto() {
    sanitize(reflect.ValueOf(e.Crypto))
}

func (e FizzEnv) SanitizeLog() {
    sanitize(reflect.ValueOf(e.Log))
}
```

## Conclusion

Much cleaner, isn't it?

This approach is known
as [method extracting](https://refactoring.com/catalog/extractFunction.html),
and when done with a purpose, it can make your code **clearer** to read, 
**leaner**, and more **maintainable**.

> Just keep in mind that each method extraction is an additional level of
> indirection. So if you abuse it, you will make your code harder to read 
> (_instead of easier_), harder to follow, and harder to reason about.

Do this refactoring **only** when it makes sense. Do it only when the **benefits
** of doing it (_i.e., not repeating your code_) **outweigh** the liabilities of
doing it (_i.e., an additional level of indirection, making code harder to
follow_).

[Sometimes a little copying is better than a little 
dependency](https://www.youtube.com/watch?v=PAAkCSZUG1c).

## Read the Source

Below, you'll find the **zip archives** of the projects and other related
artifacts that we've covered in this article.

Enjoy... And may the source be with you 🦄.

* [`fizz-env` (**3KB ** zip archive)](https://assets.zerotohero.dev/lets-create-a-syslog-logger/5f7a69db-658d-482c-bac1-9f036bb01edd/fizz-logging.zip)

--------

## Section Contents

{{ tips_nav(selected=5) }}
