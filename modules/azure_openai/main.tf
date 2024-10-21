# Azure OpenAI Cognitive Account
resource "azurerm_cognitive_account" "openai" {
  name                = var.openai_name
  location            = var.location_ai
  resource_group_name = var.resource_group_name
  kind                = "OpenAI"
  sku_name            = "S0"
  custom_subdomain_name = var.custom_subdomain_name
  tags                = var.tags

   # Disable public network access
  network_acls {
    default_action = "Deny"   # Denies all public access
  }
}

resource "azurerm_cognitive_deployment" "openai_models" {
  count                = length(var.models)
  name                 = var.models[count.index].name
  cognitive_account_id = azurerm_cognitive_account.openai.id

  model {
    name   = var.models[count.index].model
    format = var.models[count.index].format  # Correctly specify the format attribute
  }

  sku {
    name = "Standard"
  }
}

resource "azurerm_private_endpoint" "openai_private_endpoint" {
  name                = "${var.openai_name}-private-endpoint"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "${var.openai_name}-private-connection"
    private_connection_resource_id = azurerm_cognitive_account.openai.id
    subresource_names              = ["account"]  # Correct subresource name for Azure Cognitive Services
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = var.private_dns_zone_ids
  }
}
