variable "resource_group_name" {
  description = "Name of the Azure Resource Group"
}

variable "location" {
  description = "Azure region"
}

variable "vnet_address_space" {
  description = "Address space for the virtual network"
  default     = "10.0.0.0/16"
}

variable "subnet_prefixes" {
  description = "List of subnet prefixes"
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name                = "main-vnet"
  address_space       = [var.vnet_address_space]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet" {
  count               = length(var.subnet_prefixes)
  name                = "subnet-${count.index + 1}"
  resource_group_name = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefix      = var.subnet_prefixes[count.index]
}

