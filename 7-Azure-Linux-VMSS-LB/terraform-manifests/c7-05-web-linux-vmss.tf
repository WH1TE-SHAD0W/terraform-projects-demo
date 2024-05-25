locals {
  web_vm_custom_data = <<CUSTOM_DATA
  #!/bin/sh
  sudo apt update -y
  sudo apt install -y apache2
  sudo systemctl enable apache2
  sudo systemctl start apache2
  sudo ufw disable
  sudo chmod -R 777 /var/www/html
  echo "Welcome to stacksimplify - WebVM App1 - VM Hostname: $(hostname)" | sudo tee /var/www/html/index.html
  sudo mkdir /var/www/html/app1
  echo "Welcome to stacksimplify - WebVM App1 - VM Hostname: $(hostname)" | sudo tee /var/www/html/app1/hostname.html
  echo "Welcome to stacksimplify - WebVM App1 - App Status Page" | sudo tee /var/www/html/app1/status.html
  echo '<!DOCTYPE html> <html> <body style="background-color:rgb(250, 210, 210);"> <h1>Welcome to Stack Simplify - WebVM APP-1 </h1> <p>Terraform Demo</p> <p>Application Version: V1</p> </body></html>' | sudo tee /var/www/html/app1/index.html
  sudo curl -H "Metadata:true" --noproxy "*" "http://169.254.169.254/metadata/instance?api-version=2020-09-01" -o /var/www/html/app1/metadata.html
  CUSTOM_DATA

  ports = [for i in range(var.web_linux_vm_count) : "${i}022"]
}

resource "azurerm_linux_virtual_machine" "web_linux_vm" {
  count                 = var.web_linux_vm_count
  admin_username        = "azureuser"
  location              = azurerm_resource_group.rg.location
  name                  = "${local.resource_name_prefix}-web-linux-vm-${count.index}"
  network_interface_ids = [element(azurerm_network_interface.web_linux_vm_nic[*].id, count.index)]
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
}