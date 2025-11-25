+++
#   (`-')           (`-').->
#   ( OO).->        (OO )__
# ,(_/----. .----. ,--. ,'-' doubt everything,
# |__,    |\_,-.  ||  | |  |
#  (_/   /    .' .'|  `-'  | be curious,
#  .'  .'_  .'  /_ |  .-.  |
# |       ||      ||  | |  | learn.
# `-------'`------'`--' `--'

title = "Building a Custom Webhook Provider for External Secrets Operator: A Step-by-Step Guide"
description = "Building a Custom Webhook Provider for External Secrets Operator: A Step-by-Step Guide"
date = "2024-12-12"

[taxonomies]
tags = ["external-secret-operator","inbox","kubernetes"]
+++

In this tutorial, we'll walk through creating a custom webhook provider for External Secrets Operator (ESO) from scratch. We'll build a simple Go server that serves as a webhook, deploy it to Kubernetes, and configure ESO to use it for secret management.

## Understanding the Architecture

The External Secrets Operator (ESO) can fetch secrets from various providers, including custom webhooks. In this setup:

1. ESO sends requests to our webhook with a key
2. The webhook returns a structured JSON response
3. ESO processes this response and creates Kubernetes secrets accordingly

## Step 1: Creating the Webhook Server

First, let's create a simple Go server that responds to webhook requests. Here's a basic implementation:

```go
package main

import (
    "encoding/json"
    "fmt"
    "log"
    "net/http"
)

// Response structure matching ESO's expectations
type Response struct {
    Namespaces map[string]NamespaceData `json:"namespaces"`
}

type NamespaceData struct {
    Secrets map[string]Secret `json:"secrets"`
}

type Secret struct {
    Type     string         `json:"type"`
    Value    string         `json:"value"`
    Metadata SecretMetadata `json:"metadata"`
    Expires  string         `json:"expires"`
    NotBefore string        `json:"notBefore"`
}

type SecretMetadata struct {
    Labels            map[string]string `json:"labels"`
    Annotations       map[string]string `json:"annotations"`
    CreationTimestamp string           `json:"creationTimestamp"`
    LastUpdated       string           `json:"lastUpdated"`
}

func main() {
    http.HandleFunc("/webhook", webhookHandler)
    fmt.Println("Server is running on :8080")
    log.Fatal(http.ListenAndServe(":8080", nil))
}

func webhookHandler(w http.ResponseWriter, r *http.Request) {
    if r.Method != http.MethodGet {
        http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
        return
    }

    key := r.URL.Query().Get("key")
    if key != "coca-cola.cluster-001" {
        http.Error(w, "Invalid key", http.StatusBadRequest)
        return
    }

    response := Response{
        Namespaces: map[string]NamespaceData{
            "coke-system": {
                Secrets: map[string]Secret{
                    "admin-credentials": {
                        Type:  "k8s",
                        Value: "super-secret-secret",
                        Metadata: SecretMetadata{
                            Labels: map[string]string{
                                "managed-by": "coke-system",
                            },
                            Annotations: map[string]string{
                                "inject-sidecar": "true",
                            },
                            CreationTimestamp: "2024-01-01",
                            LastUpdated:      "2024-01-01",
                        },
                        Expires:   "2024-01-01",
                        NotBefore: "2024-01-01",
                    },
                },
            },
        },
    }

    w.Header().Set("Content-Type", "application/json")
    json.NewEncoder(w).Encode(response)
}
```

## Step 2: Containerizing the Webhook

Create a Dockerfile to package the webhook:

```dockerfile
FROM golang:1.20-alpine AS builder
WORKDIR /app
COPY main.go .
RUN go build -o webhook-server main.go

FROM alpine:latest
WORKDIR /root/
COPY --from=builder /app/webhook-server .
EXPOSE 8080
CMD ["./webhook-server"]
```

## Step 3: Deploying to Kubernetes

Deploy the webhook using a Kubernetes Deployment and Service:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: eso-webhook
  labels:
    app: eso-webhook
spec:
  replicas: 1
  selector:
    matchLabels:
      app: eso-webhook
  template:
    metadata:
      labels:
        app: eso-webhook
    spec:
      containers:
      - name: eso-webhook
        image: localhost:5000/eso-webhook:v1
        ports:
        - containerPort: 8080
---
apiVersion: v1
kind: Service
metadata:
  name: eso-webhook
spec:
  type: LoadBalancer
  selector:
    app: eso-webhook
  ports:
    - protocol: TCP
      port: 80
      targetPort: 8080
```

## Step 4: Configuring External Secrets Operator

Now comes the crucial part: configuring ESO to use our webhook. This involves two components:

1. A ClusterSecretStore that defines how to access our webhook
2. An ExternalSecret that specifies what secrets to fetch

### ClusterSecretStore Configuration

```yaml
apiVersion: external-secrets.io/v1beta1
kind: ClusterSecretStore
metadata:
  name: webhook-backend
spec:
  provider:
    webhook:
      url: "http://eso-webhook.default.svc.cluster.local/webhook?key={{ .remoteRef.key }}"
      method: GET
      result:
        jsonPath: "$.namespaces"
```

### ExternalSecret Configuration with Advanced Templating

```yaml
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  name: coke-admin-credentials
  namespace: coke-system
spec:
  refreshInterval: "15s"
  secretStoreRef:
    name: webhook-backend
    kind: ClusterSecretStore
  target:
    name: admin-credentials
    creationPolicy: Owner
    template:
      engineVersion: v2
      metadata:
        labels:
          managed-by: '{{ index .coke-system.secrets.admin-credentials.metadata.labels "managed-by" }}'
        annotations:
          inject-sidecar: '{{ index .coke-system.secrets.admin-credentials.metadata.annotations "inject-sidecar" }}'
      type: '{{ .coke-system.secrets.admin-credentials.type }}'
      data:
        username: '{{ .coke-system.secrets.admin-credentials.value | b64dec }}'
        password: '{{ .coke-system.secrets.admin-credentials.value | b64dec | upper }}'
        created-at: '{{ now | date "2006-01-02T15:04:05Z07:00" }}'
  data:
  - secretKey: coke-system
    remoteRef:
      key: coca-cola.cluster-001
```

## Understanding the Template Engine

The ExternalSecret configuration uses ESO's v2 template engine, which provides powerful features for transforming secret data:

1. **Engine Version**: We specify `engineVersion: v2` to use the latest templating capabilities.
2. **Accessing Hyphenated Fields**: Fields with hyphens require the `index` function, e.g., `{{ index .metadata.labels "managed-by" }}`.
3. **Data Transformation**: We can use functions like `b64dec` for base64 decoding and `upper` for uppercase conversion.
4. **Time Functions**: The `now` function with date formatting helps track secret creation times.

## Common Pitfalls and Solutions

1. **Hyphenated Field Access**: Always use the `index` function for fields with hyphens.
2. **JSON Path**: Ensure your `jsonPath` in the ClusterSecretStore matches your webhook's response structure.
3. **Service Discovery**: Use the full Kubernetes service DNS name for reliable webhook access.
4. **Template Engine Version**: Always specify `engineVersion: v2` for advanced templating features.

## Conclusion

Creating a custom webhook provider for External Secrets Operator involves careful consideration of:
- Webhook response structure
- Kubernetes deployment configuration
- ESO template engine features
- Service networking and discovery

By following this guide, you can create a flexible secret management solution that integrates seamlessly with your Kubernetes infrastructure while maintaining security and scalability.
