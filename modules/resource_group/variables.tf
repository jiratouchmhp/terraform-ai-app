variable "name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The location/region where the resource group will be created"
  type        = string
}

variable "tags" {
  description = "Tags to associate with the resource group"
  type        = map(string)
  default     = {}
}
