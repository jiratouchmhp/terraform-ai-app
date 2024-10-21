output "log_analytics_workspace_id" {
  value = azurerm_log_analytics_workspace.log_analytics.id
}

output "log_analytics_workspace_key" {
  value = azurerm_log_analytics_workspace.log_analytics.primary_shared_key
}

output "log_analytics_workspace_name" {
  value = azurerm_log_analytics_workspace.log_analytics.name
}

# Output the workspace ID as a GUID
output "workspace_id_guid" {
  value = split("/", azurerm_log_analytics_workspace.log_analytics.id)[8]
  description = "The Workspace ID (GUID)"
}