locals {
  web_vm_custom_data = <<CUSTOM_DATA
  #!/bin/sh
  #sudo yum update -y
  sudo yum install -y httpd
  sudo systemctl enable httpd
  sudo systemctl start httpd
  sudo systemctl stop firewalld
  sudo systemctl disable firewalld
  sudo chmod -R 777 /var/www/html
  sudo echo "Welcome to stacksimplify - WebVM App1 - VM Hostname: $(hostname)" > /var/www/html/index.html
  sudo mkdir /var/www/html/app1
  sudo echo "Welcome to stacksimplify - WebVM App1 - VM Hostname: $(hostname)" > /var/www/html/app1/hostname.html
  sudo echo "Welcome to stacksimplify - WebVM App1 - App Status Page" > /var/www/html/app1/status.html
  sudo echo '<!DOCTYPE html> <html> <body style="background-color:rgb(250, 210, 210);"> <h1>Welcome to Stack Simplify - WebVM APP-1 </h1> <p>Terraform Demo</p> <p>Application Version: V1</p> </body></html>' | sudo tee /var/www/html/app1/index.html
  sudo curl -H "Metadata:true" --noproxy "*" "http://169.254.169.254/metadata/instance?api-version=2020-09-01" -o /var/www/html/app1/metadata.html
  CUSTOM_DATA
}

resource "azurerm_linux_virtual_machine" "web_linux_vm" {
  admin_username        = "azure-user"
  location              = azurerm_resource_group.rg.location
  name                  = "${local.resource_name_prefix}-web-linux-vm"
  network_interface_ids = [azurerm_network_interface.web_linux_vm_nic.id]
  resource_group_name   = azurerm_resource_group.rg.name
  size                  = "Standard_DS1_v2"
  admin_ssh_key {
    public_key = file("${path.module}/../ssh-keys/terraform-azure-linux-vm.pub")
    username   = "azure-user"
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    offer     = "RHEL"
    publisher = "RedHat"
    sku       = "83-gen2"
    version   = "latest"
  }
  custom_data = base64encode(local.web_vm_custom_data)
}