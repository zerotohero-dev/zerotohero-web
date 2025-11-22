+++
#   (`-')           (`-').->
#   ( OO).->        (OO )__
# ,(_/----. .----. ,--. ,'-' doubt everything,
# |__,    |\_,-.  ||  | |  |
#  (_/   /    .' .'|  `-'  | be curious,
#  .'  .'_  .'  /_ |  .-.  |
# |       ||      ||  | |  | learn.
# `-------'`------'`--' `--'

title = "Establishing SPIFFE Federation Between Kubernetes Clusters"
description = "Establishing SPIFFE Federation Between Kubernetes Clusters"
date = "2024-12-16"

[taxonomies]
tags = ["inbox", "spiffe", "spire", "kubernetes", "spiffe", "identity", "security"]
+++

SPIFFE (Secure Production Identity Framework For Everyone) provides a robust framework for service identity across distributed systems. When using SPIFFE with SPIRE (SPIFFE Runtime Environment) in Kubernetes clusters, it's common to have multiple trust domains. To enable secure communication between these domains, you need to establish SPIFFE federation by exchanging and trusting each other's trust bundles.

In this blog post, we'll walk through the steps to establish SPIFFE federation between two Kubernetes clusters with separate trust domains.

## Scenario Overview

Assume you have:
- Server A with a trust domain `trustdomainA`
- Server B with a trust domain `trustdomainB`

Both servers are running SPIRE to manage identities. To enable federation, the servers need to exchange and trust each other's trust bundles.

## Step 1: Export the Trust Bundle

Each SPIRE server has its own trust bundle, which includes the root CA certificate for its trust domain. Start by exporting the trust bundle from Server B:

```bash
spire-server bundle show -format spiffe
```

This command will output the trust bundle for `trustdomainB` in SPIFFE format. Save this output to a file (e.g., `trust-bundleB.pem`).

## Step 2: Configure Federation in Server A

Next, configure Server A to trust `trustdomainB`. To do this, you'll use the exported trust bundle from Server B.

Add the trust bundle to Server A's configuration:

```bash
spire-server bundle set -format spiffe -id spiffe://trustdomainB -path /path/to/trust-bundleB.pem
```

This command tells Server A to trust the root CA from `trustdomainB`. Update Server A's `spire-server.conf` file if needed to reflect the federation relationship with `trustdomainB`.

## Step 3: Validate the Trust Relationship

After configuration, Server A will validate any SPIFFE identity (SVID) from `trustdomainB` by checking its signature against the root CA in the trust bundle.

When Server A encounters an identity from `trustdomainB`:
- It verifies the SVID's signature
- If the signature is valid and matches the root CA from `trustdomainB`, the identity is trusted

## Step 4: Establish Bi-Directional Trust (Optional)

If you want Server B to trust identities from `trustdomainA`, repeat the process in reverse:

1. Export the trust bundle from Server A:
```bash
spire-server bundle show -format spiffe
```

2. Configure Server B to trust the exported bundle by adding it to `trustdomainA`:
```bash
spire-server bundle set -format spiffe -id spiffe://trustdomainA -path /path/to/trust-bundleA.pem
```

Now, both servers trust each other's identities, enabling mutual federation.

## Key Considerations

### Bundle Rotation
If the root CA in a trust domain is rotated, the updated trust bundle must be shared with the other server to maintain trust.

### Unique SPIFFE IDs
Ensure that SPIFFE IDs are unique across trust domains to avoid collisions.

### Secure Transport
Always exchange trust bundles securely to prevent tampering.

## Conclusion

By following these steps, you can establish SPIFFE federation between two Kubernetes clusters with distinct trust domains. This enables secure identity-based communication across distributed systems, a critical component for modern cloud-native applications.

SPIFFE federation simplifies the management of service identity across multiple clusters and trust domains, allowing you to focus on building secure and scalable applications.
