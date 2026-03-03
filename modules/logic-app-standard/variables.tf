variable "name" {
  description = "The name of the Logic App Standard"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The Azure region where the Logic App Standard will be created"
  type        = string
}

variable "app_service_plan_id" {
  description = "The ID of the App Service Plan within which to create this Logic App"
  type        = string
}

variable "storage_account_name" {
  description = "The backend storage account name which will be used by this Logic App"
  type        = string
}

variable "storage_account_access_key" {
  description = "The access key which will be used to access the backend storage account for the Logic App"
  type        = string
  sensitive   = true
}

variable "app_settings" {
  description = "A map of key-value pairs for App Settings and custom values"
  type        = map(string)
  default     = {}
}

variable "use_extension_bundle" {
  description = "Should the logic app use the bundled extension package"
  type        = bool
  default     = true
}

variable "bundle_version" {
  description = "If use_extension_bundle is true, specifies the version range of the extension bundle to use"
  type        = string
  default     = "[1.*, 2.0.0)"
}

variable "client_affinity_enabled" {
  description = "Should the Logic App send session affinity cookies"
  type        = bool
  default     = false
}

variable "client_certificate_mode" {
  description = "The mode of the Logic App's client certificates requirement for incoming requests. Valid values: 'Required', 'Optional', 'OptionalInteractiveUser'"
  type        = string
  default     = null
  validation {
    condition     = var.client_certificate_mode == null || contains(["Required", "Optional", "OptionalInteractiveUser"], var.client_certificate_mode)
    error_message = "Must be 'Required', 'Optional', or 'OptionalInteractiveUser'."
  }
}

variable "enabled" {
  description = "Is the Logic App enabled"
  type        = bool
  default     = true
}

variable "https_only" {
  description = "Can the Logic App only be accessed via HTTPS"
  type        = bool
  default     = true
}

variable "version" {
  description = "The runtime version associated with the Logic App"
  type        = string
  default     = "~4"
}

variable "virtual_network_subnet_id" {
  description = "The subnet id which will be used by this Logic App for regional virtual network integration"
  type        = string
  default     = null
}

variable "site_config" {
  description = "Site configuration for the Logic App"
  type = object({
    always_on                        = optional(bool)
    app_scale_limit                  = optional(number)
    dotnet_framework_version         = optional(string)
    elastic_instance_minimum         = optional(number)
    ftps_state                       = optional(string)
    health_check_path                = optional(string)
    http2_enabled                    = optional(bool)
    linux_fx_version                 = optional(string)
    min_tls_version                  = optional(string)
    pre_warmed_instance_count        = optional(number)
    runtime_scale_monitoring_enabled = optional(bool)
    use_32_bit_worker_process        = optional(bool)
    vnet_route_all_enabled           = optional(bool)
    websockets_enabled               = optional(bool)
    cors = optional(object({
      allowed_origins     = list(string)
      support_credentials = optional(bool)
    }))
    ip_restriction = optional(list(object({
      ip_address                = optional(string)
      service_tag               = optional(string)
      virtual_network_subnet_id = optional(string)
      name                      = optional(string)
      priority                  = optional(number)
      action                    = optional(string)
    })))
  })
  default = null
}

variable "connection_strings" {
  description = "Connection strings for the Logic App"
  type = list(object({
    name  = string
    type  = string
    value = string
  }))
  default = []
}

variable "identity" {
  description = "An identity block for the Logic App"
  type = object({
    type         = string
    identity_ids = optional(list(string))
  })
  default = null
}

variable "public_network_access" {
  description = "Whether public network access is allowed for the Logic App. Valid values: 'Enabled', 'Disabled'"
  type        = string
  default     = "Disabled"
  validation {
    condition     = contains(["Enabled", "Disabled"], var.public_network_access)
    error_message = "Must be 'Enabled' or 'Disabled'."
  }
}

variable "vnet_content_share_enabled" {
  description = "Should content over the virtual network integration subnet be enabled. Required when using VNet integration"
  type        = bool
  default     = false
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}
