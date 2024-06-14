locals {
  web_vm_custom_data = <<CUSTOM_DATA
    #!/bin/sh
    # Update and install packages
    sudo apt update -y
    sudo apt install -y

    # Add Tailscale's package signing key and repository
    curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.noarmor.gpg | sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null
    curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.tailscale-keyring.list | sudo tee /etc/apt/sources.list.d/tailscale.list

    # Update package index and install Tailscale
    sudo apt update -y
    sudo apt-get install -y tailscale

    # Authenticate Tailscale


    # Install and start Apache
    sudo apt install -y apache2
    sudo systemctl enable apache2
    sudo systemctl start apache2

    # Disable UFW
    sudo ufw disable

    # Set permissions for /var/www/html
    sudo chmod -R 777 /var/www/html

    # Create web pages
    echo "Welcome to Culak Azure Web - WebVM App1 - VM Hostname: $(hostname)" | sudo tee /var/www/html/index.html
    sudo mkdir -p /var/www/html/app1
    echo "Welcome to Culak Azure Web - WebVM App1 - VM Hostname: $(hostname)" | sudo tee /var/www/html/app1/hostname.html
    echo "Welcome to Culak Azure Web - WebVM App1 - App Status Page" | sudo tee /var/www/html/app1/status.html
    echo '<!DOCTYPE html> <html> <body style="background-color:rgb(250, 210, 210);"> <h1>Welcome to Stack Simplify - WebVM APP-1 </h1> <p>Terraform Demo</p> <p>Application Version: V1</p> </body></html>' | sudo tee /var/www/html/app1/index.html

    # Fetch and save instance metadata
    sudo curl -H "Metadata:true" --noproxy "*" "http://169.254.169.254/metadata/instance?api-version=2020-09-01" -o /var/www/html/app1/metadata.html
    CUSTOM_DATA
}


resource "azurerm_linux_virtual_machine" "web_linux_vm" {
  admin_username        = "azureuser"
  computer_name         = "VM - Web server"
  admin_password        = "1Password!"
  location              = azurerm_resource_group.rg.location
  name                  = "${local.resource_name_prefix}-web-linux-vm"
  network_interface_ids = [azurerm_network_interface.web_linux_vm_nic.id]
  resource_group_name   = azurerm_resource_group.rg.name
  size                  = "Standard_DS1_v2"
  admin_ssh_key {
    public_key = file("${path.module}/../ssh-keys/terraform-azure-web-linux-vm.pub")
    username   = "azureuser"
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    offer     = "ubuntu-24_04-lts"
    publisher = "Canonical"
    sku       = "server"
    version   = "latest"
  }
  custom_data = base64encode(local.web_vm_custom_data)
#   provisioner "remote-exec" {
#     depends_on = [azurerm_linux_virtual_machine.bastion_linux_vm, azurerm_linux_virtual_machine.web_linux_vm]
#     connection {
#       type = "ssh"
#       host = azurerm_linux_virtual_machine.bastion_linux_vm.public_ip_address
#       user = azurerm_linux_virtual_machine.bastion_linux_vm.admin_username
#       private_key = file("${path.module}/../ssh-keys/terraform-azure-bastion-linux-vm.pem")
#     }
#   }

}


# resource "tailscale_device_authorization" "web_vm_auth" {
#   authorized = false
#   device_id  = azurerm_linux_virtual_machine.web_linux_vm.id
#   depends_on = [azurerm_linux_virtual_machine.web_linux_vm]
# }
#
# resource "tailscale_device_key" "" {
#   device_id = ""
# }

resource "tailscale_tailnet_key" "web_vm_key" {
  reusable      = true
  ephemeral     = false
  preauthorized = true
  expiry        = 3600
  description   = "web vm access tailtnet key"
}