resource "azurerm_public_ip" "web_linux_vm_public_ip" {
  allocation_method   = "Static"
  location            = azurerm_resource_group.rg.location
  name                = "${local.resource_name_prefix}-web-linux-vm-public-ip"
  resource_group_name = azurerm_resource_group.rg.name
  sku = "Standard"
  domain_name_label = "app1-vm-${random_string.random_str.id}"
}