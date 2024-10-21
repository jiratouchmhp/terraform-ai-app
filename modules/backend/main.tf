// Create the Resource Group for the backend storage
resource "azurerm_resource_group" "backend" {
  name     = var.backend_resource_group_name
  location = var.backend_location

  tags = var.tags
}

// Call the Storage Account module to create the storage account
module "storage_account" {
  source                   = "../storage_account"
  storage_account_name     = var.backend_storage_account_name
  resource_group_name      = azurerm_resource_group.backend.name
  location                 = var.backend_location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  subnet_id                = var.subnet_id
  create_private_endpoint  = false
  tags                     = var.tags
}

// Create the container to store Terraform state files
resource "azurerm_storage_container" "backend_state_container" {
  name                  = var.backend_storage_container_name
  storage_account_name  = var.backend_storage_account_name
  container_access_type = "private"
}
