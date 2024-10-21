# Variables for Azure OpenAI with Models and Private Endpoint
variable "openai_name" {
  description = "The name of the Azure OpenAI service."
  type        = string
}

variable "location" {
  description = "Azure region where the resources will be deployed."
  type        = string
}

variable "location_ai" {
  description = "Azure region for the landing zone resources"
  type        = string
  default = "East US"
}

variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet where the private endpoint will be created."
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the resources."
  type        = map(string)
  default     = {}
}

# List of models to deploy to Azure OpenAI
variable "models" {
  description = "A list of models to deploy to the OpenAI instance, with format and model name."
  type = list(object({
    name   = string
    model  = string
    format = string  # The format of the model (e.g., 'OpenAI')
  }))
  default = [
    { name = "gpt4o-deployment", model = "gpt-4o", format = "OpenAI" },
    { name = "embedding-deployment", model = "text-embedding-ada-002", format = "OpenAI" }
  ]
}

variable "custom_subdomain_name" {
  description = "The custom subdomain name for the Azure OpenAI service."
  type        = string
  default     = ""
}

variable "private_dns_zone_ids" {
  description = "The IDs of the private DNS zones to associate with the private endpoint."
  type        = list(string)
}