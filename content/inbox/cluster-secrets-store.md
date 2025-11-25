+++
#   (`-')           (`-').->
#   ( OO).->        (OO )__
# ,(_/----. .----. ,--. ,'-' doubt everything,
# |__,    |\_,-.  ||  | |  |
#  (_/   /    .' .'|  `-'  | be curious,
#  .'  .'_  .'  /_ |  .-.  |
# |       ||      ||  | |  | learn.
# `-------'`------'`--' `--'

title = "HUnderstanding ClusterSecretStore with JWT Authentication in Kubernetes"
description = "Understanding ClusterSecretStore with JWT Authentication in Kubernetes"
date = "2024-12-03"

[taxonomies]
tags = ["external-secret-operator","inbox","kubernetes","security","authentication","secrets-management"]
+++


# Understanding ClusterSecretStore with JWT Authentication in Kubernetes

When working with External Secrets Operator (ESO) in Kubernetes, configuring a ClusterSecretStore with JWT authentication requires careful consideration of several aspects. Let's explore how to set this up correctly and understand its limitations.

## Understanding the Components

A typical setup involves:
1. A webhook service that validates JWT tokens
2. A Kubernetes secret storing the JWT token
3. A ClusterSecretStore configuration that uses the token for authentication

## Basic Configuration

Here's a basic ClusterSecretStore configuration with JWT authentication:

```yaml
apiVersion: external-secrets.io/v1beta1
kind: ClusterSecretStore
metadata:
  name: vsecm-scout
spec:
  provider:
    webhook:
      url: "https://vsecm-scout.default.svc.cluster.local:8443/webhook?key={{ .remoteRef.key }}"
      method: GET
      result:
        jsonPath: "$"
      headers:
        Authorization: "Bearer {{ .jwt.token }}"
      secrets:
      - name: jwt
        secretRef:
          name: jwt-token
          key: token
      caBundle: "your-ca-bundle-here"
```

## Token Management Challenges

### Static Nature of Configuration
One critical limitation to understand is that ClusterSecretStore configurations are static. When you rotate the JWT token by updating the Kubernetes secret, the ClusterSecretStore doesn't automatically pick up the changes.

```yaml
# This secret update won't automatically reflect in ClusterSecretStore
apiVersion: v1
kind: Secret
metadata:
  name: jwt-token
type: Opaque
stringData:
  token: "your-new-jwt-token"
```

### Handling Token Rotation

Given this limitation, there are several approaches to handle token rotation:

1. **Manual Update Approach**:
```bash
# Update the JWT secret
kubectl create secret generic jwt-token --from-literal=token=new-jwt-token -n default --dry-run=client -o yaml | kubectl apply -f -

# Force update of ClusterSecretStore
kubectl replace -f clusterSecretStore.yaml
```

2. **Custom Controller Approach**:
   Create a controller that watches for secret changes and updates the ClusterSecretStore accordingly.

3. **Webhook Service Adaptation**:
   Modify your webhook service to handle token fetching differently:

```go
func webhookHandler(w http.ResponseWriter, r *http.Request) {
    // Instead of validating a static token,
    // fetch the current token from Kubernetes and validate against that
    currentToken, err := getCurrentTokenFromK8s()
    if err != nil {
        http.Error(w, "Error fetching token", http.StatusInternalServerError)
        return
    }
    
    // Validate the incoming token against the current token
    // Rest of your handler logic...
}
```

## Security Considerations

### 1. Token Lifetime
Consider the implications of token expiration:

- Long-lived tokens are easier to manage but pose higher security risks
- Short-lived tokens are more secure but require more complex rotation mechanisms

### 2. Secret Access
Ensure proper RBAC for accessing the JWT secret:

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: jwt-secret-reader
rules:
- apiGroups: [""]
  resources: ["secrets"]
  resourceNames: ["jwt-token"]
  verbs: ["get"]
```

### 3. TLS Configuration
Always use TLS for the webhook endpoint:

```go
tlsConfig := &tls.Config{
    MinVersion: tls.VersionTLS12,
    CipherSuites: []uint16{
        tls.TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384,
        tls.TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,
    },
}
```

## Best Practices

1. **Monitoring**:
    - Monitor token expiration
    - Set up alerts for failed secret fetches
    - Track webhook endpoint health

2. **Error Handling**:
    - Implement proper error reporting
    - Use appropriate HTTP status codes
    - Log authentication failures (but not sensitive data)

3. **Documentation**:
    - Document token rotation procedures
    - Maintain runbooks for common issues
    - Keep configuration templates updated

## Example: Complete Setup

Here's a complete example bringing everything together:

```yaml
# JWT Secret
apiVersion: v1
kind: Secret
metadata:
  name: jwt-token
type: Opaque
stringData:
  token: "your-jwt-token"
---
# ClusterSecretStore
apiVersion: external-secrets.io/v1beta1
kind: ClusterSecretStore
metadata:
  name: vsecm-scout
spec:
  provider:
    webhook:
      url: "https://vsecm-scout.default.svc.cluster.local:8443/webhook?key={{ .remoteRef.key }}"
      method: GET
      result:
        jsonPath: "$"
      headers:
        Authorization: "Bearer {{ .jwt.token }}"
      secrets:
      - name: jwt
        secretRef:
          name: jwt-token
          key: token
      caBundle: "your-ca-bundle-here"
---
# ExternalSecret Example
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  name: example-external-secret
spec:
  refreshInterval: "1h"
  secretStoreRef:
    kind: ClusterSecretStore
    name: vsecm-scout
  target:
    name: example-secret
  data:
  - secretKey: mykey
    remoteRef:
      key: myremotekey
```

## Conclusion

While ClusterSecretStore with JWT authentication provides a robust way to secure external secrets access, it comes with important limitations regarding token rotation. Understanding these limitations and implementing appropriate strategies for token management is crucial for maintaining a secure and operational system.

Remember that security is a continuous process, and regular reviews of your authentication mechanisms, including JWT token management, should be part of your security practices.

When implementing this setup, always consider your specific use case and requirements, and be prepared to adapt these patterns to match your security needs and operational capabilities.
