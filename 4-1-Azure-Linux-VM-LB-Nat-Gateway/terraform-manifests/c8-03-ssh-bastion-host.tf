resource "null_resource" "null_ssh_key_bastion_host" {
  depends_on = [azurerm_linux_virtual_machine.bastion_linux_vm]
  connection {
    type = "ssh"
    host = azurerm_linux_virtual_machine.bastion_linux_vm.public_ip_address
    user = azurerm_linux_virtual_machine.bastion_linux_vm.admin_username
    private_key = file("${path.module}/../ssh-keys/terraform-azure-bastion-linux-vm.pem")
  }
  provisioner "file" {
    source = "${path.module}/../ssh-keys/terraform-azure-web-linux-vm.pem"
    destination = "/tmp/terraform-azure-web-linux-vm.pem"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo chmod 400 /tmp/terraform-azure-web-linux-vm.pem"
    ]
  }
}

# resource "null_resource" "null_web_server" {
#   depends_on = [azurerm_linux_virtual_machine.bastion_linux_vm, azurerm_linux_virtual_machine.web_linux_vm]
#   connection {
#     type = "ssh"
#     host = azurerm_linux_virtual_machine.bastion_linux_vm.public_ip_address
#     user = azurerm_linux_virtual_machine.bastion_linux_vm.admin_username
#     private_key = file("${path.module}/../ssh-keys/terraform-azure-bastion-linux-vm.pem")
#   }
#   provisioner "remote-exec" {
#     inline = [
#       local.web_vm_custom_data
#     ]
#   }
# }
#
# resource "null_resource" "null_web_server" {
#   depends_on = [azurerm_linux_virtual_machine.web_linux_vm]
#   provisioner "remote-exec" {
#     inline = [
#       "sudo apt update -y",
#       "sudo apt install -y nginx",
#       "sudo systemctl start nginx",
#       "sudo systemctl enable nginx",
#       "sudo tailscale up --authkey ${tailscale_tailnet_key.web_vm_key.key}",
#     ]
#
#     connection {
#       type                = "ssh"
#       user                = "azureuser"
#       private_key         = file("${path.module}/../ssh-keys/terraform-azure-web-linux-vm.pem")
#       host                = azurerm_linux_virtual_machine.web_linux_vm.private_ip_address
#       bastion_host        = azurerm_public_ip.bastion_host_public_ip.ip_address
#       bastion_user        = "azureuser"
#       bastion_private_key = file("${path.module}/../ssh-keys/terraform-azure-bastion-linux-vm.pem")
#     }
#   }
# }