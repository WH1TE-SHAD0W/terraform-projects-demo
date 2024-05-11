variable "business_division" {
  description = "Business Division in large organisation this infrastructure belongs to"
  type = string
  default = "sap"
}

variable "environment" {
  description = "Environment variable used as a prefix"
  default = "dev"
}

variable "resource_group_name" {
  description = "Resource Group Name"
  default = "rg-default"
}

variable "resource_group_location" {
  description = "Region in which resource groups are to be created"
  default = "westeu1"
}