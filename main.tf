provider "azurerm" {
  features = {}
}

variable "resource_group_name" {
  description = "Name of the Azure Resource Group"
}

variable "location" {
  description = "Azure region"
}

module "vnet" {
  source              = "./modules/vnet"
  resource_group_name = var.resource_group_name
  location            = var.location
}

