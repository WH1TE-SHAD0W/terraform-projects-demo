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
  }
}
provider "azurerm" {
  features {}
  subscription_id = "e3a4e24b-7728-49f4-8127-d5c7a2def103"
}