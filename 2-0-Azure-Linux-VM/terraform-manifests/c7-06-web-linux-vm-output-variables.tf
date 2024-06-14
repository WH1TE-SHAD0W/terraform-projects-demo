output "web_linux_vm_public_ip" {
  value = azurerm_public_ip.web_linux_vm_public_ip.ip_address
  description = "Web Linux VM Public Address"
}

output "web_linux_vm_nic_id" {
  value = azurerm_network_interface.web_linux_vm_nic.id
  description = "Web Linux VM NIC ID"
}

output "web_linux_vm_nic_private_ips" {
  value = [azurerm_network_interface.web_linux_vm_nic.private_ip_addresses]
  description = "Web Linux VM NIC IP addresses"
}

output "web_linux_vm_public_ip_address" {
  value = azurerm_linux_virtual_machine.web_linux_vm.public_ip_address
  description = "Web Linux Virtual Machine Public IP"
}

output "web_linux_vm_private_ip_address" {
  value = azurerm_linux_virtual_machine.web_linux_vm.private_ip_address
  description = "Web Linux Virtual Machine Private IP"
}

output "web_linux_vm_id" {
  value = azurerm_linux_virtual_machine.web_linux_vm.id
  description = "Web Linux Virtual Machine ID"
}

output "web_linux_vm_128bit_id" {
  value = azurerm_linux_virtual_machine.web_linux_vm.virtual_machine_id
  description = "Web Linux Virtual Machine ID - 128-bit identifier"
}