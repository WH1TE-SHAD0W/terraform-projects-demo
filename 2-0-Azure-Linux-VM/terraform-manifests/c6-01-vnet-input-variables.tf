variable "vnet_name" {
  description = "Virtual network name"
  type = string
}

variable "vnet_address_space" {
  description = "Virtual network address space"
  type = list(string)
  default = [ "10.0.0.0/16" ]
}

variable "web_subnet_name" {
  description = "Virtual network web subnet name"
  type = string
  default = "web-subnet"
}

variable "web_subnet_address" {
  description = "Virtual network web subnet address space"
  type = list(string)
  default = [ "10.0.1.0/16" ]
}

variable "app_subnet_name" {
  description = "Virtual network app subnet name"
  type = string
  default = "app-subnet"
}

variable "app_subnet_address" {
  description = "Virtual network app subnet address spaces"
  type = list(string)
  default = ["10.0.11.0/24"]
}

variable "db_subnet_name" {
  description = "Virtual network Database subnet name"
  type = string
  default = "db-subnet"
}

variable "db_subnet_address" {
  description = "Virtual network Database subnet addresses"
  type = list(string)
  default = ["10.0.21.0/24"]
}

variable "bastion_subnet_name" {
  description = "Virtual network bastion subnet name"
  type = string
  default = "bastion-subnet"
}

variable "bastion_subnet_address" {
  description = "Virtual network bastion subnet address spaces"
  type = list(string)
  default = ["10.0.100.0/24"]
}
