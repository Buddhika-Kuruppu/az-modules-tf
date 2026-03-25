resource "azurerm_public_ip" "main" {
  count = var.public_ip_name != null ? 1 : 0

  name                = var.public_ip_name
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = var.tags
}

resource "azurerm_nat_gateway" "main" {
  name                    = var.name
  location                = var.location
  resource_group_name     = var.resource_group_name
  sku_name                = "Standard"
  idle_timeout_in_minutes = var.idle_timeout_in_minutes

  tags = var.tags
}

resource "azurerm_nat_gateway_public_ip_association" "main" {
  count = var.public_ip_name != null ? 1 : 0

  nat_gateway_id       = azurerm_nat_gateway.main.id
  public_ip_address_id = azurerm_public_ip.main[0].id
}

resource "azurerm_subnet_nat_gateway_association" "main" {
  for_each = toset(var.subnet_ids)

  subnet_id      = each.value
  nat_gateway_id = azurerm_nat_gateway.main.id
}
