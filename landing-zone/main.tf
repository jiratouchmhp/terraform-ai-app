// landing_zone/main.tf
// Create the Backend Storage for Terraform state
# module "backend" {
#   source                      = "../modules/backend"
#   backend_resource_group_name  = var.backend_resource_group_name
#   backend_location             = var.location
#   backend_storage_account_name = "${var.name-prefix}${var.backend_storage_account_name}"
#   backend_storage_container_name = "${var.name-prefix}${var.backend_storage_container_name}"
#   account_tier                 = var.account_tier
#   account_replication_type      = var.account_replication_type
#   tags                         = var.tags
# }


// Create the Resource Group for the Landing Zone
module "landing_zone_resource_group" {
  source  = "../modules/resource_group"
  name    = "${var.name-prefix}-${var.resource_group_name}-rg"
  location = var.location
  tags     = var.tags
}

# Create the User Group Module
module "user_groups" {
  source              = "../modules/user_groups"
  resource_group_name = module.landing_zone_resource_group.resource_group_name
  resource_group_id   = module.landing_zone_resource_group.resource_group_id  # Pass resource group ID for RBAC assignment

  # Define Azure AD Group names for Owner, Operator, and Read-only
  owner_group_name    = "${var.resource_group_name}-Owner"
  operator_group_name = "${var.resource_group_name}-Operator"
  readonly_group_name = "${var.resource_group_name}-Readonly"
  location            = var.location
  tags                = var.tags
  tenant_id = var.tenant_id
}

# Create the Virtual Network Module
module "network" {
  source              = "../modules/vnet"
  vnet_name           = "${var.name-prefix}-${var.vnet_name}-vnet"
  location            = var.location
  resource_group_name = module.landing_zone_resource_group.resource_group_name
  address_space       = var.vnet_address_space
  subnets             = var.subnets
}

# Get the Subnet IDs for the Virtual Machines
locals {
  vm_subnet_ids = [for vm_name, subnet_name in var.vm_subnet_mapping : {
    vm_name    = vm_name
    subnet_id  = lookup(module.network.subnet_ids, subnet_name, "")
  }]
}

# Get the Subnet ID for the Application Gateway
locals {
  app_gateway_subnet_id = lookup(
    module.network.subnet_ids, 
    var.subnet_mapping["app-gateway-stel"], 
    ""  # Default value if no match is found
  )
}

# Get the Subnet ID for the Private Endpoints
locals {
  private-endpoints_subnet_id = lookup(
    module.network.subnet_ids, 
    var.subnet_mapping["private-endpoints-stel"], 
    ""  # Default value if no match is found
  )
}

# Get the Subnet ID for the AKS Cluster
locals {
  aks_subnet_id = lookup(
    module.network.subnet_ids, 
    var.subnet_mapping["aks-stel-cluster"], 
    ""  # Default value if no match is found
  )
}

# Get the Subnet ID for the PostgreSQL Flexible Server
locals {
  postgres_subnet_id = lookup(
    module.network.subnet_ids, 
    var.subnet_mapping["postgresql-stel-flexible"], 
    ""  # Default value if no match is found
  )
}

// Create the Virtual Machines Module
module "compute_vms" {
  source              = "../modules/compute"
  vm_names            = [for vm in local.vm_subnet_ids : vm.vm_name]
  vm_size             = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  resource_group_name = module.landing_zone_resource_group.resource_group_name
  location            = var.location
  subnet_ids          = [for vm in local.vm_subnet_ids : vm.subnet_id]
  enable_managed_identity = [for vm in local.vm_subnet_ids : vm.vm_name == "github-runner-vm" ? true : vm.vm_name == "jump-box-vm" ? true : false]
  tags                = var.tags
}

# Module to create Private DNS Zones
module "private_dns_zones" {
  source              = "../modules/private_dns_zone"
  dns_zone_names      = var.private_dns_zone_names
  resource_group_name = module.landing_zone_resource_group.resource_group_name
  virtual_network_ids = [module.network.vnet_id]
}

# Module to create Storage Account with Private Endpoint
module "storage_account" {
  source                   = "../modules/storage_account"
  storage_account_name     = "${var.name-prefix}${var.storage_account_name}"
  resource_group_name      = module.landing_zone_resource_group.resource_group_name
  location                 = var.location
  create_private_endpoint  = var.create_private_endpoint
  subnet_id                = local.private-endpoints_subnet_id
  tags                     = var.tags
}

# Add DNS records for the Blob Storage Account
module "private_dns_record" {
  source              = "../modules/private_dns_record"
  dns_zone_name       = var.private_dns_zone_name_blob
  resource_group_name = module.landing_zone_resource_group.resource_group_name
  ttl                 = var.ttl
  records = [
    {
      name = "${var.name-prefix}${var.storage_account_name}"
      ip   = module.storage_account.private_endpoint_ip 
    }
  ]
}


