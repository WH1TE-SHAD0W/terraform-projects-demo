resource "azurerm_public_ip" "web-lb-public-ip" {
  allocation_method   = "Static"
  location            = azurerm_resource_group.rg.location
  name                = "${local.resource_name_prefix}-web-lb-public-ip"
  resource_group_name = azurerm_resource_group.rg.name
  sku = "Standard"
}

resource "azurerm_lb" "web-lb" {
  location            = azurerm_resource_group.rg.location
  name                = "${local.resource_name_prefix}-web-lb"
  resource_group_name = azurerm_resource_group.rg.name
  sku = "Standard"
  frontend_ip_configuration {
    name = "web_lb_fip"
    public_ip_address_id = azurerm_public_ip.web-lb-public-ip.id
  }
}

resource "azurerm_lb_backend_address_pool" "web-lb-bepool" {
  loadbalancer_id = azurerm_lb.web-lb.id
  name            = "${local.resource_name_prefix}-web-bepool"
}

resource "azurerm_lb_probe" "wen-lb-probe-80" {
  loadbalancer_id = azurerm_lb.web-lb.id
  name            = "${local.resource_name_prefix}-web-lb-probe-80"
  port            = 80
}

resource "azurerm_lb_rule" "web-lb-rule" {
  backend_port                   = 80
  frontend_ip_configuration_name = azurerm_lb.web-lb.frontend_ip_configuration.name
  frontend_port                  = 80
  loadbalancer_id                = azurerm_lb.web-lb.id
  name                           = "${local.resource_name_prefix}-web-lb-rule"
  protocol                       = "TCP"
  probe_id = azurerm_lb_probe.wen-lb-probe-80.id
}

resource "azurerm_network_interface_backend_address_pool_association" "web-nic-lb-associate" {
  backend_address_pool_id = azurerm_lb_backend_address_pool.web-lb-bepool.id
  ip_configuration_name   = azurerm_network_interface.web_linux_vm_nic.ip_configuration.name
  network_interface_id    = azurerm_network_interface.web_linux_vm_nic.id
}

