# Azure Container Apps Environment
resource "azurerm_container_app_environment" "container_env" {
  name                       = var.environment_name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  log_analytics_workspace_id = var.log_analytics_workspace_id

  tags = var.tags
}

# Azure Container App
resource "azurerm_container_app" "container_app" {
  name                         = var.container_app_name
  container_app_environment_id = azurerm_container_app_environment.container_env.id
  resource_group_name          = var.resource_group_name
  revision_mode                = var.revision_mode

  template {
    container {
      name   = var.container_name
      image  = var.container_image
      cpu    = var.container_cpu
      memory = var.container_memory

      dynamic "env" {
        for_each = var.environment_variables
        content {
          name  = env.value.name
          value = env.value.value
        }
      }
    }

    min_replicas = var.min_replicas
    max_replicas = var.max_replicas
  }

  ingress {
    external_enabled = var.ingress_external_enabled
    target_port      = var.ingress_target_port
    transport        = var.ingress_transport

    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }

  tags = var.tags
}
