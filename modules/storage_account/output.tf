output "private_endpoint_ip" {
  value = length(azurerm_private_endpoint.storage_private_endpoint) > 0 ? values(azurerm_private_endpoint.storage_private_endpoint)[0].private_service_connection[0].private_ip_address : ""
  description = "The private IP address of the storage account's private endpoint"
}

output "storage_account_name" {
  value = azurerm_storage_account.storage.name
  description = "The name of the storage account"
}

output "storage_account_id" {
  description = "The ID of the Storage Account"
  value       = azurerm_storage_account.storage.id
}

output "primary_access_key" {
  description = "The primary access key of the Storage Account"
  value       = azurerm_storage_account.storage.primary_access_key
}