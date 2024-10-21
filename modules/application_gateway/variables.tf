variable "app_gateway_name" {
  description = "Name of the Application Gateway"
  type        = string
}

variable "location" {
  description = "Azure region for the resources"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group where the Application Gateway is deployed"
  type        = string
}

variable "subnet_id" {
  description = "ID of the subnet where the Application Gateway is deployed"
  type        = string
}

variable "aks_private-endpoint_fqdn" {
  description = "FQDN of the AKS cluster"
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

variable "tags" {
  description = "Tags to apply to the resources"
  type        = map(string)
}
