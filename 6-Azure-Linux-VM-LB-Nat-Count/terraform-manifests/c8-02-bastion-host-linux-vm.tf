resource "azurerm_public_ip" "bastion_host_public_ip" {
  allocation_method   = "Static"
  location            = azurerm_resource_group.rg.location
  name                = "${local.resource_name_prefix}-bastion-linux-vm-public-ip"
  resource_group_name = azurerm_resource_group.rg.name
  sku = "Standard"
  domain_name_label = "bastion-vm-${random_string.random_str.id}"
}

resource "azurerm_network_interface" "bastion_linux_vm_nic" {
  location            = azurerm_resource_group.rg.location
  name                = "${local.resource_name_prefix}-bastion-host-vm-nic"
  resource_group_name = azurerm_resource_group.rg.name
  ip_configuration {
    name                          = "bastion-linux-vm-ip-1"
    private_ip_address_allocation = "Dynamic"
    subnet_id = azurerm_subnet.bastion_subnet.id
    public_ip_address_id = azurerm_public_ip.bastion_host_public_ip.id
  }
}

resource "azurerm_linux_virtual_machine" "bastion_linux_vm" {
  admin_username        = "azureuser"
  location              = azurerm_resource_group.rg.location
  name                  = "${local.resource_name_prefix}-bastion-host-vm"
  network_interface_ids = [azurerm_network_interface.bastion_linux_vm_nic.id]
  resource_group_name   = azurerm_resource_group.rg.name
  size                  = "Standard_DS1_v2"
  admin_ssh_key {
    public_key = file("${path.module}/../ssh-keys/terraform-azure-bastion-linux-vm.pub")
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
}

