resource "azurerm_lb_nat_rule" "web_lb_inbound_nat_rule" {
  count                          = var.web_linux_vm_count
  backend_port                   = 22
  frontend_ip_configuration_name = azurerm_lb.web-lb.frontend_ip_configuration[0].name
  loadbalancer_id                = azurerm_lb.web-lb.id
  name                           = "ssh-${element(local.ports, count.index)}-vm-22"
  protocol                       = "Tcp"
  resource_group_name            = azurerm_resource_group.rg.name
  frontend_port                  = element(local.ports, count.index)
  depends_on                     = [azurerm_linux_virtual_machine.web_linux_vm]
}

resource "azurerm_network_interface_nat_rule_association" "web_lb_nat_nic_associate" {
  count                 = var.web_linux_vm_count
  ip_configuration_name = element(azurerm_network_interface.web_linux_vm_nic[*].ip_configuration[0].name, count.index)
  nat_rule_id           = element(azurerm_lb_nat_rule.web_lb_inbound_nat_rule[*].id, count.index)
  network_interface_id  = element(azurerm_network_interface.web_linux_vm_nic[*].id, count.index)
}