resource "azurerm_network_security_group" "web_vmss_nsg" {
  location            = azurerm_resource_group.rg.location
  name                = "${local.resource_name_prefix}-web-vmss-nsg"
  resource_group_name = azurerm_resource_group.rg.name

  dynamic "security_rule" {
    for_each = var.web_vmss_inbound_ports
    content {
      name                       = "inbound-rule-${security_rule.key}"
      priority                   = security_rule.key
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = security_rule.value
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  }
}

