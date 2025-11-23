+++
#   (`-')           (`-').->
#   ( OO).->        (OO )__
# ,(_/----. .----. ,--. ,'-' doubt everything,
# |__,    |\_,-.  ||  | |  |
#  (_/   /    .' .'|  `-'  | be curious,
#  .'  .'_  .'  /_ |  .-.  |
# |       ||      ||  | |  | learn.
# `-------'`------'`--' `--'

title = "Using External Secrets Operator with HashiCorp Vault to Create Kubernetes Secrets"
description = "Using External Secrets Operator with HashiCorp Vault to Create Kubernetes Secrets"
date = "2024-12-22"

[taxonomies]
tags = ["inbox","kubernetes","security","vault","external-secret-operator","secrets-management"]
+++


When working with Kubernetes, securely managing secrets is a crucial part of your infrastructure. Traditional approaches—like directly embedding secrets in manifests or manually managing `Secret` objects—can become cumbersome and less secure over time. Enter the [External Secrets Operator (ESO)](https://external-secrets.io), a powerful way to integrate external secret stores with Kubernetes. One such secret store is [HashiCorp Vault](https://www.vaultproject.io), a proven solution for securely storing and accessing secrets.

In this post, we'll walk through the key Custom Resource Definitions (CRDs) you need to set up in your cluster to fetch secrets from Vault and have them automatically synchronized as Kubernetes secrets.

## Overview

ESO acts as a bridge between external secret stores (in this case, Vault) and Kubernetes `Secret` objects. To make this happen, you'll define a store resource that tells ESO **where** and **how** to retrieve secrets. You'll then define another resource that specifies **which** secrets to fetch and how to transform them into Kubernetes secrets.

In other words:
- **SecretStore/ClusterSecretStore:** Defines the external secret provider configuration
- **ExternalSecret:** Defines the specific secrets you want to pull from your chosen store and how to map them into Kubernetes secrets

## Key Resources

### 1. SecretStore or ClusterSecretStore

The `SecretStore` or `ClusterSecretStore` resource provides information about your Vault instance, including:

- **Endpoint:** The URL of the Vault server
- **Authentication method:** How ESO should authenticate to Vault (e.g., using a Kubernetes Service Account token, Vault token, or another method)
- **Paths and parameters:** Details like which Vault mount paths and keys to read from

**When to use `SecretStore` vs. `ClusterSecretStore`?**

- **SecretStore:** Used when you want the configuration to be namespace-specific
- **ClusterSecretStore:** Used when you want a cluster-wide configuration accessible by multiple namespaces

**Example:**
```yaml
apiVersion: external-secrets.io/v1beta1
kind: ClusterSecretStore
metadata:
  name: vault-backend
spec:
  provider:
    vault:
      server: "https://vault.example.com"
      path: "secret" # The path where secrets are stored in Vault
      version: "v2"
      auth:
        tokenSecretRef:
          name: vault-token
          key: token
```

This `ClusterSecretStore` tells ESO how to communicate with a Vault server at `vault.example.com`, using a token stored in the `vault-token` Secret.

### 2. ExternalSecret

The `ExternalSecret` resource references the `SecretStore` or `ClusterSecretStore` and tells ESO which keys from Vault to sync and how to project them into a Kubernetes Secret.

**Example:**
```yaml
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  name: my-app-secret
  namespace: default
spec:
  refreshInterval: 1h
  secretStoreRef:
    kind: ClusterSecretStore
    name: vault-backend
  target:
    name: my-app-k8s-secret
    creationPolicy: Owner
  data:
    - secretKey: api-key       # Key in the resulting K8s Secret
      remoteRef:
        key: my-app/api-key     # Path/key in Vault
```

In this `ExternalSecret`:
- `secretStoreRef` points to the `ClusterSecretStore` named `vault-backend`
- It requests a secret named `my-app/api-key` from Vault
- It maps that key into a Kubernetes Secret named `my-app-k8s-secret` under the `api-key` key

## How it Works

1. **Define the Store:**
   Set up a `ClusterSecretStore` or `SecretStore` resource that points to your Vault instance and specifies authentication details.

2. **Request the Secret:**
   Create an `ExternalSecret` resource that references the store and specifies the exact secrets you need.

3. **ESO Synchronizes the Secret:**
   The External Secrets Operator continuously reconciles resources. When it sees your `ExternalSecret`, it connects to Vault (using the instructions from the store resource), fetches the requested secret, and creates or updates the corresponding Kubernetes Secret object in your cluster.

## Analogies

- Think of the `ClusterSecretStore` as a "GPS coordinate" that tells ESO where to find the treasure (your secrets) in Vault.
- The `ExternalSecret` is your "shopping list," telling ESO which items (specific keys/values) to bring back from that secret store and how to pack them into a Kubernetes Secret.

## Pros and Cons

### Pros:
- Separation of concerns: Store configuration is separate from secret retrieval specifications
- Reusability: You can reuse the same `ClusterSecretStore` for multiple `ExternalSecrets`
- Security: Keeps sensitive data in Vault, only syncing what's necessary to Kubernetes

### Cons:
- Initial complexity: Requires understanding CRDs and writing additional YAML manifests
- Extra components: Relies on running ESO and Vault integrations

## Summary

By defining a `SecretStore` or `ClusterSecretStore` and one or more `ExternalSecrets`, you can seamlessly integrate HashiCorp Vault secrets into your Kubernetes cluster with the External Secrets Operator. This pattern centralizes and secures your secret management workflow, providing a more maintainable and secure approach than manually managing Secret objects.

### Key Takeaways:
- Use `SecretStore` or `ClusterSecretStore` to define how to connect to Vault
- Use `ExternalSecret` to specify which secrets to pull from Vault
- ESO automatically keeps your Kubernetes secrets in sync with Vault's secrets

## Further Reading

- [External Secrets Operator Documentation](https://external-secrets.io)
- [HashiCorp Vault Documentation](https://www.vaultproject.io)
