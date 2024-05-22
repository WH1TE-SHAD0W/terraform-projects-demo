resource "azurerm_network_interface" "web_linux_vm_nic" {
  count               = var.web_linux_vm_count
  location            = azurerm_resource_group.rg.location
  name                = "${local.resource_name_prefix}-web-linux-vm-nic-${count.index}"
  resource_group_name = azurerm_resource_group.rg.name
  ip_configuration {
    name                          = "web-linux-vm-ip-${count.index}"
    private_ip_address_allocation = "Dynamic"
    subnet_id = azurerm_subnet.web_subnet.id
  }
}