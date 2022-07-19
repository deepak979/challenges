#creating vnet and subnet to host VM's
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet"
  location            = local.location
  resource_group_name = local.rg_name
  address_space       = ["0.0.0.0/16"]
  dns_servers         = ["0.0.0.0", "0.0.0.0"]
  tags                = local.tags
}

#creating Subnet and NSG's
resource "azurerm_network_security_group" "frontend" {
  name                = "frontend-nsg" 
  location            = local.location
  resource_group_name = local.rg_name
  tags                = local.tags
}

resource "azurerm_subnet" "frontend" {
  name                 = "frontend-subnet"
  resource_group_name  = local.rg_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["0.0.0.0/28"]
  depends_on = [
    azurerm_virtual_network.vnet,
    azurerm_network_security_group.frontend
  ]
}

resource "azurerm_network_security_group" "midtier" {
  name                = "midtier-nsg" 
  location            = local.location
  resource_group_name = local.rg_name
  tags                = local.tags
}

resource "azurerm_subnet" "midtier" {
  name                 = "midtier-subnet"
  resource_group_name  = local.rg_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["0.0.0.0/28"]
  depends_on = [
    azurerm_virtual_network.vnet,
    azurerm_network_security_group.midtier
  ]
}

resource "azurerm_network_security_group" "backend" {
  name                = "backend-nsg" 
  location            = local.location
  resource_group_name = local.rg_name
  tags                = local.tags
}

resource "azurerm_subnet" "backend" {
  name                 = "backend-subnet"
  resource_group_name  = local.rg_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["0.0.0.0/28"]
  depends_on = [
    azurerm_virtual_network.vnet,
    azurerm_network_security_group.backend
  ]
}
