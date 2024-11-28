+++
#   (`-')           (`-').->
#   ( OO).->        (OO )__
# ,(_/----. .----. ,--. ,'-' doubt everything,
# |__,    |\_,-.  ||  | |  |
#  (_/   /    .' .'|  `-'  | be curious,
#  .'  .'_  .'  /_ |  .-.  |
# |       ||      ||  | |  | learn.
# `-------'`------'`--' `--'

title = "Pragmatic Audit Logging in Go: Starting Small and Growing Smart"
description = "Pragmatic Audit Logging in Go: Starting Small and Growing Smart"
date = "2024-11-28"

[taxonomies]
tags = ["inbox", "go", "strategy", "logging"]
+++

When building web services, audit logging is often approached in one of two extremes: either skipped entirely for "later" or over-engineered from the start. Let's explore a pragmatic middle ground, starting with a simple HTTP router factory.

## The Starting Point

Here's a typical router factory in Go - simple and functional:

```go
func factory(p, a, m string) handler {
    switch {
    case m == http.MethodPost && a == "" && p == urlKeep:
        return routeKeep
    case m == http.MethodPost && a == "read" && p == urlKeep:
        return routeShow
    default:
        return routeFallback
    }
}
```

This factory takes three parameters: path (`p`), action (`a`), and method (`m`), and returns the appropriate handler. Clean and straightforward, but with no visibility into who's doing what in our system.

## Adding Basic Audit Logging

The simplest approach to add audit logging might look like this:

```go
func factory(p, a, m string) handler {
    entry := log.AuditEntry{
        Timestamp: time.Now(),
        UserId:    "TBD",
        Resource:  p,
        SessionID: "",
    }

    switch {
    case m == http.MethodPost && a == "" && p == urlKeep:
        entry.Action = "create"
        return logAndRoute(entry, routeKeep)
    case m == http.MethodPost && a == "read" && p == urlKeep:
        entry.Action = "read"
        return logAndRoute(entry, routeShow)
    default:
        entry.Action = "fallback"
        return logAndRoute(entry, routeFallback)
    }
}

func logAndRoute(entry log.AuditEntry, h handler) handler {
    log.Audit(entry)
    return h
}
```

This gives us several key benefits:

1. **Timing Information**: When was the route selected?
2. **Action Context**: What operation was attempted?
3. **Resource Tracking**: What part of the system was accessed?
4. **Future-Proofing**: Placeholders for user and session tracking

## Why This Works as a Starting Point

This approach has several advantages:

1. **Minimal Overhead**: We're not wrapping handlers or adding middleware complexity
2. **Clear Intent**: The logging happens at a clear decision point
3. **Easy to Evolve**: We can enhance the `AuditEntry` structure as needs grow
4. **No Premature Optimization**: We haven't built infrastructure we might not need

## Where to Go From Here

As your system grows, you might want to enhance this basic approach:

1. **User Context**: Replace "TBD" with actual user information from authentication
2. **Session Tracking**: Add real session IDs for request correlation
3. **Result Logging**: Add post-handler logging to capture success/failure
4. **Data Changes**: Track what actually changed in successful operations

## Common Pitfalls to Avoid

1. **Don't Log Everything**: Audit logs are not debug logs. Focus on business-relevant events.
2. **Keep It Maintainable**: Resist the urge to add "just one more field" without clear purpose.
3. **Consider Performance**: Audit logs can grow quickly. Plan for volume early.
4. **Stay Compliant**: Ensure you're not logging sensitive data that regulations prohibit.

## Conclusion

Starting with simple, focused audit logging at key decision points provides immediate value while leaving room for growth. As your system's needs evolve, you can enhance the logging infrastructure without having to undo an over-engineered initial approach.

Remember: The best audit logging system is the one that actually gets implemented and maintained, not the one that covers every theoretical future need.

---
*This post is part of our series on practical Go patterns. For more insights on building maintainable Go services, follow our blog.*
