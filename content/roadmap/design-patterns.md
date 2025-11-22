+++
#   (`-')           (`-').->
#   ( OO).->        (OO )__
# ,(_/----. .----. ,--. ,'-' doubt everything,
# |__,    |\_,-.  ||  | |  |
#  (_/   /    .' .'|  `-'  | be curious,
#  .'  .'_  .'  /_ |  .-.  |
# |       ||      ||  | |  | learn.
# `-------'`------'`--' `--'

title = "Paint Me Like One of Your French Design Patterns"
date = "2021-11-26"

[taxonomies]
tags = ["roadmap", "development"]
+++

![Paint Me Like One of Your French Design Patterns](

{{img(
  src="/images/size/w1200/2024/03/design-pattern.png"
  alt="Using design patterns are half science, half art."
)}}

## Introduction

The more you are in software engineering, the more you realize that similar
problems are repeated all the time. Moreover, those similar sets of issues are
often solved using similar approaches.

That's where **design patterns** come in handy. A design pattern is a *
*repeatable** solution to a commonly occurring software problem. You can
consider it as a "*blueprint*." It is not a finished design; it's more like a
template to solve a specific problem that can be used in many different
scenarios.

Design patterns can speed up the development process by providing tried and
tested paradigms. Using design patterns creates a **common language.** It makes
the code more readable and prevents subtle issues that might become visible much
later. It'll be much harder to modify and refactor the code.

We can split design patterns into three categories:

* Creational design patterns,
* Structural design patterns,
* And behavioral design pattern.

This article summarizes the most commonly used design patterns, with links that
discuss each pattern more deeply.

So, without further ado, let's dig in.

## Creational Design Patterns

* [Abstract Factory](https://en.wikipedia.org/wiki/Abstract_factory_pattern):
  Create instances of several kinds of objects.
* [Builder](https://en.wikipedia.org/wiki/Builder_pattern): You have a common
  source of truth, and you want different representations of it.
* [Factory Method]((https://en.wikipedia.org/wiki/Factory_method_pattern): A (
  *mostly*) static method to let a class defer the instantiation to subclasses.
* [Object Pool](https://en.wikipedia.org/wiki/Object_pool_pattern): Avoid
  expensive object initialization by maintaining a pool of reusable objects.
* [Prototype](https://en.wikipedia.org/wiki/Prototype_pattern): A fully
  initialized instance that can be cloned elsewhere.
* [Singleton](https://en.wikipedia.org/wiki/Singleton_pattern): A class that
  only has a single instance.

## Structural Design Patterns

* [Adapter](https://en.wikipedia.org/wiki/Adapter_pattern): Convert an interface
  into another interface that the client expects.
* [Bridge](https://en.wikipedia.org/wiki/Bridge_pattern): Segregate interfaces
  from their implementations.
* [Composite](https://en.wikipedia.org/wiki/Composite_pattern): A glorified tree
  structure of objects.
* [Decorator](https://en.wikipedia.org/wiki/Decorator_pattern): Monkey-patch
  additional responsibilities to an object.
* [Façade](https://en.wikipedia.org/wiki/Facade_pattern): There's a mess behind
  the doors, but the building looks beautiful.
* [Flyweight](https://en.wikipedia.org/wiki/Flyweight_pattern): Share as much
  common data as possible to reduce the memory footprints of instantiated
  objects.
* [Proxy](https://en.wikipedia.org/wiki/Proxy_pattern): An object acting on
  behalf of another object.

## Behavioral Design Patterns

* [Chain of Responsibility](https://en.wikipedia.org/wiki/Chain-of-responsibility_pattern):
  A way to pass the request between a pipeline of middlewares.
* [Command-Query Separation Principle](https://en.wikipedia.org/wiki/Command%E2%80%93query_separation):
  Things that modify state and things that query state should be isolated.
* [Command](https://en.wikipedia.org/wiki/Command_pattern)): Encapsulate a
  request and its parameters and context to be run later.
* [Iterator](https://en.wikipedia.org/wiki/Iterator_pattern): Access a list of
  items sequentially without exposing their underlying representations.
* [Mediator](https://en.wikipedia.org/wiki/Mediator_pattern): The best analogy
  is planes talking to the control tower (*the mediator*) instead of talking to
  each other, thus reducing exponentially-increasing communication overhead.
* [Memento](https://en.wikipedia.org/wiki/Memento_pattern): Capture an object's
  internal state so that it can be re-initialized later, faster.
* [Null Object](https://en.wikipedia.org/wiki/Null_object_pattern): Provide a
  helpful default value of an object.
  The [go programming language](https://go.dev/) leaves and breathes by this.
* [Observer](https://en.wikipedia.org/wiki/Observer_pattern): When one object
  changes state, all of the interested objects get notified.
* [State](https://en.wikipedia.org/wiki/State_pattern): A **state machine**; the
  object's behavior changes (_as if its type has changed_) when its state
  changes.
* [Strategy](https://en.wikipedia.org/wiki/Strategy_pattern): Define a family of
  algorithms and make them interchangeable.
* [Template Method](https://en.wikipedia.org/wiki/Template_method_pattern):
  Delegate how the method is implemented to the subclass of an object.
* [Visitor](https://en.wikipedia.org/wiki/Visitor_pattern): Represent an
  operation to be performed on the elements of a graph of objects.

## Summary

One thing to keep in mind is that design patterns are just **guidelines**. They
are rules that are set in stone to follow religiously. So the more you use them,
the more you'll realize when it makes to deviate from them.

In addition, not every problem has an exactly matching design pattern.
Similarly, not every situation needs to be solved with a design pattern. When in
doubt, keep things simple.

{{img(
  src="/images/2021/11/guidelines.jpeg"
  alt="Design patterns are what you'd call 'guidelines' than actual 'rules.'"
)}}

One last thing: People, especially when learning design patterns for the first
time, don't consider the tradeoffs of using a certain pattern. Each design
pattern comes with its benefits and liabilities. And it's up to you as the
software engineer to use your experience and judgement to decide what to use
when.

That being said, that's all there is about common software design patterns.

Until next time... May the source be with you 🦄.

--------

## Section Contents

{{ roadmap_nav(selected=14) }}
