terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 3.0"
    }
    random = {
      source = "hashicorp/random"
      version = ">= 3.6"
    }
    tailscale = {
      source = "tailscale/tailscale"
      version = "0.16.1"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "e3a4e24b-7728-49f4-8127-d5c7a2def103"
}

provider "tailscale" {
  api_key = "tskey-api-kVVnnBZc6h11CNTRL-x5BGkSMq9uY9L7TLNiybtY5cVYu6ewRnF"
#   tailnet = "tail6fe03.ts.net"
}
