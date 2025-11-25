+++
#   (`-')           (`-').->
#   ( OO).->        (OO )__
# ,(_/----. .----. ,--. ,'-' doubt everything,
# |__,    |\_,-.  ||  | |  |
#  (_/   /    .' .'|  `-'  | be curious,
#  .'  .'_  .'  /_ |  .-.  |
# |       ||      ||  | |  | learn.
# `-------'`------'`--' `--'

title = "Building a Secure Secrets Management Server in Go"
description = "DBuilding a Secure Secrets Management Server in Go"
date = "2024-12-10"

[taxonomies]
tags = ["go","inbox","secrets-management","security","tls","cloud-native","infrastructure","authentication"]
+++

In modern cloud-native environments, managing secrets securely is crucial for maintaining the security of your infrastructure. This post walks through building a secure secrets management server in Go that handles TLS certificates and serves secrets via a REST API.

## Overview

Our server needs to:
1. Fetch secrets from a secrets manager
2. Set up a TLS-enabled HTTP server
3. Serve specific secrets based on API requests
4. Handle secret paths and implement access control

## Implementation Details

### Secret Types and Storage

The server handles two main types of secrets:
1. Infrastructure secrets (prefixed with `raw:vsecm-scout`)
    - TLS certificates and keys
    - JWT signing keys
    - Other infrastructure-related secrets

2. Application secrets (other `raw:` prefixed secrets)
    - Stored in a map for serving via the API
    - Can be accessed using path-based queries

Here's how we organize these secrets:

```go
var (
    jwtSecret      string
    secretsToServe map[string]string
)
```

### Fetching and Processing Secrets

The server starts by fetching secrets from the secrets manager:

```go
sfr, err := sentry.Fetch()
if err != nil {
    log.Fatalf("Error fetching secrets: %v", err)
}
```

It then processes these secrets, organizing them based on their prefix:

```go
for _, secret := range secrets {
    name := secret["Name"].(string)
    value := secret["value"].(string)

    switch name {
    case "raw:vsecm-scout-jwt-secret":
        jwtSecret = value
    case "raw:vsecm-scout-crt":
        serverCert = value
    // ... other cases
    default:
        if strings.HasPrefix(name, "raw:") && !strings.HasPrefix(name, "raw:vsecm-scout") {
            secretsToServe[strings.TrimPrefix(name, "raw:")] = value
        }
    }
}
```

### TLS Configuration

Security is paramount for a secrets management server. We use TLS to encrypt all communications:

```go
cert, err := tls.X509KeyPair([]byte(serverCert), []byte(serverKey))
if err != nil {
    log.Fatalf("Error loading server certificate and key: %v", err)
}

tlsConfig := &tls.Config{
    Certificates: []tls.Certificate{cert},
}

server := &http.Server{
    Addr:      ":8443",
    TLSConfig: tlsConfig,
}
```

### API Implementation

The server exposes a webhook endpoint that serves secrets based on a key and path:

```go
func webhookHandler(w http.ResponseWriter, r *http.Request) {
    // ... request validation ...

    key := values.Get("key")
    path := values.Get("path")

    secretValue, exists := secretsToServe[key]
    if !exists {
        http.Error(w, "Invalid key", http.StatusUnauthorized)
        return
    }

    // ... process and return the secret ...
}
```

### Path-Based Secret Access

The server implements a flexible path-based access system for secrets:

```go
func getValueFromPath(data interface{}, path string) (interface{}, error) {
    parts := strings.Split(path, ".")

    var current = data
    for _, part := range parts {
        switch v := current.(type) {
        case map[string]interface{}:
            if val, ok := v[part]; ok {
                current = val
            } else {
                return nil, fmt.Errorf("key not found: %s", part)
            }
        // ... handle other cases ...
        }
    }

    return current, nil
}
```

This allows clients to access nested values within secrets using dot notation (e.g., "namespaces.cokeSystem.secrets.adminCredentials").

## Security Considerations

1. **TLS**: All communications are encrypted using TLS.
2. **Access Control**: Secrets are only served to clients with valid keys.
3. **Path Validation**: The server validates all path requests to prevent unauthorized access.
4. **Error Handling**: Careful error handling prevents information leakage.

## Usage Example

To request a secret, clients make a GET request to the webhook endpoint:

```bash
curl -k "https://localhost:8443/webhook?key=key=coca-cola.cluster-001&path=namespaces.cokeSystem.secrets.adminCredentials"
```

The server will return the requested secret value if the key is valid and the path exists.

## Future Improvements

1. **JWT Validation**: Implement JWT-based authentication using the stored JWT secret.
2. **Rate Limiting**: Add rate limiting to prevent brute force attacks.
3. **Audit Logging**: Implement detailed audit logging for all secret access.
4. **Secret Rotation**: Add support for automatic secret rotation.
5. **Metrics**: Add Prometheus metrics for monitoring.

## Conclusion

Building a secure secrets management server requires careful attention to security details and proper handling of sensitive data. This implementation provides a solid foundation that can be extended based on specific requirements.

Remember that this is just one piece of a larger secrets management strategy. It should be combined with other security practices like:
- Regular secret rotation
- Strict access controls
- Comprehensive audit logging
- Network security controls
- Regular security audits

The complete code provides a secure and flexible solution for serving secrets in a cloud-native environment while maintaining security best practices.
