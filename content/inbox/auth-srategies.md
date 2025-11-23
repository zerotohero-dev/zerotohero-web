+++
#   (`-')           (`-').->
#   ( OO).->        (OO )__
# ,(_/----. .----. ,--. ,'-' doubt everything,
# |__,    |\_,-.  ||  | |  |
#  (_/   /    .' .'|  `-'  | be curious,
#  .'  .'_  .'  /_ |  .-.  |
# |       ||      ||  | |  | learn.
# `-------'`------'`--' `--'

title = "Implementing Flexible Authentication Strategies in Go: A Real-World Example with External Secrets Operator"
description = "Implementing Flexible Authentication Strategies in Go: A Real-World Example with External Secrets Operator"
date = "2024-12-10"

[taxonomies]
tags = ["inbox","go","security","secrets-management","tls","rest-api"]
+++

In modern cloud-native applications, authentication requirements can vary significantly across different environments and use cases. In this post, I'll share how we implemented a flexible authentication system for a webhook server that integrates with Kubernetes External Secrets Operator (ESO).

## The Challenge

Our webhook server needed to support different authentication methods depending on the deployment environment and security requirements. We wanted to support:

1. JWT verification with a private key
2. JWKS-based verification (for Keycloak integration)
3. Simple shared secret authentication
4. An untrusted mode for development

## The Solution: Strategy Pattern

We decided to use the Strategy pattern to implement our authentication system. This pattern allows us to encapsulate different authentication methods and switch between them easily using environment variables.

Here's the core interface that defines our authentication strategy:

```go
type AuthStrategy interface {
    Authenticate(r *http.Request) (bool, error)
}
```

This simple interface allows us to implement different authentication methods while keeping the rest of our application code unchanged.

## Implementing the Strategies

### 1. JWT Private Key Strategy

This strategy verifies JWTs using a private key stored in our secrets manager:

```go
type JWTPrivateKeyStrategy struct {
    secretClient *vsecm.Client
}

func (s *JWTPrivateKeyStrategy) Authenticate(r *http.Request) (bool, error) {
    privateKey, err := s.secretClient.FetchPassword("jwt-private-key")
    if err != nil {
        return false, fmt.Errorf("failed to fetch private key: %v", err)
    }
    // JWT verification logic here
}
```

### 2. JWKS Strategy

For integration with Keycloak or other OIDC providers, we implemented JWKS-based verification:

```go
type JWKSStrategy struct {
    jwksURL string
    keySet  jwk.Set
}

func (s *JWKSStrategy) Authenticate(r *http.Request) (bool, error) {
    // JWKS verification logic here
}
```

A key advantage of this approach is that we don't need to store any secrets - we just use the public keys provided by the OIDC provider.

### 3. Shared Secret Strategy

For simpler deployments, we implemented a basic shared secret authentication:

```go
type SharedSecretStrategy struct {
    secretClient *vsecm.Client
}

func (s *SharedSecretStrategy) Authenticate(r *http.Request) (bool, error) {
    secret, err := s.secretClient.FetchPassword("shared-secret")
    if err != nil {
        return false, fmt.Errorf("failed to fetch shared secret: %v", err)
    }
    // Secret comparison logic here
}
```

### 4. Untrusted Strategy (Development Mode)

For development environments, we have a strategy that bypasses authentication:

```go
type UntrustedStrategy struct{}

func (s *UntrustedStrategy) Authenticate(r *http.Request) (bool, error) {
    return true, nil
}
```

## Switching Between Strategies

The magic happens in our strategy factory:

```go
func getAuthStrategy() AuthStrategy {
    strategy := os.Getenv("AUTH_STRATEGY")
    switch strategy {
    case "jwt_private_key":
        return &JWTPrivateKeyStrategy{}
    case "jwks":
        return &JWKSStrategy{}
    case "shared_secret":
        return &SharedSecretStrategy{}
    case "untrusted":
        return &UntrustedStrategy{}
    default:
        panic(fmt.Sprintf("Unknown auth strategy: %s", strategy))
    }
}
```

## Using the Authentication System

The authentication system is implemented as middleware:

```go
func authMiddleware(next http.HandlerFunc) http.HandlerFunc {
    strategy := getAuthStrategy()
    return func(w http.ResponseWriter, r *http.Request) {
        authenticated, err := strategy.Authenticate(r)
        if err != nil {
            http.Error(w, fmt.Sprintf("Authentication error: %v", err), 
                      http.StatusInternalServerError)
            return
        }
        if !authenticated {
            http.Error(w, "Unauthorized", http.StatusUnauthorized)
            return
        }
        next.ServeHTTP(w, r)
    }
}
```

## Benefits of This Approach

1. **Flexibility**: Easy to switch between authentication methods using environment variables.
2. **Maintainability**: Each authentication strategy is isolated in its own type.
3. **Extensibility**: New authentication methods can be added without changing existing code.
4. **Security**: Proper separation of concerns and integration with secrets management.
5. **Developer Experience**: Easy to use development mode without compromising production security.

## Real-World Usage

In our case, we're using this system with the External Secrets Operator webhook. Here's how we configure it in different environments:

- **Production**: `AUTH_STRATEGY=jwks` for integration with Keycloak
- **Staging**: `AUTH_STRATEGY=jwt_private_key` for testing with our own JWT implementation
- **Development**: `AUTH_STRATEGY=untrusted` for rapid development

## Lessons Learned

1. **Start Simple**: Begin with the simplest strategy that meets your needs.
2. **Plan for Change**: The Strategy pattern makes it easy to evolve your authentication system.
3. **Security First**: Even in development, have a clear path to production-grade security.
4. **Configuration Matters**: Environment-based configuration provides flexibility without complexity.

## Conclusion

Building a flexible authentication system doesn't have to be complicated. By using the Strategy pattern and good design principles, we created a system that's both secure and adaptable to different environments and requirements.

Remember: security is not one-size-fits-all. The ability to adapt your authentication strategy to different environments and requirements is crucial for modern cloud-native applications.