#Create the AKS Cluster
module "aks_cluster" {
  source                          = "../modules/aks"
  cluster_name                    = "${var.name-prefix}-${var.aks_name}"
  location                        = var.location
  resource_group_name             = module.landing_zone_resource_group.resource_group_name
  dns_prefix                      = "${var.name-prefix}-${var.aks_name}"
  vnet_id                         = module.network.vnet_id
  vnet_subnet_id                  = local.aks_subnet_id
  private_endpoint_subnet_id      = local.private-endpoints_subnet_id
  admin_group_object_ids          = var.admin_group_object_ids
  system_node_pool_name           = "${var.name-prefix}sysnp"
  system_node_pool_vm_size        = var.system_node_pool_vm_size
  system_node_auto_scaling        = var.system_node_auto_scaling
  system_node_min_count           = var.system_node_min_count
  system_node_max_count           = var.system_node_max_count
  enable_user_node_pool           = var.user_node_auto_scaling
  user_node_pool_name             = "${var.name-prefix}usernp"
  user_node_pool_vm_size          = var.user_node_pool_vm_size
  user_node_auto_scaling          = var.user_node_auto_scaling
  user_node_min_count             = var.user_node_min_count
  user_node_max_count             = var.user_node_max_count
  kubernetes_version              = var.kubernetes_version
  max_pods_per_node               = var.max_pods_per_node
  private_cluster_enabled         = var.private_cluster_enabled
  sku_tier                        = var.aks_sku_tier
  service_cidr                    = var.aks_service_cidr
  dns_service_ip                  = var.dns_service_ip
  pod_cidr                        = var.pod_cidr
  tags                            = var.tags
}

# Add DNS records for the AKS Cluster
module "private_dns_record_aks" {
  source              = "../modules/private_dns_record"
  dns_zone_name       = var.private_dns_zone_name_aks 
  resource_group_name = module.landing_zone_resource_group.resource_group_name
  ttl                 = var.ttl
  records = [
    {
      name = module.aks_cluster.cluster_name
      ip   = module.aks_cluster.aks_private_endpint_ip
    }
  ]
}

# Create PostgreSQL Flexible Server Module
module "postgres_flexible" {
  source                     = "../modules/postgres_flexible"
  server_name                = "${var.name-prefix}-${var.postgres_server_name}"
  location                   = var.location
  resource_group_name        = module.landing_zone_resource_group.resource_group_name
  admin_username             = var.postgres_admin_username
  admin_password             = var.postgres_admin_password 
  postgres_version           = var.postgres_version
  sku_name                   = var.postgres_sku_name
  storage_mb                 = var.postgres_storage_mb
  backup_retention_days      = var.backup_retention_days
  geo_redundant_backup       = var.geo_redundant_backup
  high_availability_mode     = var.high_availability_mode  
  subnet_id                  = local.postgres_subnet_id
  private_dns_zone_id        = module.private_dns_zones.private_dns_zone_ids[1]
  tags                       = var.tags
}

# Create the Key Vault Module
module "key_vault" {
  source                  = "../modules/keyvault"
  key_vault_name          = "${var.name-prefix}-${var.key_vault_name}"
  resource_group_name     = module.landing_zone_resource_group.resource_group_name
  location                = var.location
  sku_name                = var.sku_name_key_vault  # You can change this to "standard" if desired
  enable_private_endpoint = var.enable_private_endpoint   # Enable the private endpoint for the Key Vault
  vnet_subnet_id          = local.private-endpoints_subnet_id  # Pass the Subnet ID for the Private Endpoint
  tags                    = var.tags
}

# Add DNS records for the Key Vault
module "private_dns_record_keyvault" {
  source              = "../modules/private_dns_record"
  dns_zone_name       = var.private_dns_zone_name_key_vault 
  resource_group_name = module.landing_zone_resource_group.resource_group_name
  ttl                 = var.ttl
  records = [
    {
      name = module.key_vault.key_vault_name
      ip   = module.key_vault.private_endpoint_ip 
    }
  ]
}

// Create Azure OpenAI Service with Models
module "azure_openai_with_models" {
  source                    = "../modules/azure_openai"
  openai_name               = "${var.name-prefix}-${var.openai_name}"
  location                  = var.location
  resource_group_name       = module.landing_zone_resource_group.resource_group_name
  subnet_id                 = local.private-endpoints_subnet_id
  custom_subdomain_name     = "${var.name-prefix}-${var.openai_name}"
  tags                      = var.tags
  private_dns_zone_ids      = module.private_dns_zones.private_dns_zone_ids
  models = var.models
}

// Create Application Gateway with WAF
module "application_gateway" {
  source                                = "../modules/application_gateway"
  app_gateway_name                      = "${var.name-prefix}-${var.app_gateway_name}"
  location                              = var.location
  resource_group_name                   = module.landing_zone_resource_group.resource_group_name
  subnet_id                             = local.app_gateway_subnet_id
  aks_private-endpoint_fqdn             = "${module.aks_cluster.cluster_name}.${var.private_dns_zone_name_aks}"
  sku_name                              = var.sku_name
  sku_tier                              = var.sku_tier
  waf_mode                              = var.waf_mode
  capacity                              = var.capacity
  tags                                  = var.tags
}

