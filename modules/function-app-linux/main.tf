resource "azurerm_linux_function_app" "main" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  service_plan_id     = var.service_plan_id

  storage_account_name       = var.storage_account_name
  storage_account_access_key = var.storage_account_access_key

  app_settings                = var.app_settings
  functions_extension_version = var.functions_extension_version
  https_only                  = var.https_only
  builtin_logging_enabled     = var.builtin_logging_enabled

  site_config {
    ftps_state          = var.site_config.ftps_state
    http2_enabled       = var.site_config.http2_enabled
    minimum_tls_version = var.site_config.minimum_tls_version

    dynamic "application_stack" {
      for_each = var.application_stack != null ? [var.application_stack] : []
      content {
        dotnet_version              = try(application_stack.value.dotnet_version, null)
        use_dotnet_isolated_runtime = try(application_stack.value.use_dotnet_isolated_runtime, null)
        java_version                = try(application_stack.value.java_version, null)
        node_version                = try(application_stack.value.node_version, null)
        python_version              = try(application_stack.value.python_version, null)
        powershell_core_version     = try(application_stack.value.powershell_core_version, null)
        use_custom_runtime          = try(application_stack.value.use_custom_runtime, null)
      }
    }

    dynamic "cors" {
      for_each = var.cors != null ? [var.cors] : []
      content {
        allowed_origins     = cors.value.allowed_origins
        support_credentials = try(cors.value.support_credentials, null)
      }
    }
  }

  dynamic "identity" {
    for_each = var.identity != null ? [var.identity] : []
    content {
      type         = identity.value.type
      identity_ids = try(identity.value.identity_ids, null)
    }
  }

  tags = var.tags
}
