+++
#   (`-')           (`-').->
#   ( OO).->        (OO )__
# ,(_/----. .----. ,--. ,'-' doubt everything,
# |__,    |\_,-.  ||  | |  |
#  (_/   /    .' .'|  `-'  | be curious,
#  .'  .'_  .'  /_ |  .-.  |
# |       ||      ||  | |  | learn.
# `-------'`------'`--' `--'

title = "Designing a Reusable Retry Package in Go: Beyond the Logger Antipatterne"
description = "Designing a Reusable Retry Package in Go: Beyond the Logger Antipatterne"
date = "2024-11-24"

[taxonomies]
tags = ["inbox","go"]
+++



# 

When building reusable Go packages, one common challenge is handling cross-cutting concerns like logging. Recently, I encountered this issue while working with a retry package that had a hard dependency on a specific logger implementation. Let's explore how to refactor this into a more reusable module.

## The Problem

Consider this implementation of a retry mechanism:

```go
func (r *ExponentialRetrier) RetryWithBackoff(
    ctx context.Context,
    operation func() error,
) error {
    b := r.newBackOff()
    totalDuration := time.Duration(0)
    return backoff.RetryNotify(
        operation,
        backoff.WithContext(b, ctx),
        func(err error, duration time.Duration) {
            totalDuration += duration
            // Direct logger dependency - this is problematic!
            log.Log().Debug("Retrying operation after error", 
                "error", err.Error(), 
                "duration", duration, 
                "total duration", totalDuration.String())
        },
    )
}
```

This code has two main issues:
1. It depends on a specific logger implementation (`log.Log()`)
2. It violates the principle that reusable modules shouldn't log directly

## Solution Approaches

Let's explore three different ways to solve this problem, each with its own trade-offs.

### 1. Callback Functions: Simple and Flexible

The simplest approach is to use a callback function:

```go
type NotifyFunc func(error, time.Duration, time.Duration)

type ExponentialRetrier struct {
    OnRetry NotifyFunc
}

func (r *ExponentialRetrier) RetryWithBackoff(
    ctx context.Context,
    operation func() error,
) error {
    b := r.newBackOff()
    totalDuration := time.Duration(0)
    
    notify := r.OnRetry
    if notify == nil {
        notify = func(error, time.Duration, time.Duration) {} // noop
    }
    
    return backoff.RetryNotify(
        operation,
        backoff.WithContext(b, ctx),
        func(err error, duration time.Duration) {
            totalDuration += duration
            notify(err, duration, totalDuration)
        },
    )
}
```

Usage is straightforward:

```go
retrier := &ExponentialRetrier{
    OnRetry: func(err error, d, total time.Duration) {
        log.Log().Debug("Retrying operation", "error", err, "duration", d)
    },
}
```

**Pros:**
- Simple to implement and understand
- Very flexible
- Minimal boilerplate
- Easy to integrate with any logging system

**Cons:**
- No built-in support for async processing
- Can be harder to test complex notification logic

### 2. Channel-Based: Async and Decoupled

For more complex scenarios, we can use channels:

```go
type RetryEvent struct {
    Error         error
    Duration      time.Duration
    TotalDuration time.Duration
}

type ExponentialRetrier struct {
    Events chan RetryEvent
}
```

This allows for asynchronous processing of retry events:

```go
events := make(chan RetryEvent, 100)
retrier := &ExponentialRetrier{Events: events}

// Process events asynchronously
go func() {
    for event := range events {
        log.Log().Debug("Retry event", 
            "error", event.Error,
            "duration", event.Duration)
    }
}()
```

**Pros:**
- Decoupled event processing
- Built-in buffering capability
- Great for high-performance scenarios
- Allows for complex event processing pipelines

**Cons:**
- More complex to implement
- Requires careful channel management
- May be overkill for simple use cases

### 3. Interface-Based: Clean and Testable

The most formal approach is to define an interface:

```go
type RetryNotifier interface {
    OnRetry(error, time.Duration, time.Duration)
}

type ExponentialRetrier struct {
    Notifier RetryNotifier
}
```

This enables clean separation of concerns:

```go
type LogNotifier struct {
    logger Logger
}

func (n *LogNotifier) OnRetry(err error, d, total time.Duration) {
    n.logger.Debug("Retrying operation", "error", err)
}

retrier := &ExponentialRetrier{
    Notifier: &LogNotifier{logger: log},
}
```

**Pros:**
- Clear separation of concerns
- Highly testable
- Follows Go interface best practices
- Easy to create multiple implementations

**Cons:**
- Most verbose approach
- May be unnecessary for simple use cases
- Requires more initial setup

## Making the Choice

Here's when to use each approach:

1. **Use Callbacks** when:
    - You need a simple, straightforward solution
    - The notification logic is simple
    - You want minimal boilerplate

2. **Use Channels** when:
    - You need async processing
    - You want to buffer events
    - You're building a high-performance system
    - You need to process events in batches

3. **Use Interfaces** when:
    - You need strong separation of concerns
    - Testing is a primary concern
    - You expect multiple implementations
    - You're building a large system with many components

## Conclusion

When building reusable Go packages, it's crucial to avoid hard dependencies on cross-cutting concerns like logging. By using one of these patterns, you can create more flexible and maintainable code that can be easily integrated into any project.

For most cases, I recommend starting with the callback approach due to its simplicity and flexibility. If you need more sophisticated features or better separation of concerns, you can graduate to channels or interfaces as needed.

Remember: The goal is to make your package as reusable as possible while maintaining clean separation of concerns. Choose the approach that best fits your specific needs while keeping the code simple and maintainable.
