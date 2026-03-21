output "id" {
  description = "The ID of the Linux Function App"
  value       = azurerm_linux_function_app.main.id
}

output "name" {
  description = "The name of the Linux Function App"
  value       = azurerm_linux_function_app.main.name
}

output "default_hostname" {
  description = "The default hostname of the Linux Function App"
  value       = azurerm_linux_function_app.main.default_hostname
}

output "outbound_ip_addresses" {
  description = "A comma separated list of outbound IP addresses"
  value       = azurerm_linux_function_app.main.outbound_ip_addresses
}

output "identity" {
  description = "The managed identity block for the Linux Function App"
  value       = azurerm_linux_function_app.main.identity
}
