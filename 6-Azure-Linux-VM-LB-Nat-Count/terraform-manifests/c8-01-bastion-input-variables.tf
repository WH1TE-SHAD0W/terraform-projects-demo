variable "bastion_service_subnet_name" {
  description = "Bastion Service Subnet Name"
  default = "AzureBastionSubnet"
}

variable "bastion_service_subnet_address_prefixes" {
  description = "Bastion Service Subnet Address Prefixes"
  default = ["10.0.101.0/27"]
}

