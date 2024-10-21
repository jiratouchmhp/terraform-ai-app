resource "azurerm_kubernetes_cluster" "aks" {
  name                    = var.cluster_name
  location                = var.location
  resource_group_name     = var.resource_group_name
  dns_prefix              = var.dns_prefix
  private_cluster_enabled = var.private_cluster_enabled  
  sku_tier                = var.sku_tier

  # Enable Managed Identity
  identity {
    type = "SystemAssigned"
  }

  # Network Profile for CNI Overlay
  network_profile {
    network_plugin      = "azure"  
    network_plugin_mode = "overlay"             # Azure CNI with Overlay
    network_policy      = "calico"              # Using Calico for network policy
    service_cidr        = var.service_cidr      # Separate range for Kubernetes services
    dns_service_ip      = var.dns_service_ip    # IP within the `service_cidr` range for DNS
    pod_cidr            = var.pod_cidr          # Specify Pod CIDR for CNI Overlay
  }


  # Enable Azure Active Directory (AAD) for RBAC
  azure_active_directory_role_based_access_control {
    azure_rbac_enabled                = true
    admin_group_object_ids = var.admin_group_object_ids
  }

  # Default System Node Pool
  default_node_pool {
    name                 = var.system_node_pool_name
    vm_size              = var.system_node_pool_vm_size
    auto_scaling_enabled = var.system_node_auto_scaling
    min_count            = var.system_node_auto_scaling ? var.system_node_min_count : null
    max_count            = var.system_node_auto_scaling ? var.system_node_max_count : null
    vnet_subnet_id       = var.vnet_subnet_id
    max_pods             = var.max_pods_per_node
    type                 = "VirtualMachineScaleSets"
    orchestrator_version = var.kubernetes_version
  }
  # Tags
  tags = var.tags
}

# Optional User Node Pool using azurerm_kubernetes_cluster_node_pool
resource "azurerm_kubernetes_cluster_node_pool" "user_node_pool" {
  count                 = var.enable_user_node_pool ? 1 : 0
  name                  = var.user_node_pool_name
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  vm_size               = var.user_node_pool_vm_size
  auto_scaling_enabled  = var.user_node_auto_scaling
  min_count             = var.user_node_auto_scaling ? var.user_node_min_count : null
  max_count             = var.user_node_auto_scaling ? var.user_node_max_count : null
  vnet_subnet_id        = var.vnet_subnet_id
  max_pods              = var.max_pods_per_node
  orchestrator_version  = var.kubernetes_version

  # Use `node_public_ip_enabled` to control if the nodes get public IPs
  node_public_ip_enabled = false

  tags = var.tags
}

# Create Private Endpoint for AKS API Server
resource "azurerm_private_endpoint" "aks_private_endpoint" {
  name                = "${var.cluster_name}-private-endpoint"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.vnet_subnet_id

  private_service_connection {
    name                           = "aks-api-connection"
    private_connection_resource_id = azurerm_kubernetes_cluster.aks.id
    subresource_names              = ["management"]  # AKS API server endpoint
    is_manual_connection           = false
  }
}