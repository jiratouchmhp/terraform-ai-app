variable "workspace_name" {
  description = "The name of the Log Analytics Workspace"
  type        = string
}

variable "location" {
  description = "Location of the workspace"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group for the workspace"
  type        = string
}

variable "sku" {
  description = "SKU for the workspace"
  type        = string
  default     = "PerGB2018"
}

variable "retention_in_days" {
  description = "Log retention in days"
  type        = number
  default     = 30
}

variable "tags" {
  description = "Tags for the Log Analytics workspace"
  type        = map(string)
}
