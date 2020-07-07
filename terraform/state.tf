terraform {
  backend "azurerm" {
    resource_group_name  = "TFState"
    storage_account_name = "nltfstate"
    container_name       = "tfazurecomponents"
  }
}
