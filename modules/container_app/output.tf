output "container_app_environment_id" {
  description = "The ID of the Container Apps Environment"
  value       = azurerm_container_app_environment.container_env.id
}

output "container_app_environment_name" {
  description = "The name of the Container Apps Environment"
  value       = azurerm_container_app_environment.container_env.name
}

output "container_app_id" {
  description = "The ID of the Container App"
  value       = azurerm_container_app.container_app.id
}

output "container_app_name" {
  description = "The name of the Container App"
  value       = azurerm_container_app.container_app.name
}

output "container_app_fqdn" {
  description = "The FQDN of the Container App"
  value       = azurerm_container_app.container_app.ingress[0].fqdn
}

output "container_app_latest_revision_name" {
  description = "The name of the latest revision"
  value       = azurerm_container_app.container_app.latest_revision_name
}

output "container_app_latest_revision_fqdn" {
  description = "The FQDN of the latest revision"
  value       = azurerm_container_app.container_app.latest_revision_fqdn
}
