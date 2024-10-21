# modules/usergroups/variables.tf

variable "resource_group_name" {
  description = "The name of the resource group to apply RBAC"
  type        = string
}

variable "resource_group_id" {
  description = "The ID of the resource group to apply RBAC"
  type        = string
}

variable "owner_group_name" {
  description = "The name of the Azure AD group for Owners"
  type        = string
}

variable "operator_group_name" {
  description = "The name of the Azure AD group for Operators"
  type        = string
}

variable "readonly_group_name" {
  description = "The name of the Azure AD group for Read-only access"
  type        = string
}

variable "location" {
  description = "The location for the resource group"
  type        = string
}

variable "tags" {
  description = "A map of tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "tenant_id" {
  description = "The Azure AD tenant ID"
  type        = string
}