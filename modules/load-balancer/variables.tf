variable "name" {
  description = "The name of the load balancer"
  type        = string
}

variable "location" {
  description = "The Azure region where the load balancer should exist"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the load balancer"
  type        = string
}

variable "sku" {
  description = "The SKU of the load balancer. Possible values are Basic and Standard"
  type        = string
  default     = "Standard"
}

variable "frontend_ip_configurations" {
  description = "List of frontend IP configurations. Set public_ip_name for a public load balancer, or subnet_id for an internal load balancer"
  type = list(object({
    name                          = string
    public_ip_name                = optional(string)
    subnet_id                     = optional(string)
    private_ip_address            = optional(string)
    private_ip_address_allocation = optional(string, "Dynamic")
    zones                         = optional(list(string))
  }))
}

variable "backend_address_pools" {
  description = "List of backend address pools to create"
  type = list(object({
    name = string
  }))
  default = []
}

variable "probes" {
  description = "List of health probes"
  type = list(object({
    name                = string
    protocol            = string
    port                = number
    request_path        = optional(string, "/")
    interval_in_seconds = optional(number, 15)
    number_of_probes    = optional(number, 2)
  }))
  default = []
}

variable "rules" {
  description = "List of load balancing rules"
  type = list(object({
    name                           = string
    protocol                       = string
    frontend_port                  = number
    backend_port                   = number
    frontend_ip_configuration_name = string
    backend_address_pool_names     = optional(list(string), [])
    probe_name                     = optional(string)
    enable_floating_ip             = optional(bool, false)
    idle_timeout_in_minutes        = optional(number, 4)
    load_distribution              = optional(string, "Default")
    disable_outbound_snat          = optional(bool, false)
    enable_tcp_reset               = optional(bool, false)
  }))
  default = []
}

variable "nat_rules" {
  description = "List of inbound NAT rules"
  type = list(object({
    name                           = string
    protocol                       = string
    frontend_port                  = number
    backend_port                   = number
    frontend_ip_configuration_name = string
    idle_timeout_in_minutes        = optional(number, 4)
    enable_floating_ip             = optional(bool, false)
    enable_tcp_reset               = optional(bool, false)
  }))
  default = []
}

variable "tags" {
  description = "A mapping of tags to assign to the load balancer and associated resources"
  type        = map(string)
  default     = {}
}
