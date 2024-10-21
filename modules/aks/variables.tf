variable "cluster_name" {
  description = "The name of the AKS cluster."
  type        = string
}

variable "location" {
  description = "The Azure location where the resources will be created."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group for the AKS cluster."
  type        = string
}

variable "dns_prefix" {
  description = "The DNS prefix for the AKS cluster."
  type        = string
}

# Network Configuration
variable "vnet_id" {
  description = "The ID of the virtual network."
  type        = string
}

variable "vnet_subnet_id" {
  description = "The ID of the subnet to use for the AKS cluster."
  type        = string
}

variable "private_endpoint_subnet_id" {
  description = "The ID of the subnet where the Private Endpoint will be created."
  type        = string
}

# variable "authorized_ip_ranges" {
#   description = "IP ranges authorized to access the Kubernetes API server."
#   type        = list(string)
# }
variable "private_cluster_enabled" {
  description = "Enable private cluster."
  type        = bool
}

variable "sku_tier" {
  description = "The SKU tier for the AKS cluster."
  type        = string
}

variable "service_cidr" {
  description = "The CIDR range for Kubernetes services."
  type        = string
}

variable "dns_service_ip" {
  description = "The IP address within the `service_cidr` range for DNS."
  type        = string
}
variable "pod_cidr" {
  description = "The CIDR range for pods."
  type        = string
}

# System Node Pool
variable "auto_scaling_enabled" {
  description = "Enable auto scaling for the system node pool."
  type        = bool
  default     = true
}

variable "system_node_pool_name" {
  description = "The name of the system node pool."
  type        = string
  default     = "systempool"
}

variable "system_node_pool_vm_size" {
  description = "The VM size for the system node pool."
  type        = string
  default     = "Standard_DS2_v2"
}

variable "system_node_count" {
  description = "The number of nodes in the system node pool."
  type        = number
  default     = 1
}

variable "system_node_auto_scaling" {
  description = "Enable auto scaling for the system node pool."
  type        = bool
  default     = true
}

variable "system_node_min_count" {
  description = "Minimum number of nodes for auto-scaling in the system node pool."
  type        = number
  default     = 1
}

variable "system_node_max_count" {
  description = "Maximum number of nodes for auto-scaling in the system node pool."
  type        = number
  default     = 5
}

variable "system_node_disk_size" {
  description = "The OS disk size for system node pool VMs (in GB)."
  type        = number
  default     = 100
}

# Max Pods per Node
variable "max_pods_per_node" {
  description = "The maximum number of pods that can run on a single node."
  type        = number
  default     = 110
}

# User Node Pool (Optional)
variable "enable_user_node_pool" {
  description = "Enable user node pool creation."
  type        = bool
  default     = false
}

variable "user_node_pool_name" {
  description = "The name of the user node pool."
  type        = string
  default     = "userpool"
}

variable "user_node_pool_vm_size" {
  description = "The VM size for the user node pool."
  type        = string
  default     = "Standard_DS2_v2"
}

variable "user_node_count" {
  description = "The number of nodes in the user node pool."
  type        = number
  default     = 1
}

variable "user_node_auto_scaling" {
  description = "Enable auto scaling for the user node pool."
  type        = bool
  default     = true
}

variable "user_node_min_count" {
  description = "Minimum number of nodes for auto-scaling in the user node pool."
  type        = number
  default     = 1
}

variable "user_node_max_count" {
  description = "Maximum number of nodes for auto-scaling in the user node pool."
  type        = number
  default     = 5
}

variable "user_node_disk_size" {
  description = "The OS disk size for user node pool VMs (in GB)."
  type        = number
  default     = 100
}

# RBAC Configuration
variable "admin_group_object_ids" {
  description = "List of Azure AD Group Object IDs that have admin access to the AKS cluster."
  type        = list(string)
}

# Kubernetes Version
variable "kubernetes_version" {
  description = "The Kubernetes version for the AKS cluster."
  type        = string
  default = "1.29.8"
}

# Miscellaneous
variable "tags" {
  description = "A map of tags to assign to the resources."
  type        = map(string)
  default     = {}
}
