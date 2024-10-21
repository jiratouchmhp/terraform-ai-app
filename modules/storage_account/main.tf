resource "azurerm_storage_account" "storage" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type

  # Optional: Enable static website if needed
  # static_website {
  #   index_document = "index.html"
  #   error_404_document = "404.html"
  # }

  # Increase timeout to handle long API responses
  # timeouts {
  #   create = "30m"
  #   update = "30m"
  # }
}

# Conditionally create the Private Endpoint
resource "azurerm_private_endpoint" "storage_private_endpoint" {
  for_each            = var.create_private_endpoint ? { "blob" = var.subnet_id } : {}
  name                = "${var.storage_account_name}-private-endpoint"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = each.value

  private_service_connection {
    name                           = "${var.storage_account_name}-private-connection"
    private_connection_resource_id = azurerm_storage_account.storage.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }
}
