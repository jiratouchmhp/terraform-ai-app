data "azurerm_client_config" "current" {}

# Create Azure Key Vault
resource "azurerm_key_vault" "key_vault" {
  name                = var.key_vault_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = var.sku_name

  tenant_id = data.azurerm_client_config.current.tenant_id

  soft_delete_retention_days      = 7
  purge_protection_enabled = true

  tags = var.tags
}

# Conditionally create a Private Endpoint for the Key Vault if enabled
resource "azurerm_private_endpoint" "key_vault_private_endpoint" {
  count               = var.enable_private_endpoint ? 1 : 0
  name                = "${var.key_vault_name}-private-endpoint"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.vnet_subnet_id

  private_service_connection {
    name                           = "${var.key_vault_name}-private-connection"
    private_connection_resource_id = azurerm_key_vault.key_vault.id
    subresource_names              = ["vault"]
    is_manual_connection           = false
  }

  tags = var.tags
}


