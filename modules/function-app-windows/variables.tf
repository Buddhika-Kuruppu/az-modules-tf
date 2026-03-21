variable "name" {
  description = "The name of the Windows Function App"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The Azure region where the Function App will be created"
  type        = string
}

variable "service_plan_id" {
  description = "The ID of the App Service Plan"
  type        = string
}

variable "storage_account_name" {
  description = "The backend storage account name used by the Function App"
  type        = string
}

variable "storage_account_access_key" {
  description = "The access key for the backend storage account"
  type        = string
  sensitive   = true
}

variable "app_settings" {
  description = "A map of key-value pairs for App Settings and custom values"
  type        = map(string)
  default     = {}
}

variable "functions_extension_version" {
  description = "The runtime version of the Azure Functions host to use"
  type        = string
  default     = "~4"
}

variable "https_only" {
  description = "Can the Function App only be accessed via HTTPS"
  type        = bool
  default     = true
}

variable "builtin_logging_enabled" {
  description = "Should built-in logging be enabled on the Function App"
  type        = bool
  default     = true
}

variable "site_config" {
  description = "Basic site configuration for the Function App"
  type = object({
    ftps_state          = optional(string, "Disabled")
    http2_enabled       = optional(bool, false)
    minimum_tls_version = optional(string, "1.2")
  })
  default = {}
}

variable "application_stack" {
  description = "The application stack for the Windows Function App runtime"
  type = object({
    dotnet_version              = optional(string)
    use_dotnet_isolated_runtime = optional(bool)
    java_version                = optional(string)
    node_version                = optional(string)
    powershell_core_version     = optional(string)
    use_custom_runtime          = optional(bool)
  })
  default = null
}

variable "cors" {
  description = "CORS settings for the Function App"
  type = object({
    allowed_origins     = list(string)
    support_credentials = optional(bool)
  })
  default = null
}

variable "identity" {
  description = "Managed identity for the Function App"
  type = object({
    type         = string
    identity_ids = optional(list(string))
  })
  default = null
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}
