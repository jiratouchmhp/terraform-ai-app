output "private_dns_zone_ids" {
  description = "List of Private DNS Zone IDs."
  value = [for zone in azurerm_private_dns_zone.dns_zone : zone.id]
}