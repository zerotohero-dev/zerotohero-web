+++
#   (`-')           (`-').->
#   ( OO).->        (OO )__
# ,(_/----. .----. ,--. ,'-' doubt everything,
# |__,    |\_,-.  ||  | |  |
#  (_/   /    .' .'|  `-'  | be curious,
#  .'  .'_  .'  /_ |  .-.  |
# |       ||      ||  | |  | learn.
# `-------'`------'`--' `--'

title = "Modernizing TLS Certificates in Kubernetes: From CN to SAN"
description = "Modernizing TLS Certificates in Kubernetes: From CN to SAN"
date = "2024-12-10"

[taxonomies]
tags = ["inbox","kubernetes","tls","certificates","security"]
+++

When working with Kubernetes and TLS certificates, you might encounter an error message that looks something like this:

```
error: failed to verify certificate: x509: certificate relies on legacy Common Name field, use SANs instead
```

This article explains why this error occurs and how to fix it, particularly in the context of the external-secrets operator and VSecM integration.

## Understanding the Problem

### The Legacy Common Name Field

Historically, TLS certificates used the Common Name (CN) field to specify the hostname that the certificate was valid for. This approach had several limitations:

1. It only allowed for a single hostname per certificate
2. The field wasn't explicitly defined for hostname verification
3. It created potential security vulnerabilities

### The Modern Approach: Subject Alternative Names (SANs)

Subject Alternative Names (SANs) were introduced to address these limitations. SANs provide:

- Support for multiple hostnames
- Explicit fields for DNS names, IP addresses, and other identifiers
- Better security through more precise hostname matching
- Compliance with modern security standards

## Real-World Example

Let's look at a real-world scenario involving the external-secrets operator and VSecM Scout. The following error occurs when using a certificate generated with only a Common Name:

```
Warning  UpdateFailed  error retrieving secret: failed to call endpoint: tls: failed to verify certificate: 
x509: certificate relies on legacy Common Name field, use SANs instead
```

### The Solution

To fix this, we need to modify our certificate generation process to include Subject Alternative Names. Here's how to do it:

1. Create an OpenSSL configuration file that includes SAN extensions
2. Generate the certificate using this configuration
3. Update the certificate in your Kubernetes cluster

Here's the complete script that implements these changes:

```bash
#!/usr/bin/env bash

SCOUT_DNS="vsecm-scout.vsecm-system.svc.cluster.local"

# Generate a private key
openssl genrsa -out server.key 2048

# Create a configuration file for the certificate
cat > server.conf << EOF
[req]
distinguished_name = req_distinguished_name
x509_extensions = v3_req
prompt = no
[req_distinguished_name]
CN = ${SCOUT_DNS}
[v3_req]
keyUsage = critical, digitalSignature, keyEncipherment
extendedKeyUsage = serverAuth
subjectAltName = @alt_names
[alt_names]
DNS.1 = ${SCOUT_DNS}
EOF

# Create a self-signed certificate using the configuration file
openssl req -new -x509 -sha256 -key server.key -out server.crt \
  -days 3650 -config server.conf
```

## Understanding the Changes

Let's break down the key components of the solution:

### 1. Configuration File Structure
The OpenSSL configuration file includes several important sections:

- `[req]`: Basic certificate request settings
- `[req_distinguished_name]`: Certificate subject information
- `[v3_req]`: Certificate extensions
- `[alt_names]`: Subject Alternative Names

### 2. Key Extensions
We specify two important extensions:

```
keyUsage = critical, digitalSignature, keyEncipherment
extendedKeyUsage = serverAuth
```

These define how the certificate can be used and ensure it's properly configured for server authentication.

### 3. Subject Alternative Names
The crucial part that fixes our error:

```
subjectAltName = @alt_names
[alt_names]
DNS.1 = ${SCOUT_DNS}
```

This explicitly defines the DNS name that the certificate is valid for.

## Best Practices

When updating your certificates:

1. Always include both CN and SAN fields for maximum compatibility
2. Use specific key usage and extended key usage extensions
3. Keep the certificate validity period reasonable (3650 days in our example)
4. Store private keys securely
5. Implement proper certificate rotation procedures

## Verifying the Certificate

After generating your certificate, you can verify it has the correct SAN entries using:

```bash
openssl x509 -in server.crt -text -noout | grep DNS
```

You should see your DNS name listed in the Subject Alternative Name section.

## Conclusion

Moving from Common Name to Subject Alternative Names is more than just fixing an error—it's about adopting modern security practices. While the change requires updating certificate generation scripts, the benefits include improved security, better compatibility with modern systems, and adherence to current best practices.

Remember to update your certificate generation processes across all your infrastructure to prevent similar issues in the future. This small change can save you from debugging sessions and potential security vulnerabilities down the line.

Stay secure! 🔐
