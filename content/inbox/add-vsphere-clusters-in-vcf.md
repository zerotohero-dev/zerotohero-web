+++
#   (`-')           (`-').->
#   ( OO).->        (OO )__
# ,(_/----. .----. ,--. ,'-' doubt everything,
# |__,    |\_,-.  ||  | |  |
#  (_/   /    .' .'|  `-'  | be curious,
#  .'  .'_  .'  /_ |  .-.  |
# |       ||      ||  | |  | learn.
# `-------'`------'`--' `--'

title = "Adding vSphere Clusters in VMware Cloud Foundation: A Detailed Guide"
description = "Adding vSphere Clusters in VMware Cloud Foundation: A Detailed Guide"
date = "2024-12-12"

[taxonomies]
tags = ["inbox", "vmware", "vcf", "vcf", "vcf", "vcf", "infrastructure", "vcf"]
+++

VMware Cloud Foundation (VCF) provides two methods for adding capacity to deployed workload domains:
- Adding hosts to existing clusters
- Adding new clusters to existing workload domains

This guide focuses on the process of adding a new cluster to an existing workload domain.

## Process Overview

### Initial Navigation
1. Access SDDC Manager dashboard
2. Navigate to Workload Domains
3. Select target domain
4. Click Actions > Add Cluster

### Configuration Steps

#### 1. Storage Configuration
- Select principal storage type (e.g., vSAN)
- Configure vSAN settings if applicable:
    - Set failures to tolerate
    - Enable/disable deduplication and compression
    - Option to mount remote vSAN datastore for compute-only clusters

#### 2. Cluster Settings
- Assign cluster name
- Select VLCM (vSphere Lifecycle Manager) desired state image
- Choose hosts from free pool (minimum 3 for vSAN)

#### 3. Network Configuration
Default switch configuration includes:
- Single switch with two NICs
- Separate port groups for:
    - Management traffic
    - vMotion traffic
    - vSAN traffic
- VLAN ID assignment for NSX overlay network

#### 4. Licensing
- Apply appropriate vSphere license keys
- Review configuration
- Initiate deployment

## Deployment Process

### Timeline
- Typical deployment: approximately 30 minutes
- Progress monitored through SDDC Manager workflow

### Automated Tasks
SDDC Manager performs numerous operations:
- Cluster creation
- Host configuration
- Storage setup
- Network configuration
- NSX fabric integration

## Verification Steps

### 1. SDDC Manager
- Verify new cluster appears in domain
- Check host assignments
- Review cluster status

### 2. vSphere Client
- Confirm cluster in vCenter inventory
- Verify host configuration
- Check storage and network settings

### 3. NSX Manager
- Navigate to System > Fabric > Host
- Verify cluster added to NSX fabric
- Check host preparation status

## Benefits

1. **Scalability**
    - Easy infrastructure expansion
    - Flexible capacity management
    - Response to application demands

2. **Automation**
    - Consistent deployment process
    - Reduced manual intervention
    - Integrated configuration

3. **Integration**
    - Automatic NSX fabric inclusion
    - Coordinated networking setup
    - Unified management

## Best Practices

1. **Planning**
    - Verify resource availability
    - Plan network configuration
    - Prepare host inventory

2. **Implementation**
    - Follow standard naming conventions
    - Document VLAN assignments
    - Verify prerequisites

3. **Post-Deployment**
    - Validate all components
    - Test connectivity
    - Update documentation

## Conclusion

Adding vSphere clusters through SDDC Manager provides a streamlined, automated approach to scaling your VCF infrastructure. The process ensures consistent deployment while maintaining integration with all necessary components, from storage to networking and security.

The ability to easily add capacity through new clusters helps organizations maintain agility in responding to changing workload demands while ensuring standardization across the infrastructure.
