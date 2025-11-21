+++
#   (`-')           (`-').->
#   ( OO).->        (OO )__
# ,(_/----. .----. ,--. ,'-' doubt everything,
# |__,    |\_,-.  ||  | |  |
#  (_/   /    .' .'|  `-'  | be curious,
#  .'  .'_  .'  /_ |  .-.  |
# |       ||      ||  | |  | learn.
# `-------'`------'`--' `--'

title = "Installing VMware vCenter Server Appliance (vCSA): Stage 1 Deployment Guide"
description = "Installing VMware vCenter Server Appliance (vCSA): Stage 1 Deployment Guide"
date = "2024-12-12"

[taxonomies]
tags = ["inbox", "vmware", "vcenter", "vcf", "esxi", "virtualization", "deployment"]
+++

This guide walks through the first stage of deploying vCenter Server Appliance (vCSA) on an ESXi host. Like any critical infrastructure deployment, proper preparation and verification at each step is essential for success.

## Prerequisites Verification

Before beginning the installation:
1. Verify DNS resolution for target ESXi host:
   ```bash
   nslookup esxi-4.zerotohero.dev
   # Should resolve to 192.168.1.104
   ```

2. Verify DNS resolution for vCSA FQDN:
   ```bash
   nslookup vcsa.zerotohero.dev
   # Should resolve to 192.168.1.111
   ```

## Installation Process

### 1. Launch Installer
- Navigate to mounted vCSA ISO
- Go to `/vcsa-ui-installer/Win32/` directory
- Double-click installer executable

### 2. Initial Setup
1. Select "Install" from the main menu
2. Acknowledge two-stage installation process
3. Accept End User License Agreement (EULA)

### 3. Target Host Configuration
- ESXi Host: esxi-4.zerotohero.dev
- Username: root
- Password: (lab password)
- **Security Tip**: Verify host SSL thumbprint matches ESXi DCUI (F2 > View Support Information)

### 4. vCSA VM Configuration
- VM Name: vCSA
- Root Password: (set secure password)
- Deployment Size: Tiny (suitable for managing up to 10 hosts)
- Storage Size: Default

### 5. Storage Configuration
- Select datastore: esxi-4
- Enable thin disk mode for efficient storage utilization
- Note: vSAN configuration (if needed) comes later

### 6. Network Configuration
#### Network Selection
- Select "VM Network" port group
- Connects to vSwitch0 on management network
- Verify network connectivity via ESXi host client:
    - Navigate to Networking > Virtual Switches
    - Confirm vSwitch0 configuration with VM Network port group
    - Verify physical uplink (vmnic0) connectivity

#### Network Settings
- FQDN: vcsa.zerotohero.dev
- IP Address: 192.168.1.111
- Subnet Mask: 255.255.255.0
- Gateway: 192.168.1.1
- DNS Server: 192.168.1.100
- Default Ports:
    - HTTP: 80
    - HTTPS: 443

## Important Notes

### DNS Configuration
- Proper DNS setup is critical for vCSA deployment
- Both forward and reverse DNS resolution must work correctly
- DNS issues are a common source of deployment problems

### Network Connectivity
- vCSA requires reliable network connectivity
- Management network access is essential
- Verify all network settings before proceeding

### Time Synchronization
- Accurate time settings are crucial
- NTP configuration follows in Stage 2

## Next Steps

After Stage 1 completes (approximately 3-8 minutes):
1. Verify VM deployment on ESXi host
2. Proceed to Stage 2 configuration
3. Configure SSO domain
4. Set up initial vSphere environment

Remember: This is just Stage 1 of the deployment. Stage 2 will handle the configuration of the appliance, including SSO setup, time synchronization, and initial vSphere environment configuration.
