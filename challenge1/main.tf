#creating random password for windows vm
resource "random_password" "windows_vm" {
  length           = 16
  upper            = true
  min_upper        = 2
  special          = true
  min_special      = 2
  numeric           = true
  min_numeric      = 2
  override_special = "/?@#%^_-=+"
}

#creating random password for sql vm
resource "random_password" "sql_vm" {
  length           = 16
  upper            = true
  min_upper        = 2
  special          = true
  min_special      = 2
  numeric           = true
  min_numeric      = 2
  override_special = "/?@#%^_-=+"
}

#main file where a customize module is created to deploy the VM's
module "main"{
    source               = "./modules/main"
    location             = local.location
    resource_group_name  = local.rg_name
    tags                 = local.tags
    frontend_subnet      = azurerm_subnet.frontend.id
    midtier_subnet       = azurerm_subnet.midtier.id
    backend_subnet       = azurerm_subnet.backend.id
    frontend_vm_size     = "size of vm"
    midtier_vm_size      = "size of vm"
    backend_vm_size      = "size of vm"
    frontend_vm_name     = "name of the vm"
    midtier_vm_name      = "name of the vm"
    backend_vm_name      = "name of the vm"
    sql_password         = random_password.sql_vm.result
    windows_password     = random_password.windows_vm.result
    admin_username       = "username of admin"
    vm_publisher         = "MicrosoftWindowsServer"
    vm_offer             = "WindowsServer"
    vm_sku               = "2019-Datacenter"
    sql_admin            ="username of sql admin"
    depends_on = [
    azurerm_subnet.frontend,
    azurerm_subnet.midtier,
    azurerm_subnet.backend
  ]
}
