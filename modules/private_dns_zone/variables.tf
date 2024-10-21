variable "dns_zone_names" {
  description = "List of Private DNS Zone names to create."
  type        = list(string)
}

variable "resource_group_name" {
  description = "Resource group where the Private DNS Zones will be created."
  type        = string
}

variable "virtual_network_ids" {
  description = "List of Virtual Network IDs to link to each DNS Zone."
  type        = list(string)
  default     = []
}

variable "registration_enabled" {
  description = "Whether DNS registration should be enabled for the linked VNETs."
  type        = bool
  default     = false
}
