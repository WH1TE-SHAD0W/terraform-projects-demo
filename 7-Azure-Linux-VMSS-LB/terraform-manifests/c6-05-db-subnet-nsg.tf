resource "azurerm_subnet" "db-subnet" {
  address_prefixes     = var.db_subnet_address
  name                 = "${azurerm_virtual_network.vnet.name}-${var.db_subnet_name}"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
}

resource "azurerm_network_security_group" "db_subnet_nsg" {
  location            = azurerm_resource_group.rg.location
  name                = "${azurerm_subnet.db-subnet.name}-nsg"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet_network_security_group_association" "db_subnet_nsg_association" {
  network_security_group_id = azurerm_network_security_group.db_subnet_nsg.id
  subnet_id                 = azurerm_subnet.db-subnet.id
}

resource "azurerm_network_security_rule" "db_nsg_inbound_rule" {
    for_each = var.db_inbound_ports
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
    network_security_group_name = azurerm_network_security_group.db_subnet_nsg.name
}