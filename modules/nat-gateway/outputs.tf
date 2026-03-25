output "id" {
  description = "The ID of the NAT gateway"
  value       = azurerm_nat_gateway.main.id
}

output "name" {
  description = "The name of the NAT gateway"
  value       = azurerm_nat_gateway.main.name
}

output "location" {
  description = "The location of the NAT gateway"
  value       = azurerm_nat_gateway.main.location
}

output "resource_group_name" {
  description = "The name of the resource group"
  value       = azurerm_nat_gateway.main.resource_group_name
}

output "public_ip_id" {
  description = "The ID of the public IP address associated with the NAT gateway"
  value       = length(azurerm_public_ip.main) > 0 ? azurerm_public_ip.main[0].id : null
}

output "public_ip_address" {
  description = "The public IP address associated with the NAT gateway"
  value       = length(azurerm_public_ip.main) > 0 ? azurerm_public_ip.main[0].ip_address : null
}

output "tags" {
  description = "The tags assigned to the NAT gateway"
  value       = azurerm_nat_gateway.main.tags
}
