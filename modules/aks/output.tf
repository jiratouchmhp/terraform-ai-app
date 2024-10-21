output "kube_config" {
  description = "The Kubernetes config."
  value       = azurerm_kubernetes_cluster.aks.kube_config_raw
}

output "managed_identity_principal_id" {
  description = "The principal ID of the Managed Identity assigned to the AKS cluster."
  value       = azurerm_kubernetes_cluster.aks.identity[0].principal_id
}


output "aks_private_endpint_ip" {
  description = "The private IP address of the AKS API server Private Endpoint."
  value       = azurerm_private_endpoint.aks_private_endpoint.private_service_connection[0].private_ip_address
}

output "cluster_name" {
  description = "The name of the AKS cluster."
  value       = azurerm_kubernetes_cluster.aks.name
}

output "cluster_id" {
  description = "The ID of the AKS cluster."
  value       = azurerm_kubernetes_cluster.aks.id
}