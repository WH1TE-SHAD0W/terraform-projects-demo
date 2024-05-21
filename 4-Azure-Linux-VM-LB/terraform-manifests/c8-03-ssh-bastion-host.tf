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