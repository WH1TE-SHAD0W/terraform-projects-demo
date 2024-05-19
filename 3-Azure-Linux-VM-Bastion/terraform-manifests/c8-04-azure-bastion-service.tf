resource "azurerm_subnet" "bastion_service_subnet" {
  address_prefixes     = var.bastion_service_subnet_address_prefixes
  name                 = var.bastion_service_subnet_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
}

resource "azurerm_public_ip" "bastion_service_public_ip" {
  allocation_method   = "Static"
  location            = azurerm_resource_group.rg.location
  name                = "${local.resource_name_prefix}-bastion-service-public-ip"
  resource_group_name = azurerm_resource_group.rg.name
  domain_name_label = "bastion-service-${random_string.random_str.id}"
  sku = "Standard"
}

resource "azurerm_bastion_host" "bastion_host" {
  location            = azurerm_resource_group.rg.location
  name                = "${local.resource_name_prefix}-bastion-service"
  resource_group_name = azurerm_resource_group.rg.name
  ip_configuration {
    name                 = "configuration"
    public_ip_address_id = azurerm_public_ip.bastion_service_public_ip.id
    subnet_id            = azurerm_subnet.bastion_service_subnet.id
  }
}