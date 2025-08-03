# Networking Module - Zero Trust MVP

This module provisions the foundational networking components for a Zero Trust architecture, including:

- Virtual Network (VNet)
- Three Subnets (Public, Private App, Private Data)
- Network Security Groups (NSGs)
- Application Security Groups (ASGs)

## Features

- Implements 3-tier segmented network topology
- Enables NSG-based traffic filtering and ASG-based microsegmentation
- Aligns with Zero Trust principles

## Usage

```hcl
module "networking" {
  source              = "./modules/networking"
  project_name        = "zero-trust-mvp"
  environment         = "mvp"
  location            = "East US"
  location_short      = "eastus"
  vnet_address_space  = ["10.0.0.0/16"]
  resource_group_name = "zero-trust-mvp-mvp-rg"

  common_tags = {
    Project     = "Zero-Trust-MVP"
    Environment = "mvp"
    Owner       = "DevSecOps-Team"
    CreatedBy   = "Terraform"
  }
}
