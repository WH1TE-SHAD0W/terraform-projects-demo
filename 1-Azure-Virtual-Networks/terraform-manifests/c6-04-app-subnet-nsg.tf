resource "azurerm_subnet" "app_subnet" {
  address_prefixes     = var.app_subnet_address
  name                 = "${azurerm_virtual_network.vnet.name}-${var.app_subnet_name}"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
}

resource "azurerm_network_security_group" "app_subnet_nsg" {
  location            = azurerm_resource_group.rg.location
  name                = "${azurerm_subnet.app_subnet.name}-nsg"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet_network_security_group_association" "app_subnet_nsg_association" {
  network_security_group_id = azurerm_network_security_group.app_subnet_nsg.id
  subnet_id                 = azurerm_subnet.app_subnet.id
  depends_on = [azurerm_network_security_rule.app_nsg_inbound_rule]
}

locals {
  app_inbound_ports = {
    "100" : "80", # If the key starts with a number, you must use the colon syntax ":" instead of "="
    "110" : "443",
    "120" : "8080",
    "130" : "22"
  }
}

resource "azurerm_network_security_rule" "app_nsg_inbound_rule" {
    for_each = local.app_inbound_ports
    name                        = "Rule-Port-${each.value}"
    priority                    = each.key
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = each.value
    source_address_prefix       = "*"
    destination_address_prefix  = "*"
    resource_group_name         = azurerm_resource_group.rg.name
    network_security_group_name = azurerm_network_security_group.app_subnet_nsg.name
}