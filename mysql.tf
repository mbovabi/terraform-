# modules/mysql.tf

variable "resource_group_name" {
  description = "Name of the Azure Resource Group"
}

variable "location" {
  description = "Azure region"
}

variable "mysql_server_name" {
  description = "Name of the MySQL server"
}

variable "mysql_admin_login" {
  description = "Admin username for the MySQL server"
}

variable "mysql_admin_password" {
  description = "Admin password for the MySQL server"
}

resource "azurerm_mysql_server" "mysql" {
  name                = var.mysql_server_name
  resource_group_name = var.resource_group_name
  location            = var.location
  version             = "5.7"

  sku {
    tier = "Basic"
    capacity = 50
  }

  storage_profile {
    storage_mb = 5120
  }

  administrator_login          = var.mysql_admin_login
  administrator_login_password = var.mysql_admin_password
}

resource "azurerm_mysql_database" "wordpress_db" {
  name                = "wordpressdb"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_server.mysql.name
  charset             = "utf8mb4"
  collation           = "utf8mb4_general_ci"
}
