terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.1.0"
    }
  }
  # backend "azurerm" {
  #   resource_group_name   = "terraform-backend-rg"
  #   storage_account_name  = "tfstateaccount445"
  #   container_name        = "tfstate"
  #   key                   = "landing_zone.tfstate"  // State file for application ai zone
  # }
}

#Service principal: 
#Should be owner of the subscriptions
#Add Group.ReadWrite.All and Directory.ReadWrite.All to the service principal.
provider "azurerm" {
  features {}
    subscription_id = var.subscription_id
    client_id       = var.client_id
    client_secret   = var.client_secret
    tenant_id       = var.tenant_id

    use_cli = false  # Ensure Azure CLI authentication is disabled
}

provider "azuread" {
  tenant_id       = var.tenant_id       
  client_id       = var.client_id      
  client_secret   = var.client_secret
}