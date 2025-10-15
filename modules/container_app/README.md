# Azure Container App Module

This Terraform module provisions Azure Container Apps resources, including a Container Apps Environment and a Container App.

## Overview

Azure Container Apps is a fully managed serverless container service that enables you to run microservices and containerized applications without managing complex infrastructure. This module simplifies the deployment of Container Apps with support for key configuration options including:

- Container Apps Environment with Log Analytics integration
- Container App with customizable container settings
- Configurable scaling (min/max replicas)
- Ingress configuration with external access support
- Environment variables support
- Resource tagging

## Features

- **Container Apps Environment**: Managed environment with Log Analytics workspace integration
- **Container App**: Deploy containerized applications with custom images
- **Auto-scaling**: Configure minimum and maximum replica counts
- **Ingress**: Support for external and internal traffic with customizable target ports
- **Environment Variables**: Pass configuration to containers via environment variables
- **Resource Management**: CPU and memory allocation per container
- **Tagging**: Apply consistent tags across resources

## Usage

### Basic Example

```hcl
module "container_app" {
  source = "../modules/container_app"

  environment_name           = "my-container-env"
  container_app_name         = "my-app"
  location                   = "East US"
  resource_group_name        = "my-resource-group"
  log_analytics_workspace_id = "/subscriptions/.../resourceGroups/.../providers/Microsoft.OperationalInsights/workspaces/my-workspace"
  
  container_image  = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"
  container_cpu    = 0.5
  container_memory = "1.0Gi"

  min_replicas = 1
  max_replicas = 5

  ingress_external_enabled = true
  ingress_target_port      = 80

  tags = {
    environment = "production"
    project     = "my-project"
  }
}
```

### Advanced Example with Environment Variables

```hcl
module "container_app" {
  source = "../modules/container_app"

  environment_name           = "production-env"
  container_app_name         = "api-service"
  location                   = "Southeast Asia"
  resource_group_name        = "production-rg"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id
  
  container_name   = "api"
  container_image  = "myregistry.azurecr.io/my-api:v1.0.0"
  container_cpu    = 1.0
  container_memory = "2.0Gi"

  environment_variables = [
    {
      name  = "DATABASE_URL"
      value = "postgresql://..."
    },
    {
      name  = "API_KEY"
      value = var.api_key
    },
    {
      name  = "LOG_LEVEL"
      value = "info"
    }
  ]

  min_replicas = 2
  max_replicas = 10

  ingress_external_enabled = true
  ingress_target_port      = 8080
  ingress_transport        = "http2"

  revision_mode = "Multiple"

  tags = {
    environment = "production"
    team        = "backend"
    cost-center = "engineering"
  }
}
```

### Example with Existing Log Analytics Workspace

```hcl
# Use existing Log Analytics workspace
data "azurerm_log_analytics_workspace" "existing" {
  name                = "existing-workspace"
  resource_group_name = "monitoring-rg"
}

module "container_app" {
  source = "../modules/container_app"

  environment_name           = "dev-environment"
  container_app_name         = "web-app"
  location                   = "West Europe"
  resource_group_name        = "development-rg"
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.existing.id
  
  container_image = "nginx:latest"
  
  ingress_target_port = 80

  tags = {
    environment = "development"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| azurerm | >= 3.0 |

## Providers

| Name | Version |
|------|---------|
| azurerm | >= 3.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_container_app_environment.container_env](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_app_environment) | resource |
| [azurerm_container_app.container_app](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_app) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| environment_name | The name of the Container Apps Environment | `string` | n/a | yes |
| container_app_name | The name of the Container App | `string` | n/a | yes |
| location | The Azure location where the resources will be created | `string` | n/a | yes |
| resource_group_name | The name of the resource group | `string` | n/a | yes |
| log_analytics_workspace_id | The ID of the Log Analytics Workspace for the Container Apps Environment | `string` | n/a | yes |
| container_image | The container image to deploy | `string` | n/a | yes |
| revision_mode | The revision mode for the Container App ('Single' or 'Multiple') | `string` | `"Single"` | no |
| container_name | The name of the container | `string` | `"main"` | no |
| container_cpu | The required CPU for the container | `number` | `0.25` | no |
| container_memory | The required memory for the container in Gi | `string` | `"0.5Gi"` | no |
| environment_variables | List of environment variables for the container | `list(object({ name = string, value = string }))` | `[]` | no |
| min_replicas | The minimum number of replicas for the Container App | `number` | `1` | no |
| max_replicas | The maximum number of replicas for the Container App | `number` | `10` | no |
| ingress_external_enabled | Whether the Container App ingress is exposed externally | `bool` | `true` | no |
| ingress_target_port | The target port for the Container App ingress | `number` | `80` | no |
| ingress_transport | The transport protocol for the Container App ingress ('auto', 'http', or 'http2') | `string` | `"auto"` | no |
| tags | A map of tags to assign to the resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| container_app_environment_id | The ID of the Container Apps Environment |
| container_app_environment_name | The name of the Container Apps Environment |
| container_app_id | The ID of the Container App |
| container_app_name | The name of the Container App |
| container_app_fqdn | The FQDN of the Container App |
| container_app_latest_revision_name | The name of the latest revision |
| container_app_latest_revision_fqdn | The FQDN of the latest revision |

## Best Practices

1. **Log Analytics**: Always integrate with a Log Analytics workspace for monitoring and diagnostics
2. **Scaling**: Configure appropriate min/max replicas based on your traffic patterns
3. **Resource Allocation**: Set CPU and memory based on your application requirements
4. **Revision Mode**: Use "Single" for simple deployments, "Multiple" for blue-green deployments
5. **Security**: Use internal ingress for internal-only applications
6. **Tagging**: Apply consistent tags for cost tracking and resource management

## Notes

- The Container Apps Environment requires a Log Analytics workspace for logging and monitoring
- Container CPU can be set to: 0.25, 0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0
- Container memory must be specified in Gi (e.g., "0.5Gi", "1.0Gi", "2.0Gi")
- Ingress can be configured as external (publicly accessible) or internal (private)
- Auto-scaling is based on HTTP traffic and configured with min/max replica counts

## References

- [Azure Container Apps Documentation](https://learn.microsoft.com/en-us/azure/container-apps/)
- [Terraform azurerm_container_app_environment](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_app_environment)
- [Terraform azurerm_container_app](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_app)
