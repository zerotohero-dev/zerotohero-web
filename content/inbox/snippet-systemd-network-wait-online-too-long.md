+++
#   (`-')           (`-').->
#   ( OO).->        (OO )__
# ,(_/----. .----. ,--. ,'-' doubt everything,
# |__,    |\_,-.  ||  | |  |
#  (_/   /    .' .'|  `-'  | be curious,
#  .'  .'_  .'  /_ |  .-.  |
# |       ||      ||  | |  | learn.
# `-------'`------'`--' `--'

title = "Snippet/Draft: systemd-networkd-wait-online.service Waits Too Long During Ubuntu Startup"
description = "Snippet/Draft: systemd-networkd-wait-online.service Waits Too Long During Ubuntu Startup"
date = "2025-07-13"

[taxonomies]
tags = ["snippets", "drafts", "inbox", "ubuntu", "systemd"]
+++

Quick fix: Disable the service (if you don't need to wait for network at boot):

```bash
sudo systemctl disable systemd-networkd-wait-online.service
```

Better fixes:

Configure it to wait only for specific interfaces:

Edit the service:

```bash
sudo systemctl edit systemd-networkd-wait-online.service
```

Add:

```txt
ini[Service]
ExecStart=
ExecStart=/lib/systemd/systemd-networkd-wait-online --interface=eth0
```

Reduce the timeout:

```ini
[Service]
ExecStart=
ExecStart=/lib/systemd/systemd-networkd-wait-online --timeout=10
```

Check which interfaces are causing delays:

```bash
hnetworkctl status
```

Look for interfaces that are "configuring" or "pending".

If you're using NetworkManager instead of `systemd-networkd`, you can disable 
this service and enable the NetworkManager equivalent:

```bash
sudo systemctl disable systemd-networkd-wait-online.service
sudo systemctl enable NetworkManager-wait-online.service
```

The most common cause is having network interfaces defined in `/etc/netplan/` or 
`/etc/network/interfaces` that aren't actually connected, causing the service 
to wait for them unnecessarily.
