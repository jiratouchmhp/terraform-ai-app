variable "vm_names" {
  description = "List of virtual machine names to create"
  type        = list(string)
}

variable "vm_size" {
  description = "Size of the Virtual Machines"
  type        = string
}

variable "admin_username" {
  description = "Admin username for the virtual machines"
  type        = string
}

variable "admin_password" {
  description = "Admin password for the virtual machines"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group in which to create the virtual machines"
  type        = string
}

variable "location" {
  description = "Azure region in which to create the virtual machines"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs to assign to the virtual machines, matching the vm_names"
  type        = list(string)
}

variable "enable_managed_identity" {
  description = "List of boolean values indicating whether to enable Managed Identity for each VM"
  type        = list(bool)
}

variable "tags" {
  description = "Tags to be applied to the virtual machines"
  type        = map(string)
  default     = {}
}
