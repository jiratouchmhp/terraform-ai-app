variable "server_name" {
  description = "The name of the PostgreSQL Flexible Server."
  type        = string
}

variable "location" {
  description = "The Azure location for the PostgreSQL Flexible Server."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group where the PostgreSQL Flexible Server will be created."
  type        = string
}

variable "admin_username" {
  description = "The administrator username for PostgreSQL."
  type        = string
}

variable "admin_password" {
  description = "The administrator password for PostgreSQL."
  type        = string
  sensitive   = true
}

variable "postgres_version" {
  description = "The version of PostgreSQL (e.g., 13)."
  type        = string
  default     = "13"
}

variable "sku_name" {
  description = "The SKU name for the PostgreSQL server (e.g., Standard_D2s_v3)."
  type        = string
}

variable "storage_mb" {
  description = "The storage size in MB."
  type        = number
  default     = 32768
}

variable "backup_retention_days" {
  description = "Number of days to retain backups."
  type        = number
  default     = 7
}

variable "geo_redundant_backup" {
  description = "Enable geo-redundant backup (Enabled or Disabled)."
  type        = string
  default     = "Disabled"
}

variable "subnet_id" {
  description = "The ID of the subnet to be delegated for the PostgreSQL Flexible Server."
  type        = string
}

variable "availability_zone" {
  description = "The Availability Zone to deploy the server into."
  type        = string
  default     = "1"
}

variable "tags" {
  description = "Tags to apply to resources."
  type        = map(string)
  default     = {}
}

variable "private_dns_zone_id" {
  description = "The ID of the private DNS zone."
  type        = string
}

variable "high_availability_mode" {
  description = "The high availability mode. Allowed values: 'ZoneRedundant', 'SameZone', or 'Disabled'"
  type        = string
  default     = "Disabled"  # Set the default to Disabled if you want to omit the HA block
  validation {
    condition     = contains(["ZoneRedundant", "SameZone", "Disabled"], var.high_availability_mode)
    error_message = "high_availability_mode must be one of 'ZoneRedundant', 'SameZone', or 'Disabled'."
  }
}
