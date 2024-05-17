business_division = "hr"
environment = "dev"
resource_group_name = "rg"
resource_group_location = "westeurope"

vnet_name = "vnet"
vnet_address_space = ["10.1.0.0/16"]

web_subnet_name = "web-subnet"
web_subnet_address = ["10.1.1.0/24"]

app_subnet_name = "app-subnet"
app_subnet_address = ["10.1.2.0/24"]

db_subnet_name = "db-subnet"
db_subnet_address = ["10.1.3.0/24"]

bastion_subnet_name = "bastion-subnet"
bastion_subnet_address = ["10.1.100.0/24"]

bastion_service_subnet_name = "AzureBastionSubnet"
bastion_service_subnet_address_prefixes = ["10.1.101.0/27"]
