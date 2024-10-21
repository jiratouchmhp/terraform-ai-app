# Outputs for Azure OpenAI with Private Endpoint and Deployed Models
output "openai_name" {
  description = "The name of the Azure OpenAI service."
  value       = azurerm_cognitive_account.openai.name
}

output "openai_id" {
  description = "The id of the Azure OpenAI service."
  value       = azurerm_cognitive_account.openai.id
}

output "openai_endpoint" {
  description = "The endpoint of the Azure OpenAI service."
  value       = azurerm_cognitive_account.openai.endpoint
}

output "private_endpoint_ip" {
  description = "The private IP address of the Azure OpenAI private endpoint."
  value       = azurerm_private_endpoint.openai_private_endpoint.private_service_connection[0].private_ip_address
}

output "deployed_models" {
  description = "List of deployed models in OpenAI."
  value       = [for model in azurerm_cognitive_deployment.openai_models : model.name]
}
