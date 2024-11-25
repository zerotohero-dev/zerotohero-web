+++
#   (`-')           (`-').->
#   ( OO).->        (OO )__
# ,(_/----. .----. ,--. ,'-' doubt everything,
# |__,    |\_,-.  ||  | |  |
#  (_/   /    .' .'|  `-'  | be curious,
#  .'  .'_  .'  /_ |  .-.  |
# |       ||      ||  | |  | learn.
# `-------'`------'`--' `--'

title = "Design Patterns in Go: Building a Policy Management System"
description = "Design Patterns in Go: Building a Policy Management System"
date = "2024-11-24"

[taxonomies]
tags = ["inbox", "go"]
+++

When building systems that require access control, one common requirement is managing policies that define who can access what. In this post, I'll walk through the design and implementation of a policy management system in Go, highlighting important design decisions and patterns along the way.

## The Initial Design

Let's start with a basic policy model. Our policies need to track permissions for different paths and SPIFFE IDs:

```go
type PolicyPermission string

const (
    PermissionRead  PolicyPermission = "read"
    PermissionWrite PolicyPermission = "write"
)

type Policy struct {
    Id              string             `json:"id"`
    Name            string             `json:"name"`
    SpiffeIdPattern string             `json:"spiffe_id_pattern"`
    PathPattern     string             `json:"path_pattern"`
    Permissions     []PolicyPermission `json:"permissions"`
    CreatedAt       time.Time          `json:"created_at"`
    CreatedBy       string             `json:"created_by"`
}
```

For thread-safe storage, we'll use Go's `sync.Map`:

```go
var policies sync.Map
```

## The Evolution of the Design

### First Iteration: Basic CRUD

Our first attempt might look something like this:

```go
func CreatePolicy(policies *sync.Map, policy Policy) error {
    if policy.Id == "" || policy.Name == "" {
        return ErrInvalidPolicy
    }
    
    if _, exists := policies.Load(policy.Id); exists {
        return ErrPolicyExists
    }
    
    policies.Store(policy.Id, policy)
    return nil
}
```

However, this design has a few issues:
1. It requires clients to generate their own IDs
2. It mixes validation with storage logic
3. It doesn't return the created policy

### Second Iteration: Adding Request/Response Types

We might be tempted to add request/response types:

```go
type PolicyRequest struct {
    Name            string
    SpiffeIdPattern string
    PathPattern     string
    Permissions     []PolicyPermission
    CreatedBy       string
}

func CreatePolicy(policies *sync.Map, req PolicyRequest) (Policy, error)
```

But this introduces a new problem: we're mixing API concerns with our core policy management logic. The policy package should remain focused on managing Policy objects, regardless of how they're being created or accessed.

### Final Design: Clean Separation of Concerns

The better approach is to keep the policy package focused on managing Policy objects and handle request/response mapping at the API layer:

```go
// In the policy package
func CreatePolicy(policies *sync.Map, policy Policy) (Policy, error) {
    if policy.Name == "" {
        return Policy{}, ErrInvalidPolicy
    }

    policy.Id = uuid.New().String()
    if policy.CreatedAt.IsZero() {
        policy.CreatedAt = time.Now()
    }

    policies.Store(policy.Id, policy)
    return policy, nil
}
```

Then in your HTTP handler or API layer:

```go
// In your API package
func (h *Handler) CreatePolicy(w http.ResponseWriter, r *http.Request) {
    var req CreatePolicyRequest
    if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
        http.Error(w, err.Error(), http.StatusBadRequest)
        return
    }
    
    policy := Policy{
        Name:            req.Name,
        SpiffeIdPattern: req.SpiffeIdPattern,
        PathPattern:     req.PathPattern,
        Permissions:     req.Permissions,
        CreatedBy:       getUserFromContext(r.Context()),
    }
    
    createdPolicy, err := CreatePolicy(h.policies, policy)
    if err != nil {
        // Handle error
        return
    }
    
    json.NewEncoder(w).Encode(createdPolicy)
}
```

## Key Design Principles

1. **Separation of Concerns**: Keep the core policy logic separate from API concerns. The policy package shouldn't know about HTTP requests or JSON serialization.

2. **Single Responsibility**: Each component should have one job:
    - Policy package: Manage policy objects
    - API layer: Handle HTTP requests/responses
    - Validation layer: Validate inputs

3. **Interface Segregation**: The policy package exposes simple operations (Create, Read, Update, Delete) that can be composed into more complex operations at higher levels.

4. **Immutability**: Operations that modify policies return new Policy objects rather than modifying existing ones.

## Benefits of This Design

1. **Testability**: Core policy logic can be tested without HTTP concerns
2. **Reusability**: The policy package can be used with different interfaces (HTTP, gRPC, CLI)
3. **Maintainability**: Changes to API formats don't require changes to core logic
4. **Flexibility**: Easy to add new features or change implementation details

## Conclusion

When designing systems, it's tempting to mix concerns for convenience. However, keeping clear boundaries between different layers of your application leads to more maintainable and flexible code. In our policy management system, separating the core policy logic from API concerns gives us a more robust and reusable solution.

The final implementation allows for easy extension and modification while maintaining clean separation between the different concerns in the system. This makes it easier to test, maintain, and evolve the system as requirements change.

Remember: Good design isn't about getting it perfect the first time - it's about making it easy to change as you learn more about your requirements.
