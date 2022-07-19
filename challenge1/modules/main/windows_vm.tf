#Creating frontend VM for hoting website

resource "azurerm_network_interface" "frontend-nic" {
  name                = "frontend-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.frontend_subnet
    private_ip_address_allocation = "Dynamic"
  }
}
resource "azurerm_windows_virtual_machine" "frontend" {
  name                = var.frontend_vm_name
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.frontend_vm_size
  admin_username      = var.admin_username
  admin_password      = var.windows_password 
  network_interface_ids = [
    azurerm_network_interface.frontend-nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = "128"
  }

  source_image_reference {
    publisher = var.vm_publisher
    offer     = var.vm_offer
  }
  depends_on = [
    azurerm_network_interface.frontend-nic
  ]
}

#Creating midtier VM for running different jobs

resource "azurerm_network_interface" "midtier-nic" {
  name                = "midtier-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.midtier_subnet
    private_ip_address_allocation = "Dynamic"
  }
}
resource "azurerm_windows_virtual_machine" "midtier" {
  name                = var.midtier_vm_name
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.midtier_vm_size
  admin_username      = var.admin_username
  admin_password      = var.windows_password 
  network_interface_ids = [
    azurerm_network_interface.midtier-nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = "128"
  }

  source_image_reference {
    publisher = var.vm_publisher
    offer     = var.vm_offer
  }
  depends_on = [
    azurerm_network_interface.midtier-nic
  ]
}
