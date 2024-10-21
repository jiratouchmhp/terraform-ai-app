variable "dns_zone_name" {
  description = "The Private DNS Zone name."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group where the DNS records will be created."
  type        = string
}

variable "ttl" {
  description = "TTL for the DNS records."
  type        = number
  default     = 300
}

variable "records" {
  description = "List of A records to create."
  type = list(object({
    name = string
    ip   = string
  }))
  default = []
}

variable "cname_records" {
  description = "List of CNAME records to create."
  type = list(object({
    name  = string
    cname = string
  }))
  default = []
}
