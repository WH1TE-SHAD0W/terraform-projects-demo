output "virtual_network_name" {
  value = azurerm_virtual_network.vnet.name
  description = "Virtual network name"
}

output "virtual_network_id" {
  value = azurerm_virtual_network.vnet.id
  description = "Virtual network id"
}

output "web_subnet_name" {
  value = azurerm_subnet.web_subnet.name
  description = "Web subnet name"
}

output "web_subnet_id" {
  value = azurerm_subnet.web_subnet.id
  description = "Web subnet id"
}

output "web_subnet_nsg_name" {
  value = azurerm_network_security_group.web_subnet_nsg.name
  description = "Web subnet nsg name"
}

output "web_subnet_nsg_id" {
  value = azurerm_network_security_group.web_subnet_nsg.id
  description = "Web subnet nsg id"
}