# Service Principal Configuration Variables
variable "subscription_id" {
  description = "Subscription ID for the Azure subscription"
  type        = string
}

variable "client_id" {
  description = "Client ID for the Service Principal"
  type        = string
}

variable "client_secret" {
  description = "Client Secret for the Service Principal"
  type        = string
  sensitive   = true
}

variable "tenant_id" {
  description = "Tenant ID for the Azure AD tenant"
  type        = string
}

#Core Variables Project
variable "resource_group_name" {
  description = "Name of the Resource Group for the landing zone resources"
  type        = string
}

variable "location" {
  description = "Azure region for the landing zone resources"
  type        = string
}

variable "location_ai" {
  description = "Azure region for the landing zone resources"
  type        = string
}

variable "name-prefix" {
  description = "Prefix to use for naming resources"
  type        = string
}

// State Backend Storage Configuration Variables
variable "backend_resource_group_name" {
  description = "Name of the Resource Group for backend storage"
  type        = string
}

# State BackendStorage Account Configuration Variables
variable "backend_storage_account_name" {
  description = "Name of the storage account for backend state files"
  type        = string
}

variable "backend_storage_container_name" {
  description = "Name of the storage container for storing Terraform state"
  type        = string
}

# Files Storage Account Configuration Variables
variable "storage_account_name" {
  description = "Name of the storage account for files"
  type        = string
}
variable "storage_container_name" {
  description = "Name of the storage container for storing files"
  type        = string
}

variable "account_tier" {
  description = "Storage account tier (e.g., Standard or Premium)"
  type        = string
}

variable "account_replication_type" {
  description = "Storage account replication type (e.g., LRS, ZRS)"
  type        = string
}

variable "create_private_endpoint" {
  description = "Create a Private Endpoint for the storage account"
  type        = bool
}


# Network Configuration Variables
variable "vnet_name" {
  description = "Name of the Virtual Network for the landing zone"
  type        = string
}

variable "vnet_address_space" {
  description = "Address space for the Virtual Network"
  type        = list(string)
}

variable "subnets" {
  description = "List of subnets to create within the VNet, including their names and address prefixes"
  type        = list(object({
    name           = string
    address_prefix = string
  }))
}

variable "subnet_mapping" {
  description = "Map of VM names to their corresponding subnet names"
  type        = map(string)
}

variable "vm_subnet_mapping" {
  description = "Map of VM names to their corresponding subnet names"
  type        = map(string)
}

#Private DNS Configuration Variables
variable "private_dns_zone_names" {
  description = "List of Private DNS Zones for different services"
  type        = list(string)
}

variable "private_dns_zone_name_blob" {
  description = "Name of the Blob Private DNS Zone"
  type        = string
  default     = "privatelink.blob.core.windows.net"
}
variable "private_dns_zone_name_postgres" {
  description = "Name of the Postgres Private DNS Zone"
  type        = string
  default     = "privatelink.postgres.database.azure.com"
}
variable "private_dns_zone_name_aks" {
  description = "Name of the AKS Private DNS Zone"
  type        = string
  default     =  "privatelink.southeastasia.azmk8s.io"
}
variable "private_dns_zone_name_key_vault" {
  description = "Name of the Key-Vault Private DNS Zone"
  type        = string
  default     = "privatelink.vaultcore.azure.net"
}
variable "private_dns_zone_name_open_ai" {
  description = "Name of the Open AI Private DNS Zone"
  type        = string
  default     = "privatelink.openai.azure.com"
}

variable "ttl" {
  description = "Time to live for the DNS records"
  type        = number
}


# VM Configuration Variables
variable "vm_size" {
  description = "Size of the Virtual Machines to be created"
  type        = string
}

variable "admin_username" {
  description = "Admin username for the virtual machines"
  type        = string
}

variable "admin_password" {
  description = "Admin password for the virtual machines"
  type        = string
}

