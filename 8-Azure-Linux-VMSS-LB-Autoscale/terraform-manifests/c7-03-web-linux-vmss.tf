locals {
  web_vm_custom_data =
  <<CUSTOM_DATA
  #!/bin/sh
  sudo apt update -y
  sudo apt install -y apache2
  sudo systemctl enable apache2
  sudo systemctl start apache2
  sudo ufw disable
  sudo chmod -R 777 /var/www/html
  echo "Welcome to Marek Culak website - WebVM App1 - VM Hostname: $(hostname)" | sudo tee /var/www/html/index.html
  sudo mkdir /var/www/html/app1
  echo "Welcome to Marek Culak website - WebVM App1 - VM Hostname: $(hostname)" | sudo tee /var/www/html/app1/hostname.html
  echo "Welcome to Marek Culak website - WebVM App1 - App Status Page" | sudo tee /var/www/html/app1/status.html
  echo '<!DOCTYPE html> <html> <body style="background-color:rgb(250, 210, 210);"> <h1>Welcome to Marek Culak website - WebVM APP-1 </h1> <p>Terraform Demo</p> <p>Application Version: V1</p> </body></html>' | sudo tee /var/www/html/app1/index.html
  sudo curl -H "Metadata:true" --noproxy "*" "http://http://marek-culak-lb-vmss.westeurope.cloudapp.azure.com/metadata/instance?api-version=2020-09-01" -o /var/www/html/app1/metadata.html
  CUSTOM_DATA
}

resource "azurerm_linux_virtual_machine_scale_set" "web_vmss" {
  admin_username       = "azureuser"
  location             = azurerm_resource_group.rg.location
  name                 = "${local.resource_name_prefix}-web-vmss"
  resource_group_name  = azurerm_resource_group.rg.name
  sku                  = "Standard_DS1_v2"
  computer_name_prefix = "vmss-app"
  instances = 2
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
  network_interface {
    name = "web-vmss-nic"
    primary = "true"
    network_security_group_id = azurerm_network_security_group.web_vmss_nsg.id
    ip_configuration {
      name = "internal"
      primary = true
      subnet_id = azurerm_subnet.web_subnet.id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.web-lb-bepool.id]
    }
  }
  upgrade_mode = "Automatic"
  custom_data = base64encode(local.web_vm_custom_data)
}