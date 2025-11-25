+++
#   (`-')           (`-').->
#   ( OO).->        (OO )__
# ,(_/----. .----. ,--. ,'-' doubt everything,
# |__,    |\_,-.  ||  | |  |
#  (_/   /    .' .'|  `-'  | be curious,
#  .'  .'_  .'  /_ |  .-.  |
# |       ||      ||  | |  | learn.
# `-------'`------'`--' `--'

title = "Building an ACL System for SPIFFE-based Secrets Store"
description = "Building an ACL System for SPIFFE-based Secrets Store"
date = "2024-11-24"

[taxonomies]
tags = ["SPIFFE","go","inbox","authentication","infrastructure","kubernetes"]
+++

Managing secrets in a microservices environment is challenging. While tools like HashiCorp Vault are excellent, sometimes you need a lighter solution that integrates deeply with your existing SPIFFE-based identity system. In this post, we'll build an ACL (Access Control List) system for a SPIFFE-aware secrets store.

## The Problem

In a SPIFFE-enabled infrastructure, each workload has a unique SPIFFE ID. For example:
- `spiffe://example.org/web-server/prod/001`
- `spiffe://example.org/payment-service/staging/002`

These IDs authenticate workloads, but we need authorization too. Which secrets can each workload access? How do we manage these permissions at scale?

## Design Goals

1. **Pattern-Based Access**: Allow policies using SPIFFE ID patterns and path patterns
2. **Simple but Powerful**: Keep the API simple while supporting complex use cases
3. **Integration Ready**: Easy to integrate with existing SPIFFE/SPIRE deployments
4. **Developer Friendly**: Clear API design with intuitive client usage

## API Design

We'll organize our API endpoints logically:

```go
// Authentication endpoints
const (
    urlAuthInit  = "/v1/auth/init"     
    urlAuthLogin = "/v1/auth/login"    
)

// Store endpoints
const (
    urlStoreSecrets = "/v1/store/secrets"          
    urlStoreSecret  = "/v1/store/secrets/{path:*}" 
    urlStoreList    = "/v1/store/list/{path:*}"    
)

// Access Control endpoints
const (
    urlAclPolicies   = "/v1/store/acl/policies"      
    urlAclPolicyByID = "/v1/store/acl/policies/{id}" 
    urlAclCheck      = "/v1/store/acl/check"         
)
```

## Core Components

### 1. Policy Definition

A policy connects SPIFFE ID patterns to secret paths:

```go
type Policy struct {
    ID              string    `json:"id"`
    Name            string    `json:"name"`
    SpiffeIDPattern string    `json:"spiffe_id_pattern"`
    PathPattern     string    `json:"path_pattern"`
    Permissions     []string  `json:"permissions"`
    CreatedAt       time.Time `json:"created_at"`
    CreatedBy       string    `json:"created_by"`
}
```

Example policy:
```json
{
    "name": "web-servers-prod",
    "spiffe_id_pattern": "spiffe://example.org/web-server/prod/.*",
    "path_pattern": "secrets/web/prod/*",
    "permissions": ["read", "list"]
}
```

### 2. Server Implementation

The server handles policy management and access checking:

```go
type ACLService struct {
    policies sync.Map
}

func (s *ACLService) CheckAccess(w http.ResponseWriter, r *http.Request) {
    var req CheckAccessRequest
    if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
        http.Error(w, err.Error(), http.StatusBadRequest)
        return
    }

    matchingPolicies := []string{}
    allowed := false

    s.policies.Range(func(key, value interface{}) bool {
        policy := value.(*Policy)
        
        // Check SPIFFE ID pattern
        matched, err := regexp.MatchString(policy.SpiffeIDPattern, req.SpiffeID)
        if err != nil || !matched {
            return true
        }

        // Check path pattern
        if matched, _ := path.Match(policy.PathPattern, req.Path); !matched {
            return true
        }

        // Check permissions
        for _, perm := range policy.Permissions {
            if perm == req.Action {
                matchingPolicies = append(matchingPolicies, policy.ID)
                allowed = true
                break
            }
        }

        return true
    })

    json.NewEncoder(w).Encode(CheckAccessResponse{
        Allowed:          allowed,
        MatchingPolicies: matchingPolicies,
    })
}
```

### 3. Client SDK

A clean client SDK makes integration easy:

```go
type ACLClient struct {
    baseURL    string
    httpClient *http.Client
}

func (c *ACLClient) CheckAccess(ctx context.Context, spiffeID, path, action string) (*CheckAccessResponse, error) {
    req := CheckAccessRequest{
        SpiffeID: spiffeID,
        Path:     path,
        Action:   action,
    }

    body, err := json.Marshal(req)
    if err != nil {
        return nil, fmt.Errorf("marshaling request: %w", err)
    }

    httpReq, err := http.NewRequestWithContext(
        ctx,
        "POST",
        fmt.Sprintf("%s/v1/store/acl/check", c.baseURL),
        bytes.NewReader(body),
    )
    if err != nil {
        return nil, fmt.Errorf("creating request: %w", err)
    }

    // ... handle response ...
}
```

## Usage Examples

Here's how to use the system:

```go
// Create a policy
client := NewACLClient("http://localhost:8080")
policy, err := client.CreatePolicy(ctx, CreatePolicyRequest{
    Name:            "web-servers",
    SpiffeIDPattern: "spiffe://example.org/web-server/.*",
    PathPattern:     "secrets/web/*",
    Permissions:     []string{"read", "list"},
})

// Check access
resp, err := client.CheckAccess(ctx, 
    "spiffe://example.org/web-server/001",
    "secrets/web/config",
    "read",
)
fmt.Printf("Access allowed: %v\n", resp.Allowed)
```

## Production Considerations

1. **Storage**: Replace `sync.Map` with a proper database
2. **Caching**: Add policy cache with TTL
3. **Monitoring**: Add metrics for policy evaluations
4. **Audit Logging**: Log all access checks
5. **Rate Limiting**: Protect the API from abuse

## Security Considerations

1. **Pattern Validation**: Validate SPIFFE ID patterns strictly
2. **Least Privilege**: Start with minimal permissions
3. **Policy Versioning**: Consider versioning policies
4. **Audit Trail**: Log all policy changes
5. **Regular Reviews**: Implement policy review processes

## Conclusion

This SPIFFE-aware ACL system provides a solid foundation for securing your secrets store. It's simple enough to understand quickly but flexible enough to handle complex access patterns. The pattern-based matching makes it easy to manage permissions at scale.

Remember to adapt the implementation based on your specific needs. You might want to add features like:
- Policy inheritance
- Temporary access grants
- More sophisticated pattern matching
- Integration with external policy engines

The complete code is available in the examples above. Feel free to use and modify it for your needs!

---

*This post is part of our series on SPIFFE-based infrastructure. Stay tuned for more posts about secrets management, workload identity, and secure service-to-service communication.*