# Create Log Analytics Workspace
module "log_analytics" {
  source              = "../modules/log_analytics"
  workspace_name      = "${var.name-prefix}-${var.workspace_name}"
  location            = var.location
  resource_group_name = module.landing_zone_resource_group.resource_group_name
  sku                 = var.sku_log_analytics
  retention_in_days   = var.retention_in_days
  tags                = var.tags
}

# Diagnostics for Application Gateway
module "appgw_diagnostics" {
  source                      = "../modules/diagnostics"
  resource_name               = module.application_gateway.application_gateway_name
  target_resource_id          = module.application_gateway.application_gateway_id
  log_analytics_workspace_id  = module.log_analytics.log_analytics_workspace_id
  logs_categories             = []
  logs_categories_group       = ["allLogs"]
  metrics_categories          = ["AllMetrics"]
}

# Diagnostics for AKS
module "aks_diagnostics" {
  source                      = "../modules/diagnostics"
  resource_name               = module.aks_cluster.cluster_name
  target_resource_id          = module.aks_cluster.cluster_id
  log_analytics_workspace_id  = module.log_analytics.log_analytics_workspace_id
  logs_categories             = ["kube-audit", "cluster-autoscaler", "kube-controller-manager"]
  logs_categories_group       = []
  metrics_categories          = ["AllMetrics"]
}

# Diagnostics for VMs OMS Agent Extension
module "vm_github_runner_diagnostics_extension" {
  source                = "../modules/vm_extension"
  vm_name               = module.compute_vms.vm_names[1]   # Replace with your VM resource name
  vm_id                 = module.compute_vms.vm_ids[1]     # Replace with your VM resource ID
  workspace_id = module.log_analytics.workspace_id_guid
  workspace_key = module.log_analytics.log_analytics_workspace_key
}
module "vm_jump_box_diagnostics_extension" {
  source                = "../modules/vm_extension"
  vm_name               = module.compute_vms.vm_names[0]   # Replace with your VM resource name
  vm_id                 = module.compute_vms.vm_ids[0]     # Replace with your VM resource ID
  workspace_id = module.log_analytics.workspace_id_guid
  workspace_key = module.log_analytics.log_analytics_workspace_key
}


# Diagnostics for Storage Account
module "storage_diagnostics" {
  source                      = "../modules/diagnostics"
  resource_name               = module.storage_account.storage_account_name
  target_resource_id          = module.storage_account.storage_account_id
  log_analytics_workspace_id  = module.log_analytics.log_analytics_workspace_id
  logs_categories             = []
  logs_categories_group       = []
  metrics_categories          = ["AllMetrics"]
}

# Diagnostics for Blob Service in Storage Account
module "blob_diagnostics" {
  source                      = "../modules/diagnostics"
  resource_name               = "${module.storage_account.storage_account_name}"
  target_resource_id          = "${module.storage_account.storage_account_id}/blobServices/default/"
  log_analytics_workspace_id  = module.log_analytics.log_analytics_workspace_id

  # Blob-specific Log Categories
  logs_categories             = [] # For Blob service
  logs_categories_group       = ["allLogs"]
  
  # Metrics Categories
  metrics_categories          = ["AllMetrics"]
}


# Diagnostics for Key Vault
module "keyvault_diagnostics" {
  source                      = "../modules/diagnostics"
  resource_name               = module.key_vault.key_vault_name
  target_resource_id          = module.key_vault.key_vault_id
  log_analytics_workspace_id  = module.log_analytics.log_analytics_workspace_id
  logs_categories             = []
  logs_categories_group       = ["allLogs"]
  metrics_categories          = ["AllMetrics"]
}

# Diagnostics for Azure OpenAI (minimal support)
module "openai_diagnostics" {
  source                      = "../modules/diagnostics"
  resource_name               = module.azure_openai_with_models.openai_name
  target_resource_id          = module.azure_openai_with_models.openai_id
  log_analytics_workspace_id  = module.log_analytics.log_analytics_workspace_id
  logs_categories             = []
  logs_categories_group       = ["allLogs"]
  metrics_categories          = ["AllMetrics"]
}

# Diagnostics for Azure PostgreSQL Flexible Server
module "postgres_flexible_diagnostics" {
  source                      = "../modules/diagnostics"
  resource_name               = module.postgres_flexible.postgres_flexible_server_name
  target_resource_id          = module.postgres_flexible.postgres_flexible_server_id
  log_analytics_workspace_id  = module.log_analytics.log_analytics_workspace_id

  # Log categories specific to Azure PostgreSQL Flexible Server
  logs_categories             = []
  logs_categories_group       = ["allLogs"]
  
  # Metrics for Azure PostgreSQL Flexible Server
  metrics_categories          = ["AllMetrics"]
}

module "log_analytics_diagnostics" {
  source                      = "../modules/diagnostics"
  resource_name               = module.log_analytics.log_analytics_workspace_name
  target_resource_id          = module.log_analytics.log_analytics_workspace_id
  log_analytics_workspace_id  = module.log_analytics.log_analytics_workspace_id

  # Log categories for Log Analytics Workspace
  logs_categories             = []
  logs_categories_group       = ["allLogs"]
  
  # Metrics categories for Log Analytics Workspace
  metrics_categories          = ["AllMetrics"]
}

