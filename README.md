# My NixOS Homelab

This repository contains the NixOS configurations for my homelab, encompassing my workstation, server, and VPS.  It serves as a central point for managing and documenting my infrastructure as code.

## Overview

My homelab is built using NixOS, a declarative Linux distribution that allows for reproducible and easily manageable system configurations.  This setup enables me to:

* **Infrastructure as code:**  Enables automation, improves reliability, and quick redeployment if needed.
* **Easily manage updates and rollbacks:**  NixOS's atomic updates and rollbacks simplify system maintenance and allow for easy recovery from failed updates.
* **Version control infrastructure:**  Storing my configurations in Git provides version history and facilitates collaboration (if applicable).

## Components

This repository manages the configuration for the following components:

* **Workstation:** My primary desktop computer.  Located at home.
* **Server:** My dedicated server for hosting ZFS file service and other various services, also located at home.
* **VPS:** A virtual private server hosted with DigitalOcean.

## Directory Structure

```
nixos/
├── workstation/  # Configuration for the workstation
│   ├── hardware-configuration.nix # Hardware specific config
│   └── configuration.nix       # Main system config
│   └── config                  # Additional system and user config
├── server/       # Configuration for the home server
│   ├── hardware-configuration.nix # Hardware specific config
│   └── configuration.nix       # Main system config
│   └── config                  # Additional system and user config
└── vps/          # Configuration for the DigitalOcean VPS
│   ├── hardware-configuration.nix # Hardware specific config
│   └── configuration.nix       # Main system config
│   └── config                  # Additional system and user config
README.md        # This file
```
