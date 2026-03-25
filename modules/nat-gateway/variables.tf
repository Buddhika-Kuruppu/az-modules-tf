variable "name" {
  description = "The name of the NAT gateway"
  type        = string
}

variable "location" {
  description = "The Azure region where the NAT gateway should exist"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the NAT gateway"
  type        = string
}

variable "idle_timeout_in_minutes" {
  description = "The idle timeout in minutes for the NAT gateway"
  type        = number
  default     = 4
  validation {
    condition     = var.idle_timeout_in_minutes >= 4 && var.idle_timeout_in_minutes <= 120
    error_message = "idle_timeout_in_minutes must be between 4 and 120."
  }
}

variable "public_ip_name" {
  description = "The name of the public IP address to create and associate with the NAT gateway. If null, no public IP is created."
  type        = string
  default     = null
}

variable "subnet_ids" {
  description = "A list of subnet IDs to associate with the NAT gateway"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "A mapping of tags to assign to the NAT gateway and associated resources"
  type        = map(string)
  default     = {}
}
