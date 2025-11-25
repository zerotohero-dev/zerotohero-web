+++
#   (`-')           (`-').->
#   ( OO).->        (OO )__
# ,(_/----. .----. ,--. ,'-' doubt everything,
# |__,    |\_,-.  ||  | |  |
#  (_/   /    .' .'|  `-'  | be curious,
#  .'  .'_  .'  /_ |  .-.  |
# |       ||      ||  | |  | learn.
# `-------'`------'`--' `--'

title = "Building a Secure Webhook Server with Go and Docker: A Step-by-Step Guide"
description = "Building a Secure Webhook Server with Go and Docker: A Step-by-Step Guide"
date = "2024-12-11"

[taxonomies]
tags = ["go","inbox","kubernetes","security","webhooks"]
+++

In this tutorial, we'll walk through the process of building and containerizing a secure webhook server using Go. We'll cover everything from setting up the project structure to creating a production-ready Docker container.

## Project Overview

Our webhook server is designed to handle secure GET requests with query parameters, process JSON data, and implement basic authentication. The server listens on port 8443 and includes detailed request logging for debugging purposes.

## Prerequisites

- Go 1.20 or later
- Docker
- Basic understanding of Go and Docker concepts

## Project Structure

Let's start with our project structure:

```
.
├── Dockerfile
├── go.mod
└── main.go
```

## The Application Code

Our `main.go` implements a webhook server with the following features:
- Secure parameter handling with URL decoding
- JSON data processing
- Path-based data retrieval
- Detailed request logging
- Basic authentication

The server expects requests with a key parameter and returns JSON data based on the provided path. It includes basic security measures like key validation and proper error handling.

## Dependencies

Our `go.mod` file specifies the project dependencies:

```go
module vsecm-scout

go 1.23.1

require github.com/vmware-tanzu/secrets-manager/sdk v0.28.0

// ... other dependencies ...
```

## Dockerizing the Application

The Dockerfile for our application uses a multi-stage build process to create a minimal and secure production image. Here's a breakdown of our Dockerfile:

```dockerfile
# Build stage
FROM golang:1.20-alpine AS builder

WORKDIR /app

# Copy go mod and sum files
COPY go.mod ./

# Download all dependencies
RUN go mod download

# Copy the source code
COPY main.go ./

# Build the application
RUN CGO_ENABLED=0 GOOS=linux go build -o webhook-server .

# Final stage
FROM alpine:latest

WORKDIR /root/

# Copy the binary from the builder stage
COPY --from=builder /app/webhook-server .

# Expose the port the app runs on
EXPOSE 8443

# Run the binary
CMD ["./webhook-server"]
```

### Key Features of Our Dockerfile:

1. **Multi-stage Build**: We use a multi-stage build to keep our final image size small by only including the compiled binary.

2. **Dependency Management**: The build stage properly handles Go module dependencies.

3. **Static Binary**: We compile a static binary that will run efficiently in the Alpine container.

4. **Security**: Using Alpine as the base image reduces the attack surface of our container.

## Building and Running the Container

To build your Docker image:

```bash
docker build -t vsecm-scout .
```

To run the container:

```bash
docker run -p 8443:8443 vsecm-scout
```

## Best Practices Implemented

1. **Security**:
    - URL parameter decoding for safe input handling
    - Basic authentication with key validation
    - Proper error handling and status codes

2. **Docker Best Practices**:
    - Multi-stage builds for smaller images
    - Proper dependency management
    - Clear and maintainable Dockerfile structure

3. **Golang Best Practices**:
    - Clear error handling
    - Structured logging
    - Clean code organization

## Testing the Webhook Server

Once running, you can test the webhook server with a curl command:

```bash
curl "http://localhost:8443/webhook?key=key=coca-cola.cluster-001%26path=namespaces.cokeSystem.secrets.adminCredentials"
```

## Conclusion

This setup provides a solid foundation for a production-ready webhook server. The combination of Go's robust standard library and Docker's containerization makes it easy to deploy and scale this service in any environment.

Remember to always follow security best practices when deploying webhook servers in production environments, such as:
- Using HTTPS in production
- Implementing rate limiting
- Adding more comprehensive authentication
- Monitoring and logging
- Regular security updates

## Next Steps

Consider enhancing the application with:
- TLS support
- Rate limiting
- Comprehensive logging
- Metrics collection
- Health check endpoints

Happy coding!
