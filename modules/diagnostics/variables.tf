variable "resource_name" {
  description = "The name of the resource for which diagnostics are being configured"
  type        = string
}

variable "target_resource_id" {
  description = "The ID of the target resource for diagnostics"
  type        = string
}

variable "log_analytics_workspace_id" {
  description = "The ID of the log analytics workspace to send diagnostics data to"
  type        = string
}

variable "logs_categories" {
  description = "List of log categories to enable"
  type        = list(string)
}
variable "logs_categories_group" {
  description = "List of log categories to enable"
  type        = list(string)
}

variable "metrics_categories" {
  description = "List of metric categories to enable"
  type        = list(string)
}
