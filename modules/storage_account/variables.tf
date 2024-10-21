variable "storage_account_name" {
  description = "The name of the Storage Account."
  type        = string
}

variable "resource_group_name" {
  description = "The resource group where the Storage Account and Private Endpoints will be created."
  type        = string
}

variable "location" {
  description = "The Azure location where the resources will be created."
  type        = string
}

variable "account_tier" {
  description = "The storage account tier (e.g., Standard or Premium)."
  type        = string
  default     = "Standard"
}

variable "account_replication_type" {
  description = "The replication type for the storage account (e.g., LRS, GRS)."
  type        = string
  default     = "LRS"
}

variable "tags" {
  description = "A mapping of tags to assign to the resources."
  type        = map(string)
}

variable "create_private_endpoint" {
  description = "Boolean to determine whether a Private Endpoint should be created."
  type        = bool
}

variable "subnet_id" {
  description = "The ID of the subnet where the Private Endpoint will be created. Required if create_private_endpoint is true."
  type        = string
  default     = ""  # Default to an empty string
}

