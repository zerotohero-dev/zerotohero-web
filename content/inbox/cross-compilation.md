+++
#   (`-')           (`-').->
#   ( OO).->        (OO )__
# ,(_/----. .----. ,--. ,'-' doubt everything,
# |__,    |\_,-.  ||  | |  |
#  (_/   /    .' .'|  `-'  | be curious,
#  .'  .'_  .'  /_ |  .-.  |
# |       ||      ||  | |  | learn.
# `-------'`------'`--' `--'

title = "Cross-Compiling Go Applications on M3 Macs: A Practical Guide"
description = "Cross-Compiling Go Applications on M3 Macs: A Practical Guide"
date = "2024-11-27"

[taxonomies]
tags = ["go","inbox","kubernetes","architecture","shell-scripting","cloud-native","linux"]
+++


Cross-compiling Go applications on Apple Silicon (M-series) Macs can be tricky, especially when dealing with CGO dependencies. In this guide, we'll explore different approaches to building Go applications for multiple architectures, specifically targeting Linux (AMD64 and ARM64) and macOS (ARM64).

## The Challenge

When working with Go applications that use CGO, simple cross-compilation commands like `GOOS=linux GOARCH=amd64 go build` might not be sufficient. This is particularly true when:

- Your application uses CGO-dependent packages
- You need to build for multiple architectures
- You're working on an M-series Mac

## Initial Approach: Local Cross-Compilation

My first attempt involved using traditional cross-compilation tools. Here's what I initially tried:

```bash
# Linux ARM64
CGO_ENABLED=0 GOEXPERIMENT=boringcrypto go build -o keeper ./app/keeper/cmd/main.go
CGO_ENABLED=1 GOEXPERIMENT=boringcrypto go build -o nexus ./app/nexus/cmd/main.go
CGO_ENABLED=0 GOEXPERIMENT=boringcrypto go build -o spike ./app/spike/cmd/main.go
```

However, when trying to cross-compile for different architectures, I ran into issues:

```bash
GOOS=linux GOARCH=amd64 CGO_ENABLED=1 GOEXPERIMENT=boringcrypto go build -o nexus-linux-amd64 ./app/nexus/cmd/main.go
```

This approach failed because it needed proper cross-compilation toolchains.

## The Solution: Docker-Based Cross-Compilation

After exploring various options, I found that using Docker for cross-compilation provides the most reliable and reproducible solution. Here's how to implement it:

1. First, create a Dockerfile:

```dockerfile
FROM golang:1.21-alpine AS builder

# Install build tools
RUN apk add --no-cache gcc musl-dev

# Set working directory
WORKDIR /app

# Copy go mod files
COPY go.mod go.sum ./
RUN go mod download

# Copy source code
COPY . .

# Build for different platforms
RUN GOOS=linux GOARCH=amd64 CGO_ENABLED=0 GOEXPERIMENT=boringcrypto go build -o keeper-linux-amd64 ./app/keeper/cmd/main.go && \
    GOOS=linux GOARCH=amd64 CGO_ENABLED=1 GOEXPERIMENT=boringcrypto go build -o nexus-linux-amd64 ./app/nexus/cmd/main.go && \
    GOOS=linux GOARCH=amd64 CGO_ENABLED=0 GOEXPERIMENT=boringcrypto go build -o spike-linux-amd64 ./app/spike/cmd/main.go && \
    GOOS=linux GOARCH=arm64 CGO_ENABLED=0 GOEXPERIMENT=boringcrypto go build -o keeper-linux-arm64 ./app/keeper/cmd/main.go && \
    GOOS=linux GOARCH=arm64 CGO_ENABLED=1 GOEXPERIMENT=boringcrypto go build -o nexus-linux-arm64 ./app/nexus/cmd/main.go && \
    GOOS=linux GOARCH=arm64 CGO_ENABLED=0 GOEXPERIMENT=boringcrypto go build -o spike-linux-arm64 ./app/spike/cmd/main.go
```

2. Create a build script:

```bash
#!/bin/bash

# Build the Docker image
docker build -t go-cross-compiler .

# Create a container and copy the binaries
docker create --name temp-container go-cross-compiler
docker cp temp-container:/app/keeper-linux-amd64 .
docker cp temp-container:/app/nexus-linux-amd64 .
docker cp temp-container:/app/spike-linux-amd64 .
docker cp temp-container:/app/keeper-linux-arm64 .
docker cp temp-container:/app/nexus-linux-arm64 .
docker cp temp-container:/app/spike-linux-arm64 .

# Clean up
docker rm temp-container
```

## Advantages of the Docker Approach

1. **Reproducibility**: The build environment is consistent across different development machines
2. **No Local Dependencies**: No need to install cross-compilation tools locally
3. **Simplified Process**: One command builds all targets
4. **Consistent Results**: Binaries are built in a controlled environment
5. **Easy CI/CD Integration**: The Docker-based approach works well in automated pipelines

## Building for macOS ARM64

For macOS ARM64 builds, you can still build natively on your M-series Mac:

```bash
GOOS=darwin GOARCH=arm64 CGO_ENABLED=0 GOEXPERIMENT=boringcrypto go build -o keeper-darwin-arm64 ./app/keeper/cmd/main.go
GOOS=darwin GOARCH=arm64 CGO_ENABLED=1 GOEXPERIMENT=boringcrypto go build -o nexus-darwin-arm64 ./app/nexus/cmd/main.go
GOOS=darwin GOARCH=arm64 CGO_ENABLED=0 GOEXPERIMENT=boringcrypto go build -o spike-darwin-arm64 ./app/spike/cmd/main.go
```

## Common Pitfalls and Solutions

1. **CGO Dependencies**: When `CGO_ENABLED=1`, ensure your Docker container has the necessary build tools installed
2. **Architecture Mismatch**: Double-check `GOOS` and `GOARCH` values match your target platforms
3. **Build Tags**: Consider using build tags for platform-specific code
4. **Static Linking**: For better portability, use `CGO_ENABLED=0` when possible

## Conclusion

While cross-compilation on M-series Macs presents some challenges, using Docker provides a robust and maintainable solution. This approach simplifies the build process and ensures consistent results across different architectures.

For projects that don't require CGO, you might still use direct cross-compilation. However, for complex projects with CGO dependencies, the Docker-based approach is recommended.

Remember to version your build scripts and Dockerfile alongside your project code to maintain build reproducibility across your team.
