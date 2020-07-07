terraform {
  backend "azurerm" {
    resource_group_name  = "${var.prefix}-TFState"
    storage_account_name = "${lower(var.prefix)}nltfstate"
    container_name       = "${lower(var.prefix)}tfazurecomponents"
  }
}
