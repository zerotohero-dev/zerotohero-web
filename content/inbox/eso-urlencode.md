+++
#   (`-')           (`-').->
#   ( OO).->        (OO )__
# ,(_/----. .----. ,--. ,'-' doubt everything,
# |__,    |\_,-.  ||  | |  |
#  (_/   /    .' .'|  `-'  | be curious,
#  .'  .'_  .'  /_ |  .-.  |
# |       ||      ||  | |  | learn.
# `-------'`------'`--' `--'

title = "Debugging URL Encoding Issues with External Secrets Operator's Webhook Provider"
description = "Debugging URL Encoding Issues with External Secrets Operator's Webhook Provider"
date = "2024-12-12"

[taxonomies]
tags = ["inbox", "kubernetes", "webhooks", "url-encoding", "debugging"]
+++

When working with Kubernetes External Secrets Operator (ESO) and its webhook provider, you might encounter some interesting URL encoding challenges. In this post, I'll walk through a specific issue we encountered and how we solved it, which might help others facing similar problems.

## The Setup

We started with a basic `ClusterSecretStore` configuration using ESO's webhook provider:

```yaml
apiVersion: external-secrets.io/v1beta1
kind: ClusterSecretStore
metadata:
  name: webhook-backend
spec:
  provider:
    webhook:
      url: "http://eso-webhook.default.svc.cluster.local:80/webhook?{{ .remoteRef.key }}"
      method: GET
      result:
        jsonPath: "$"
```

Our webhook server was a simple Go application designed to handle requests and return secret values based on a path parameter. We expected clean, separate query parameters, but reality had different plans.

## The Problem

When we started debugging why our webhook wasn't working as expected, we added some basic logging to our Go server:

```go
key := r.URL.Query().Get("key")
fmt.Println("key", key)
```

To our surprise, the key was empty! Further investigation by printing the raw URL revealed something interesting:

```
Method: GET
URL: /webhook?key%3Dcoca-cola.cluster-001%26path%3Dnamespaces.cokeSystem.secrets.adminCredentials.value
Protocol: HTTP/1.1
```

The entire query string was URL-encoded as a single parameter. Instead of getting our parameters separately, everything was encoded within the `key` parameter.

## The Solution

### Understanding What's Happening

When ESO processes the template in our ClusterSecretStore URL, it's taking the entire `remoteRef.key` value and inserting it as-is into the URL. If our `remoteRef.key` contains URL-special characters (like `=` and `&`), they get encoded, resulting in our doubly-nested query string.

### Fixing the Server Code

Here's how we modified our webhook server to handle this situation properly:

```go
func webhookHandler(w http.ResponseWriter, r *http.Request) {
    // Get the 'key' query parameter
    encodedKey := r.URL.Query().Get("key")
    
    // Unescape the key parameter
    decodedKey, err := url.QueryUnescape(encodedKey)
    if err != nil {
        http.Error(w, "Failed to decode key parameter", http.StatusBadRequest)
        return
    }
    
    // Parse the decoded key as a query string
    values, err := url.ParseQuery(decodedKey)
    if err != nil {
        http.Error(w, "Invalid key format", http.StatusBadRequest)
        return
    }

    authKey := values.Get("key")
    path := values.Get("path")

    // Validate and use the parameters
    if authKey != "coca-cola.cluster-001" {
        http.Error(w, "Invalid authentication key", http.StatusUnauthorized)
        return
    }

    if path == "" {
        http.Error(w, "Path is required", http.StatusBadRequest)
        return
    }

    // Process the request...
}
```

The key improvements in this solution are:

1. Using `url.QueryUnescape()` to properly decode the URL-encoded parameter
2. Using `url.ParseQuery()` to parse the decoded string as a query string itself
3. Extracting the actual key and path values from the parsed query parameters

### Using the ClusterSecretStore

With this server implementation, we can now use our ClusterSecretStore like this:

```yaml
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  name: example-external-secret
spec:
  secretStoreRef:
    name: webhook-backend
    kind: ClusterSecretStore
  target:
    name: example-secret
  data:
  - secretKey: adminPassword
    remoteRef:
      key: "key=coca-cola.cluster-001&path=namespaces.cokeSystem.secrets.adminCredentials.value"
```

## Lessons Learned

1. Always implement detailed request logging when debugging webhook issues
2. Don't assume how parameters will be encoded or structured in webhook requests
3. Use standard library functions for URL parsing and decoding instead of custom string manipulation
4. Remember that template variables in Kubernetes resources might be processed differently than you expect

## Conclusion

URL encoding issues can be tricky to debug, especially when dealing with nested query parameters. By understanding how ESO processes template variables and using proper URL parsing tools, we can build robust webhook handlers that correctly handle these scenarios.

Remember to always implement proper logging during development and testing phases - it makes debugging these kinds of issues much easier. The Go standard library provides excellent tools for handling URL encoding and parsing, so make use of them instead of trying to parse query strings manually.

This solution provides a clean way to handle the URL encoding challenges while maintaining the security and functionality requirements of our webhook provider.
