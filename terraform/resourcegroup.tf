resource "azurerm_resource_group" "resourcegroup" {
  name     = "${var.prefix}-TFAzureComponents-${var.environment}"
  location = "West Europe"
}