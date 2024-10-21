# modules/network/main.tf

# Create the Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.address_space
}

# Create the Subnets
resource "azurerm_subnet" "subnet" {
  count               = length(var.subnets)
  name                = var.subnets[count.index].name
  resource_group_name = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes    = [var.subnets[count.index].address_prefix]

  # Dynamic delegation block for PostgreSQL
  dynamic "delegation" {
    for_each = var.subnets[count.index].name == "postgresql" ? [1] : []
    content {
      name = "postgresql-flexible-server-delegation"
      service_delegation {
        name = "Microsoft.DBforPostgreSQL/flexibleServers"
        actions = [
          "Microsoft.Network/virtualNetworks/subnets/action",
          "Microsoft.Network/virtualNetworks/subnets/join/action"
        ]
      }
    }
  }
}
