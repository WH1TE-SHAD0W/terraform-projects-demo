output "bastion_host_vm_public_ip_address" {
  description = "Bastion Host VM IP address"
  value = azurerm_public_ip.bastion_host_public_ip.ip_address
}