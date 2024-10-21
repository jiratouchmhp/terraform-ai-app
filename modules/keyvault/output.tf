output "key_vault_id" {
  description = "The ID of the Key Vault"
  value       = azurerm_key_vault.key_vault.id
}

output "key_vault_name" {
  description = "The name of the Key Vault"
  value       = azurerm_key_vault.key_vault.name
}

output "key_vault_uri" {
  description = "The URI of the Key Vault"
  value       = azurerm_key_vault.key_vault.vault_uri
}

output "private_endpoint_ip" {
  description = "The private IP address of the Private Endpoint"
  value       = azurerm_private_endpoint.key_vault_private_endpoint[0].private_service_connection[0].private_ip_address
}
