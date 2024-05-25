resource "azurerm_subnet" "bastion_subnet" {
  address_prefixes     = var.bastion_subnet_address
  name                 = "${azurerm_virtual_network.vnet.name}-${var.bastion_subnet_name}"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
}

resource "azurerm_network_security_group" "bastion_subnet_nsg" {
  location            = azurerm_resource_group.rg.location
  name                = "${azurerm_subnet.bastion_subnet.name}-nsg"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet_network_security_group_association" "bastion_subnet_nsg_association" {
  network_security_group_id = azurerm_network_security_group.bastion_subnet_nsg.id
  subnet_id                 = azurerm_subnet.bastion_subnet.id
  depends_on = [azurerm_network_security_rule.bastion_nsg_inbound_rule]
}

resource "azurerm_network_security_rule" "bastion_nsg_inbound_rule" {
  for_each = var.bastion_inbound_ports
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
    network_security_group_name = azurerm_network_security_group.bastion_subnet_nsg.name
}