# Postgres Configuration Variables
variable "postgres_server_name" {
  description = "Name of the PostgreSQL server"
  type        = string
}
variable "postgres_admin_username" {
  description = "Admin username for the PostgreSQL server"
  type        = string
}
variable "postgres_admin_password" {
  description = "Admin password for the PostgreSQL server"
  type        = string
  sensitive   = true
}
variable "postgres_version" {
  description = "Version of PostgreSQL to deploy"
  type        = string
}
variable "postgres_sku_name" {
  description = "SKU name for the PostgreSQL server"
  type        = string
}
variable "postgres_storage_mb" {
  description = "SKU capacity for the PostgreSQL server"
  type        = number
}
variable "backup_retention_days" {
  description = "Number of days to retain backups"
  type        = number
}
variable "geo_redundant_backup" {
  description = "Enable geo-redundant backups"
  type        = bool
}
variable "high_availability_mode" {
  description = "Enable high availability mode for the PostgreSQL server"
  type        = string 
  # Options: "ZoneRedundant" or "Disabled"
}

# Azure OpenAI Configuration Variables
variable "openai_name" {
  description = "Name of the Azure OpenAI Workspace"
  type        = string
}
variable "models" {
  description = "A list of models to deploy to the OpenAI instance."
  type = list(object({
    name   = string
    model  = string
    format = string
  }))
}


# Key Vault Configuration Variables
variable "key_vault_name" {
  description = "Name of the Key Vault"
  type        = string
}
variable "sku_name_key_vault" {
  description = "SKU name for the Key Vault"
  type        = string
}
variable "enable_private_endpoint" {
  description = "Enable Private Endpoint for the Key Vault"
  type        = bool
}

# AKS Configuration Variables
variable "aks_name" {
  description = "Name of the AKS cluster"
  type        = string
}
variable "system_node_pool_vm_size" {
  description = "VM size for the system node pool"
  type        = string
}
variable "system_node_auto_scaling" {
  description = "Enable auto-scaling for the system node pool"
  type        = bool
}
variable "system_node_min_count" {
  description = "Minimum number of nodes for auto-scaling in the system node pool"
  type        = number
}
variable "system_node_max_count" {
  description = "Maximum number of nodes for auto-scaling in the system node pool"
  type        = number
}
variable "user_node_pool_vm_size" {
  description = "VM size for the user node pool"
  type        = string
}
variable "user_node_auto_scaling" {
  description = "Enable auto-scaling for the user node pool"
  type        = bool
}
variable "user_node_min_count" {
  description = "Minimum number of nodes for auto-scaling in the user node pool"
  type        = number
}
variable "user_node_max_count" {
  description = "Maximum number of nodes for auto-scaling in the user node pool"
  type        = number
}
variable "kubernetes_version" {
  description = "Version of Kubernetes to deploy"
  type        = string
}
variable "max_pods_per_node" {
  description = "Maximum number of pods per node"
  type        = number
}
variable "private_cluster_enabled" {
  description = "Enable private cluster"
  type        = bool
}
variable "aks_sku_tier" {
  description = "SKU tier for the AKS cluster"
  type        = string
}
variable "aks_service_cidr" {
  description = "CIDR range for Kubernetes services"
  type        = string
}
variable "dns_service_ip" {
  description = "IP address within the `service_cidr` range for DNS"
  type        = string
}
variable "pod_cidr" {
  description = "CIDR range for pods"
  type        = string
}

variable "aks_private-endpoint_fqdn" {
  description = "FQDN of the AKS cluster"
  type        = string
  default = ""
}

# Application Gateway Configuration Variables
variable "app_gateway_name" {
  description = "Name of the Application Gateway"
  type        = string
}

variable "aks_static_ip" {
  description = "Static IP address of the AKS service"
  type        = string
}

variable "static_webapp_fqdn" {
  description = "FQDN of the Static Web App"
  type        = string
}

variable "aks_host_header" {
  description = "Custom host header for AKS"
  type        = string
}

variable "sku_name" {
  description = "SKU name for the Application Gateway"
  type        = string
}

variable "sku_tier" {
  description = "SKU tier for the Application Gateway"
  type        = string
}

variable "waf_mode" {
  description = "WAF mode for the Application Gateway (Detection or Prevention)"
  type        = string
}

variable "capacity" {
  description = "The instance capacity for the Application Gateway"
  type        = number
}

variable "admin_group_object_ids" {
  description = "List of Azure AD Group Object IDs that have admin access to the AKS cluster."
  type        = list(string)
}

# Log Analytics Configuration Variables
variable "workspace_name" {
  description = "Name of the Log Analytics Workspace"
  type        = string
}
variable "sku_log_analytics" {
  description = "SKU for the Log Analytics Workspace"
  type        = string
}
variable "retention_in_days" {
  description = "Log retention in days"
  type        = number
}

# Other Variables
variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
}