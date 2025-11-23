+++
#   (`-')           (`-').->
#   ( OO).->        (OO )__
# ,(_/----. .----. ,--. ,'-' doubt everything,
# |__,    |\_,-.  ||  | |  |
#  (_/   /    .' .'|  `-'  | be curious,
#  .'  .'_  .'  /_ |  .-.  |
# |       ||      ||  | |  | learn.
# `-------'`------'`--' `--'

title = "Better Error Handling Patterns for Go SDKs"
description = "Better Error Handling Patterns for Go SDKse"
date = "2024-12-01"

[taxonomies]
tags = ["inbox","go","development"]
+++

When building SDKs in Go, one common challenge is balancing transparency and debuggability with clean error handling. This becomes particularly evident when implementing retry mechanisms, where we need to track multiple attempts, delays, and error states.

## The Common Approach: Logging

Many SDKs resort to internal logging for debugging:

```go
func Retry(scope string, f func() error, s Strategy) error {
    correlationID := crypto.Id()
    log.TraceLn(correlationID, "Starting retry loop")
    // ... retry logic with logging
    return err
}
```

While this provides visibility, it has several drawbacks:
- Forces a logging implementation on SDK users
- Mixes concerns between error handling and logging
- Makes testing more complicated
- Can pollute user logs with SDK internals

## Better Patterns for SDK Error Handling

### 1. Rich Error Types

Instead of logging, return structured error information:

```go
type RetryError struct {
    OriginalError error
    Attempts     int
    TotalTime    time.Duration
    Scope        string
    CorrelationID string
}

func (e *RetryError) Error() string {
    return fmt.Sprintf(
        "failed after %d attempts over %v in scope '%s' (correlation_id: %s): %v",
        e.Attempts,
        e.TotalTime,
        e.Scope,
        e.CorrelationID,
        e.OriginalError,
    )
}
```

Benefits:
- Users can extract detailed information when needed
- Follows Go's error handling patterns
- Makes testing straightforward
- Keeps separation of concerns

### 2. Event Callbacks

Allow users to plug in their own handling:

```go
type RetryCallback func(attempt int, delay time.Duration, err error)

func Retry(f func() error, s Strategy, onRetry RetryCallback) error {
    // Call onRetry for each attempt
}
```

This approach:
- Gives users complete control over instrumentation
- Enables custom metrics collection
- Supports different logging implementations
- Maintains flexibility

### 3. Optional Debug Mode

Configure debug behavior through options:

```go
type Config struct {
    Logger Logger
    Debug  bool
}

func Retry(f func() error, s Strategy, cfg *Config) error {
    if cfg != nil && cfg.Debug && cfg.Logger != nil {
        // Log debug information
    }
}
```

This pattern:
- Makes debugging optional
- Allows users to choose their logging implementation
- Keeps debug information out of production logs

## Best Practices

1. **Return, Don't Log**: SDKs should return rich error information rather than logging internally.

2. **Structured Errors**: Use custom error types with fields that capture important debugging details.

3. **Error Wrapping**: Preserve error context through the chain:
   ```go
   fmt.Errorf("retry failed: %w", originalError)
   ```

4. **Flexible Instrumentation**: Provide hooks for users to implement their own logging/metrics.

5. **Clear Documentation**: Document error types and their fields thoroughly.

## Implementation Example

Here's a complete implementation combining these patterns:

```go
type RetryInfo struct {
    CorrelationID string
    Events        []RetryEvent
    StartTime     time.Time
}

type RetryEvent struct {
    Attempt   int
    Delay     time.Duration
    Error     error
    TimeStamp time.Time
}

func Retry(f func() error, s Strategy, onRetry RetryCallback) error {
    info := &RetryInfo{
        CorrelationID: crypto.Id(),
        StartTime:    time.Now(),
    }
    
    for i := 0; i <= int(s.MaxRetries); i++ {
        err := f()
        
        if err == nil {
            return nil
        }
        
        event := RetryEvent{
            Attempt:   i + 1,
            TimeStamp: time.Now(),
            Error:     err,
        }
        
        if onRetry != nil {
            onRetry(event.Attempt, event.Delay, err)
        }
        
        info.Events = append(info.Events, event)
        // ... retry logic
    }
    
    return &RetryError{
        Info:    info,
        LastErr: info.Events[len(info.Events)-1].Error,
    }
}
```

## Conclusion

By following these patterns, we can build SDKs that:
- Provide rich debugging information
- Respect separation of concerns
- Give users control over logging and instrumentation
- Maintain clean, idiomatic Go code

Remember: good SDK design is about enabling users while staying out of their way. Return errors, don't log them, and give users the tools they need to handle errors appropriately in their context.
