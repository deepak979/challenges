#Creating backend VM for hosting Database

resource "azurerm_network_interface" "backend-nic" {
  name                = "backend-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.backend_subnet
    private_ip_address_allocation = "Dynamic"
  }
}
resource "azurerm_windows_virtual_machine" "backend" {
  name                = var.backend_vm_name
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.backend_vm_size
  admin_username      = var.admin_username
  admin_password      = var.windows_password 
  network_interface_ids = [
    azurerm_network_interface.backend-nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = "128"
  }

  source_image_reference {
    publisher = "MicrosoftSQLServer"
    offer     = "sql2019-ws2019"
    sku       = "Enterprise"
  }
  depends_on = [
    azurerm_network_interface.backend-nic
  ]
}

resource "azurerm_mssql_virtual_machine" "backend_sql" {
  virtual_machine_id               = azurerm_windows_virtual_machine.backend.id
  sql_license_type                 = "PAYG"
  sql_connectivity_port            = 1433
  sql_connectivity_type            = "PRIVATE"
  sql_connectivity_update_password = var.sql_password
  sql_connectivity_update_username = var.sql_admin
  depends_on = [
    azurerm_windows_virtual_machine.backend
  ]
}
