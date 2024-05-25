business_division = "hr"
environment = "dev"
resource_group_name = "rg"
resource_group_location = "westeurope"

vnet_name = "vnet"
vnet_address_space = ["10.1.0.0/16"]

web_subnet_name = "web-subnet"
web_inbound_ports = {
    "100" : "80",
    "110" : "443",
    "130" : "22",
  }
web_subnet_address = ["10.1.1.0/24"]

app_subnet_name = "app-subnet"
app_inbound_ports = {
    "100" : "80",
    "110" : "443",
    "130" : "22",
    "140" : "8080",
  }
app_subnet_address = ["10.1.2.0/24"]

db_subnet_name = "db-subnet"
db_inbound_ports = {
    "100" : "3306",
    "110" : "1433",
    "120" : "5432",
  }
db_subnet_address = ["10.1.3.0/24"]

bastion_subnet_name = "bastion-subnet"
bastion_inbound_ports = {
    "100" : "22",
    "110" : "3389"
  }
bastion_subnet_address = ["10.1.100.0/24"]

web_linux_vm_count = 4