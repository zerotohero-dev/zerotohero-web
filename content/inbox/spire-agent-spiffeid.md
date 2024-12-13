+++
#   (`-')           (`-').->
#   ( OO).->        (OO )__
# ,(_/----. .----. ,--. ,'-' doubt everything,
# |__,    |\_,-.  ||  | |  |
#  (_/   /    .' .'|  `-'  | be curious,
#  .'  .'_  .'  /_ |  .-.  |
# |       ||      ||  | |  | learn.
# `-------'`------'`--' `--'

title = "Customizing SPIRE Agent SPIFFE IDs: A Deep Dive"
description = "Customizing SPIRE Agent SPIFFE IDs: A Deep Dive"
date = "2024-12-02"

[taxonomies]
tags = ["inbox", "spiffe", "spire", "spiffeid", "spire-agent", "identity"]
+++

When working with SPIRE (the SPIFFE Runtime Environment), you might notice that your agent SPIFFE IDs follow a standard pattern like `spiffe://trust-domain/spire-agent`. But what if you need to customize this identifier? Let's explore how SPIRE handles agent SPIFFE ID assignment and how you can configure it to meet your needs.

## Default Behavior

By default, SPIRE Server generates agent SPIFFE IDs using a simple pattern:
```
spiffe://{trust_domain}/spire-agent
```

For example, with a trust domain of `spike.ist`, you'll see entries like:
```
Entry ID         : c3d0ecbf-38b1-4a0c-86ac-67d181503f9d
SPIFFE ID       : spiffe://spike.ist/spire-agent
Parent ID       : spiffe://spike.ist/spire/agent/join_token/a098731b-14a8-4ef3-b2ff-b63c2cc9f985
```

This default `/spire-agent` path component is hard-coded in SPIRE Server when no custom configuration is provided.

## Customizing Agent SPIFFE IDs

You can customize the agent SPIFFE ID path using the `agent_path_template` configuration option in your SPIRE Server configuration. Here's how:

```txt
server {
    trust_domain = "spike.ist"
    agent_path_template = "/custom-agents/{{ .AgentID }}"
    # ... other server configuration
}
```

### Available Template Variables

The template system supports different variables depending on your attestation method:

#### With X509 PoP Attestation
- `.NodeName`
- `.AgentID`
- `.TrustDomain`

#### With Join Token Attestation
- `.AgentID` (a UUID)
- `.TrustDomain`

Note that join token attestation provides fewer variables since it doesn't collect node-specific information during the attestation process.

## Example Templates

1. Using AgentID with join token attestation:
```txt
agent_path_template = "/nodes/{{ .AgentID }}"
# Results in: spiffe://spike.ist/nodes/c3d0ecbf-38b1-4a0c-86ac-67d181503f9d
```

2. Combining multiple path components:
```txt
agent_path_template = "/datacenter/primary/agent/{{ .AgentID }}"
```

## Considerations

When choosing your agent path template:
- Consider the attestation method you're using and available variables
- Ensure the template will generate unique identifiers for each agent
- Keep the paths meaningful and organized for your environment
- Remember that changing the template will affect new agent registrations, not existing ones

## Conclusion

While SPIRE provides a sensible default for agent SPIFFE IDs, the ability to customize them using `agent_path_template` gives you flexibility in organizing and identifying your agents. Whether you're using X509 PoP or join token attestation, you can create a naming scheme that fits your infrastructure's needs.
