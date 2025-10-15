# Example usage of the Container App module

# This example demonstrates how to use the container_app module
# to deploy a simple web application using Azure Container Apps

# Prerequisites:
# 1. A resource group must exist
# 2. A Log Analytics workspace must be created or referenced

# Example: Create or reference a resource group
# module "resource_group" {
#   source   = "../modules/resource_group"
#   name     = "container-app-rg"
#   location = "East US"
#   tags = {
#     environment = "development"
#     project     = "container-apps-demo"
#   }
# }

# Example: Create or reference a Log Analytics workspace
# module "log_analytics" {
#   source              = "../modules/log_analytics"
#   workspace_name      = "container-app-logs"
#   resource_group_name = module.resource_group.resource_group_name
#   location            = "East US"
#   sku                 = "PerGB2018"
#   retention_in_days   = 30
#   tags = {
#     environment = "development"
#   }
# }

# Deploy a Container App with the module
module "container_app_example" {
  source = "../modules/container_app"

  # Container Apps Environment settings
  environment_name           = "my-container-env"
  log_analytics_workspace_id = "<log-analytics-workspace-id>" # Use module.log_analytics.workspace_id

  # Container App settings
  container_app_name  = "hello-world-app"
  resource_group_name = "<resource-group-name>" # Use module.resource_group.resource_group_name
  location            = "East US"

  # Container settings
  container_name   = "hello-world"
  container_image  = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"
  container_cpu    = 0.25
  container_memory = "0.5Gi"

  # Optional: Environment variables
  environment_variables = [
    {
      name  = "APP_ENV"
      value = "development"
    },
    {
      name  = "LOG_LEVEL"
      value = "info"
    }
  ]

  # Scaling settings
  min_replicas = 1
  max_replicas = 3

  # Ingress settings
  ingress_external_enabled = true
  ingress_target_port      = 80
  ingress_transport        = "auto"

  # Revision mode
  revision_mode = "Single"

  # Tags
  tags = {
    environment = "development"
    project     = "container-apps-demo"
    managed_by  = "terraform"
  }
}

# Outputs from the module
output "container_app_fqdn" {
  description = "The FQDN of the deployed Container App"
  value       = module.container_app_example.container_app_fqdn
}

output "container_app_id" {
  description = "The ID of the Container App"
  value       = module.container_app_example.container_app_id
}

output "container_app_environment_id" {
  description = "The ID of the Container Apps Environment"
  value       = module.container_app_example.container_app_environment_id
}
