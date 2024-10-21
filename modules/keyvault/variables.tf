variable "key_vault_name" {
  description = "The name of the Azure Key Vault"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The location/region where the resources will be deployed"
  type        = string
}

variable "sku_name" {
  description = "The SKU of the Key Vault"
  type        = string
  default     = "standard" # Options: "standard", "premium"
}

variable "enable_private_endpoint" {
  description = "Flag to enable or disable private endpoint"
  type        = bool
  default     = true
}

variable "vnet_subnet_id" {
  description = "The subnet ID where the private endpoint will be created"
  type        = string
  default     = ""
}

variable "tags" {
  description = "A map of tags to apply to resources"
  type        = map(string)
  default     = {}
}
