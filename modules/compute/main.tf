resource "azurerm_network_interface" "nic" {
  count               = length(var.vm_names)
  name                = "${var.vm_names[count.index]}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_ids[count.index]  # Use the correct subnet_id for each VM
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  count                  = length(var.vm_names)
  name                   = var.vm_names[count.index]
  resource_group_name    = var.resource_group_name
  location               = var.location
  size                   = var.vm_size
  admin_username         = var.admin_username
  admin_password         = var.admin_password
  network_interface_ids  = [azurerm_network_interface.nic[count.index].id]
  disable_password_authentication = false

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = 30
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  identity {
    type = var.enable_managed_identity[count.index] ? "SystemAssigned" : "UserAssigned"
  }

  tags = var.tags
}


