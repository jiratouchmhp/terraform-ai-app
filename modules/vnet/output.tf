# modules/network/outputs.tf

output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}

output "subnet_ids" {
  description = "Map of subnet IDs by subnet names"
  value = { for subnet in azurerm_subnet.subnet : subnet.name => subnet.id }
}