#Setting terraform worksapce and azurerm version

terraform {
  required_version = "tfe version"
  backend "remote" {
    hostname     = "terraform"
    organization = "company"

    workspaces {
      name = "name of worksapce"
    }
  }
}

provider "azurerm" {
  subscription_id            = local.subscription_id
  tenant_id                  = local.tenant_id
  version                    = "2.99.0"
}
