resource "azurerm_logic_app_standard" "main" {
  name                       = var.name
  resource_group_name        = var.resource_group_name
  location                   = var.location
  app_service_plan_id        = var.app_service_plan_id
  storage_account_name       = var.storage_account_name
  storage_account_access_key = var.storage_account_access_key

  app_settings            = var.app_settings
  bundle_version          = var.bundle_version
  client_affinity_enabled = var.client_affinity_enabled
  client_certificate_mode = var.client_certificate_mode
  enabled                 = var.enabled
  https_only              = var.https_only
  use_extension_bundle    = var.use_extension_bundle
  version                 = var.version
  virtual_network_subnet_id = var.virtual_network_subnet_id

  dynamic "site_config" {
    for_each = var.site_config != null ? [var.site_config] : []
    content {
      always_on                        = try(site_config.value.always_on, null)
      app_scale_limit                  = try(site_config.value.app_scale_limit, null)
      dotnet_framework_version         = try(site_config.value.dotnet_framework_version, null)
      elastic_instance_minimum         = try(site_config.value.elastic_instance_minimum, null)
      ftps_state                       = try(site_config.value.ftps_state, null)
      health_check_path                = try(site_config.value.health_check_path, null)
      http2_enabled                    = try(site_config.value.http2_enabled, null)
      linux_fx_version                 = try(site_config.value.linux_fx_version, null)
      min_tls_version                  = try(site_config.value.min_tls_version, null)
      pre_warmed_instance_count        = try(site_config.value.pre_warmed_instance_count, null)
      runtime_scale_monitoring_enabled = try(site_config.value.runtime_scale_monitoring_enabled, null)
      use_32_bit_worker_process        = try(site_config.value.use_32_bit_worker_process, null)
      vnet_route_all_enabled           = try(site_config.value.vnet_route_all_enabled, null)
      websockets_enabled               = try(site_config.value.websockets_enabled, null)

      dynamic "cors" {
        for_each = try(site_config.value.cors, null) != null ? [site_config.value.cors] : []
        content {
          allowed_origins     = cors.value.allowed_origins
          support_credentials = try(cors.value.support_credentials, null)
        }
      }

      dynamic "ip_restriction" {
        for_each = try(site_config.value.ip_restriction, [])
        content {
          ip_address                = try(ip_restriction.value.ip_address, null)
          service_tag               = try(ip_restriction.value.service_tag, null)
          virtual_network_subnet_id = try(ip_restriction.value.virtual_network_subnet_id, null)
          name                      = try(ip_restriction.value.name, null)
          priority                  = try(ip_restriction.value.priority, null)
          action                    = try(ip_restriction.value.action, null)
        }
      }
    }
  }

  dynamic "connection_string" {
    for_each = var.connection_strings
    content {
      name  = connection_string.value.name
      type  = connection_string.value.type
      value = connection_string.value.value
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

# azapi_update_resource sets ARM properties not exposed by the azurerm provider:
#   publicNetworkAccess     – controls internet-facing access at the platform level
#   vnetContentShareEnabled – routes content share traffic through the VNet integration subnet
resource "azapi_update_resource" "logic_app_config" {
  type        = "Microsoft.Web/sites@2023-01-01"
  resource_id = azurerm_logic_app_standard.main.id

  body = {
    properties = {
      publicNetworkAccess     = var.public_network_access
      vnetContentShareEnabled = var.vnet_content_share_enabled
    }
  }
}
