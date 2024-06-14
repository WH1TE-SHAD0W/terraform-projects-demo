resource "azurerm_network_interface" "web_linux_vm_nic" {
  location            = azurerm_resource_group.rg.location
  name                = "${local.resource_name_prefix}-web-linux-vm-nic"
  resource_group_name = azurerm_resource_group.rg.name
  ip_configuration {
    name                          = "web-linux-vm-ip-1"
    private_ip_address_allocation = "Dynamic"
    subnet_id = azurerm_subnet.web_subnet.id
    #public_ip_address_id = azurerm_public_ip.web_linux_vm_public_ip.id
  }
}