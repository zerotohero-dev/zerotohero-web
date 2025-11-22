+++
#   (`-')           (`-').->
#   ( OO).->        (OO )__
# ,(_/----. .----. ,--. ,'-' doubt everything,
# |__,    |\_,-.  ||  | |  |
#  (_/   /    .' .'|  `-'  | be curious,
#  .'  .'_  .'  /_ |  .-.  |
# |       ||      ||  | |  | learn.
# `-------'`------'`--' `--'

title = "Understanding Go's slog Log Levels: A Practical Guidee"
description = "Understanding Go's slog Log Levels: A Practical Guide"
date = "2024-11-28"

[taxonomies]
tags = ["inbox", "go", "go", "logging"]
+++


Go's `slog` package, introduced in Go 1.21, provides a structured logging interface that's both powerful and flexible. One of its key features is the log level system, which helps developers control what messages appear in their logs. Let's dive deep into how these levels work.

## The Logging Level Hierarchy

The `slog` package implements a hierarchical level system where each level represents a different severity of log message. The hierarchy, from lowest to highest severity, is:

1. Debug
2. Info
3. Warn
4. Error

## How Level Filtering Works

The logging level you set acts as a minimum threshold. Any log message with a severity level equal to or higher than this threshold will be displayed, while messages with lower severity levels will be filtered out.

### Example Setup

Here's a basic example showing two different logger configurations:

```go
package main

import (
    "log/slog"
    "os"
)

func main() {
    // Debug level logger
    debugLogger := slog.New(slog.NewTextHandler(os.Stdout, &slog.HandlerOptions{
        Level: slog.LevelDebug,
    }))

    // Info level logger
    infoLogger := slog.New(slog.NewTextHandler(os.Stdout, &slog.HandlerOptions{
        Level: slog.LevelInfo,
    }))
}
```

### Debug Level Configuration

When you set the logger level to Debug:

```go
debugLogger.Debug("Debug message")   // ✅ Will be displayed
debugLogger.Info("Info message")     // ✅ Will be displayed
debugLogger.Warn("Warning message")  // ✅ Will be displayed
debugLogger.Error("Error message")   // ✅ Will be displayed
```

### Info Level Configuration

When you set the logger level to Info:

```go
infoLogger.Debug("Debug message")    // ❌ Won't be displayed
infoLogger.Info("Info message")      // ✅ Will be displayed
infoLogger.Warn("Warning message")   // ✅ Will be displayed
infoLogger.Error("Error message")    // ✅ Will be displayed
```

## Common Pitfalls and Solutions

### 1. Default Level

If you don't specify a level in the `HandlerOptions`, the logger defaults to Info level. This means Debug messages won't be visible unless explicitly configured:

```go
// This logger will use Info level by default
logger := slog.New(slog.NewTextHandler(os.Stdout, nil))
```

### 2. Environment-Based Configuration

It's common to want different log levels in different environments. Here's a pattern for setting the level based on an environment variable:

```go
func getLogLevel() slog.Level {
    levelStr := os.Getenv("LOG_LEVEL")
    switch levelStr {
    case "DEBUG":
        return slog.LevelDebug
    case "WARN":
        return slog.LevelWarn
    case "ERROR":
        return slog.LevelError
    default:
        return slog.LevelInfo
    }
}

func main() {
    logger := slog.New(slog.NewTextHandler(os.Stdout, &slog.HandlerOptions{
        Level: getLogLevel(),
    }))
    // Use logger...
}
```

## Best Practices

1. **Development vs. Production**: Use Debug level during development for maximum visibility, but consider using Info level in production to reduce noise and improve performance.

2. **Appropriate Level Usage**:
    - Debug: Detailed information for debugging
    - Info: General operational messages
    - Warn: Warning messages for potentially harmful situations
    - Error: Error messages for serious problems

3. **Structured Logging**: Take advantage of slog's structured logging capabilities:

```go
logger.Info("user login", 
    "username", user.Name,
    "loginTime", time.Now(),
    "attemptNumber", attempts)
```

## Conclusion

Understanding how slog's log levels work is crucial for effective logging in Go applications. By setting appropriate log levels and following best practices, you can maintain clean and informative logs that help with both debugging and monitoring your application.

Remember that log levels are just one part of a good logging strategy. Combined with structured logging and proper log management, they help create a robust observability solution for your Go applications.
