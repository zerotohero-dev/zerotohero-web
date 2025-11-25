+++
#   (`-')           (`-').->
#   ( OO).->        (OO )__
# ,(_/----. .----. ,--. ,'-' doubt everything,
# |__,    |\_,-.  ||  | |  |
#  (_/   /    .' .'|  `-'  | be curious,
#  .'  .'_  .'  /_ |  .-.  |
# |       ||      ||  | |  | learn.
# `-------'`------'`--' `--'

title = "Building a Kubernetes Operator for VSecM Secret Management"
description = "Building a Kubernetes Operator for VSecM Secret Management"
date = "2024-12-12"

[taxonomies]
tags = ["inbox","kubernetes","secrets-management","security","SPIFFE","SPIRE"]
+++

Managing secrets in Kubernetes can be challenging, especially when integrating with external secret management systems. In this post, we'll explore how to build a Kubernetes Operator that integrates with VMware Secrets Manager (VSecM) to automatically sync and manage secrets in your cluster.

## What We're Building

Our operator will watch for custom `VSecMSecret` resources that define how secrets should be fetched from VSecM and stored in Kubernetes. It will handle:

- Fetching secrets from VSecM using SPIFFE-based mTLS
- Creating or updating Kubernetes Secrets based on the fetched data
- Periodic refresh of secrets based on configurable intervals
- Mapping of secret data, labels, and annotations

## The Custom Resource Definition

First, let's look at how users will define their secrets using our custom resource:

```yaml
apiVersion: vsecm.com/v1alpha1
kind: VSecMSecret
metadata:
  name: database-credentials
spec:
  vsecmSafeURL: https://path/to/vsecm/safe/api/endpoint
  secretType: k8s
  refreshInterval: 1h    
  target:
    name: database-credentials
  data:
    - key: username
      ref: "databaseCredentials.cocaCola.data.username"
    - key: password
      ref: "databaseCredentials.cocaCola.data.password"
  labels:
    - key: app
      ref: databaseCredentials.cocaCola.labels.app
  annotations:
    - key: env
      ref: databaseCredentials.cocaCola.annotations.env
```

## Setting Up the Project

While we could build the operator from scratch, using the Operator SDK makes our lives easier. Let's walk through the process:

1. Initialize the project:
```bash
operator-sdk init --domain vsecm.com --repo github.com/yourusername/vsecm-operator
```

2. Create the API and controller:
```bash
operator-sdk create api --group vsecm --version v1alpha1 --kind VSecMSecret --resource --controller
```

## Implementing the Controller

The heart of our operator is the controller. Here's the key implementation:

```go
func (r *VSecMSecretReconciler) Reconcile(ctx context.Context, req ctrl.Request) (ctrl.Result, error) {
    logger := log.FromContext(ctx)

    // Fetch the VSecMSecret instance
    var vSecMSecret vsecmv1alpha1.VSecMSecret
    if err := r.Get(ctx, req.NamespacedName, &vSecMSecret); err != nil {
        return ctrl.Result{}, client.IgnoreNotFound(err)
    }

    // Fetch secrets from VSecM
    secretData, err := r.fetchSecretsFromVSecM(vSecMSecret.Spec.VSecMSafeURL)
    if err != nil {
        logger.Error(err, "Failed to fetch secrets from VSecM")
        return ctrl.Result{}, err
    }

    // Create or update Kubernetes Secret
    secret := &corev1.Secret{
        ObjectMeta: metav1.ObjectMeta{
            Name:      vSecMSecret.Spec.Target.Name,
            Namespace: vSecMSecret.Namespace,
        },
    }

    // Parse and set secret data, labels, and annotations
    // ... (implementation details)

    // Schedule the next reconciliation based on the refresh interval
    refreshInterval, _ := time.ParseDuration(vSecMSecret.Spec.RefreshInterval)
    return ctrl.Result{RequeueAfter: refreshInterval}, nil
}
```

## Deploying the Operator

To deploy our operator, we need several components:

1. The Custom Resource Definition (CRD):
```yaml
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  name: vsecmsecrets.vsecm.com
spec:
  group: vsecm.com
  versions:
    - name: v1alpha1
      served: true
      storage: true
      schema:
        openAPIV3Schema:
          # ... (schema details)
```

2. RBAC Configuration:
```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: vsecm-operator
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: vsecm-operator
rules:
  - apiGroups: ["vsecm.com"]
    resources: ["vsecmsecrets"]
    verbs: ["get", "list", "watch"]
  - apiGroups: [""]
    resources: ["secrets"]
    verbs: ["get", "list", "watch", "create", "update", "patch"]
```

3. Operator Deployment:
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: vsecm-operator
spec:
  replicas: 1
  selector:
    matchLabels:
      app: vsecm-operator
  template:
    metadata:
      labels:
        app: vsecm-operator
    spec:
      serviceAccountName: vsecm-operator
      containers:
      - name: operator
        image: your-registry/vsecm-operator:v0.1.0
```

## Using the Operator

Once deployed, using the operator is as simple as creating a VSecMSecret resource:

```bash
kubectl apply -f - <<EOF
apiVersion: vsecm.com/v1alpha1
kind: VSecMSecret
metadata:
  name: database-credentials
spec:
  vsecmSafeURL: https://vsecm.example.com
  secretType: k8s
  refreshInterval: 1h    
  target:
    name: database-credentials
  data:
    - key: username
      ref: "databaseCredentials.cocaCola.data.username"
    - key: password
      ref: "databaseCredentials.cocaCola.data.password"
EOF
```

## Production Considerations

When deploying this operator in production, consider:

1. **Security**:
    - Implement proper SPIFFE mTLS authentication
    - Use secure connection strings
    - Implement proper error handling for secret management

2. **Performance**:
    - Set appropriate resource limits
    - Configure reasonable refresh intervals
    - Implement caching if needed

3. **Monitoring**:
    - Add metrics for secret refresh operations
    - Monitor operator health
    - Set up alerts for failed operations

4. **High Availability**:
    - Consider running multiple replicas
    - Implement proper leader election
    - Handle network partitions gracefully

## Conclusion

Building a Kubernetes Operator for secret management demonstrates the power and flexibility of Kubernetes' extension mechanisms. By automating the synchronization of secrets between VSecM and Kubernetes, we've created a solution that:

- Reduces manual intervention in secret management
- Provides a declarative way to configure secret synchronization
- Maintains consistency between VSecM and Kubernetes secrets
- Allows for easy integration with existing workflows

The complete source code for this operator is available on GitHub at [github.com/yourusername/vsecm-operator](https://github.com/yourusername/vsecm-operator).

Remember that secret management is critical to your application's security. Always review and test thoroughly before deploying to production, and ensure you follow your organization's security policies and best practices.
