variable "environment_name" {
  description = "The name of the Container Apps Environment"
  type        = string
}

variable "container_app_name" {
  description = "The name of the Container App"
  type        = string
}

variable "location" {
  description = "The Azure location where the resources will be created"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "log_analytics_workspace_id" {
  description = "The ID of the Log Analytics Workspace for the Container Apps Environment"
  type        = string
}

variable "revision_mode" {
  description = "The revision mode for the Container App. Possible values are 'Single' and 'Multiple'"
  type        = string
  default     = "Single"
}

variable "container_name" {
  description = "The name of the container"
  type        = string
  default     = "main"
}

variable "container_image" {
  description = "The container image to deploy (e.g., 'mcr.microsoft.com/azuredocs/containerapps-helloworld:latest')"
  type        = string
}

variable "container_cpu" {
  description = "The required CPU for the container (e.g., 0.25, 0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0)"
  type        = number
  default     = 0.25
}

variable "container_memory" {
  description = "The required memory for the container in Gi (e.g., '0.5Gi', '1.0Gi', '1.5Gi', '2.0Gi')"
  type        = string
  default     = "0.5Gi"
}

variable "environment_variables" {
  description = "List of environment variables for the container"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "min_replicas" {
  description = "The minimum number of replicas for the Container App"
  type        = number
  default     = 1
}

variable "max_replicas" {
  description = "The maximum number of replicas for the Container App"
  type        = number
  default     = 10
}

variable "ingress_external_enabled" {
  description = "Whether the Container App ingress is exposed externally"
  type        = bool
  default     = true
}

variable "ingress_target_port" {
  description = "The target port for the Container App ingress"
  type        = number
  default     = 80
}

variable "ingress_transport" {
  description = "The transport protocol for the Container App ingress. Possible values are 'auto', 'http', and 'http2'"
  type        = string
  default     = "auto"
}

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
  default     = {}
}
