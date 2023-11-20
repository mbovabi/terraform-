# modules/vmss.tf

variable "resource_group_name" {
  description = "Name of the Azure Resource Group"
}

variable "location" {
  description = "Azure region"
}

variable "subnet_id" {
  description = "ID of the subnet to deploy the VMSS"
}

resource "azurerm_lb" "lb" {
  name                = "lb-vmss"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Basic"

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.pip.id
  }
}

resource "azurerm_public_ip" "pip" {
  name                = "pip-vmss"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "nic" {
  name                = "nic-vmss"
  resource_group_name = var.resource_group_name
  location            = var.location

  ip_configuration {
    name                          = "ipconfig-vmss"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
  }
}

resource "azurerm_virtual_machine_scale_set" "vmss" {
  name                = "vmss"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Standard_DS1_v2"
  instances           = 1

  upgrade_policy_mode = "Automatic"

  network_profile {
    name    = "default"
    primary = true

    ip_configuration {
      name                          = "ipconfig-vmss"
      subnet_id                     = var.subnet_id
      primary                       = true
      private_ip_address_allocation = "Dynamic"
    }
  }

  os_profile {
    computer_name  = "vmss"
    admin_username = "adminuser"
    admin_password = "Password1234!"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  load_balancer {
    id = azurerm_lb.lb.id
  }
}
