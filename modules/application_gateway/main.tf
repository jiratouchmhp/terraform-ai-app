resource "azurerm_public_ip" "app_gateway_public_ip" {
  name                = "${var.app_gateway_name}-ip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Create Application Gateway
resource "azurerm_application_gateway" "app_gateway" {
  name                = var.app_gateway_name
  location            = var.location
  resource_group_name = var.resource_group_name

  sku {
    name     = var.sku_name
    tier     = var.sku_tier
    capacity = var.capacity
  }

  waf_configuration {
    enabled            = true
    firewall_mode      = var.waf_mode
    rule_set_type      = "OWASP"
    rule_set_version   = "3.2"
  }

  gateway_ip_configuration {
    name      = "appgateway-ip-config"
    subnet_id = var.subnet_id
  }

  frontend_ip_configuration {
    name                 = "frontend-ip"
    public_ip_address_id = azurerm_public_ip.app_gateway_public_ip.id
  }

  frontend_port {
    name = "http-port"
    port = 80
  }

  # frontend_port {
  #   name = "https-port"
  #   port = 443
  # }

  # Define backend pools, without backend addresses directly
  backend_address_pool {
    name = "aks-frontend-backend-pool"
  }

  backend_address_pool {
    name = "aks-api-backend-pool"
  }

  # Health probe for AKS Api
  probe {
    name                = "aks-api-healthprobe"
    protocol            = "Http" # using "Https" for HTTPS
    path                = "/api/health"  # Customize based on your API health check path
    interval            = 30
    timeout             = 30
    unhealthy_threshold = 3
    pick_host_name_from_backend_http_settings = true
  }

  # Health probe for AKS frontend
  probe {
    name                = "aks-frontend-healthprobe"
    protocol            = "Http" # using "Https" for HTTPS
    path                = "/"  # Customize based on your frontend health check path
    interval            = 30
    timeout             = 30
    unhealthy_threshold = 3
    pick_host_name_from_backend_http_settings = true
  }

  # HTTP Settings for AKS API server
  backend_http_settings {
    name                  = "aks-api-http-settings"
    cookie_based_affinity  = "Disabled"
    port                  = 80    # using 443 for HTTPS
    protocol              = "Http" # using "Https" for HTTPS
    request_timeout       = 20
    probe_name            = "aks-api-healthprobe"  # Associate the health probe
    host_name             = var.aks_private-endpoint_fqdn
    # pick_host_name_from_backend_address = true    # Automatically picks host name from backend address
    # host_name             = var.aks_host_header   # Set the custom host name here
  }

  # HTTP Settings for AKS frontend traffic
  backend_http_settings {
    name                  = "aks-frontend-http-settings"
    cookie_based_affinity  = "Disabled"
    port                  = 80    # using 443 for HTTPS
    protocol              = "Http" # using "Https" for HTTPS
    request_timeout       = 20
    probe_name            = "aks-frontend-healthprobe"  # Associate the health probe
    host_name             = var.aks_private-endpoint_fqdn
    # pick_host_name_from_backend_address = true  # Automatically picks host name from backend address
    # host_name             = var.aks_host_header # Set the custom host name here
  }

  http_listener {
    name                           = "listener-http"
    frontend_ip_configuration_name = "frontend-ip"
    frontend_port_name             = "http-port"
    protocol                       = "Http"
  }

  # Using HTTPS when SSL certificate is available
  # http_listener {
  #   name                           = "listener-https"
  #   frontend_ip_configuration_name = "frontend-ip"
  #   frontend_port_name             = "https-port"
  #   # protocol                     = "Https" 
  # }

  # Path-based Routing: API and Frontend
  url_path_map {
    name = "path-routing"

    # Default rule to send all traffic to the frontend (AKS)
    default_backend_address_pool_name  = "aks-frontend-backend-pool"
    default_backend_http_settings_name = "aks-frontend-http-settings"

    # Rule for API traffic routed to AKS API backend
    path_rule {
      name                       = "aks-api-rule"
      paths                      = ["/api", "/api/*"]
      backend_address_pool_name   = "aks-api-backend-pool"
      backend_http_settings_name  = "aks-api-http-settings"
    }

    # Rule for frontend traffic routed to AKS frontend
    path_rule {
      name                       = "aks-frontend-rule"
      paths                      = ["/*"]
      backend_address_pool_name   = "aks-frontend-backend-pool"
      backend_http_settings_name  = "aks-frontend-http-settings"
    }
  }

  # Request Routing Rule for HTTP
  request_routing_rule {
    name                  = "path-routing-rule-http"
    rule_type             = "PathBasedRouting"
    http_listener_name    = "listener-http"
    url_path_map_name     = "path-routing"
    priority              = 100
  }

  # Request Routing Rule for HTTPS
  # request_routing_rule {
  #   name                  = "path-routing-rule-https"
  #   rule_type             = "PathBasedRouting"
  #   http_listener_name    = "listener-https"
  #   url_path_map_name     = "path-routing"
  #   priority              = 200
  # }

  tags = var.tags
}




