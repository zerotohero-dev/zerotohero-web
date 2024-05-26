+++
#   (`-')           (`-').->
#   ( OO).->        (OO )__
# ,(_/----. .----. ,--. ,'-' doubt everything,
# |__,    |\_,-.  ||  | |  |
#  (_/   /    .' .'|  `-'  | be curious,
#  .'  .'_  .'  /_ |  .-.  |
# |       ||      ||  | |  | learn.
# `-------'`------'`--' `--'

title = "Here's a Technique to Ensure Environment Variables Are Set Before Starting a Microservice"
date = "2021-06-06"

[taxonomies]
tags = ["tips", "go", "environment-variables", "microservices"]
+++

![Environment Variables](/content/images/size/w1200/2024/03/pipes.png)

## Introduction

Let's say that you have microservices that you don't want to start serving
content unless certain environment variables have been defined.

Recently, we had to implement such a solution for **FizzBuzz Pro**

In our case, we needed to make sure that the `fizz-crypto` microservice did not
start unless the following variables were defined in the system.

```txt
FIZZ_PORT_SVC_CRYPTO
FIZZ_JWT_KEY
FIZZ_RANDOM_BYTE_LENGTH
FIZZ_BCRYPT_HASH_ROUNDS
FIZZ_AES_PASSPHRASE
```

How do we make sure that the service does not start if any of these environment
variables are missing? And how can we do this with the minimal amount of
maintenance overhead?

Introducing the `fizz-env` Module
---------------------------------

To begin, let's create a module for our purposes. We'll publish our module
to `github.com/zerotohero-dev/fizz-env` private git repository:

```bash
# Switch to our workspace:
cd $WORKSPACE

# `fizz-env` is an empty repository:
git clone git@github.com:zerotohero-dev/fizz-env.git

# Switch to the project folder:
cd fizz-env

# Initialize our module:
go mod init github.com/zerotohero-dev/fizz-env
```

This will result in the following `go.mod` file that defines our module:

```txt
module github.com/zerotohero-dev/fizz-env

go 1.16
```

Then let's create a `./pkg/env/fizz.go` file that we'll work on:

```bash
cd $WORKSPACE/fizz-env
mkdir -p pkg/env
touch pkg/env/fizz.go
```

Then let's import the packages that we'll need:

```go
// $WORKSPACE/fizz-env/pkg/env/fizz.go

import (
    "fmt"
    "os"
    "reflect"
)
```

## The `FizzEnv` Struct

To reduce potential errors and typos, it's best to define the environment
variables that we need using a struct that holds these variables as fields.

We'll name our struct `FizzEnv`:

```go
// $WORKSPACE/fizz-env/pkg/env/fizz.go

package env

type envCrypto struct {
    PortSvcCrypto    string
    JwtKey           string
    RandomByteLength string
    BcryptHashRounds string
    AesPassphrase    string
}

type FizzEnv struct {
    Crypto envCrypto
}
```

So, for example, if `env` is a `FizzEnv`, then `env.Crypto.JwtKey` will hold the
value of `$FIZZ_JWT_KEY` environment variable.

## The Factory Function

Let's also create a [**factory function**](https://en.wikipedia.org/wiki/Factory_(object-oriented_programming))
to create an instance of `FizzEnv` and populate the related field values from
the system's environment:

```go
// $WORKSPACE/fizz-env/pkg/env/fizz.go

func New() *FizzEnv {
    res := &FizzEnv{
        Crypto: envCrypto{
            PortSvcCrypto:    os.Getenv("FIZZ_PORT_SVC_CRYPTO"),
            JwtKey:           os.Getenv("FIZZ_JWT_KEY"),
            RandomByteLength: os.Getenv("FIZZ_RANDOM_BYTE_LENGTH"),
            BcryptHashRounds: os.Getenv("FIZZ_BCRYPT_HASH_ROUNDS"),
            AesPassphrase:    os.Getenv("FIZZ_AES_PASSPHRASE"),
            Environment:      os.Getenv("FIZZ_ENV"),
        },
    }

    return res
}
```

## Sanitizing the Environment Variables

Finally, let's create a [receiver function](https://tour.golang.org/methods/1) that
traverses and makes sure that all of the environment variables that we need have
been set:

