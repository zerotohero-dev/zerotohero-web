+++
#   (`-')           (`-').->
#   ( OO).->        (OO )__
# ,(_/----. .----. ,--. ,'-' doubt everything,
# |__,    |\_,-.  ||  | |  |
#  (_/   /    .' .'|  `-'  | be curious,
#  .'  .'_  .'  /_ |  .-.  |
# |       ||      ||  | |  | learn.
# `-------'`------'`--' `--'

title = "Expanding vSphere Clusters in VMware Cloud Foundation: A Guide to Adding Hosts"
description = "Expanding vSphere Clusters in VMware Cloud Foundation: A Guide to Adding Hosts"
date = "2024-12-12"

[taxonomies]
tags = ["VCF","inbox"]
+++

While VMware Cloud Foundation (VCF) offers multiple ways to increase capacity, adding hosts to an existing cluster is one of the most straightforward methods. This guide walks through the process of expanding a vSphere cluster by adding new hosts.

## Process Overview

### Current State Assessment
Before adding hosts:
- Check current cluster composition in vSphere client
- Review existing configuration in SDDC Manager
- Verify host count and configuration

### Navigation Path
1. Access SDDC Manager
2. Navigate to Workload Domains
3. Select target domain
4. View cluster details
5. Access Hosts tab
6. Select Actions > Add Host

## Host Selection Process

### Key Considerations

#### Network Pool Compatibility
- Hosts must be commissioned for the correct network pool
- Example: Management domain requires hosts from management network pool
- Different pools (like prod pool) are for different domains

#### Configuration Inheritance
- New hosts automatically inherit:
    - Current switch configuration
    - Network settings
    - Cluster policies
    - Security settings

## Implementation Steps

1. **Host Selection**
    - Choose from available free pool
    - Verify network pool compatibility
    - Select appropriate number of hosts

2. **License Assignment**
    - Apply vSphere license keys
    - Verify license availability
    - Ensure compliance

3. **Review and Deploy**
    - Confirm configuration settings
    - Review inherited parameters
    - Initiate addition workflow

## Deployment Process

### Timeline
- Typical deployment: approximately 15 minutes
- Progress tracked through workflow interface

### Automated Tasks
SDDC Manager handles:
- Host integration
- Network configuration
- Cluster policy application
- Storage setup
- Security configuration

## Verification Steps

### 1. SDDC Manager Verification
- Check updated host count
- Verify cluster composition
- Review host status

### 2. vSphere Client Validation
- Confirm host addition
- Check cluster configuration
- Verify resource availability

## Best Practices

1. **Pre-expansion Planning**
    - Verify resource requirements
    - Check network pool compatibility
    - Ensure license availability

2. **Implementation**
    - Add hosts during maintenance windows
    - Verify configurations before proceeding
    - Monitor workflow progress

3. **Post-expansion**
    - Validate cluster operations
    - Check resource distribution
    - Update documentation

## Benefits

1. **Scalability**
    - Easy capacity expansion
    - Flexible resource management
    - Quick response to demand

2. **Consistency**
    - Automated configuration inheritance
    - Standardized deployment
    - Reduced human error

3. **Efficiency**
    - Streamlined process
    - Minimal manual intervention
    - Quick implementation

## Conclusion

Expanding vSphere clusters through SDDC Manager provides a reliable and efficient method for increasing capacity in your VCF environment. The automated inheritance of configurations ensures consistency while simplifying the expansion process.

Remember to carefully consider network pool compatibility and existing configurations when selecting hosts for addition. The streamlined process helps organizations quickly respond to changing capacity needs while maintaining standardization across their infrastructure.
