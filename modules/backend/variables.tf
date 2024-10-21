variable "backend_resource_group_name" {
  description = "Name of the Resource Group for the backend storage"
  type        = string
}

variable "backend_location" {
  description = "Azure region where the backend storage will be created"
  type        = string
  default     = "East US"
}

variable "backend_storage_account_name" {
  description = "Name of the Storage Account for storing Terraform state"
  type        = string
}

variable "backend_storage_container_name" {
  description = "Name of the container in the Storage Account for storing state files"
  type        = string
  default     = "tfstate"
}

variable "account_tier" {
  description = "Storage account tier (e.g., Standard or Premium)"
  type        = string
  default     = "Standard"
}

variable "account_replication_type" {
  description = "Storage account replication type (e.g., LRS, ZRS)"
  type        = string
  default     = "LRS"
}

variable "tags" {
  description = "Tags to be applied to all resources"
  type        = map(string)
  default     = {}
}

variable "subnet_id" {
  description = "ID of the subnet where the Private Endpoint will be created"
  type        = string
  default = ""
}

variable "private_endpoint_enabled" {
  description = "Boolean to determine whether a Private Endpoint should be created"
  type        = bool
  default = false
}