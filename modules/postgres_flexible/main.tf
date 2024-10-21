resource "azurerm_postgresql_flexible_server" "postgres" {
  name                   = var.server_name
  location               = var.location
  resource_group_name    = var.resource_group_name
  administrator_login    = var.admin_username
  administrator_password = var.admin_password
  version                = var.postgres_version
  storage_mb             = var.storage_mb
  sku_name               = var.sku_name
  zone                   = var.availability_zone
  # Disable public network access since VNet integration is enabled
  public_network_access_enabled = false

  delegated_subnet_id    = var.subnet_id 
  private_dns_zone_id = var.private_dns_zone_id
  geo_redundant_backup_enabled  = var.geo_redundant_backup
  backup_retention_days  = var.backup_retention_days

  dynamic "high_availability" {
    for_each = var.high_availability_mode != "Disabled" ? [1] : []
    content {
      mode = var.high_availability_mode  # Must be "ZoneRedundant" or "SameZone"
    }
  }

  tags = var.tags
}

# resource "azurerm_private_endpoint" "postgres_private_endpoint" {
#   name                = "${var.server_name}-pe"
#   location            = var.location
#   resource_group_name = var.resource_group_name
#   subnet_id           = var.private_endpoint_subnet_id

#   private_service_connection {
#     name                           = "${var.server_name}-private-connection"
#     private_connection_resource_id = azurerm_postgresql_flexible_server.postgres.id
#     subresource_names              = ["postgresqlServer"]
#     is_manual_connection           = false
#   }
# }