```go
// $WORKSPACE/fizz-env/pkg/env/fizz.go

func (e FizzEnv) SanitizeCrypto()  {
    v := reflect.ValueOf(e.Crypto)

    for i := 0; i < v.NumField(); i++ {
        val, name := v.Field(i).String(), v.Type().Field(i).Name

        if val == "" {
            panic(
                fmt.Sprintf(
                    "The environment variable that maps to '%s' " +
                    "is not defined.", name,
                ),
            )
        }
    }
}
```

Since there could be any number of fields in our struct, we had to
use [reflection](https://blog.golang.org/laws-of-reflection)
to iterate across the struct fields to keep our code maintainable by following
the [open-closed principle](https://en.wikipedia.org/wiki/Open%E2%80%93closed_principle).

And that's pretty much it.

Whenever any of the required environment variables are not defined,
calling `env.SanitizeCrypto()` on a `FizzEnv` instance `env` will cause the
application to crash real loud real fast, which you would prefer rather than the
app running silently despite the necessary environment information that it needs
being missing.

> **Aside**
>
> Failing early, and failing loudly is also known as
> the [fail-fast principle](https://en.wikipedia.org/wiki/Fail-fast "Fail-fast")
> in software engineering. The **fail-fast principle** means that you should stop
> the current operation as soon as any unexpected error occurs.
>
> Surprisingly, this approach results in a **more stable** solution in the long
> run. Why so? Because when you follow this principle, you **tighten the feedback
loop**: Instead of suppressing errors and sweeping things under the rug, you
> quickly reveal the defects and fix the failures as early as possible.
>
> In the end, you'll benefit from this approach greatly.

## Our Solution in Action

Let's use this in a microservice to see our solution in action:

```bash
# Switch to our workspace:
cd $WORKSPACE

# `fizz-crypto` is an empty repository:
git clone git@github.com:zerotohero-dev/fizz-crypto.git

# We'll create our files in here:
cd fizz-crypto

# Initialize our module:
go mod init github.com/zerotohero-dev/fizz-crypto
```

This will result in the following `go.mod` file that defines our module:

```txt
module github.com/zerotohero-dev/fizz-env

go 1.16
```

Now, let's `go get` our dependency:

```bash
go get github.com/zerotohero-dev/fizz-env
```

And we can use our new `fizz-env/pkg/env` as follows:

```go
// $WORKSPACE/fizz-crypto/main.go 

package main

import (
    "fmt"
    "github.com/zerotohero-dev/fizz-env/pkg/env"
)

func main() {
    // Populate an `env.FizzEnv` collection buy parsing the system
    // environment variables:
    e := env.New()

    // Make sure that all of the environment variables that 
    //`fizz-crypto` needs have been defined; panic otherwise.
    e.SanitizeCrypto()

    // Print the value of an environment variable.
    fmt.Println("key", e.Crypto.JwtKey)
}
```

Since we haven't defined any environment variables yet, running the above code
on my system results in the following **panic** as expected:

```txt
panic: The environment variable that corresponds to 'PortSvcCrypto' 
is not defined.

goroutine 1 [running]:
github.com/zerotohero-dev/fizz-env/pkg/env.FizzEnv.
SanitizeCrypto(0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0)
        /Users/volkan/go/pkg/mod/github.com/zerotohero-dev/
fizz-env@v0.1.0/pkg/env/fizz.go:40 +0x30f
main.main()
        /Users/volkan/Desktop/PROJECTS/fizz-crypto/main.go:22 +0x78
```

## Conclusion

In this article, we've seen an approach to ensure that all of the environment
variables that a service needs have been defined before the service starts.

We will use this `fizz-env` module in all of the **FizzBuzz Pro** microservices
that we'll be creating.

I'll also share any improvement to this `fizz-env` module that's worth
mentioning as we develop it.

## Read the Source

Below, you'll find the **zip archives** of the projects and other related
artifacts that we've covered in this article.

Enjoy... And may the source be with you 🦄.

* [`fizz-crypto` (**3KB** zip archive)](https://assets.zerotohero.dev/heres-a-technique-to-ensure-environment-variables-are-set-before-starting-a-microservice/0174edce-3b6b-419e-83c2-f4995b317935/fizz-crypto.zip)
* [`fizz-env` (**2KB** zip archive)](https://assets.zerotohero.dev/heres-a-technique-to-ensure-environment-variables-are-set-before-starting-a-microservice/0174edce-3b6b-419e-83c2-f4995b317935/fizz-env.zip)

--------

## Section Contents

{{ tips_nav(selected=7) }}
