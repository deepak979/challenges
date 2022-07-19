#suppose you need to configure vm backup  using an existing backup policy which is created using portal

#fetching vault in which backup needs to be configured
data "azurerm_recovery_services_vault" "vault" {
  name                = "name of vault"
  resource_group_name = "name of Resource group where vault exists"
}

#fetching backup policy to configure vm backup
data "azurerm_backup_policy_vm" "backup_policy" {
  name                = "name of the backup policy"
  recovery_vault_name = data.azurerm_recovery_services_vault.vault.name
  resource_group_name = "name of Resource group where vault exists"
}

#fetching vm details for which backup needs to be configured
data "azurerm_virtual_machine" "frontend" {
  name                = "name of the vm"
  resource_group_name = "Name of rg where vm is deployed"
}

#using the aboce data lets configure VM Backup
resource "azurerm_backup_protected_vm" "vm" {
  resource_group_name = "Name of rg where vm is deployed"
  recovery_vault_name = data.azurerm_recovery_services_vault.vault.name
  source_vm_id        = data.azurerm_virtual_machine.frontend.id
  backup_policy_id    = data.azurerm_backup_policy_vm.backup_policy.id
}
