+++
#   (`-')           (`-').->
#   ( OO).->        (OO )__
# ,(_/----. .----. ,--. ,'-' doubt everything,
# |__,    |\_,-.  ||  | |  |
#  (_/   /    .' .'|  `-'  | be curious,
#  .'  .'_  .'  /_ |  .-.  |
# |       ||      ||  | |  | learn.
# `-------'`------'`--' `--'

title = "Implementing JWT Authentication with mTLS in Go"
description = "Implementing JWT Authentication with mTLS in Go"
date = "2024-11-27"

[taxonomies]
tags = ["inbox", "jwt", "security"]
+++

Mutual TLS (mTLS) and JSON Web Tokens (JWT) are both powerful security mechanisms that serve different purposes. While mTLS ensures secure bidirectional authentication between client and server at the transport layer, JWTs handle authentication and authorization at the application layer. Combining both provides a robust security model for sensitive operations.

## The Setup

Let's walk through implementing a secure secret management system that uses both mTLS and JWT authentication. Our example will demonstrate:

1. A client making authenticated requests
2. A server validating both mTLS and JWT
3. Error handling for various authentication scenarios

## Client-Side Implementation

First, let's look at how to make a request with both mTLS and JWT authentication:

```go
func Post(client *http.Client, path string, mr []byte) ([]byte, error) {
    req, err := http.NewRequest("POST", path, bytes.NewBuffer(mr))
    if err != nil {
        return []byte{}, errors.Join(
            errors.New("post: Failed to create request"),
            err,
        )
    }

    req.Header.Set("Content-Type", "application/json")
    
    // Add JWT authentication
    if jwt, err := os.ReadFile(".spike-admin-token"); err == nil {
        req.Header.Set("Authorization", "Bearer "+string(bytes.TrimSpace(jwt)))
    }

    r, err := client.Do(req)
    if err != nil {
        return []byte{}, errors.Join(
            errors.New("post: Problem connecting to peer"),
            err,
        )
    }

    // Handle response...
}
```

The client is already configured for mTLS, and we simply add the JWT as a Bearer token in the Authorization header.

## Server-Side Implementation

On the server side, we need to validate both the mTLS connection (handled by the server configuration) and the JWT token:

```go
func routeGetSecret(w http.ResponseWriter, r *http.Request) {
    // Extract and validate JWT
    authHeader := r.Header.Get("Authorization")
    if authHeader == "" || !strings.HasPrefix(authHeader, "Bearer ") {
        w.WriteHeader(http.StatusUnauthorized)
        return
    }

    tokenString := strings.TrimPrefix(authHeader, "Bearer ")

    // Parse and validate the token
    token, err := jwt.ParseWithClaims(tokenString, &state.CustomClaims{}, func(token *jwt.Token) (interface{}, error) {
        if _, ok := token.Method.(*jwt.SigningMethodHMAC); !ok {
            return nil, fmt.Errorf("unexpected signing method: %v", token.Header["alg"])
        }
        return []byte(adminToken), nil
    })

    if err != nil || !token.Valid {
        w.WriteHeader(http.StatusUnauthorized)
        return
    }

    // Process the authenticated request...
}
```

## JWT Generation

The JWTs are generated with specific claims that we validate:

```go
claims := state.CustomClaims{
    RegisteredClaims: &jwt.RegisteredClaims{
        ExpiresAt: jwt.NewNumericDate(now.Add(24 * time.Hour)),
        IssuedAt:  jwt.NewNumericDate(now),
        NotBefore: jwt.NewNumericDate(now),
        Issuer:    "nexus",
        Subject:   "spike-admin",
    },
    AdminTokenID: "spike-admin-jwt",
}
```

## Security Considerations

1. **Defense in Depth**: Using both mTLS and JWT provides two independent layers of security:
    - mTLS ensures the client has valid certificates and is authorized at the transport layer
    - JWT ensures the specific request is authorized and hasn't expired at the application layer

2. **Token Management**: JWTs are set to expire after 24 hours, requiring periodic renewal. This limits the impact of token compromise.

3. **Validation Checks**:
    - Signature verification ensures the token hasn't been tampered with
    - Claims validation ensures the token is being used as intended
    - Expiry checking prevents use of old tokens

## Best Practices

1. **Error Handling**: Return generic error messages to avoid leaking implementation details:
   ```go
   w.WriteHeader(http.StatusUnauthorized)
   ```

2. **Logging**: Log authentication failures for monitoring and alerting, but avoid logging sensitive data:
   ```go
   log.Log().Info("routeGetSecret", "msg", "Invalid token")
   ```

3. **Token Storage**: Store tokens securely and never log them. In our example, we read from a protected file.

## Conclusion

Combining mTLS and JWT authentication provides a robust security model where:
- mTLS ensures secure transport and mutual authentication
- JWT handles fine-grained authorization and session management
- Together they provide defense in depth against various attack vectors

When implementing such a system, careful attention to error handling, logging, and security best practices is essential. The extra complexity is justified when dealing with sensitive operations like secret management.
