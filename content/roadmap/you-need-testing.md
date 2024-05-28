+++
#   (`-')           (`-').->
#   ( OO).->        (OO )__
# ,(_/----. .----. ,--. ,'-' doubt everything,
# |__,    |\_,-.  ||  | |  |
#  (_/   /    .' .'|  `-'  | be curious,
#  .'  .'_  .'  /_ |  .-.  |
# |       ||      ||  | |  | learn.
# `-------'`------'`--' `--'

title = "You Need Testing"
date = "2021-11-26"

[taxonomies]
tags = ["roadmap", "testing"]
+++

{{img(
  src="/images/size/w1200/2024/03/testing.png",
  alt="Test all the thingz!"
)}}

## Testing is **not** About the Tools

Yes, there are frameworks
like [Jest](https://jestjs.io/), [Mocha](https://mochajs.org/),
and [Jasmine](https://jasmine.github.io/). There are even test runners
like [Karma](https://karma-runner.github.io/2.0/index.html); however, without
proper [Behavior-Driven Development](https://en.wikipedia.org/wiki/Behavior-driven_development)
and [Test Driven Development](https://en.wikipedia.org/wiki/Test-driven_development)
foundation, you will not benefit from those tools.

Testing is all about the mindset.

At the very least, you'll need to understand the terminology
like [unit tests](https://en.wikipedia.org/wiki/Unit_testing), 
[stubs](https://en.wikipedia.org/wiki/Test_stub), 
[spies](https://stackoverflow.com/questions/12827580/mocking-vs-spying-in-mocking-frameworks),
and more important than that, you'll have to figure out **why** _you need
testing ("unit testing"---see what I did there?_) and **how** to implement
various testing strategies.

There are several different testing types and strategies that you need to be
aware of as well. For starters, you might want to learn
about [unit tests](https://en.wikipedia.org/wiki/Unit_testing), 
[integration tests](https://en.wikipedia.org/wiki/Integration_testing), 
[functional tests](https://en.wikipedia.org/wiki/Functional_testing), 
[acceptance tests](https://en.wikipedia.org/wiki/Acceptance_testing), 
[performance tests](https://en.wikipedia.org/wiki/Software_performance_testing), 
[smoke tests](https://en.wikipedia.org/wiki/Smoke_testing_(software)),
and [exploratory testing](https://en.wikipedia.org/wiki/Exploratory_testing).

## How Much Testing is Enough Testing?

**How much** testing is **enough** testing?

That's an important question too. The answer to it depends on your situation:

For instance, if you are a startup, rapidly prototyping at an insane cadence,
writing tests may (_"**may**" is the keyword here_) be counter-productive.

Per contra, if you are a well-established organization with remotely
collaborating teams and business units, or if you are open-sourcing a library,
then *not* writing tests will be equivalent to being back-kicked by a donkey in
the guts---not fun!

## Learning Resources

Here are some reference materials that can help in your journey:

* [Test-Driven Development By Example](https://www.goodreads.com/book/show/387190.Test_Driven_Development)
* [JavaScript Testing with Jasmine: JavaScript Behavior-Driven Development](https://www.goodreads.com/book/show/17165516-javascript-testing-with-jasmine)
* [Make Tests Read Like a Book](http://www.uxebu.com/blog/2013/01/08/make-tests-read-like-a-book/)
* [Performance Testing Guidance for Web Applications](https://www.goodreads.com/book/show/3133219-performance-testing-guidance-for-web-applications)
* [BDD in Action: Behavior-Driven Development for the Whole Software Lifecycle](https://www.goodreads.com/book/show/20578311-bdd-in-action)

## Conclusion

This article provided you with some bedtime reading material on test-driven
development.

Testing is a vast field, and there is a lot to explore. Hence, the resources
here are by no means a definitive list. Instead, they are hand-curated for you
as a **starting point** to build a solid testing **foundation** and **mindset**.
Once you consume them, you'll have a much better understanding of where to go
next.

Until next time... May the source be with you 🦄.

--------

## Section Contents

{{ roadmap_nav(selected=17) }}
