output "id" {
  description = "The ID of the load balancer"
  value       = azurerm_lb.main.id
}

output "name" {
  description = "The name of the load balancer"
  value       = azurerm_lb.main.name
}

output "location" {
  description = "The Azure region where the load balancer exists"
  value       = azurerm_lb.main.location
}

output "resource_group_name" {
  description = "The name of the resource group in which the load balancer exists"
  value       = azurerm_lb.main.resource_group_name
}

output "frontend_ip_configurations" {
  description = "Map of frontend IP configuration names to their IDs and private IP addresses"
  value = {
    for fic in azurerm_lb.main.frontend_ip_configuration : fic.name => {
      id                 = fic.id
      private_ip_address = fic.private_ip_address
    }
  }
}

output "public_ip_addresses" {
  description = "Map of frontend IP configuration names to their public IP addresses"
  value = {
    for k, v in azurerm_public_ip.main : k => v.ip_address
  }
}

output "public_ip_ids" {
  description = "Map of frontend IP configuration names to their public IP resource IDs"
  value = {
    for k, v in azurerm_public_ip.main : k => v.id
  }
}

output "backend_address_pool_ids" {
  description = "Map of backend address pool names to their IDs"
  value = {
    for k, v in azurerm_lb_backend_address_pool.main : k => v.id
  }
}

output "probe_ids" {
  description = "Map of probe names to their IDs"
  value = {
    for k, v in azurerm_lb_probe.main : k => v.id
  }
}

output "tags" {
  description = "The tags assigned to the load balancer"
  value       = azurerm_lb.main.tags
}
