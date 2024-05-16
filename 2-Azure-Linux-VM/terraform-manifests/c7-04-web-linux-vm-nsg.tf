resource "azurerm_network_security_group" "web-vm-nic-nsg" {
  location            = azurerm_resource_group.rg.location
  name                = "${azurerm_network_interface.web_linux_vm_nic.name}-nsg"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_network_interface_security_group_association" "web_vm_nic_nsg_association" {
  network_security_group_id = azurerm_network_security_group.web-vm-nic-nsg.id
  network_interface_id      = azurerm_network_interface.web_linux_vm_nic.id
  depends_on = [azurerm_network_security_rule.web_nsg_inbound_rule]
}


locals {
  web_vm_nic_inbound_ports = {
    "100" : "80", # If the key starts with a number, you must use the colon syntax ":" instead of "="
    "110" : "443",
    "120" : "22"
  }
}

resource "azurerm_network_security_rule" "web-vm-nic-nsg-inbound-rule" {
    for_each = local.web_vm_nic_inbound_ports
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
