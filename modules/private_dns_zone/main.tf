# Create the Private DNS Zones
resource "azurerm_private_dns_zone" "dns_zone" {
  count               = length(var.dns_zone_names)
  name                = var.dns_zone_names[count.index]
  resource_group_name = var.resource_group_name

  # Ensure DNS Zone can be destroyed but no explicit depends_on to avoid cycles
  lifecycle {
    prevent_destroy = false  # Allow DNS Zones to be destroyed when needed
  }
}

# Create the Private DNS Zone Virtual Network Links
resource "azurerm_private_dns_zone_virtual_network_link" "vnet_link" {
  count                  = length(var.dns_zone_names) * length(var.virtual_network_ids)

  name                   = "${var.dns_zone_names[floor(count.index / length(var.virtual_network_ids))]}-vnet-link-${count.index % length(var.virtual_network_ids)}"
  private_dns_zone_name  = azurerm_private_dns_zone.dns_zone[floor(count.index / length(var.virtual_network_ids))].name
  resource_group_name    = var.resource_group_name
  virtual_network_id     = var.virtual_network_ids[count.index % length(var.virtual_network_ids)]
  registration_enabled   = var.registration_enabled

  # Ensure the Virtual Network Links are allowed to be destroyed first
  lifecycle {
    prevent_destroy = false  # Allow Virtual Network Links to be destroyed before DNS Zone
  }
}
