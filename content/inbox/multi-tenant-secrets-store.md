+++
#   (`-')           (`-').->
#   ( OO).->        (OO )__
# ,(_/----. .----. ,--. ,'-' doubt everything,
# |__,    |\_,-.  ||  | |  |
#  (_/   /    .' .'|  `-'  | be curious,
#  .'  .'_  .'  /_ |  .-.  |
# |       ||      ||  | |  | learn.
# `-------'`------'`--' `--'

title = "Designing a Multi-Tenant Secret Store for Kubernetes"
description = "Designing a Multi-Tenant Secret Store for Kubernetes"
date = "2024-12-12"

[taxonomies]
tags = ["inbox","kubernetes","secrets-management","security","SPIFFE","SPIRE"]
+++

Managing secrets in a Kubernetes environment can be challenging, especially when dealing with multiple tenants, clusters, and different types of secrets. In this post, we'll explore how to design a flexible and secure secret store that can handle various secret types while integrating with existing tools like External Secrets Operator (ESO).

## The Challenge

When building a secret management system, we often need to handle different types of secrets:

1. **Workload Secrets**: Tied to specific workloads and verified using SPIFFE IDs
2. **Kubernetes Secrets**: Traditional Kubernetes secrets that get created as `kind: Secret` resources
3. **Raw Secrets**: Generic secrets that don't fit into the above categories and might be managed by special operators

Each of these secret types has its own requirements and lifecycle, making it crucial to design a storage system that can handle them all efficiently.

## The Solution: A Hierarchical JSON Structure

Let's look at a JSON schema that can accommodate all these requirements:

```txt
{
  "tenants": {
    "<tenant-name>": {
      "clusters": {
        "<cluster-name>": {
          "namespaces": {
            "<namespace-name>": {
              "secrets": {
                "<secret-name>": {
                  "type": "workload | kubernetes | raw",
                  "value": "<secret-value>",
                  "metadata": {
                    "labels": {
                      "<label-key>": "<label-value>"
                    },
                    "annotations": {
                      "<annotation-key>": "<annotation-value>"
                    },
                    "creationTimestamp": "<ISO8601-timestamp>",
                    "lastUpdated": "<ISO8601-timestamp>"
                  },
                  "spiffeId": "<spiffe-id>",  // Only for workload type
                  "expirationDate": "<ISO8601-timestamp>",
                  "notBefore": "<ISO8601-timestamp>"
                }
              }
            }
          },
          "global_secrets": {
            "<secret-name>": {
              // Same structure as namespace-level secrets
            }
          }
        }
      }
    }
  }
}
```

This structure provides several key benefits:

1. **Multi-tenant Support**: Each tenant gets its own isolated space in the store
2. **Hierarchical Organization**: Clear separation between clusters, namespaces, and global secrets
3. **Type-based Classification**: Each secret explicitly declares its type
4. **Rich Metadata**: Support for labels, annotations, and time-based validity

## Implementing the Store

Here's how we can implement this secret store in practice:

### 1. Storing Secrets

```python
def store_secret(tenant, cluster, namespace, secret_name, secret_data):
    secret = {
        "type": secret_data["type"],
        "value": secret_data["value"],
        "metadata": {
            "labels": secret_data.get("labels", {}),
            "annotations": secret_data.get("annotations", {}),
            "creationTimestamp": datetime.utcnow().isoformat(),
            "lastUpdated": datetime.utcnow().isoformat()
        },
        "expirationDate": secret_data.get("expirationDate"),
        "notBefore": secret_data.get("notBefore")
    }
    
    # Add SPIFFE ID for workload secrets
    if secret["type"] == "workload":
        if "spiffeId" not in secret_data:
            raise ValueError("SPIFFE ID required for workload secrets")
        secret["spiffeId"] = secret_data["spiffeId"]
    
    # Store in your key-value store
    key = f"{tenant}:{cluster}:{namespace}:{secret_name}"
    store.set(key, json.dumps(secret))
```

### 2. Retrieving Secrets

```python
def get_secret(tenant, cluster, namespace, secret_name):
    key = f"{tenant}:{cluster}:{namespace}:{secret_name}"
    secret_json = store.get(key)
    
    if not secret_json:
        return None
        
    secret = json.loads(secret_json)
    
    # Verify time-based validity
    now = datetime.utcnow().isoformat()
    if secret.get("notBefore") and now < secret["notBefore"]:
        raise ValueError("Secret not yet valid")
    if secret.get("expirationDate") and now > secret["expirationDate"]:
        raise ValueError("Secret has expired")
        
    return secret
```

## Integration with External Tools

### External Secrets Operator (ESO)

To integrate with ESO, we can create a webhook that serves our secrets:

```yaml
apiVersion: external-secrets.io/v1beta1
kind: SecretStore
metadata:
  name: custom-webhook-store
spec:
  provider:
    webhook:
      url: "https://secret-store.example.com/secrets"
      method: GET
      result:
        jsonPath: "$.value"
      headers:
        X-Tenant: "{{ .remoteRef.tenant }}"
        X-Cluster: "{{ .remoteRef.cluster }}"
        X-Namespace: "{{ .remoteRef.namespace }}"
```

### VSecM Integration

VSecM can use the `type` field to determine how to handle each secret:

```python
def handle_secret(secret):
    if secret["type"] == "workload":
        # Verify SPIFFE ID before returning
        verify_spiffe_id(secret["spiffeId"])
    elif secret["type"] == "kubernetes":
        # Create Kubernetes Secret resource
        create_k8s_secret(secret)
    elif secret["type"] == "raw":
        # Pass to appropriate operator
        handle_raw_secret(secret)
```

## Benefits of This Design

1. **Type Safety**: Explicit typing prevents confusion about how to handle different secrets
2. **Flexibility**: Easy to add new secret types or metadata fields
3. **Integration-Ready**: Works well with existing tools like ESO and VSecM
4. **Scalability**: Hierarchical structure supports multi-tenant, multi-cluster environments
5. **Auditability**: Built-in support for timestamps and metadata

## Conclusion

By designing our secret store with clear type distinctions and a hierarchical structure, we've created a flexible system that can handle various secret types while maintaining compatibility with existing tools. The explicit typing system makes it easy for tools like VSecM to handle secrets appropriately, while the rich metadata support enables advanced features like time-based validity and auditing.

Whether you're managing workload secrets, Kubernetes secrets, or special operator-managed secrets, this design provides a solid foundation for your secret management needs.

---

*Do you have thoughts on this secret store design? How would you extend it for your use case? Share your ideas in the comments below!*
