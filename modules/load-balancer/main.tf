resource "azurerm_public_ip" "main" {
  for_each = {
    for fic in var.frontend_ip_configurations : fic.name => fic
    if fic.public_ip_name != null
  }

  name                = each.value.public_ip_name
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = each.value.zones

  tags = var.tags
}

resource "azurerm_lb" "main" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku

  dynamic "frontend_ip_configuration" {
    for_each = var.frontend_ip_configurations
    content {
      name                          = frontend_ip_configuration.value.name
      public_ip_address_id          = frontend_ip_configuration.value.public_ip_name != null ? azurerm_public_ip.main[frontend_ip_configuration.value.name].id : null
      subnet_id                     = frontend_ip_configuration.value.public_ip_name == null ? frontend_ip_configuration.value.subnet_id : null
      private_ip_address            = frontend_ip_configuration.value.public_ip_name == null ? frontend_ip_configuration.value.private_ip_address : null
      private_ip_address_allocation = frontend_ip_configuration.value.public_ip_name == null ? frontend_ip_configuration.value.private_ip_address_allocation : null
      zones                         = frontend_ip_configuration.value.zones
    }
  }

  tags = var.tags
}

resource "azurerm_lb_backend_address_pool" "main" {
  for_each = { for pool in var.backend_address_pools : pool.name => pool }

  name            = each.value.name
  loadbalancer_id = azurerm_lb.main.id
}

resource "azurerm_lb_probe" "main" {
  for_each = { for probe in var.probes : probe.name => probe }

  name                = each.value.name
  loadbalancer_id     = azurerm_lb.main.id
  protocol            = each.value.protocol
  port                = each.value.port
  request_path        = each.value.protocol != "Tcp" ? each.value.request_path : null
  interval_in_seconds = each.value.interval_in_seconds
  number_of_probes    = each.value.number_of_probes
}

resource "azurerm_lb_rule" "main" {
  for_each = { for rule in var.rules : rule.name => rule }

  name                           = each.value.name
  loadbalancer_id                = azurerm_lb.main.id
  protocol                       = each.value.protocol
  frontend_port                  = each.value.frontend_port
  backend_port                   = each.value.backend_port
  frontend_ip_configuration_name = each.value.frontend_ip_configuration_name
  backend_address_pool_ids       = [for name in each.value.backend_address_pool_names : azurerm_lb_backend_address_pool.main[name].id]
  probe_id                       = each.value.probe_name != null ? azurerm_lb_probe.main[each.value.probe_name].id : null
  enable_floating_ip             = each.value.enable_floating_ip
  idle_timeout_in_minutes        = each.value.idle_timeout_in_minutes
  load_distribution              = each.value.load_distribution
  disable_outbound_snat          = each.value.disable_outbound_snat
  enable_tcp_reset               = each.value.enable_tcp_reset
}

resource "azurerm_lb_nat_rule" "main" {
  for_each = { for rule in var.nat_rules : rule.name => rule }

  name                           = each.value.name
  resource_group_name            = var.resource_group_name
  loadbalancer_id                = azurerm_lb.main.id
  protocol                       = each.value.protocol
  frontend_port                  = each.value.frontend_port
  backend_port                   = each.value.backend_port
  frontend_ip_configuration_name = each.value.frontend_ip_configuration_name
  idle_timeout_in_minutes        = each.value.idle_timeout_in_minutes
  enable_floating_ip             = each.value.enable_floating_ip
  enable_tcp_reset               = each.value.enable_tcp_reset
}
