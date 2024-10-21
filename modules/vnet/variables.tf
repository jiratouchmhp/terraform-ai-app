variable "vnet_name" {
  description = "Name of the Virtual Network"
  type        = string
}

variable "location" {
  description = "Azure region for the VNet"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group where the VNet is deployed"
  type        = string
}

variable "address_space" {
  description = "Address space for the Virtual Network"
  type        = list(string)
}

variable "subnets" {
  description = "List of subnets to create in the VNet, each subnet object includes name and address prefix"
  type        = list(object({
    name           = string
    address_prefix = string
  }))
}
