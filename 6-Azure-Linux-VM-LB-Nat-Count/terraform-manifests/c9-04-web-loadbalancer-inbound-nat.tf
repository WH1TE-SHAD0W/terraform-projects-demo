resource "azurerm_lb_nat_rule" "web_lb_inbound_nat_rule" {
  backend_port                   = 22
  frontend_ip_configuration_name = azurerm_lb.web-lb.frontend_ip_configuration[0].name
  loadbalancer_id                = azurerm_lb.web-lb.id
  name                           = "ssh-1022-vm-22"
  protocol                       = "Tcp"
  resource_group_name            = azurerm_resource_group.rg.name
  frontend_port                  = 1022
}

resource "azurerm_network_interface_nat_rule_association" "web_lb_nat_nic_associate" {
  ip_configuration_name = azurerm_network_interface.web_linux_vm_nic.ip_configuration[0].name
  nat_rule_id           = azurerm_lb_nat_rule.web_lb_inbound_nat_rule.id
  network_interface_id  = azurerm_network_interface.web_linux_vm_nic.id
}